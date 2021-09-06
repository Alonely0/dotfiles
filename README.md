# End Dotfiles
[**!!! UNMANTAINED !!!**](https://github.com/Alonely0/dotfiles-2.0)
## Rofi menu
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/rofi.png">

## Alacritty
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/alacritties.png">

## NeoVim
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/nvim+browser.png">
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/nvim.png">

## Ranger *(with NeoVim integration)*
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/ranger.png">

## Librewolf/Firefox
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/vertical_tabs_not_hovering.png">
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/vertical_tabs_hovering.png">

## DuckDuckGo theme
<img src="https://raw.githubusercontent.com/Alonely0/dotfiles/master/screenshots/ddg.png">

---

## Dependencies
- [XMonad](https://xmonad.org/), [XMonad-Contrib](https://github.com/xmonad/xmonad-contrib), [wmctrl](https://www.freedesktop.org/wiki/Software/wmctrl/) and all that stuff: Required

- [Polybar Git](https://github.com/polybar/polybar): Required if you want a bar on the top of your screen.

- [NeoVim Git](https://github.com/neovim/neovim): Optional if you use another editor such as Emacs and you don't care about using my NeoVim dotfiles.

- [Ranger Git](https://github.com/ranger/ranger) & [Ueberzug Git](https://aur.archlinux.org/packages/python-ueberzug-git/): Optional if you use another file manager such as Thunar and you don't care about using my Ranger dotfiles.

- [Ibhagwan's Picom fork](https://github.com/ibhagwan/picom): Required.

- [Rofi Git](https://github.com/davatorium/rofi): If you want a menu, it's required.

- [ZSH](https://www.zsh.org/), [Oh my ZSH](https://ohmyz.sh) and [Powerlevel10k](https://github.com/romkatv/powerlevel10k): If you want to use my zsh dotfiles, then all of them are required.

- [Tuxfetch](https://github.com/Alonely0/jfetch): Optional

- [Alacritty](https://github.com/alacritty/alacritty): If you want to use my terminal dotfiles, then it's required.

- [Librewolf](https://librewolf-community.gitlab.io/) (Or [Firefox](https://www.mozilla.org/en-US/firefox/new/), but I've only tested the dotfiles with librewolf): Optional.

- [Dunst](https://dunst-project.org/): Required, elsewhere you won't have notifications.

- [PlayerCTL](https://github.com/altdesktop/playerctl): Optional, lets you use next/prev/pause keys in your keyboard.

- [BrightnessCTL](https://github.com/Hummer12007/brightnessctl): Optional, lets you use your +brightness/-brightness keys in your keyboard

- Am I missing something? Open an issue or make a pull request with the changes.

---

## Installation
Backup your dotfiles, and then move all the content of the repo except the screenshots folder and this readme to your `$HOME`. For librewolf/firefox setup, read readme on `.librewolf` folder. Then, compile XMonad config with `xmonad --recompile`.

For the Duckduckgo theme, go to your browser's settings and set your new tab URL to this: ```https://duckduckgo.com/?kae=-1&kav=1&kao=-1&kay=b&kaq=-1&kaj=m&kg=p&kp=-2&kap=-1&kbc=1&kax=-1&kv=-1&kak=-1&k21=303751&kj=303751&k9=ffffff&kx=00b7ff&k8=c1c1c1&kaa=8b8b8b&k7=181b28```

---

## Troubleshooting
- My wallpaper is gone!
    Ensure FEH is installed and edit the line of the xmonad config that launches it and modify it with the path of your wallpaper.
- When logging in, suddently my greeter pops up again!
    Open a TTY, log in with your user and write `xmonad --recompile`. Then come back to your greeter and try again.

---

## Thanks to...
- [Axarva](https://github.com/Axarva) for her XMonad configuration.
- [Jimmy](https://github.com/Jimmysit0) for his fetch and his advices.
- [Garuda Linux Team](https://garudalinux.org/about.html) for a lot of the aliases of the `.zshrc`. (Yep, I used Garuda linux for a couple of months)
- [Astroryan](https://github.com/astroryan12) for his firefox config for having vertical tabs.

**A lot of thanks guys!**
