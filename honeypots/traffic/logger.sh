#!/bin/sh

LOG="/telemetry/traffic.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

while true; do
  printf "traffic> "
  IFS= read -r cmd || exit

  [ -z "$(echo "$cmd" | tr -d '[:space:]')" ] && continue

  echo "$(date) CMD: $cmd" >> "$LOG"

  sleep $(awk -v min=0.2 -v max=0.8 'BEGIN{srand(); print min+rand()*(max-min)}')

  case "$cmd" in
    status)
      echo "Signal: GREEN"
      ;;
    *)
      echo "invalid command"
      ;;
  esac
done
