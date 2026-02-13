#!/bin/bash

echo "Blocking outbound traffic from honeypots..."

iptables -A FORWARD -d 0.0.0.0/0 -j DROP

echo "Outbound blocked."
