# Welcome ~/

This repository contains my personal Linux dotfiles.  
They are often (speak: all the time) a work in progress and may or may not work for you.  
I use [Awesome](https://awesomewm.org) with my own theme called _Groovebox_ and `picom-git` on Arch.

![screenshot.png](screenshot.png)

## Installation

### Dependencies

Some of these are not hard dependencies and can be changed in the config files.  
This is more of a list for me, the packages are for `pacman`.

Dependency | Package
--- | ---
Awesome | `awesome`
Picom | `picom-git` (AUR)
Alacritty | `alacritty`
Zsh | `zsh zsh-syntax-highlighting`
Rofi | `rofi`
Slock | `slock`
NetworkManager-Applet | `network-manager-applet networkmanager-openvpn`
Brave | `brave-bin` (AUR)
Moc | `moc-pulse` (AUR)
Flameshot | `flameshot`
Zathura | `zathura zathura-pdf-poppler`
Roboto Mono Nerd Font | `nerd-fonts-roboto-mono` (AUR)

Clone the repo into your home directory.

```sh
git clone https://github.com/sihensel/dotfiles.git
```

There is no wallpaper included, Awesome looks for `~/wallpapers/wall.jpg`.  
This can be configured in [theme.lua](awesome/themes/groovebox/theme.lua#L42).  
Use `Super + s` to see all available shortcuts.

### Install Script

The script `install.sh` places symlinks to the local repo, so all files can stay in one place.  
You might want to ignore that, this is just for my personal setup.

```sh
./install.sh   # or
./install.sh -d /path/to/dotfiles/
```

## Configure Neovim Plugins

The keybinds are listed in [init.vim](nvim/init.vim).
Run `:PlugInstall` in Neovim to install all plugins. `nodejs` (or an lts release) and `npm` are required for `coc`. Langauge server packs can be installed with e.g.:

```sh
CocInstall coc-pyright coc-sumneko-lua coc-json coc-clangd coc-cmake
```
Check [the docs](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions) and the [install guide](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim) for more info.  
Install the following packages with your package manager:
```
fd ripgrep jp xclip glow
```

## LF File Manager

To make file previews work, install the following packages:
```
ueberzug imagemagick ffmpeg ghostscript
```
Make sure the scripts `lf-cleaner`, `lf-previewer` and `lf-run` in [lf](lf) are executable and in your `PATH`.

## Slack Theme

My Gruvbox Slack theme. I don't know where else to put this, so I just paste it here.  
Paste into `Preferences` > `Themes`.  
```
#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7
```

## Pacman Hook

Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo cp clear_cache.hook /etc/pacman.d/hooks
```
