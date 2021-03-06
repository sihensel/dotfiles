#!/bin/sh

# this script goes through all my git repos and executes a git pull

#"${my_array[@]}" - list elements of array
#"${!my_array[@]}" - list indices of array

cd ~/ || exit 1

for i in sihensel.github.io dotfiles docs python studium new-tab; do
    if [ -d "$i" ]; then
        echo "cd into ${i}..."
        cd ~/"$i" || exit 1
        git pull
        cd ~/ || exit 1
        echo "-------------------------------------"
    fi
done

cd ~/ || exit 1
echo "All done."
exit 0
