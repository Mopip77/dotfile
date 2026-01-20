#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
sketchybar --set $NAME background.drawing=$SELECTED

# Handle space switching event to highlight previous space
if [[ $SENDER == "space_change" ]]; then
    # Read previous space from temp file
    PREV_SPACE=$(cat /tmp/sketchybar_prev_space 2>/dev/null || echo "")

    # Parse current space from $INFO (format: { "display-1": 7 })
    CURRENT_SPACE=$(echo "$INFO" | jq -r '.[]')

    # Reset all space icon colors to default
    for i in {1..18}; do
        sketchybar --set space.$i icon.color=$PAPER_YELLOW
    done

    # Highlight previous space with orange color (if exists and is different from current)
    if [[ -n "$PREV_SPACE" ]] && [[ "$PREV_SPACE" != "$CURRENT_SPACE" ]]; then
        sketchybar --set space.$PREV_SPACE icon.color=$MAGENTA
    fi

    # Save current space as the new previous space
    echo "$CURRENT_SPACE" > /tmp/sketchybar_prev_space
fi

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


