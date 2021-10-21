# ~/.zshrc
source ~/.zsh-alias

# general settings
setopt autocd extendedglob nomatch
unsetopt beep notify
stty stop undef

# history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups

zstyle :compinstall filename '/home/simon/.zshrc'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

autoload -Uz compinit
compinit

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
export PROMPT='%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$fg[cyan]%}$(parse_git_branch)%{$reset_color%}$ '
export PATH="$PATH:$HOME/.rvm/bin"

# Load syntax highlighting; should be last.
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
