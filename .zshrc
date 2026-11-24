#------------------------------------------------------------------------------
# GENERAL SETTINGS
#------------------------------------------------------------------------------

unsetopt beep notify
[[ $- == *i* ]] && stty stop undef

# disable terminal flow control
setopt no_flow_control
stty -ixon 2>/dev/null

# history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups

# configure completion
# https://thevaluable.dev/zsh-completion-guide-examples/
zstyle :compinstall filename '${HOME}/.zshrc'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt list_rows_first
setopt glob_complete
setopt always_to_end
setopt list_packed
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


#------------------------------------------------------------------------------
# INPUT MODE AND CURSOR
#------------------------------------------------------------------------------

# emacs mode
bindkey -e

# CTRL + W and CTRL + B to jump words forwards/backwards
bindkey '^W' forward-word
bindkey '^B' backward-word
# CTRL + Arrow Keys to jump words forwards/backwards
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[OC' forward-word
bindkey '^[OD' backward-word

# CTRL + Backspace to delete words backwards
bindkey '^H' backward-kill-word
# CTRL + Delete to delete words forwards
bindkey '^[[3;5~' kill-word
# Delete to delete char under cursor
bindkey '^[[3~' delete-char
# Ctrl + S to delete from cursor to end of line
bindkey '^S' kill-line

# use the default cursor specified by the terminal emulator
zle-line-init() {
    echo -ne '\e[0 q'
}
zle -N zle-line-init


#------------------------------------------------------------------------------
# FZF HISTORY
#------------------------------------------------------------------------------
# from https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_key_bindings_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_key_bindings_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_key_bindings_options+=" -o $__fzf_opt"
      else
        __fzf_key_bindings_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{
[[ -o interactive ]] || return 0

__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_T_OPTS-}" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

__fzfcmd() {
  [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

} always {
  eval $__fzf_key_bindings_options
  'unset' '__fzf_key_bindings_options'
}


#------------------------------------------------------------------------------
# CUSTOM FUNCTIONS
#------------------------------------------------------------------------------

# show current OS_CLOUD environment variable in prompt
function parse_os_cloud() {
    printenv | grep -e 'OS_CLOUD' 2> /dev/null | sed -e 's/.*=\(.*\)/(\1)/'
}

# enable yazi to stay in current directory when quitting
function y() {
    local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
    command rm -f -- "$tmp"
}

# pyenv config
if [[ $HOST == "arch-T14" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
    eval "$(pyenv virtualenv-init -)"
fi


#------------------------------------------------------------------------------
# COLORS AND PROMPT
#------------------------------------------------------------------------------

autoload -U colors && colors
setopt prompt_subst

# load the SVC module, which supports git
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '   # show the git branch

# red prompt for the root user (copy to /root/.zshrc)
if [[ $EUID = 0 ]]; then
    export PROMPT='%F{red}ROOT %2~%f # '
else
    export PROMPT='%F{magenta}%2~%f %F{cyan}${vcs_info_msg_0_}%f%F{red}$(parse_os_cloud)%f$ '
fi

# enable kubectl auto completion
source <(kubectl completion zsh)

# import aliases
source ~/.zsh-alias

# load work setup, if available
if [ -s ~/.zsh-work ]; then
    source ~/.zsh-work
fi

# Load syntax highlighting; should be last
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
