#!/usr/bin/env zsh

FILE="/tmp/yabai_active_window_info"
# window save line format
# id<>app<>title

action=${1:-}

# Initialize hisotry file
[[ "init" = "$action" ]] && [[ -e $FILE ]] && rm $FILE
[[ -e $FILE ]] || touch $FILE

# Load history window ids
window_ids=( $(cat $FILE) )

# Record new window id
window_id=$"YABAI_WINDOW_ID"

json=$(yabai -m query --windows --window $window_id)

echo "window created."

if [ -n $json ]; then
  app=$(echo $json | jq '.app')
  if (($IGNORE_APPS[(I)$app])); then
    echo "app:${app} is in black list."
    return
  fi
fi

