#!/bin/bash

export JAVA_HOME=/userdata/jdk/

case "$1" in
start)
  /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b &
;;
stop)
  /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -q
;;
esac
exit $?
