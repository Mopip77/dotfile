#!/bin/bash

###
#
# 记录最近使用的窗口便于切换
#
###

export LOGFILE="/tmp/yabai-recent.log"
export LOCKFILE="/tmp/yabai-recent.lock"
export CAPACITY=10

function init() {
    if [[ ! -e "${RECENT_WINDOW_ID_LOG_FILE}" ]]; then
        touch "${RECENT_WINDOW_ID_LOG_FILE}"
    fi
}

function record() {
    exec 200>"$LOCKFILE"
    flock -n 200 || { echo "Another instance is already running"; exit 1; }
    # 过滤 sticky 窗口
    local is_sticky=$(yabai -m query --windows --window $YABAI_WINDOW_ID | jq '."is-sticky"')
    if [[ "$is_sticky" = "true" ]]; then
        return
    fi

    WINDOW_IDS=()
    while IFS= read -r line; do
        WINDOW_IDS+=("$line")
    done < "$LOGFILE"

    WINDOW_IDS=("${WINDOW_IDS[@]/$YABAI_WINDOW_ID}")
    WINDOW_IDS=($YABAI_WINDOW_ID ${WINDOW_IDS[@]})

    if [ ${#WINDOW_IDS[@]} -gt $CAPACITY ]; then
        WINDOW_IDS=("${WINDOW_IDS[@]:0:$CAPACITY}")
    fi

    printf "%s\n" "${WINDOW_IDS[@]}" > "$LOGFILE"
}

function focus_recent() {
    WINDOW_IDS=()
    while IFS= read -r line; do
        WINDOW_IDS+=("$line")
    done < "$LOGFILE"

    local CURRENT_WINDOW_ID=$(yabai -m query --windows --window | jq '.id')

    for ID in "${WINDOW_IDS[@]}"; do
        if [ "$ID" != "$CURRENT_WINDOW_ID" ]; then
            yabai -m window --focus $ID
            return
        fi
    done

}

case "$1" in
    init)
        init
        ;;
    focus)
        focus_recent
        ;;
    record)
        record
        ;;
esac


