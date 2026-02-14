#!/bin/sh
echo "EnvSensor v2.1"

exec socat TCP-LISTEN:1883,reuseaddr,fork EXEC:/logger.sh,echo=0
