#!/bin/sh

# creates symbolic links for my dotfiles so all files can stay in the dotfiles folder
# WARNING: this script will overwrite existing files
# this script should be POSIX compliant (checked with https://www.shellcheck.net/)

dot_dir=~/dotfiles   # FULL path to the repo

# see https://archive.md/TRzn4
while getopts ":p:" opt; do
    case $opt in
        p)
            dot_dir=$OPTARG
        ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# check if dotfiles repo exists
if [ ! -d "$dot_dir" ]
then
    echo "Directory '${dot_dir}' not found, you can specify a path with -p"
    exit 1
fi

# make sure to start in the home directory
cd ~/ || exit 1

# start creating symlinks
# files in ~/
for i in .tigrc .zshrc .zshenv .zsh-alias
do
    if [ -f "$i" ]; then
        rm -f "$i"
    fi
    ln -sf "$dot_dir"/"$i" "$i"
done

# ~/.config
if [ ! -d ~/.config ]
then
    mkdir -p ~/.config
fi

cd ~/.config || exit 1

for i in alacritty lf mako mpd ncmpcpp nvim river rofi waybar zathura mimeapps.list user-dirs.dirs
do
    if [ -d "$i" ] || [ -f "$i" ]; then
        rm -rf "$i"
    fi
    ln -sf "$dot_dir"/"$i" "$i"
done

# create MPD playlists directory
mkdir -p ~/.config/mpd/playlists

# wrap up
unset "$dot_dir"
cd ~/ || exit 1
echo "All done, no errors."
exit 0
