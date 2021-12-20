#!/bin/bash
curl -G \
        --data-urlencode "t=${3}" \
        http://127.0.0.1:8080/arcade/stream/${1}/`basename ${2}`
