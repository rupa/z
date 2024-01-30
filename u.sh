# Copyright (c) 2009 rupa deadwyler. Licensed under the WTFPL license, Version 2

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#     * put something like this in your .bashrc/.zshrc:
#         . /path/to/u.sh
#     * cd around for a while to build up the db
#     * PROFIT!!
#     * optionally:
#         set $_u_CMD in .bashrc/.zshrc to change the command (default u).
#         set $_u_DATA in .bashrc/.zshrc to change the datafile (default ~/.u).
#         set $_u_MAX_SCORE lower to age entries out faster (default 9000).
#         set $_u_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#         set $_u_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#         set $_u_EXCLUDE_DIRS to an array of directories to exclude.
#         set $_u_OWNER to your username if you want use u while sudo with $HOME kept
#
# USE:
#     * u foo     # cd to most frecent dir matching foo
#     * u foo bar # cd to most frecent dir matching foo and bar
#     * u -r foo  # cd to highest ranked dir matching foo
#     * u -t foo  # cd to most recently accessed dir matching foo
#     * u -l foo  # list matches instead of cd
#     * u -e foo  # echo the best match, don't cd
#     * u -c foo  # restrict matches to subdirs of $PWD
#     * u -x      # remove the current directory from the datafile
#     * u -h      # show a brief help message

[ -d "${_u_DATA:-$HOME/.u}" ] && {
    echo "ERROR: u.sh's datafile (${_u_DATA:-$HOME/.u}) is a directory."
}

_u() {

    local datafile="${_u_DATA:-$HOME/.u}"

    # if symlink, dereference
    [ -h "$datafile" ] && datafile=$(readlink "$datafile")

    # bail if we don't own ~/.u and $_u_OWNER not set
    [ -u "$_u_OWNER" -a -f "$datafile" -a ! -O "$datafile" ] && return

    _u_dirs () {
        [ -f "$datafile" ] || return

        local line
        while read line; do
            # only count directories
            [ -d "${line%%\|*}" ] && echo "$line"
        done < "$datafile"
        return 0
    }

    # add entries
    if [ "$1" = "--add" ]; then
        shift

        # $HOME and / aren't worth matching
        [ "$*" = "$HOME" -o "$*" = '/' ] && return

        # don't track excluded directory trees
        if [ ${#_u_EXCLUDE_DIRS[@]} -gt 0 ]; then
            local exclude
            for exclude in "${_u_EXCLUDE_DIRS[@]}"; do
                case "$*" in "$exclude"*) return;; esac
            done
        fi

        # maintain the data file
        local tempfile="$datafile.$RANDOM"
        local score=${_u_MAX_SCORE:-9000}
        _u_dirs | \awk -v path="$*" -v now="$(\date +%s)" -v score=$score -F"|" '
            BEGIN {
                rank[path] = 1
                time[path] = now
            }
            $2 >= 1 {
                # drop ranks below 1
                if( $1 == path ) {
                    rank[$1] = $2 + 1
                    time[$1] = now
                } else {
                    rank[$1] = $2
                    time[$1] = $3
                }
                count += $2
            }
            END {
                if( count > score ) {
                    # aging
                    for( x in rank ) print x "|" 0.99*rank[x] "|" time[x]
                } else for( x in rank ) print x "|" rank[x] "|" time[x]
            }
        ' 2>/dev/null >| "$tempfile"
        # do our best to avoid clobbering the datafile in a race condition.
        if [ $? -ne 0 -a -f "$datafile" ]; then
            \env rm -f "$tempfile"
        else
            [ "$_u_OWNER" ] && chown $_u_OWNER:"$(id -ng $_u_OWNER)" "$tempfile"
            \env mv -f "$tempfile" "$datafile" || \env rm -f "$tempfile"
        fi

    # tab completion
    elif [ "$1" = "--complete" -a -s "$datafile" ]; then
        _u_dirs | \awk -v q="$2" -F"|" '
            BEGIN {
                q = substr(q, 3)
                if( q == tolower(q) ) imatch = 1
                gsub(/ /, ".*", q)
            }
            {
                if( imatch ) {
                    if( tolower($1) ~ q ) print $1
                } else if( $1 ~ q ) print $1
            }
        ' 2>/dev/null

    else
        # list/go
        local echo fnd last list opt typ
        while [ "$1" ]; do case "$1" in
            --) while [ "$1" ]; do shift; fnd="$fnd${fnd:+ }$1";done;;
            -*) opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
                    c) fnd="^$PWD $fnd";;
                    e) echo=1;;
                    h) echo "${_u_CMD:-u} [-cehlrtx] args" >&2; return;;
                    l) list=1;;
                    r) typ="rank";;
                    t) typ="recent";;
                    x) \sed -i -e "\:^${PWD}|.*:d" "$datafile";;
                esac; opt=${opt:1}; done;;
             *) fnd="$fnd${fnd:+ }$1";;
        esac; last=$1; [ "$#" -gt 0 ] && shift; done
        [ "$fnd" -a "$fnd" != "^$PWD " ] || list=1

        # if we hit enter on a completion just go there
        case "$last" in
            # completions will always start with /
            /*) [ -u "$list" -a -d "$last" ] && builtin cd "$last" && return;;
        esac

        # no file yet
        [ -f "$datafile" ] || return

        local cd
        cd="$( < <( _u_dirs ) \awk -v t="$(\date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -F"|" '
            function frecent(rank, time) {
              # relate frequency and time
              dx = t - time
              return int(10000 * rank * (3.75/((0.0001 * dx + 1) + 0.25)))
            }
            function output(matches, best_match, common) {
                # list or return the desired directory
                if( list ) {
                    if( common ) {
                        printf "%-10s %s\n", "common:", common > "/dev/stderr"
                    }
                    cmd = "sort -n >&2"
                    for( x in matches ) {
                        if( matches[x] ) {
                            printf "%-10s %s\n", matches[x], x | cmd
                        }
                    }
                } else {
                    if( common && !typ ) best_match = common
                    print best_match
                }
            }
            function common(matches) {
                # find the common root of a list of matches, if it exists
                for( x in matches ) {
                    if( matches[x] && (!short || length(x) < length(short)) ) {
                        short = x
                    }
                }
                if( short == "/" ) return
                for( x in matches ) if( matches[x] && index(x, short) != 1 ) {
                    return
                }
                return short
            }
            BEGIN {
                gsub(" ", ".*", q)
                hi_rank = ihi_rank = -9999999999
            }
            {
                if( typ == "rank" ) {
                    rank = $2
                } else if( typ == "recent" ) {
                    rank = $3 - t
                } else rank = frecent($2, $3)
                if( $1 ~ q ) {
                    matches[$1] = rank
                } else if( tolower($1) ~ tolower(q) ) imatches[$1] = rank
                if( matches[$1] && matches[$1] > hi_rank ) {
                    best_match = $1
                    hi_rank = matches[$1]
                } else if( imatches[$1] && imatches[$1] > ihi_rank ) {
                    ibest_match = $1
                    ihi_rank = imatches[$1]
                }
            }
            END {
                # prefer case sensitive
                if( best_match ) {
                    output(matches, best_match, common(matches))
                    exit
                } else if( ibest_match ) {
                    output(imatches, ibest_match, common(imatches))
                    exit
                }
                exit(1)
            }
        ')"

        if [ "$?" -eq 0 ]; then
          if [ "$cd" ]; then
            if [ "$echo" ]; then echo "$cd"; else builtin cd "$cd"; fi
          fi
        else
          return $?
        fi
    fi
}

alias ${_u_CMD:-u}='_u 2>&1'

[ "$_u_NO_RESOLVE_SYMLINKS" ] || _u_RESOLVE_SYMLINKS="-P"

if type compctl >/dev/null 2>&1; then
    # zsh
    [ "$_u_NO_PROMPT_COMMAND" ] || {
        # populate directory list, avoid clobbering any other precmds.
        if [ "$_u_NO_RESOLVE_SYMLINKS" ]; then
            _u_precmd() {
                (_u --add "${PWD:a}" &)
                : $RANDOM
            }
        else
            _u_precmd() {
                (_u --add "${PWD:A}" &)
                : $RANDOM
            }
        fi
        [[ -n "${precmd_functions[(r)_u_precmd]}" ]] || {
            precmd_functions[$(($#precmd_functions+1))]=_u_precmd
        }
    }
    _u_zsh_tab_completion() {
        # tab completion
        local compl
        read -l compl
        reply=(${(f)"$(_u --complete "$compl")"})
    }
    compctl -U -K _u_zsh_tab_completion _u
elif type complete >/dev/null 2>&1; then
    # bash
    # tab completion
    complete -o filenames -C '_u --complete "$COMP_LINE"' ${_u_CMD:-u}
    [ "$_u_NO_PROMPT_COMMAND" ] || {
        # populate directory list. avoid clobbering other PROMPT_COMMANDs.
        grep "_u --add" <<< "$PROMPT_COMMAND" >/dev/null || {
            PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''(_u --add "$(command pwd '$_u_RESOLVE_SYMLINKS' 2>/dev/null)" 2>/dev/null &);'
        }
    }
fi
