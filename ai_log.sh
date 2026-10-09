#!/bin/bash
# AI Logger Shell Wrapper - Simplifies logging from shell scripts
# Usage: ai_log prompt "Your message here"
#        ai_log response "AI response here"
#        ai_log code "Code snippet"
#        ai_log system "System message"

LOG_FILE="${AI_LOG_FILE:-/root/ailog.md}"
TYPE="$1"
shift
MESSAGE="$*"

# Ensure log file exists
touch "$LOG_FILE"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

case "$TYPE" in
    prompt)
        ICON="USER"
        ;;
    response)
        ICON="AI"
        ;;
    code)
        ICON="CODE"
        ;;
    system)
        ICON="SYS"
        ;;
    *)
        ICON="INFO"
        ;;
esac

echo "" >> "$LOG_FILE"
echo "### [$TIMESTAMP] $ICON" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "$MESSAGE" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Logged to $LOG_FILE"