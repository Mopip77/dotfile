#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin

function log() {
    echo "${*}" >> /tmp/T/claude.log
}

if [ -n "${YABAI_SPACE_INDEX}" ]; then
    if command -v yabai >/dev/null; then
        yabai -m space --focus ${YABAI_SPACE_INDEX}
    fi
fi

