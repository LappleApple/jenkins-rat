#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'

MESSAGE="$1"
TITLE="${2:-}"
COLOR="${3:-purple}"

NOTIFY=false
if [ $COLOR = red ]; then NOTIFY=true; fi

curl -f -s -XPOST $RAT_HIPCHAT_URL/v2/room/$RAT_HIPCHAT_ROOM/notification?auth_token=$RAT_HIPCHAT_TOKEN \
    -d "message=$MESSAGE&from=$TITLE&color=$COLOR&notify=$NOTIFY"
