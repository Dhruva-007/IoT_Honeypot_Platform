#!/bin/bash

LOGFILE="telemetry/ip_connections.log"

echo "[IP LOGGER START] $(date)" >> $LOGFILE
echo "Monitoring TCP SYN packets to port 2323 (packet-level)" >> $LOGFILE

sudo tcpdump -i any -n tcp dst port 2323 and tcp[tcpflags] & tcp-syn != 0 -l 2>/dev/null |
while read line; do
    SRC_IP=$(echo "$line" | grep -oE 'IP ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' | head -1 | awk '{print $2}')
    if [ -n "$SRC_IP" ]; then
        echo "$(date) SRC_IP=$SRC_IP DST_PORT=2323" >> $LOGFILE
    fi
done
