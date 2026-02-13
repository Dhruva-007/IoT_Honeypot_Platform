#!/bin/sh

LOG="/telemetry/cctv.log"
SESSION_ID=$(date +%s)

echo "[SESSION START] id=$SESSION_ID time=$(date)" >> "$LOG"

while true; do
  printf "# "
  IFS= read -r cmd || exit

  [ -z "$(echo "$cmd" | tr -d '[:space:]')" ] && continue

  echo "$(date) CMD: $cmd" >> "$LOG"

  # Realistic latency
  sleep $(awk -v min=0.2 -v max=0.8 'BEGIN{srand(); print min+rand()*(max-min)}')

  case "$cmd" in
    uname*)
      echo "Linux 3.10.14 #1 SMP Embedded"
      ;;
    ps)
      echo "  PID TTY      STAT   TIME COMMAND"
      echo "    1 ?        Ss     0:00 init"
      echo "   45 ?        S      0:01 watchdog"
      echo "  101 ?        S      0:00 telnetd"
      ;;
    wget*|curl*|tftp*|nc*)
      echo "Downloading..."
      ;;
    ls*)
      echo "bin etc proc var tmp"
      ;;
    cat*)
      echo "file content"
      ;;
    *)
      RESP=$(shuf -n1 <<EOF
command not found
invalid input
operation completed
EOF
)
      echo "$RESP"
      ;;
  esac
done
