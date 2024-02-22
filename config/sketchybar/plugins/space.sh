#!/bin/bash

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
sketchybar --set $NAME background.drawing=$SELECTED

if [[ $SENDER == "front_app_switched" ]]; then

    SPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

    for i in "${!SPACES[@]}"; do
        sid=$(($i+1))
        arr=()
        icons=""

        # 特殊处理，Bob 在每个 space 都会被查询出来，直接过滤
        QUERY=$(yabai -m query --windows --space $sid | jq '.[] | select(.app != "Bob") | .app')

        if grep -q "\"" <<< $QUERY; then

            while IFS= read -r line; do arr+=("$line"); done <<< "$QUERY"

                for i in "${!arr[@]}"
                do
                    icon=$(echo ${arr[i]} | sed 's/"//g')
                    icon=$($HOME/.config/sketchybar/icons.sh $icon)
                    icons+="$icon  "
                done

        fi

        sketchybar --set space.$sid label="$icons"

    done

fi

