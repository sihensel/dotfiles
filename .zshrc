# ~/.zshrc

# colors and prompt
autoload -U colors && colors
PS1="%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$ "

# general settings
setopt autocd extendedglob nomatch
unsetopt beep notify
stty stop undef

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
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

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'

# some aliases
alias ls='ls -hlN --color=auto --group-directories-first'
alias la='ls -AhlN --color=auto --group-directories-first'
alias free='free -m'
alias grep='grep --color=auto'
alias ..='cd ..'
alias vim='nvim'
alias pac='sudo pacman'
alias uppac='sudo reflector --country France --country Germany --latest 10 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias p='python3'

# Edit line in vim with ctrl-e (requires 'export VISUAL=nvim' in .profile)
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load syntax highlighting; should be last.
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
