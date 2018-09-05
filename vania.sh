#!/bin/bash

# Vania Menu
options=(
    "Install Open edX"
    "Generate Certificate"
    "Check Status"
    "Restart LMS"
    "Restart CMS"
    "Restart edxapp_worker"
		"Install Open edX Insight"
    "Quit"
)
PS3="Select your Open edX task (1-8): "

select option in "${options[@]}"; do
    case "$REPLY" in
        1) bash install-openedx.sh ;;
        2) bash gencert-openedx.sh ;;
        3) bash status-openedx.sh ;;
        4) bash restart-lms-openedx.sh ;;
        5) bash restart-cms-openedx.sh ;;
        6) bash restart-edxappworker-openedx.sh ;;
        7) bash install-insights.sh ;;
				8) break ;;
    esac
done
