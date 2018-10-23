#!/bin/bash

VBAN_PATH="/usr/local/bin/vban_receptor"
VBAN_STREAM_NAME="Stream1"
REMOTE_IP_ADDRESS="10.1.240.7"
LOCAL_PORT="6980"
AUDIO_BACKEND="alsa"
DEVICE="plughw:UA25EX,0"

function start_func(){
    local instances=(`pidof vban_receptor`)
    if [ "${1}" != "" ]; then
        ${VBAN_PATH} -i${REMOTE_IP_ADDRESS} -p${LOCAL_PORT} -s${VBAN_STREAM_NAME} -b${AUDIO_BACKEND} -q4 -d${1} &
        echo "PID:${!}"
    fi
}

function stop_func(){
    local instance=`netstat -pan 2>/dev/null | egrep '^udp' | grep "vban_receptor" | grep ${LOCAL_PORT} | awk '{print $6}' | awk -F'/' '{print $1}'`
    if [ "${instance}" != "" ]; then
        kill -15 ${instance}
    fi
}

case ${1} in
    start ) start_func ${DEVICE};;
    restart ) stop_func
            start_func ${DEVICE};;
    pause ) stop_func
            start_func null;;
    stop ) stop_func;;
esac
