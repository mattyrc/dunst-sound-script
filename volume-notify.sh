#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function get_volum_percent {
    amixer get Master | grep -m 1 -o -E [[:digit:]]+%
}

function send_notification {
    volume=`get_volume`
    percent=`get_volum_percent`
    # Make the bars (|||||)
    bar=$(seq -s "|" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i /usr/share/icons/monotone/22x22/pool/speaker.png -t 1000 -r 2593 -u normal "$percent    $bar "
}

case $1 in
    up)
    # Set the volume on (if it was muted)
    amixer -D pulse set Master on > /dev/null
    # Up the volume (+ 5%)
    amixer -D pulse sset Master 5%+ > /dev/null
    send_notification
    ;;
    down)
    amixer -D pulse set Master on > /dev/null
    amixer -D pulse sset Master 5%- > /dev/null
    send_notification
    ;;
    mute)
    # Toggle mute
    amixer -D pulse set Master 1+ toggle > /dev/null
    if is_mute ; then
        dunstify -i /usr/share/icons/monotone/22x22/pool/pnmixer-muted.png -t 1000 -r 2593 -u normal "Mute"
    else
        send_notification
    fi
    ;;
esac
