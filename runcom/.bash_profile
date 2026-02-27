# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname "$(dirname "$SCRIPT_PATH")")"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles; continuing with default shell."
  return
fi

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,n,path,env,exports,alias,fzf,grep,prompt,completion,fix,zoxide}; do
  # Guard missing globs/files (prevents noisy errors)
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
  # Add in the path to your julia dev box helper script
  export PATH="$HOME/code/jd/scripts:$PATH"
fi

# Set LSCOLORS (dircolors may not exist everywhere)
if command -v dircolors >/dev/null 2>&1 && [ -f "$DOTFILES_DIR/system/.dir_colors" ]; then
  eval "$(dircolors -b "$DOTFILES_DIR/system/.dir_colors")"
fi

# Wrap up
unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE
export DOTFILES_DIR

# juliaup (portable; no hardcoded /Users paths)
if [ -d "$HOME/.juliaup/bin" ]; then
  case ":$PATH:" in
  *:"$HOME/.juliaup/bin":*) ;;
  *) export PATH="$HOME/.juliaup/bin${PATH:+:${PATH}}" ;;
  esac
fi

# Local environment hook (optional)
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# fzf shell integration — pretty Ctrl-R history search, Ctrl-T file picker
# Requires fzf 0.48+ (installed via GitHub releases in Docker image)
# Also works with Homebrew fzf on macOS
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi
