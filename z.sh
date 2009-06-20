#!/bin/bash

# pure shell version of 'new j'
# has frecency, rank, and recent
# has common and case preference
# lists to stderr
# protect multiple PROMPT_COMMAND appends

z() {
 local datafile=$HOME/.z
 if [ "$1" = "--add" ]; then
  # add
  shift
  # $HOME isn't worth matching
  [ "$*" = "$HOME" ] && return
  awk -v q="$*" -v t="$(date +%s)" -F"|" '
   BEGIN { l[q] = 1; d[q] = t }
   $2 >= 1 {
    if( $1 == q ) {
     l[$1] = $2 + 1
     d[$1] = t
    } else {
     l[$1] = $2
     d[$1] = $3
    }
    count += $2
   }
   END {
    if( count > 1000 ) {
     for( i in l ) print i "|" 0.9*l[i] "|" d[i] # aging
    } else for( i in l ) print i "|" l[i] "|" d[i]
   }
  ' $datafile 2>/dev/null > $datafile.tmp
  mv -f $datafile.tmp $datafile
 elif [ "$1" = "--complete" ]; then
  # tab completion
  awk -v q="$2" -F"|" '
   BEGIN { split(substr(q,3),a," ") }
   {
    if( system("test -d \"" $1 "\"") ) next
    for( i in a ) $1 !~ a[i] && $1 = ""; if( $1 ) print $1
   }
  ' $datafile 2>/dev/null
 else
  # list/go
  while [ "$1" ]; do case $1 in
   -h) echo "z [-h][-l][-r][-t] args" >/dev/stderr; return;;
   -l) local list=1;;
   -r) local typ="rank";;
   -t) local typ="recent";;
   --) while [ "$1" ]; do shift; local q="$q $1";done;;
    *) local q="$q $1";;
  esac; local n=$1; shift; done
  [ "$q" ] || local list=1
  # if we hit enter on a completion just go there
  [ -d "$n" ] && {
   cd "$n"
   return
  }
  cd="$(awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$q" -F"|" '
   function frecent(rank, time) {
    dx = t-time
    if( dx < 3600 ) return rank*4
    if( dx < 86400 ) return rank*2
    if( dx < 604800 ) return rank/2
    return rank/4
   }
   function output(r, s, c) {
    if( list ) {
     if( typ == "recent" ) {
      cmd = "sort -nr >/dev/stderr"
     } else cmd = "sort -n >/dev/stderr"
     for( i in r ) if( r[i] ) printf "%-15s %s\n", r[i], i | cmd
     if( c ) printf "%-15s %s\n", "common:", c > "/dev/stderr"
    } else {
     if( c ) s = c
     print s
    }
   }
   function common(r, a, nc) {
    for( i in r ) {
     if( r[i] && (!shortest || length(i) < length(shortest)) ) shortest = i
    }
    if( shortest == "/" ) return
    for( i in r ) {
     if( r[i] && i !~ shortest ) x = 1
    }
    if( x ) return
    if( nc ) {
     for( i in a ) if( tolower(shortest) !~ tolower(a[i]) ) x = 1
    } else for( i in a ) if( shortest !~ a[i] ) x = 1
    if( !x ) return shortest
   }
   BEGIN { split(q, a, " ") }
   {
    if( system("test -d \"" $1 "\"") ) next
    if( typ == "rank" ) {
     f = $2
    } else if( typ == "recent" ) {
     f = t-$3
    } else f = frecent($2, $3)
    case[$1] = nocase[$1] = f
    for( i in a ) {
     if( $1 !~ a[i] ) delete case[$1]
     if( tolower($1) !~ tolower(a[i]) ) delete nocase[$1]
    }
    if( case[$1] > oldf ) {
     cx = $1
     oldf = case[$1]
    } else if( nocase[$1] > noldf ) {
     ncx = $1
     noldf = nocase[$1]
    }
    print $0 >> FILENAME ".tmp"
   }
   END {
    if( cx ) {
     output(case, cx, common(case, a, 0))
    } else if( ncx ) output(nocase, ncx, common(nocase, a, 1))
   }
  ' $datafile)"
  mv -f $datafile.tmp $datafile
  [ "$cd" ] && cd "$cd"
 fi
}
# tab completion
complete -C 'z --complete "$COMP_LINE"' z
# populate directory list. avoid clobbering other PROMPT_COMMANDs.
echo $PROMPT_COMMAND | grep -q "z" || {
 PROMPT_COMMAND='z --add "$(pwd -P)";'"$PROMPT_COMMAND"
}
