#!/bin/bash

if [ ! -z "${JAVA_OPTIONS}" ]; then
    echo "Using java options: ${JAVA_OPTIONS}"
fi

JAVA_OPTIONS=${JAVA_OPTIONS:--Xms2048m -Xmx4096m}
export JAVA_OPTIONS

java ${JAVA_OPTIONS} -jar openvidu-server.jar