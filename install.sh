#!/bin/sh

# creates symbolic links for my dotfiles so all files can stay in ~/dotfiles
# WARNING: this script will overwrite existing files that match the filenames from the dotfiles repo!
# this script should be POSIX compliant.

dotdir=~/dotfiles   # specify the FULL path to the repo here

# check if dotfiles repo exists
if [ ! -d "$dotdir" ]; then
    echo "${dotdir} not found, either clone the git repo or specift the correct path, exiting."
    exit 1
fi

# make sure to start in the home directory
cd ~/ || exit 1

# start creating symlinks
# files in ~/
for i in .xinitrc .zshrc .zshenv .zsh-alias; do
    if [ -f "$i" ]; then
        rm -f "$i"
    fi
    ln -sf "$dotdir"/"$i" "$i"
done

# MOC
if [ -d ~/.moc ]; then
    rm -rf ~/.moc
fi
ln -sf "$dotdir"/moc ~/.moc

# .config
if [ ! -d ~/.config ]; then
    mkdir -p ~/.config
fi
cd ~/.config || exit 1

for i in alacritty awesome neofetch nvim picom rofi zathura; do
    if [ -d "$i" ] || [ -f "$i" ]; then
        rm -rf "$i"
    fi
    ln -sf "$dotdir"/"$i" "$i"
done

# wrap up
cd ~/ || exit 1
unset $dotdir
echo "All done, no errors."
exit 0
