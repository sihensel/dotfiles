# Welcome ~/

This repository contains my personal Linux dotfiles.  
They are often (speak: all the time) a work in progress and may or may not work for you.  
I use [Awesome](https://awesomewm.org) with my own theme called _Groovebox_ and `picom-git` on Arch.

![screenshot.png](screenshot.png)

Programs in the screenshot:
- Neovim
- Neofetch
- tty-clock
- the notification from MOC

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
Typora | `typora` (AUR)
Zathura | `zathura zathura-pdf-poppler`
Roboto Mono Nerd Font | `nerd-fonts-roboto-mono` (AUR)

Clone the repo into your home directory.

```sh
git clone https://github.com/sihensel/dotfiles.git
```

There is no wallpaper included, Awesome looks for `~/wallpapers/wall.jpg`.  
This can be configured in [theme.lua](awesome/themes/groovebox/theme.lua).  
Use `Super + s` to see all available shortcuts.

The script `install.sh` places symlinks to the local repo, so all files can stay in one place.  
You might want to ignore that, this is just for my personal setup.

```sh
./install.sh   # or
./install.sh -d /path/to/dotfiles/
```

## Configure Neovim plugins
The keybinds are listed in `nvim/init.vim`.
To make the Neovim config work, install `nodejs` (or an lts release) and `npm`. Then run `PlugInstall` in Neovim to install all plugins.  
Finally, install the langauge server packs for your preferred langauge, e.g.:

```sh
CocInstall coc-pyright coc-sumneko-lua coc-json coc-clangd coc-cmake
```
Check [the docs](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions) and the [install guide](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim) for more info.  
To make `telescope.nvim` work, install the external packages `fd` and `ripgrep`.  
Also get `glow` for Markdown rendering.

## Slack Theme
My Gruvbox Slack theme. I don't know where else to put this, so I just paste it here.  
Paste into `Preferences` > `Themes`.  
`#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7`

## Pacman Hook
Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo cp clear_cache.hook /etc/pacman.d/hooks
```
