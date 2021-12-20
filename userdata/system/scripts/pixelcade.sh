#!/bin/bash
# Pixelcade marquee update script for Batocera

case $1 in
    gameStart)
        # Update Pixelcade display
        curl http://127.0.0.1:8080/arcade/stream/${2}/`basename ${5}`
    ;;

    gameStop)
        # Reset Pixelcade to Batocera logo
        curl http://127.0.0.1:8080/arcade/stream/user/batocera
    ;;
esac
