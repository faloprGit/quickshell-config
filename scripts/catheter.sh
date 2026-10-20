#!/usr/bin/env bash

FILE="$HOME/.config/quickshell/scripts/catheter/catheter_timestamp.txt"
BACKUP_FILE="$HOME/.config/quickshell/scripts/catheter/catheter_timestamp.bak"

TARGET_MONITOR="${2:-global}"
MODE_FILE="/tmp/waybar_clock_mode_${TARGET_MONITOR}"

if [ ! -f "$MODE_FILE" ]; then echo "normal" > "$MODE_FILE"; fi
if [ ! -f "$FILE" ]; then date +%s > "$FILE"; fi

# FORCE the cache file to exist instantly with a safe fallback value if missing
if [ ! -f "/tmp/waybar_update_count" ]; then echo "0" > /tmp/waybar_update_count; fi

if [ "$1" == "--toggle" ]; then
    CURRENT_MODE=$(cat "$MODE_FILE" 2>/dev/null || echo "normal")
    if [ "$CURRENT_MODE" == "seconds" ]; then
        echo "normal" > "$MODE_FILE"
    else
        echo "seconds" > "$MODE_FILE"
    fi
    pkill -SIGRTMIN+5 waybar || true
    exit 0
fi

if [ "$1" == "--update" ]; then
    if [ -f "$FILE" ]; then cp "$FILE" "$BACKUP_FILE"; fi
    date +%s > "$FILE"
    pkill -SIGRTMIN+5 waybar || true
    exit 0
fi

if [ "$1" == "--undo" ]; then
    if [ -f "$BACKUP_FILE" ]; then
        mv "$BACKUP_FILE" "$FILE"
        pkill -SIGRTMIN+5 waybar || true
    fi
    exit 0
fi

if [ "$1" == "--read" ]; then
    CURRENT_MODE=$(cat "$MODE_FILE" 2>/dev/null || echo "normal")

    LAST_SECS=$(cat "$FILE" 2>/dev/null || date +%s)
    CURRENT_SECS=$(date +%s)
    DIFF_SECS=$((CURRENT_SECS - LAST_SECS))
    if [ $DIFF_SECS -lt 0 ]; then DIFF_SECS=0; fi

    DAYS=$((DIFF_SECS / 86400))
    HOURS=$(((DIFF_SECS % 86400) / 3600))
    MINUTES=$(((DIFF_SECS % 3600) / 60))

    if [ $DAYS -gt 0 ] || [ $HOURS -gt 0 ]; then
        CATHETER_STR="󰏪 ${DAYS}d ${HOURS}h"
    else
        CATHETER_STR="󰏪 0d ${MINUTES}m"
    fi

    if [ "$CURRENT_MODE" == "seconds" ]; then
        CLOCK_TEXT=$(date +"%H:%M:%S")

        # Read the pre-calculated file instantly (0ms latency!)
        UPDATE_COUNT=$(cat /tmp/waybar_update_count 2>/dev/null || echo "0")

        # Color thresholds
        if [ "$UPDATE_COUNT" -lt 25 ]; then
            COLOR_HEX="#a4ffd2"
        elif [ "$UPDATE_COUNT" -le 100 ]; then
            COLOR_HEX="#fadb75"
        else
            COLOR_HEX="#ff7575"
        fi

        DISPLAY_LABEL="<span color='${COLOR_HEX}'>󰚰 ${UPDATE_COUNT}</span> <span color='#636366'>|</span> 󰥔 ${CLOCK_TEXT} <span color='#636366'>|</span> <span color='#75f1fa'>${CATHETER_STR}</span>"
    else
        CLOCK_TEXT=$(date +"%a, %d. %b %H:%M")
        DISPLAY_LABEL="󰥔 ${CLOCK_TEXT}"
    fi

    CALENDAR_TOOLTIP=$(cal | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
    CURRENT_DAY=$(date +"%e" | tr -d ' ')
    CALENDAR_TOOLTIP=$(echo "$CALENDAR_TOOLTIP" | sed -E "s/(^| )($CURRENT_DAY)( |$)/\\1<span color='#75f1fa'><b>\\2<\/b><\/span>\\3/")
    CALENDAR_TOOLTIP=$(echo "$CALENDAR_TOOLTIP" | awk '{printf "%s\\n", $0}' | sed 's/"/\\"/g')

    echo "{\"text\": \"${DISPLAY_LABEL}\", \"tooltip\": \"<tt><small>${CALENDAR_TOOLTIP}</small></tt>\"}"
    exit 0
fi
