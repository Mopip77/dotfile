#!/bin/bash

shurufa() {
  curPath=$(cd `dirname $0`; pwd)
  layout=$(${curPath}/get_current_shurufa)
  if [[ $layout == *"ABC"* ]];then
     echo "🇺🇸 "
  else
     echo "🇨🇳 "
  fi
}

emoji() {
  echo " 🤦🏼💆🏻🙆🏼"
}


arr=(
"`emoji`"
#"`shurufa`"
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
