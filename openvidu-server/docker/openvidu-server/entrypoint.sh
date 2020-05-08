#!/bin/bash

printf "\n"
printf "\n  ======================================="
printf "\n  =       LAUNCH OPENVIDU-SERVER        ="
printf "\n  ======================================="
printf "\n"

if [ ! -z "${JAVA_OPTIONS}" ]; then
    printf "\n  Using java options: %s" "${JAVA_OPTIONS}"
fi

JAVA_OPTIONS=${JAVA_OPTIONS:--Xms2048m -Xmx4096m}
export JAVA_OPTIONS

java ${JAVA_OPTIONS} -jar openvidu-server.jar