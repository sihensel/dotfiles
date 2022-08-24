# Welcome ~/

This repository contains my personal Linux dotfiles.  
They are often (speak: all the time) a work in progress and may or may not work for you.  
I recently switched from X11 to Wayland using the [River](https://github.com/riverwm/river) compositor.

![screenshot.png](screenshot.png)

<details>
  <summary>Screenshot for AwesomeWM</summary>

  ![screenshot_awesome.png](screenshot_awesome.png)
</details>

## Dependencies

Some of these are not hard dependencies and can be changed in the config files. This is more of a list for me.

Install with `pacman -S --needed <PACKAGE>`.
```
zsh zsh-syntax-highlighting networkmanager-openvpn network-manager-applet zathura zathura-pdf-poppler wayland wl-clipboard waybar xdg-desktop-portal xdg-desktop-portal-wlr swaybg pipewire wireplumber pipewire-alsa pipewire-jack libpipewire02 helvum mpd mpc ncmpcpp grim swaylock mako kitty polkit brightnessctl
```

AUR Packages
```
river rofi-lbonn-wayland wdisplays brave-bin nerd-fonts-roboto-mono ctpv-git
```

The configs for `awesome`, `picom` and `alacritty` are outdated, it you want to use then, make sure to install these packages as well.
```
awesome rofi slock flameshot picom-git (AUR) moc-pulse (AUR)
```

## Installation

Clone the repo into your home directory.

```sh
git clone https://github.com/sihensel/dotfiles.git
```

There is no wallpaper included, the window manager looks for `~/wallpapers/wall.jpg`.  
This can be configured in [theme.lua](awesome/themes/groovebox/theme.lua#L42) for awesome or [process.sh](river/process.sh) for river.

### Install Script

The script `install.sh` places symlinks to the local repo, so all files can stay in one place.  
You might want to ignore that, this is just for my personal setup.

```sh
./install.sh   # or
./install.sh -p /path/to/dotfiles/
```

## Configure Neovim Plugins

The keybinds are listed in [init.vim](nvim/init.vim).
Run `:PlugInstall` in Neovim to install all plugins. `nodejs` and `npm` are required for `coc`. Langauge server packs can be installed with e.g.:

```sh
CocInstall coc-pyright coc-sumneko-lua coc-json coc-clangd coc-cmake
```
Check [the docs](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions) and the [install guide](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim) for more info.

Install the following packages with your package manager:
```
fd ripgrep jp xclip glow
```

## Slack Theme

Gruvbox Slack theme. Paste into `Preferences` > `Themes`.
```
#282828,#3c3836,#D65D0E,#1D2021,#504945,#FBF1C7,#83C07C,#fb4934,#282828,#FBF1C7
```

## Pacman Hook

Make sure to install the `pacman-contrib` package, then copy the file to `/etc/pacman.d/hooks`.

```sh
sudo cp clear_cache.hook /etc/pacman.d/hooks
```

## Miscellaneous

Make sure to create the directory for MPD playlists.
```sh
mkdir -p ~/.config/mpd/playlists
```

Disable mouse acceleration:
```sh
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
```

### Enable screen sharing

For Chrome, visit `chrome://flags/#enable-webrtc-pipewire-capturer` and `chrome://flags/#ozone-platform-hint`.

Start Slack with: `slack --enable-features=WebRTCPipeWireCapturer`.
