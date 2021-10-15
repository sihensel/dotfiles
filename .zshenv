# set screen layout on my PC using xrandr
# check for the name of the connected display ('eDP' means laptop)
if [[ ! $(xrandr | grep " connected " | awk '{ print$1 }') = 'eDP' ]] && [[ ! $(xrandr | grep "HDMI1" | awk '{ print$2 }') = 'disconnected' ]] then
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 928x1440 --rotate normal --output HDMI1 --mode 2560x1440 --pos 928x0 --rotate normal
fi

# set keyboard layout and disable caps
setxkbmap -option caps:none
setxkbmap -model pc105 -layout us -variant altgr-intl

export EDITOR="nvim"
export VIISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"
export READER="zathura"
#export MANPAGER="nvim -c 'set ft=man' -"
export GTK_THEME=Materia:dark
export PATH="$HOME/.local/bin:$PATH"
