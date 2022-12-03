#!/bin/bash

# load lib
. $(dirname $0)/spacebar-lib.sh

arr=(
# 这个软件有bug, 卡死后mac的sound直接不可用了
#"`output_device`"
"`volume`"
"`ip`"
#"`info`"
)

res=""

arrLength=${#arr[@]}
for ((i=0;i<${arrLength};i++))
do
  out=${arr[i]}
  [[ $i != $((arrLength - 1)) ]] && out="${out} | "
  res="$res$out"
done

echo $res
