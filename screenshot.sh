#!/bin/bash

save_dir=$HOME/Documents/Screenshots/

get_date=$(date +%m-%d-%Y_%I%M%p)

# ex. 02-11-2020_0258PM.png
filename=%m-%d-%Y_%I%M%p.png
print_date=$(date +%m-%d-%Y_%I%M%p)

while test $# -gt 0; do
    case "$1" in

    # Help Information
    -h|--help)
            echo " "
            echo "   Scrot Script with Notifications"
            echo "   ---------------------------------------------------------"
            echo " "
            echo "   This script will allow capturing a screenshot on the center"
            echo "   monitor or by using the select tool."
            echo "   A notification will also be displayed through Dunst."
            echo " "
            echo "   Options:"
            echo "      -h, --help        Display this help text"
            echo "      -c, --center      Capture the center screen"
            echo "      -s, --select      Use the selection tool"
            echo " "
            echo "   Depends:"
            echo "      Scrot             Main screenshot application"
            echo "      Dunst             Screenshot notifications"
            echo "      ImageMagick       Resizing the screenshots"
            echo " "
        exit 1
        ;;

        -c|-m|--center|middle)
        # Capture center screen only
        # Default no flag option

            shift

            # Take screenshot with scrot
            scrot -q 100 "$save_dir/$filename"

            # Get the final filename/dir of new screenshot
            unset -v latest
            for file in "$save_dir"*; do
              [[ $file -nt $latest ]] && latest=$file
            done

            # Crop image to center screen (2560x1080)
            convert $latest -crop 2560x1080+1920-0 $latest

            # Create a temporary square icon for dunst
            tmp='/tmp/tmp_scrot.png'
            convert $latest \
                -resize 11.85% \
                -gravity Center \
                -crop 128x128+227+0-0-0 \
                $tmp
            break
            ;;

        -s|--select)

            shift

            scrot -s -q 100 "$save_dir/$filename"

            # Get the final filename/dir of new screenshot
            unset -v latest
            for file in "$save_dir"*; do
                [[ $file -nt $latest ]] && latest=$file
            done

            # Create a temporary square icon for dunst
            tmp='/tmp/tmp_scrot.png'
            convert $latest \
                -resize 50.00% \
                -gravity Center \
                -crop 128x128+0+0 \
                $tmp
            break
            ;;
        *)
            echo "'$1' is not a valid flag! See help below:"
            screenshot --help
            exit 1;
            ;;
    esac
done

# Send notification via dunstify
#dunstify "Screenshot Saved" "$latest" -a screenshot -i $tmp

do_action () {
    /usr/bin/thunar "$HOME/Documents/Screenshots/"
}

dunstify --action=do_action,open "Screenshot" "$print_date.png" -a screenshot -i $tmp

exit 1
