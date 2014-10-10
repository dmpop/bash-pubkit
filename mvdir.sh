#!/bin/sh
# mvdir
# David Reiss <davidn@gmail.com>
# Created: 2002-07-21
# Last update: 2012-12-06

t1=`mktemp`
t2=`mktemp`
t3=`mktemp`

[ $# -gt 0 ] || set .

for d in "$@"; do
(
  cd "$d" || continue

  ls > $t1
  cp -f $t1 $t2

  ${EDITOR:-vi} $t2
  status=$?
  [ $status -ne 0 ] && exit $status

  if [ `< $t1 wc -l` -ne `< $t2 wc -l` ]; then
    echo "line count mismatch"
    rm -f $t1 $t2 $t3
    exit 1
  fi

  < $t2 sed -e "s/^-/.\/-/" -e "s/'/'\\\\''/g" -e "s/.*/'&'/" > $t3
  < $t1 sed -e "s/^-/.\/-/" -e "s/'/'\\\\''/g" -e "s/.*/'&'/" > $t2
  paste -d, $t2 $t3 | sed '/^\(.*\),\1$/d' | nl -s, > $t1
  (
    < $t1 sed -ne "s/^ *\(.*\),'\(.*\)','\(\)'$/rm '\2'/p" \
              -ne "s/^ *\(.*\),'\(.*\)','\(.*\)'$/mv '\2' '##mvdir\1'/p"
    < $t1 sed -ne "s/^ *\(.*\),'\(.*\)','\(..*\)'$/mv '##mvdir\1' '\3'/p"
  ) | sh -v

  rm -f $t1 $t2 $t3
)
status=$?
[ $status -ne 0 ] && echo "$0: aborted" && exit $?
done
