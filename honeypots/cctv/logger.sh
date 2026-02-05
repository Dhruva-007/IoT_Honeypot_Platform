#!/bin/sh

LOG="/telemetry/cctv.log"

SESSION_ID=$(date +%s)
echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

while true; do
  printf "# "
  IFS= read -r cmd || exit

  # Ignore empty or whitespace-only input
  if [ -z "$(echo "$cmd" | tr -d '[:space:]')" ]; then
    continue
  fi

  echo "$(date) CMD: $cmd" >> "$LOG"

  sh -c "$cmd"
done
