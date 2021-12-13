# Welcome ~/

This repository contains my personal Linux dotfiles.  
They are often (speak: all the time) a work in progress and may or may not work for you.  
I use [Awesome](https://awesomewm.org) with my own theme called _Groovebox_ and `picom-git` on Arch.

![screenshot.png](screenshot.png)

Programs in the screenshot:
- Neovim
- Neofetch
- tty-clock

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
PCmanFM | `pcmanfm-gtk3`
Moc | `moc-pulse` (AUR)
taskwarrior | `task`
Flameshot | `flameshot`
Typora | `typora` (AUR)
Zathura | `zathura zathura-pdf-poppler`
Roboto Mono Nerd Font | `nerd-fonts-roboto-mono` (AUR)
Materia Theme | `materia-gtk-theme`

Clone the repo into your home directory.

```sh
git clone https://github.com/sihensel/dotfiles.git
```

There is no wallpaper included, Awesome looks for a file in `~/wallpapers`.  
This can be configured in `awesome/themes/groovebox/theme.lua`.

The script `install.sh` places symlinks to the local repo, so all files can stay in one place.  
You might want to ignore that, this is just for my personal setup.

```sh
./install.sh   # or
./install.sh -d /path/to/dotfiles/
```

### Slack Theme
My Gruvbox Slack theme. I don't know where else to put this, so I just paste it here.  
Paste into `Preferences` > `Themes`.  
`#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7`

### Pacman Hook
Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo cp clear_cache.hook /etc/pacman.d/hooks
```
