#!/bin/bash

appname="$1"
summary="$2"
body="$3"

AUDIO_DIR=$HOME/.scripts/dunst/dunst-sound/audio_files

# Convert match to lowercase
appname_case=$(echo "$appname" | tr '[:upper:]' '[:lower:]')
summary_case=$(echo "$summary" | tr '[:upper:]' '[:lower:]')
body_case=$(echo "$body" | tr '[:upper:]' '[:lower:]')

# by APPNAME ----------------------------------------------------------
case $appname_case in
    # DEFAULT NOTIFICATIONS --
    *'transmission'*|'dropbox'|*'chrom'*|'firefox'|'nwjs')
        paplay --volume 45536 $AUDIO_DIR/default.wav
        exit
        ;;
    # MESSAGING --
    *'steam'*|*'signal'*|'android'*)
        paplay --volume 45536 $AUDIO_DIR/message.wav
        exit
        ;;
    # EMAIL --
    'mailnag')
        paplay --volume 45536 $AUDIO_DIR/email.wav
        exit
        ;;
    *)
        # do nothing..
        ;;
esac

# by SUMMARY ----------------------------------------------------------
case $summary_case in
    # ERROR MESSAGES --
    *'fail'*|*'error'*|*'warn'*)
        paplay --volume 35536 $AUDIO_DIR/warn.wav
        exit
        ;;
    # TWITCH NOTIFICATIONS --
    *'live!')
        paplay $AUDIO_DIR/online.wav
        exit
        ;;
    # NEWSBOAT RSS FEED --
    'newsboat'*)
        paplay --volume 45536 $AUDIO_DIR/default.wav
        exit
        ;;
    # LOCK TIMER WARNING --
    'locker')
        paplay $AUDIO_DIR/beep.wav
        exit
        ;;
    # SCREENSHOT SCRIPT --
    'screenshot')
        paplay --volume 35536 $AUDIO_DIR/screenshot.wav
        exit
        ;;
    *)
        # do nothing..
        ;;
esac

# by BODY --------------------------------------------------------------
case $body_case in
    # ERROR MESSAGES --
    *'fail'*|*'failure'*|*'has failed'*|*'error'*|*'warn'*)
        paplay --volume 35536 $AUDIO_DIR/warn.wav
        exit
        ;;
    # MINECRAFT USER SIGN-IN/OUT
    *'joined the server'*)
        paplay --volume 35536 $AUDIO_DIR/signed-on.wav
        exit
        ;;
    *'left the server'*)
        paplay --volume 35536 $AUDIO_DIR/signed-off.wav
        exit
        ;;
    *'success'*)
        paplay --volume 35536 $AUDIO_DIR/complete.wav
        exit
        ;;
    *)
        # do nothing..
        ;;
esac
exit
