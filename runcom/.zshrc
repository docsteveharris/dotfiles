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

# PIXI
eval "$(pixi completion --shell zsh)"
export PATH="/Users/steve/.pixi/bin:$PATH"
