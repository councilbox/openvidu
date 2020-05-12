#!/bin/bash

### Use container as a single headless chrome ###

if [ "$HEADLESS_CHROME_ONLY" == true ]; then
    google-chrome --no-sandbox --headless --remote-debugging-port=$HEADLESS_CHROME_PORT  &> /chrome.log &
    sleep 100000000
else

### Use container as OpenVidu recording module ###

### Variables ###

URL=${URL:-https://councilbox.com}
RESOLUTION=${RESOLUTION:-640x360}
FRAMERATE=${FRAMERATE:-25}
WIDTH="$(cut -d'x' -f1 <<< $RESOLUTION)"
HEIGHT="$(cut -d'x' -f2 <<< $RESOLUTION)"
RTMP_URL=${RTMP_URL:-false}
BITRATE=${BITRATE:-700k}

export URL
export RESOLUTION
export FRAMERATE
export WIDTH
export HEIGHT
export RTMP_URL

### Show rtmp url
echo "RTMP address ==> $RTMP_URL"
### Show url to stream
echo "URL to stream ==> $URL"
### Show resolution, framerate, bitrate
echo "Resolution: $RESOLUTION ; Framerate: $FRAMERATE ; Bitrate: $BITRATE"

### Get a free display identificator ###

DISPLAY_NUM=99
DONE="no"

while [ "$DONE" == "no" ]
do
  out=$(xdpyinfo -display :$DISPLAY_NUM 2>&1)
  if [[ "$out" == name* ]] || [[ "$out" == Invalid* ]]
  then
     # Command succeeded; or failed with access error;  display exists
     (( DISPLAY_NUM+=1 ))
  else
     # Display doesn't exist
     DONE="yes"
  fi
done

export DISPLAY_NUM

echo "First available display -> :$DISPLAY_NUM"
echo "----------------------------------------"

pulseaudio -D

### Start Chrome in headless mode with xvfb, using the display num previously obtained ###

touch xvfb.log
chmod 777 xvfb.log
xvfb-run --server-num=${DISPLAY_NUM} --server-args="-ac -screen 0 ${RESOLUTION}x24 -noreset" google-chrome --start-maximized --no-sandbox --test-type --disable-dev-shm-usage --disable-infobars --window-size=$WIDTH,$HEIGHT --window-position=0,0 --no-first-run --ignore-certificate-errors --autoplay-policy=no-user-gesture-required --kiosk $URL &> xvfb.log &
touch stop
sleep 2

if [[ "$RTMP_URL" != false ]]; then
  echo "Send rtmp"
  <./stop ffmpeg -y -f alsa -i pulse -f x11grab -draw_mouse 0 -framerate $FRAMERATE -video_size $RESOLUTION -i :$DISPLAY_NUM -c:a aac -c:v libx264 -b:v $BITRATE -preset ultrafast -crf 28 -refs 4 -qmin 4 -pix_fmt yuv420p -filter:v fps=$FRAMERATE -f flv $RTMP_URL
else
  echo "Rtmp sending failed, rtmp address not received"
fi

fi