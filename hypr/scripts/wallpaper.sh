case $1 in

    # Load wallpaper from .cache of last session 
  "init")
    if [ -f ~/.cache/current_wallpaper.jpg ]; then
      wal -q -i ~/.cache/current_wallpaper.jpg
      echo "Wallpaper loaded from cache"
    else
      wal -q -i ~/git/wallpapers/
      echo "Random wallpaper selected"
    fi
  ;;

  "select")
    selected=$(ls ~/git/wallpapers | grep "jpg" | rofi -dmenu -replace -config ~/git/my_configs/rofi/config-wallpaper.rasi)
    if [ ! "$selected" ]; then
      echo "No wallpaper selected"
      exit
    fi
    wal -q -i ~/git/wallpapers/$selected
    echo "Wallpaper $selected selected"
  ;;

  # Randomly select wallpaper 
  *)
    wal -q -i ~/git/wallpapers/
    echo "Random wallpaper selected"
  ;;

esac

# ----------------------------------------------------- 
# Load current pywal color scheme
# ----------------------------------------------------- 
source "$HOME/.cache/wal/colors.sh"
echo "Wallpaper: $wallpaper"

# ----------------------------------------------------- 
# Copy selected wallpaper into .cache folder
# ----------------------------------------------------- 
cp $wallpaper ~/.cache/current_wallpaper.jpg
cp $wallpaper ~/.cache/lockscreen.png

# ----------------------------------------------------- 
# get wallpaper iamge name
# ----------------------------------------------------- 
newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")

# ----------------------------------------------------- 
# Reload waybar with new colors
# -----------------------------------------------------
~/git/my_configs/waybar/launch.sh

# ----------------------------------------------------- 
# Set the new wallpaper
# -----------------------------------------------------
transition_type="wipe"
# transition_type="outer"
# transition_type="random"

swww img $wallpaper \
  --transition-bezier .43,1.19,1,.4 \
  --transition-fps=60 \
  --transition-type=$transition_type \
  --transition-duration=0.7 \
  --transition-pos "$( hyprctl cursorpos )"

pywalfox update
pywal-discord update

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
sleep 1
notify-send "Colors and Wallpaper updated" "with image $newwall"

echo "DONE!"
