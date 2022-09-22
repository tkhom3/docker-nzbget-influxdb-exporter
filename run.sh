#!/bin/sh

OPTION="$1"
LOCKFILE="$HOME/influxdb-export.lock"

# Cleanup file on exit
trap 'rm -f "$LOCKFILE"' EXIT

if [ ! -e "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

if [[ "$OPTION" = "start" ]]; then
  echo "Collecting metrics on the following CRON schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE sh $HOME/run.sh run" | crontab - && crond -f

elif [[ "$OPTION" = "run" ]]; then
  if [ -f "$LOCKFILE" ]; then
    echo "$LOCKFILE detected, exiting! Already running?" | tee -a "$LOG_FILE"
    exit 1
  else
    touch "$LOCKFILE"
  fi

  python3 "$HOME/export.py" 2>&1 | tee -a "$LOG_FILE"
  rm -f "$LOCKFILE"

else
  echo "Unsupported option: $OPTION" | tee -a "$LOG_FILE"
  exit 1
fi
