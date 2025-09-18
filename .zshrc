# import aliases
source ~/.zsh-alias

#------------------------------------------------------------------------------
# GENERAL SETTINGS
#------------------------------------------------------------------------------

unsetopt beep notify
[[ $- == *i* ]] && stty stop undef

# history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups

# configure completion
# https://thevaluable.dev/zsh-completion-guide-examples/
zstyle :compinstall filename '/home/simon/.zshrc'
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

# Edit line in nvim with ctrl-e (requires 'export VISUAL=nvim' in .zshenv)
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


#------------------------------------------------------------------------------
# INPUT MODE AND CURSOR
#------------------------------------------------------------------------------

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes
# cursor options:
# 2 - steady block
# 4 - steady underline
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'underline' ]]; then
    echo -ne '\e[4 q'
  fi
}

# # Use underline cursor on startup and for each new prompt
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins    # initiate `vi insert` as keymap
    echo -ne '\e[4 q'
}
zle -N zle-line-init
echo -ne '\e[4 q'
preexec() { echo -ne '\e[4 q' ;}


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

# show current git branch in git repos
# https://gist.github.com/reinvanoyen/05bcfe95ca9cb5041a4eafd29309ff29
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

# show current openstack clouds.yaml entry
function parse_os_cloud() {
    printenv | grep -e 'OS_CLOUD' 2> /dev/null | sed -e 's/.*=\(.*\)/(\1)/'
}

# pyenv config
if [[ $HOST == "arch-T14" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


#------------------------------------------------------------------------------
# COLORS AND PROMPT
#------------------------------------------------------------------------------

autoload -U colors && colors
setopt prompt_subst
export PATH="$PATH:$HOME/.rvm/bin"

# disable prompt colors for the root user
if [[ $EUID = 0 ]]; then
    export PROMPT='[%n@%M %2~]%{$fg[cyan]%}$(parse_git_branch)%{$fg[red]%}$(parse_os_cloud)%{$reset_color%}# '
else
    export PROMPT='%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%2~%{$fg[red]%}]%{$fg[cyan]%}$(parse_git_branch)%{$fg[red]%}$(parse_os_cloud)%{$reset_color%}$ '
fi

# enable kubectl auto completion
source <(kubectl completion zsh)

# Load syntax highlighting; should be last
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
