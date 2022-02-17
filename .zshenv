# set the screen layout
if [[ $(xrandr | grep "eDP1") ]] then
    # Detect if an external screen is connected to the Laptop via HDMI
    if [[ $(xrandr | grep "HDMI1" | awk '{ printf$2 }') = "connected" ]] then
        xrandr --output eDP1 --primary --mode 1920x1080 --pos 928x1440 --rotate normal --output HDMI1 --mode 2560x1440 --pos 928x0 --rotate normal > /dev/null 2>&1
    elif [[ $(xrandr | grep "HDMI1" | awk '{ printf$2 }') = "disconnected" ]] then
        xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --off
    fi
else
    # PC settings
    if [[ $(xrandr | grep "HDMI-0" | awk '{ printf$2 }') = "connected" ]] && [[ $(xrandr | grep "DP-0" | awk '{ printf$2 }') = "connected" ]] then
        xrandr --output DP-0 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x172 --rotate normal > /dev/null 2>&1
    fi
fi

# set keyboard layout and disable caps
setxkbmap -model pc105 -layout us -variant altgr-intl
setxkbmap -option caps:none

export EDITOR="nvim"
export VIISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export GTK_THEME=Adwaita:dark
export PATH="$HOME/.local/bin:$PATH"

# paste this into /etc/profile
# export WINIT_X11_SCALE_FACTOR=1.66 alacritty
