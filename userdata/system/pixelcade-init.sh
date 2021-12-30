#!/bin/bash

export JAVA_HOME=/userdata/jdk/

case "$1" in
start)
  /userdata/system/jdk/jre/bin/java -Dioio.SerialPorts=ttyACM0 -jar /userdata/system/pixelcade/pixelweb.jar -b &
  sleep 3
  curl -G \
    --data-urlencode "event=FEStart" \
    http://127.0.0.1:8080/arcade/stream/user/batocera
;;
stop)
  curl -G \
    --data-urlencode "event=FEQuit" \
    http://127.0.0.1:8080/quit
;;
esac
exit $?
