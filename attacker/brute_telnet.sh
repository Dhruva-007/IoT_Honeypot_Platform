#!/bin/bash

echo "Simulating brute-force attack on CCTV..."

for i in {1..5}
do
  (
    echo "root"
    sleep 1
    echo "password$i"
    sleep 1
  ) | telnet localhost 2323 >/dev/null 2>&1
done

echo "Done."
