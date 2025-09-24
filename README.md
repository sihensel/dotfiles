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
fd ripgrep fzf tree-sitter tree-sitter-cli
```

Also install the Python provider for Neovim.
```
pip install neovim
```


## Firefox setup

Go to `about:config`:
- `extensions.pocket.enabled` to `false`
- `browser.tabs.loadBookmarksInBackground` to `true`
- `browser.bookmarks.openInTabClosesMenu` to `false`
- `browser.tabs.loadBookmarksInTabs` to `true`
- `browser.translations.automaticallyPopup` to `false`
- `browser.translations.enable` to `false`
- `media.videocontrols.picture-in-picture.video-toggle.enabled` to `false`
- `browser.tabs.hoverPreview.enabled` to `false`
- `browser.tabs.hoverPreview.showThumbnails` to `false`
- `middlemouse.paste` to `false`
- `browser.quitShortcut.disabled` to `false`

Add the following line to the `My Filters` tab in uBlock Origin to disable the "Sign in with ..." popup.

```
accounts.google.com/gsi/*
```


## Slack Theme

Gruvbox Slack theme. Paste into `Preferences` > `Appearance`.
```
#282828,#D65D0E,#83C07C,#FB4934
```


## Pacman Hook

Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo mkdir /etc/pacman.d/hooks
sudo cp clear_cache.hook /etc/pacman.d/hooks
```
