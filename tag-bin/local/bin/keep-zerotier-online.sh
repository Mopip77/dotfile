#!/bin/bash

help() {
    echo "Usage: $0 <ping-ip> <zt-network-id>"
    echo ""
    echo "Ping <ping-ip> first. If failed, leave and re-join <zt-network-id>"
}

main() {
    if ! ping -c 5  $1 &> /dev/null; then
        echo "failed to ping $1, re-join $2"
        sudo zerotier-cli leave $2
        sudo zerotier-cli join $2
    fi
}

if [[ $# -ne 2 ]]; then
    help
else
    main $@
fi
