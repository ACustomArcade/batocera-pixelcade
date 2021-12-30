#!/bin/bash

system="${1}"
systemname="${2}"

case ${system} in
  arcade)
    system="mame-arcade"
    ;;
esac

curl -G \
  --data-urlencode "event=FEScroll" \
  --data-urlencode "t=${systemname}" \
  http://127.0.0.1:8080/console/stream/${system}
