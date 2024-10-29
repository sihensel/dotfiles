# Welcome ~/

This repository contains my personal Linux dotfiles.<br>
They are often (speak: all the time) a work in progress and may or may not work for you.<br>

![screenshot.png](screenshot.png)


## Dependencies

The list of used packages can be found in `packages.txt` and `packages_AUR.txt`.<br>
To install them, use:

```sh
pacman -S --needed - < packages.txt
yay -S --needed - < packages_AUR.txt
```

The configs for `awesome`, `picom`, and `kitty` are outdated, if you want to use them, make sure to install these packages as well.
```
pacman -S awesome kitty rofi slock flameshot
yay -S picom-git
```


## Installation

Clone the repo into your home directory.

```sh
git clone https://github.com/sihensel/dotfiles.git
```

There is no wallpaper included, the window manager looks for `~/wallpapers/wall.jpg`.<br>
This can be configured in [theme.lua](awesome/themes/groovebox/theme.lua#L42) for awesome or [process.sh](river/process.sh#L44) for river.

### Install Script

The script `install.sh` places symlinks to the local repo, so all files can stay in one place.<br>
You might want to ignore that, this is just for my personal setup.

```sh
./install.sh   # or
./install.sh -p /path/to/dotfiles/
```

*Note*: I use the `xdg-user-dirs` package to get rid of most of the standard XDG directories. See the [user-dirs.dirs](./user-dirs.dirs) file for details.


## Configure Neovim Plugins

The keybinds are listed in [init.lua](nvim/init.lua).<br>
Plugins are managed via [Lazy.nvim](https://github.com/folke/lazy.nvim). The Plugin manager installs itself and all plugins automatically.<br>
LSP clients are also installed automatically via [Mason](https://github.com/williamboman/mason.nvim).

The following packages are exteneral dependencies, install them with your package manager:
```
fd ripgrep fzf jq tree-sitter tree-sitter-cli
```

Also install the Python provider for Neovim.
```
pip install neovim
```


## Firefox userChrome.css

This theme is heavily based on [Dook97's](https://github.com/Dook97/firefox-qutebrowser-userchrome) config with a few additions.
It is intended to use with the [tridactyl](https://github.com/tridactyl/tridactyl) extension (Install the `firefox-tridactyl` package for Arch, and restart Firefox _twice_).<br>
When using Librewolf (or any other Firefox fork I guess), install the `tridactyl` extension from their Github repo.

Go to `about:config`:
1. Set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
2. Set `browser.compactmode.show` to `true`
3. Also set `extensions.pocket.enabled` to `false` while we're at it
4. For my setup:
    1. `browser.tabs.loadBookmarksInBackground` to `true`
    2. `browser.bookmarks.openInTabClosesMenu` to `false`
    3. `browser.translations.automaticallyPopup` to `false`
    4. `browser.translations.enable` to `false`
    5. `browser.translations.panelShown` to `false`

Go to the `Customize Toolbar` menu (under `More Tools`) and set `density` to `compact`.<br>
Enable a dark theme in the settings, I use [this Gruvbox theme](https://addons.mozilla.org/en-US/firefox/addon/gruvbox-dark-theme/).<br>
Copy the `chrome` directory to the root directory of your Firefox profile. Check `about:profiles` for the path to your profile.

The custom folder icon for the bookmarks toolbar is from [icons8.com](https://icons8.com/icon/12160/folder).


## Slack Theme

Gruvbox Slack theme. Paste into `Preferences` > `Themes`.
```
#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7
```


## Pacman Hook

Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo mkdir /etc/pacman.d/hooks
sudo cp clear_cache.hook /etc/pacman.d/hooks
```


## Enable screen sharing for Chrome and Slack

For Chrome, visit `chrome://flags/#enable-webrtc-pipewire-capturer` and `chrome://flags/#ozone-platform-hint`.<br>
Start Chrome with `google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland`.

Start Slack with: `slack --enable-features=WebRTCPipeWireCapturer`.
