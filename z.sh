#!/bin/bash

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#   * put something like this in your .bashrc:
#     . /path/to/z.sh
#   * cd around for a while to build up the db
#   * PROFIT!!
#
# USE:
#   * z foo     # goes to most frecent dir matching foo
#   * z foo bar # goes to most frecent dir matching foo and bar
#   * z -r foo  # goes to highest ranked dir matching foo
#   * z -t foo  # goes to most recently accessed dir matching foo
#   * z -l foo  # list all dirs matching foo (by frecency)

z() {
 local datafile="$HOME/.z"
 if [ "$1" = "--add" ]; then
  # add
  shift
  # $HOME isn't worth matching
  [ "$*" = "$HOME" ] && return
  awk -v p="$*" -v t="$(date +%s)" -F"|" '
   BEGIN { rank[p] = 1; time[p] = t }
   $2 >= 1 {
    if( $1 == p ) {
     rank[$1] = $2 + 1
     time[$1] = t
    } else {
     rank[$1] = $2
     time[$1] = $3
    }
    count += $2
   }
   END {
    if( count > 1000 ) {
     for( i in rank ) print i "|" 0.9*rank[i] "|" time[i] # aging
    } else for( i in rank ) print i "|" rank[i] "|" time[i]
   }
  ' "$datafile" 2>/dev/null > "$datafile.tmp"
  mv -f "$datafile.tmp" "$datafile"
 elif [ "$1" = "--complete" ]; then
  # tab completion
  awk -v q="$2" -F"|" '
   BEGIN {
    if( q == tolower(q) ) nocase = 1
    split(substr(q,3),fnd," ")
   }
   {
    if( system("test -d \"" $1 "\"") ) next
    if( nocase ) {
     for( i in fnd ) tolower($1) !~ tolower(fnd[i]) && $1 = ""
     if( $1 ) print $1
    } else {
     for( i in fnd ) $1 !~ fnd[i] && $1 = ""
     if( $1 ) print $1
    }
   }
  ' "$datafile" 2>/dev/null
 else
  # list/go
  while [ "$1" ]; do case "$1" in
   -h) echo "z [-h][-l][-r][-t] args" >&2; return;;
   -l) local list=1;;
   -r) local typ="rank";;
   -t) local typ="recent";;
   --) while [ "$1" ]; do shift; local fnd="$fnd $1";done;;
    *) local fnd="$fnd $1";;
  esac; local last=$1; shift; done
  [ "$fnd" ] || local list=1
  # if we hit enter on a completion just go there
  [ -d "$last" ] && cd "$last" && return
  [ -f "$datafile" ] || return
  local cd="$(awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -v tmpfl="$datafile.tmp" -F"|" '
   function frecent(rank, time) {
    dx = t-time
    if( dx < 3600 ) return rank*4
    if( dx < 86400 ) return rank*2
    if( dx < 604800 ) return rank/2
    return rank/4
   }
   function output(files, toopen, override) {
    if( list ) {
     if( typ == "recent" ) {
      cmd = "sort -nr >&2"
     } else cmd = "sort -n >&2"
     for( i in files ) if( files[i] ) printf "%-10s %s\n", files[i], i | cmd
     if( override ) printf "%-10s %s\n", "common:", override > "/dev/stderr"
    } else {
     if( override ) toopen = override
     print toopen
    }
   }
   function common(matches, fnd, nc) {
    for( i in matches ) {
     if( matches[i] && (!short || length(i) < length(short)) ) short = i
    }
    if( short == "/" ) return
    for( i in matches ) if( matches[i] && i !~ short ) x = 1
    if( x ) return
    if( nc ) {
     for( i in fnd ) if( tolower(short) !~ tolower(fnd[i]) ) x = 1
    } else for( i in fnd ) if( short !~ fnd[i] ) x = 1
    if( !x ) return short
   }
   BEGIN { split(q, a, " ") }
   {
    if( system("test -d \"" $1 "\"") ) next
    print $0 >> tmpfl
    if( typ == "rank" ) {
     f = $2
    } else if( typ == "recent" ) {
     f = t-$3
    } else f = frecent($2, $3)
    wcase[$1] = nocase[$1] = f
    for( i in a ) {
     if( $1 !~ a[i] ) delete wcase[$1]
     if( tolower($1) !~ tolower(a[i]) ) delete nocase[$1]
    }
    if( wcase[$1] > oldf ) {
     cx = $1
     oldf = wcase[$1]
    } else if( nocase[$1] > noldf ) {
     ncx = $1
     noldf = nocase[$1]
    }
   }
   END {
    if( cx ) {
     output(wcase, cx, common(wcase, a, 0))
    } else if( ncx ) output(nocase, ncx, common(nocase, a, 1))
   }
  ' "$datafile")"
  if [ $? -gt 0 ]; then
   rm -f "$datafile.tmp"
  else
   mv -f "$datafile.tmp" "$datafile"
   [ "$cd" ] && cd "$cd"
  fi
 fi
}
# tab completion
complete -C 'z --complete "$COMP_LINE"' z
# populate directory list. avoid clobbering other PROMPT_COMMANDs.
echo $PROMPT_COMMAND | grep -q "z --add"
[ $? -gt 0 ] && PROMPT_COMMAND='z --add "$(pwd -P)";'"$PROMPT_COMMAND"
