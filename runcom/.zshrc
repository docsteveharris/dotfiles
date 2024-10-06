
eval $(thefuck --alias)


# https://pipx.pypa.io/stable/
# Created by `pipx` on 2024-10-06 16:13:22
export PATH="$PATH:/Users/steve/.local/bin"
eval "$(register-python-argcomplete pipx)"

# miniconda
export PATH="$HOME/miniconda3/bin:$PATH"
conda config --set auto_activate_base false
