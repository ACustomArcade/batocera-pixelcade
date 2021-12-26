#!/bin/bash

export JAVA_HOME=/userdata/jdk/

case "$1" in
start)
  /userdata/system/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b &
  sleep 3
  curl http://127.0.0.1:8080/arcade/stream/user/batocera
;;
stop)
  /userdata/system/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -q
;;
esac
exit $?
