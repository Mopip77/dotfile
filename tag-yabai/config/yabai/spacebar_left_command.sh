#!/bin/bash

# load lib
. $(dirname $0)/spacebar-lib.sh

arr=(
  "`output_device`"
  "`now_playing`"
)

res=""

arrLength=${#arr[@]}
for ((i=0;i<${arrLength};i++))
do
  out="${arr[i]}"
  if [[ ! -z "$out" ]]; then
      res="$res | $out"
  fi
done

echo $res
