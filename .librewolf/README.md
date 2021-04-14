# Librewolf/Firefox dotfiles

## 1: Install dots
Open librewolf (aka the privacy-respectful firefox) and enter this browser page `about:support`. Here you must find your `profile` directory and paste it somewhere, we'll use it later

## 2. Install backend
Go ahead and install [This extension](https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/)

## 3. Install dots
Do you remember that I told you to keep your profile dir? Now we'll need it.
If you used any `userChrome.css` earlier, delete all stuff on your `PROFILE_DIR/chrome`. Once done, move all stuff in `./profile/` to your profile folder.
[Install my firefox theme](https://addons.mozilla.org/en-US/firefox/addon/end-theme/) (only if you want the by default colors to match)

## 3. Apply dots
Enter `about:config` and enter this in the search box `toolkit.legacyUserProfileCustomizations.stylesheets`. Then set its value to true.
Go to this browser page `about:addons` and enter Tree Style Tab's preferences. Scroll down until the end of the configuration page and import the `config-hover.json` that I dropped in your profile dir.

Then, scroll up a little for finding the **Advance** section. Open it and load the CSS file that I also dropped in your profile dir, named as `treestyletab.css`

## Reboot librewolf
Go to `about:restartrequired` and click the restart button for applying at 100% the vertical tabs.

## Troubleshooting
- Vertical tabs disappeared
    Uninstall the extension and install it again, then do sections 3 & 4 again.

- Vertical tabs getting weird
    Delete `PROFILE_DIR/chrome`, `PROFILE_DIR/config-hover.css`and `PROFILE_DIR/treestyletab.css`, the extension `Tree Style Tab` and then redo the installation.

- Anything else?
    Open up an issue.
