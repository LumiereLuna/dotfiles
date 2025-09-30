HISTFILE=~/.zhistory
HISTSIZE=50
SAVEHIST=100

setopt extendedglob nomatch notify AUTO_LIST AUTO_PARAM_SLASH APPEND_HISTORY

# Enable vi mode.
bindkey -v

# Automatically highlight first element of completion menu
setopt MENU_COMPLETE
# Automatically list choices on ambiguous completion.
setopt AUTO_LIST
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

autoload -Uz compinit promptinit vcs_info
compinit
promptinit

# vcs_info supports many VCSs, you may not want all of these because
# there is no point in running the code to detect systems you do not
# use. So you may also pick a few from that list and enable only
# those:
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '[%b]'

# Enable expression substitution inside of the prompt variable
# declaration.
setopt PROMPT_SUBST
setopt COMPLETE_ALIASES

prompt_exit_code() {
    local EXIT_CODE=$?

    # Catch-all for any unspecified error.
    if [ $EXIT_CODE -eq 1 ]; then
        echo -n "%F{red}!%f "

    # Misuse of built-ins.
    elif [ $EXIT_CODE -eq 2 ]; then
        echo -n "%F{yellow}sh?%f "

    # The command can not be executed.
    elif [ $EXIT_CODE -eq 126 ]; then
        echo -n "%F{yellow}-x%f "

    # The command couldn't be found.
    elif [ $EXIT_CODE -eq 127 ]; then
        echo -n "%F{yellow}cmd?%f "

    # Invalid argument
    elif [ $EXIT_CODE -eq 128 ]; then
        echo -n "%F{yellow}arg?%f "

    # Fatal error signal #1.
    elif [ $EXIT_CODE -eq 129 ]; then
        echo -n "%F{red}err%f "

    # Terminated by SIGINT (Ctrl+C).
    elif [ $EXIT_CODE -eq 130 ]; then
        echo -n "%F{yellow}^C%f "
    fi
}

vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo -n "${vcs_info_msg_0_} "
    fi
}

# The path expression truncates long paths similar to bash's 'PROMPT_DIRTRIM=3'.
# Source:
# https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt
PROMPT='%S%n@%M $(prompt_exit_code)%(5~|%-1~/.../%3~|%4~) $(vcs_info_wrapper)%%%s '

if [ -f "${HOME}/.shared.sh" ]; then
    . "${HOME}/.shared.sh"
fi

if [ $(command -v fzf) ]; then
    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --zsh)"
fi

if [ $(command -v zoxide) ]; then
    eval "$(zoxide init zsh)"
fi
