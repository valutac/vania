#!/bin/bash

# Vania Menu
options=(
    "Install Open edX"
    "Generate Certificate"
    "Quit" 
)
PS3="Select your Open edX task (1-3): " 

select option in "${options[@]}"; do
    case "$REPLY" in 
        1) bash install-openedx.sh ;;
        2) bash gencert-openedx.sh ;;
        3) break ;;
    esac
done