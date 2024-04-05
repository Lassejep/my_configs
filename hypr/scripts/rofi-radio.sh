#!/bin/sh

ARGS="--no-video"
notification(){
	notify-send "Playing now: " "$@"
}

menu(){
	printf "1. Lofi Girl <lofi>\n"
    printf "2. Theprimeagen <stream>\n"
    printf "3. DR P1 <radio>\n"
    printf "4. PirateSoftware <stream>\n"
}

main() {
    choice=$(menu | rofi -dmenu | cut -d. -f1)

    case $choice in
        1)
            notification "Lofi Girl🎶";
            URL="https://youtu.be/jfKfPfyJRdk"
            ADDITIONAL_ARGS="--volume=60"
            break
            ;;
        2)
            notification "Theprimeagen Stream";
            URL="https://www.twitch.tv/theprimeagen"
            ADDITIONAL_ARGS=""
            break
            ;;
        3)
            notification "DR P1";
            URL="https://live-icy.gslb01.dr.dk/A/A03H.mp3"
            additional_args=""
            break
            ;;
        4)
            notification "PirateSoftware Stream";
            URL="https://www.twitch.tv/piratesoftware"
            ADDITIONAL_ARGS=""
            break
            ;;

        esac
        mpv $ARGS --title="radio-mpv" $URL $ADDITIONAL_ARGS
    }

pkill -f radio-mpv || main
notify-send "Radio stopped"
