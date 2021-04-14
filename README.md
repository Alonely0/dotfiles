# End Dotfiles
## Rofi menu
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/rofi.png">

## Alacritty
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/alacritty.png">

## Librewolf/Firefox
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/vertical_tabs_not_hovering.png">
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/vertical_tabs_hovering.png">

---

## Dependencies
- [XMonad](https://xmonad.org/), [XMonad-Contrib](https://github.com/xmonad/xmonad-contrib), [wmctrl](https://www.freedesktop.org/wiki/Software/wmctrl/) and all that stuff: Required

- [KDE Plasma](https://kde.org/plasma-desktop/): Optional, but then you won't be able to use the dock below.

- [Latte Dock Git](https://github.com/KDE/latte-dock): Optional, but needs KDE Plasma to work.

- [Kvantum](https://github.com/tsujan/Kvantum) Required if you installed KDE.

- [Ibhagwan's Picom fork](https://github.com/ibhagwan/picom): Required.

- [Rofi Git](https://github.com/davatorium/rofi): If you want a menu, it's required.

- [ZSH](https://www.zsh.org/), [Oh my ZSH](https://ohmyz.sh) and [Powerlevel10k](https://github.com/romkatv/powerlevel10k): If you want to use my zsh dotfiles, then all of them are required.

- [Tuxfetch](https://github.com/Alonely0/jfetch): Optional

- [Alacritty](https://github.com/alacritty/alacritty): If you want to use my terminal dotfiles, then it's required.

- [Librewolf](https://librewolf-community.gitlab.io/) (Or [Firefox](https://www.mozilla.org/en-US/firefox/new/), but I've only tested the dotfiles with librewolf): Optional.

- [Dunst](https://dunst-project.org/): Required because KDE notifications in XMonad are a mess, and lets you customize all.

- [PlayerCTL](https://github.com/altdesktop/playerctl): Optional, lets you use next/prev/pause keys in your keyboard.

- [BrightnessCTL](https://github.com/Hummer12007/brightnessctl): Optional, lets you use your +brightness/-brightness keys in your keyboard

- Am I missing something? Open an issue or make a pull request with the changes.


## Installation
Backup your dotfiles, and then move all the content of the repo except the screenshots folder and this readme to your `$HOME`. For librewolf/firefox setup, read readme on `.librewolf` folder.
Then, compile XMonad config with `xmonad --recompile`.

## Troubleshooting
- Dunst doesnt work!
    If dunst doesn't launch, delete or move this file: `/usr/share/dbus-1/services/org.kde.plasma.Notifications.service`.

- My wallpaper is gone!
    Reconfigure your wallpaper opening a contextual menu on the desktop (right click) and going to `Configure desktop & wallpaper` 

## Thanks to...
- [Axarva](https://github.com/Axarva) for her XMonad configuration.
- [Jimmy](https://github.com/Jimmysit0) for his fetch and his advices.
- [Garuda Linux Team](https://garudalinux.org/about.html) for a lot of the aliases of the `.zshrc`. (Yep, I used Garuda linux for a couple of months)
- [Astroryan](https://github.com/astroryan12) for his firefox config for having vertical tabs.

**A lot of thanks guys!**
