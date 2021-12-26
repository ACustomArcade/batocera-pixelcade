#!/bin/bash
echo "${1} ${2} ${3}" >> /userdata/system/logs/test.log
system="${1}"
rom="${2}"
romname="${3}"

if [[ "${system}" == "fbneo" ]]; then
        system="mame"
fi

curl -G \
        --data-urlencode "t=${romname}" \
        http://127.0.0.1:8080/arcade/stream/${system}/`basename ${rom}`
