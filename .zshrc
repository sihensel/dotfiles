# ~/.zshrc

source ~/.zsh-alias

# colors and prompt
autoload -U colors && colors
PS1="%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$ "
#PS1="%n@%M %~ # "

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

# cursor options:
# 0 - blinking block
# 1 - blinking block (default)
# 2 - steady block
# 3 - blinking underline
# 4 - steady underline
# 5 - blinking bar, xterm
# 6 - steady bar, xterm

# Change cursor shape for different vi modes.
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

# Edit line in vim with ctrl-e (requires 'export VISUAL=nvim' in .profile)
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load syntax highlighting; should be last.
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
