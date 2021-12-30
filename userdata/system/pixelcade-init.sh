#!/bin/bash

export JAVA_HOME=/userdata/jdk/

case "$1" in
start)
  cd /userdata/system/pixelcade
  /userdata/system/jdk/jre/bin/java -Dioio.SerialPorts=/dev/ttyACM0 -jar /userdata/system/pixelcade/pixelweb.jar -b &
;;
stop)
  curl -G \
    --data-urlencode "event=FEQuit" \
    http://127.0.0.1:8080/quit
;;
esac
exit $?
