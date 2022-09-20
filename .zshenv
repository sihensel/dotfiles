export EDITOR="nvim"
export VIISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export GTK_THEME=Adwaita:dark
export PATH="$HOME/.local/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$PATH"

# Manpage colors
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS="-RF"

export BAT_THEME="gruvbox-dark"

# Wayland
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_DESKTOP=river
export XDG_SESSION_TYPE=wayland

export SDL_VIDEODRIVER=wayland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GPG_TTY=$(tty)

# check river(1) and xkeyboard-config(7)
export XKB_DEFAULT_LAYOUT=us(altgr-intl)
export XKB_DEFAULT_OPTIONS=caps:none

# autostart River
if [[ -z $WAYLAND_DISPLAY && $(tty) = "/dev/tty1" ]]; then
    exec dbus-run-session river > /dev/null 2>&1
fi
