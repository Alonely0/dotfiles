theme="end"

dir="$HOME/.config/rofi/launcher"

rofi -no-lazy-grab -show drun \
-modi run,drun,window \
-theme $dir/"$theme".rasi -drun-icon-theme "BeautyLine" -font 'noto sans 11'
