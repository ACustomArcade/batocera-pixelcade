#!/bin/bash
# Pixelcade marquee update script for Batocera

case $1 in
    gameStart)
        # Update Pixelcade display
        JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -m stream -c ${2} -g ${5}
    ;;

    gameStop)
        # Reset Pixelcade to last uploaded image to SD Card
        curl http://localhost:8080/localplayback
    ;;
esac
