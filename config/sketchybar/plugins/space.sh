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

        QUERY=$(yabai -m query --windows --space $sid | jq 'sort_by(.app) | .[] | select(."is-sticky" == false and ."is-hidden" == false and ."role" != "" and ."is-minimized" == false) | .app')

        if grep -q "\"" <<< $QUERY; then

            while IFS= read -r line; do arr+=("$line"); done <<< "$QUERY"

                for i in "${!arr[@]}"
                do
                    icon=$(echo ${arr[i]} | sed 's/"//g')
                    icon=$($HOME/.config/sketchybar/icons.sh $icon)
                    icons+="$icon "
                done

        fi

        sketchybar --set space.$sid label="$icons"

    done

fi

