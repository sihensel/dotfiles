##############################################################
#
# ~/.bashrc
#
# Maintainer:
#       Simon Hensel
#       https://github.com/dolanseesu/dotfiles
#
#
##############################################################


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# custom prompt
#PS1='[\u@\h \W]\$ '
PS1='\[\e[31m\][\[\e[33m\]\u\[\e[32m\]@\[\e[34m\]\h \[\e[35m\]\W\[\e[31m\]]\[\e[00m\]\$ '

stty -ixon          # disable ctrl-s and ctrl-q
shopt -s autocd     # auto-cd

# some aliases
alias ls='ls -hlN --color=auto --group-directories-first'
alias la='ls -AhlN --color=auto --group-directories-first'
alias free='free -m'
alias grep='grep --color=auto'
alias ..='cd ..'

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias vim='nvim'
alias pac='sudo pacman'
alias gs='git status'
alias uppac='sudo reflector --country France --country Germany --latest 10 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias p='python3'
