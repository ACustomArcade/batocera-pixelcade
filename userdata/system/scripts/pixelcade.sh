#!/bin/bash
# Pixelcade marquee update script for Batocera

action=${1}
systemName=${2}
emulator=${3}
core=${4}
rom=${5}

case ${systemName} in
  fbneo)
    systemName="mame"
    ;;
  scummvm)
    rom="${rom%.*}"
    ;;
esac

case $action in
    gameStart)
        # Update Pixelcade display
        curl http://127.0.0.1:8080/arcade/stream/${systemName}/`basename ${rom}`
    ;;

    gameStop)
        # Reset Pixelcade to Batocera logo
        curl http://127.0.0.1:8080/arcade/stream/user/batocera
    ;;
esac
