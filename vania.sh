#!/bin/bash

# Vania Menu
options=(
    "Install Open edX"
    "Generate Certificate"
    "Check Status"
    "Restart LMS"
    "Restart CMS"
    "Restart edxapp_worker"
    "Quit" 
)
PS3="Select your Open edX task (1-7): " 

select option in "${options[@]}"; do
    case "$REPLY" in 
        1) bash install-openedx.sh ;;
        2) bash gencert-openedx.sh ;;
        3) bash status-openedx.sh ;;
        4) bash restart-lms-openedx.sh ;;
        5) bash restart-cms-openedx.sh ;;
        6) bash restart-edxappworker-openedx.sh ;;
        7) break ;;
    esac
done