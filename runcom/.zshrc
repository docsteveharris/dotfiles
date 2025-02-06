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

# https://pipx.pypa.io/stable/
# Created by `pipx` on 2024-10-06 16:13:22
export PATH="$PATH:/Users/steve/.local/bin"
# https://pipx.pypa.io/stable/
# Created by `pipx` on 2024-10-06 16:13:22
eval "$(register-python-argcomplete pipx)"


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/steve/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# NVM config
# https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# PIXI
eval "$(pixi completion --shell zsh)"
export PATH="/Users/steve/.pixi/bin:$PATH"

# Starship
eval "$(starship init zsh)"
