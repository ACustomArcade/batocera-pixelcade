#!/bin/bash
JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -m stream -c ${1} -g ${2} -t "${3}"
