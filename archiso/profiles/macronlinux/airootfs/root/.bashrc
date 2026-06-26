#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la'

# Lance fastfetch automatiquement à l'ouverture du terminal
if [ -x /usr/bin/fastfetch ]; then
    fastfetch
fi
