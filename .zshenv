# set PATH, make sure all entires are unique
typeset -U path PATH
path=(~/.local/bin $path)
path=(/usr/share/git/diff-highlight $path)
path=($(go env GOPATH)/bin $path)
export PATH

export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_TIME="de_DE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export VISUAL="nvim"
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="librewolf"
export READER="$BROWSER"

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
export XDG_CURRENT_DESKTOP=wl-roots
export XDG_SESSION_DESKTOP=wl-roots
export XDG_SESSION_TYPE=wayland

export SDL_VIDEODRIVER=wayland
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE="gtk3"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GPG_TTY=$(tty)

# Keyboard layout and disable caps lock
export XKB_DEFAULT_LAYOUT=us(altgr-intl)
export XKB_DEFAULT_OPTIONS=caps:none

export GTK_THEME="Adwaita:dark"
export XCURSOR_SIZE=24
export XCURSOR_THEME="Adwaita"

export WLR_RENDERER="vulkan"
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export PROTON_ENABLE_WAYLAND=1
