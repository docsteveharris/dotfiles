# =========================================================================== #
# zsh autocomplete instead of compinit
# Autocompletions must be loaded before other zoxide
autoload -Uz compinit
compinit -i

# =========================================================================== #

eval $(thefuck --alias)


# https://pipx.pypa.io/stable/
# Created by `pipx` on 2024-10-06 16:13:22
export PATH="$PATH:/Users/steve/.local/bin"
eval "$(register-python-argcomplete pipx)"

# miniconda
export PATH="$HOME/miniconda3/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/steve/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/steve/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/steve/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/steve/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
