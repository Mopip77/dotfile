#!/bin/bash

# patch one file diff to others
if [[  $# -eq 0 || $1 = "-h" ]]; then
  echo "./$0 <diff-target-ref> <src> <dst>[...<dst>]"
fi

diff_file=$(mktemp)
git diff $1 $2 > $diff_file

for arg in "${@:3}"
do
  patch -p1 $arg $diff_file
done
