# Used for setting user's interactive shell configuration and executing commands,
# will be read when starting as an interactive shell.

# User configuration
HIST_STAMPS="dd/mm/yyyy"

# SSH agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Bash completion in zsh
autoload bashcompinit
bashcompinit

gitsync () {
    [ -z "${1}" ] && $1="$(pwd)"
    git -C $1 pull
    git -C $1 add -A
    git -C $1 commit -m "Auto-sync: $(date +%Y-%m-%d_%H:%M:%S)"
    git -C $1 push
}

wttr_weather () {
    if [ -z "${1}" ]
    then
        curl 'https://wttr.in/?w'
    else
        curl 'https://wttr.in/'"$(echo $1)"
    fi
}

# Aliases
alias config='git -C $XDG_CONFIG_HOME'
alias config-sync='gitsync $XDG_CONFIG_HOME'
alias reflect='sudo reflector --verbose --latest 30 --sort rate --save /etc/pacman.d/mirrorlist'
alias py='bpython'
alias vim='nvim'
alias mutt='neomutt'
alias ofoam="source ${FOAM_INST_DIR}/OpenFOAM-5.0/etc/bashrc"
alias ncmpc='ncmpcpp --screen playlist --slave-screen visualizer'
alias weather='wttr_weather'
alias newterm="$TERMINAL 2>/dev/null & disown 2>&1 1>/dev/null"

# Powerlevel9k things

# ZIM settings
ztermtitle='%~:%n@%m'
zhighlighters=(main brackets cursor)
zinput_mode='vi'

# Prompt
zprompt_theme='powerlevel10k'
if tty | grep -q tty; then
    # TTY default to the text theme
    [[ -f "${ZDOTDIR}/.p10k.text.zsh" ]] && source "${ZDOTDIR}/.p10k.text.zsh"
else
    # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
    [[ -f "${ZDOTDIR}/.p10k.icon.zsh" ]] && source "${ZDOTDIR}/.p10k.icon.zsh"
fi
# Source the theme
source ${ZIM_HOME}/init.zsh
