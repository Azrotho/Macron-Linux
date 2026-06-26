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

# Hook de citations d'erreurs MacronLinux
macron_error_hook() {
    local exit_code=$?
    if [ $exit_code -ne 0 ] && [ $exit_code -ne 130 ]; then
        local quotes=(
            "C'est de la poudre de perlimpinpin ! 🪄"
            "Parce que c'est notre projeeet !!! 📣"
            "Qu'ils viennent me chercher ! 🏛️"
            "Je ne céderai rien aux fainéants. 💼"
            "Je traverse la rue et je vous en trouve du travail ! 🚦"
            "Nous sommes en guerre ! 🪖"
            "C'est un pognon de dingue ! 💸"
            "Il n'y a pas de formule magique. ✨"
        )
        local rand=$(( RANDOM % ${#quotes[@]} ))
        echo -e "\e[1;31m🇫🇷 [MacronLinux] ${quotes[$rand]}\e[0m"
    fi
}
if [[ ! "$PROMPT_COMMAND" =~ "macron_error_hook" ]]; then
    PROMPT_COMMAND="macron_error_hook${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

