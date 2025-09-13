# shellcheck disable=SC2148
# ~/.bashrc

# Assemble prompt
# Modular prompt builder
function bash_prompt() {
    local exit_code=$? ps=""
    for mod in "${PROMPT_ORDER[@]}"; do
        case $mod in
            user_host) ps+="$(__prompt_user_host)" ;;
            path)      ps+="$(__prompt_cwd)"       ;;
            git)       ps+="$(__prompt_git)"       ;;
            venv)      ps+="$(__prompt_venv)"      ;;
            time)      ps+="$(__prompt_time)"      ;;
        esac
    done

    local symbol color
    [[ $EUID -eq 0 ]] && symbol="#" || symbol=">"
    [[ $exit_code -eq 0 ]] && color=$C_SUCCESS || color=$C_ERROR

    PS1="\n$(__c $color)$ps $symbol$RESET "
}

# shellcheck disable=SC1091
[[ ! -n "${PS1}" ]] || source "/usr/share/bash-completion/bash_completion"

[[ -f ~/.config/env ]] && source ~/.config/env
[[ -f ~/.config/alias ]] && source ~/.config/alias

[[ -f ~/.config/function ]] && source ~/.config/functions

# Enable some useful feature that makes `bash` more like `zsh` then people think.
shopt -s checkwinsize autocd extglob histappend cmdhist lithist

# Key bindings for history search.
bind '"\e[A": history-search-backward' ; bind '"\e[B": history-search-forward'


[[ ! -x "$(command -v hugo)" ]] || source <(hugo completion bash)

# Add .local/bin to the path.
test -d ~/.local/bin && PATH="${PATH}:$HOME/.local/bin"

declare -A __PROMPT_CACHE

export HISTIGNORE="&:ls:[bf]g:exit:clear:history:pwd:cd:source:reload:ls:ll:la:lt:hist:ping"

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T '

# Colored GCC warnings and errors
GCC_COLORS="error=$C_ERROR:warning=$C_WARNING:note=$C_NOTE:"
export GCC_COLORS+="caret=$C_CARET:locus=$C_LOCUS:quote=$C_QUOTE"

export EDITOR=nano

export STARSHIP_LOG="errors"

# Have less display colors for manpage.
export LESS_TERMCAP_mb=$'\e['"$C_WARNING"'m'
export LESS_TERMCAP_md=$'\e[1;'"$C_TITLE"'m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'

# begin reverse video → magenta background, white foreground
export LESS_TERMCAP_so=$'\e[1;45;'"$C_FG_SO"'m'

export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[35m'

export GROFF_NO_SGR="1"

# Initialize SSH agent.
eval "$(ssh-agent -s)" > /dev/null 2>&1

PROMPT_COMMAND="bash_prompt"
