#!/bin/bash

system="${1}"
systemname="${2}"

curl -G \
        --data-urlencode "t=${systemname}" \
        http://127.0.0.1:8080/console/stream/${system}
