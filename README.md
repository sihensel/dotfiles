# Dotfiles

![screenshot.png](screenshot.png)

This repository contains my personal Linux dotfiles.

Programs in the screenshot:
- Neovim
- Neofetch
- MOC (with the Gruvbox color scheme, based on [this](https://github.com/hringriin/dotfiles/blob/master/moc/themes/hringriin_theme))

My Awesome theme is based on Multicolor from [Awesome Copycats](https://github.com/lcpz/awesome-copycats).

## Installation

Clone the repo into your home directory:

```bash
git clone https://github.com/dolanseesu/dotfiles.git ~/ && cd dotfiles
```

Run the install-script. You may ignore the question about the laptop setup, that is just for me.
WARNING: This script deletes all preset files and replaces them with symlinks, so use with caution.

```bash
~/dotfiles/install.sh
```

If nothing happens, make sure to set the script as executable.

```bash
chmod 744 ~/dotfiles/install.sh
```

While this repo was created for personal use, feel free to use it (the terms of the GNU General Public License v3.0 apply).
Please note that these files are often a work in progress, so I won't make any guarantees that these will work for you. Also I'm not responsible if they break your system.
