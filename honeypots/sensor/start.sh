#!/bin/sh
echo "EnvSensor v2.1"

exec socat TCP-LISTEN:1883,reuseaddr,fork EXEC:/logger.sh,pty,stderr,setsid,sane,echo=0
