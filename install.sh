#!/usr/bin/env sh

# creates symbolic links for my dotfiles so all files can stay in ~/dotfiles
# WARNING: this script will overwrite existing files that match the filenames from the dotfiles repo!
# this script should be POSIX compliant.

dotdir=~/dotfiles   # specify the FULL path to the repo here
laptop=false

echo "Configure dotfiles for the laptop? (y/n)"
read -r usrcmd

if [ "$usrcmd" = "y" ] || [ "$usrcmd" = "Y" ]; then
    laptop=true
fi

# check if dotfiles repo exists
if [ ! -d "$dotdir" ]; then
    echo "${dotdir} not found, either clone the git repo or specift the correct path, exiting."
    exit 1
fi

# make sure to start in the home directory
cd ~/ || exit 1

# start creating symlinks
# files in ~/
for i in .bashrc .zshrc .profile .vimrc; do
    if [ -f "$i" ]; then
        rm -f "$i"
    fi
    ln -sf "$dotdir"/"$i" "$i"
done

# MOC
if [ "$laptop" = false ]; then
    if [ ! -d ~/.moc ]; then
        mkdir -p ~/.moc
    fi
    cd ~/.moc || exit 1

    for i in eqsets themes config equalizer; do
        if [ -d "$i" ] || [ -f "$i" ]; then
            rm -rf "$i"
        fi
    ln -sf "$dotdir"/moc/"$i" "$i"
    done
fi

# .config
if [ ! -d ~/.config ]; then
    mkdir -p ~/.config
fi
cd ~/.config || exit 1

if [ "$laptop" = true ]; then
    for i in alacritty awesome; do
        if [ -d "$i" ] || [ -f "$i" ]; then
            rm -rf "$i"
        fi
        if [ "$i" = "alacritty" ] || [ "$i" = "awesome" ]; then
            cp -r "$dotdir"/"$i" .
        else
            ln -sf "$dotdir"/"$i" "$i"
        fi
    done
    
    # put laptop dotfiles in place
    rm -f alacritty/alacritty.yml
    mv alacritty/alacritty_laptop.yml alacritty/alacritty.yml
    rm -f awesome/rc.lua
    mv awesome/rc_laptop.lua awesome/rc.lua
else
    for i in alacritty awesome neofetch zathura; do
        if [ -d "$i" ] || [ -f "$i" ]; then
            rm -rf "$i"
        fi
        ln -sf "$dotdir"/"$i" "$i"
    done
fi

# Neovim
if [ ! -d nvim ]; then
    mkdir -p nvim
fi
cd nvim || exit 1
ln -sf "$dotdir"/nvim/init.vim init.vim

# finish
cd ~/ || exit 1
echo "All done, no errors."
exit 0
