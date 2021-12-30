#!/bin/bash

system="${1}"
rom="${2}"
romname="${3}"

case ${system} in
  fbneo)
    system="mame"
    ;;
  scummvm)
    rom="${rom%.*}"
    ;;
esac

curl -G \
        --data-urlencode "event=FEScroll" \
        --data-urlencode "t=${romname}" \
        http://127.0.0.1:8080/arcade/stream/${system}/`basename ${rom}`
