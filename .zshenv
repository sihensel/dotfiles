# set screen layout on my PC using xrandr
# check for the name of the connected display ('eDP' means laptop)
# basically paste the output of arandr here

if [[ $(xrandr | grep " connected " | awk '{ print$1 }') =~ 'DP-0' ]] && [[ $(xrandr | grep " connected " | awk '{ print$1 }') =~ 'HDMI-0' ]] then
    # PC
    xrandr --output DP-0 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x172 --rotate normal > /dev/null 2>&1

elif [[ $(xrandr | grep " connected " | awk '{ print$1 }') =~ 'eDP' ]] then
    # Laptop
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 928x1440 --rotate normal --output HDMI1 --mode 2560x1440 --pos 928x0 --rotate normal > /dev/null 2>&1
fi

# set keyboard layout and disable caps
setxkbmap -option caps:none
setxkbmap -model pc105 -layout us -variant altgr-intl

export EDITOR="nvim"
export VIISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export GTK_THEME=Adwaita:dark
export PATH="$HOME/.local/bin:$PATH"
