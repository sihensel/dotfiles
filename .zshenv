# set screen layout on my PC using xrandr
# check for the name of the connected display ('eDP' means laptop)
if [[ ! $(xrandr | grep " connected " | awk '{ print$1 }') = 'eDP' ]]; then
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x180 --rotate normal --output DP-0 --mode 2560x1440 --pos 1920x0 --rotate normal
fi


# set keyboard layout and disable caps
setxkbmap -option caps:none
setxkbmap -model pc105 -layout us -variant altgr-intl

export EDITOR="nvim"
export VIISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export MANPAGER="nvim -c 'set ft=man' -"
#export GTK_THEME=Adwaita:dark
export GTK_THEME=Materia:dark
