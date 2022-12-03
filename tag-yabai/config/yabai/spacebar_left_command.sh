#!/bin/bash

# load lib
. $(dirname $0)/spacebar-lib.sh

arr=(
  "`output_device`"
)

res=""

arrLength=${#arr[@]}
for ((i=0;i<${arrLength};i++))
do
  [[ $i -eq 0 ]] && res="| "

  out=${arr[i]}
  [[ $i != $((arrLength - 1)) ]] && out="${out} | "
  res="$res$out"
done

echo $res
