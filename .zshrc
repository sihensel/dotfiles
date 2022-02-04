# ~/.zshrc
source ~/.zsh-alias

# general settings
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

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
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

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne '\e[4 q'
}
zle -N zle-line-init
# Use underline cursor on startup and for each new prompt
echo -ne '\e[4 q'
preexec() { echo -ne '\e[4 q' ;}

# Edit line in vim with ctrl-e (requires 'export VISUAL=nvim' in .zshenv)
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# show current git branch in git repos
# https://gist.github.com/reinvanoyen/05bcfe95ca9cb5041a4eafd29309ff29
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

# colors and prompt
autoload -U colors && colors
setopt prompt_subst
export PROMPT='%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%2~%{$fg[red]%}]%{$fg[cyan]%}$(parse_git_branch)%{$reset_color%}$ '
export PATH="$PATH:$HOME/.rvm/bin"

# Manpage colors
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS=-R

# Load syntax highlighting; should be last.
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
