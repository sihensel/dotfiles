# Welcome ~/

-- Under construction --

![screenshot.png](screenshot.png)

This repository contains my personal Linux dotfiles.
They are often (speak: all the time) a work in progress and may or may not work for you.

Programs in the screenshot (outdated, will get updated soon):
- Neovim
- Neofetch
- MOC (with the Gruvbox color scheme, based on [this](https://github.com/hringriin/dotfiles/blob/master/moc/themes/hringriin_theme))

My Awesome theme is based on Multicolor from [Awesome Copycats](https://github.com/lcpz/awesome-copycats).

## Dependencies (WIP)
- Jetbrains Mono Nerd Font
- Roboto Mono
- Moc
- taskwarrior
- pulseaudio
- dmenu (to be rofi)
- alacritty
- pcmanfm-gtk3
- etc.

## Installation

Clone the repo into your home directory or download the zip.

```bash
git clone https://github.com/sihensel/dotfiles.git ~/
```

There is an install script that places symlinks to the local repo. 
You might want to ignore that, this is just for my personal setup.

```bash
~/dotfiles/install.sh
```

### Slack Theme
My Gruvbox Slack theme.
I don't know where else to put this, so I just paste it here.
Paste into `Preferences` > `Themes`.
`#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7`

### Pacman Hook
Copy `clear_cache.hook` to `/etc/pacman.d/hooks`.
You might need to change the owner to root with
```bash
sudo chown root: clear_cache.hook`
```
### Note:
The files `.vimrc` and `.bashrc` are outdated, since I no longer use these programs.
