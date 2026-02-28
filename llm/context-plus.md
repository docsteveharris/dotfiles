## CONTEXT-PLUS

(remaining 20% — debugging, architecture, edge cases)

# Dotfiles — AI Assistant Context (Long)

<!-- Include CONTEXT.md content first, then the following -->

## Shell startup detail

### DOTFILES_DIR resolution (`.bash_profile`)

```bash
CURRENT_SCRIPT=$BASH_SOURCE
if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname "$(dirname "$SCRIPT_PATH")")"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
fi
```

- In the container, `~/.bash_profile` is a stow symlink →
  `/opt/dotfiles/runcom/.bash_profile`, so `readlink` resolves correctly and
  `DOTFILES_DIR` → `/opt/dotfiles`
- On macOS, same mechanism works with `~/.dotfiles` symlink or direct stow

### PATH construction detail (`.path`)

- Starts from `getconf PATH` (clean system PATH)
- `HOMEBREW_PREFIX` set via `is-supported`/`is-arm64` → `/opt/homebrew` (ARM) or `/usr/local` (Intel)
- `prepend-path()` guards with `[ -d ]` — safe on both platforms
- Two pytools-venv guards: `/opt/pytools-venv/bin` (container) and `$HOME/opt/pytools-venv/bin` (macOS)
- Duplicate removal via awk at end of `.path`
- juliaup PATH added separately in `.bash_profile` with idempotent `case` guard

### fzf integration (two-layer)

1. `system/.fzf` — sources Debian/Homebrew key-binding files if present (mostly no-op in container)
2. `.bash_profile` — `eval "$(fzf --bash)"` — the actual working integration for container

- `FZF_CTRL_R_OPTS` includes `pbcopy` — macOS only, silently fails on Linux

## Stow detail

### runcom stow

```
dotfiles/runcom/
├── .bash_profile    → $HOME/.bash_profile
├── .bashrc          (symlink to .bash_profile in repo)
└── .inputrc         → $HOME/.inputrc
```

`.bashrc` is a symlink to `.bash_profile` inside the repo — both end up in `$HOME`.

### config stow

Each `config/<tool>/` directory contains a `.config/` subdirectory mirroring
the XDG layout. Stow target is `$HOME`, so:

```
config/zellij/.config/zellij/config.kdl → ~/.config/zellij/config.kdl
config/nvim/.config/nvim/               → ~/.config/nvim/
config/yazi/.config/yazi/               → ~/.config/yazi/
```

`XDG_PACKAGES` in Makefile: `ghostty git lazygit nvim prettier tmux yazi zellij`

### Julia — not stowed

Julia config is **copied**, not stowed, because `~/.julia` must be a real
writable directory (not a symlink tree):

```bash
# Makefile target
link-julia:
    mkdir -p $(HOME)/.julia/config
    cp config/julia/startup.jl $(HOME)/.julia/config/startup.jl
    mkdir -p $(HOME)/.julia/environments/dsbc
    cp config/julia/environments/dsbc/Project.toml \
       $(HOME)/.julia/environments/dsbc/Project.toml
```

In the container this is done by `init-perms-dev.sh` with md5 stamp idempotency.

## Neovim / LazyVim detail

### Plugin inventory

| File                 | Plugin                      | Purpose                                               |
| -------------------- | --------------------------- | ----------------------------------------------------- |
| `clipboard.lua`      | LazyVim/LazyVim opts        | OSC 52 clipboard via `vim.g.clipboard`                |
| `core.lua`           | LazyVim/LazyVim opts        | tokyonight colorscheme                                |
| `slime.lua`          | jpalardy/vim-slime          | REPL send to Zellij right pane                        |
| `julia-lsp.lua`      | nvim-lspconfig              | Disables julials (prevents "client quit" error)       |
| `jetls.lua`          | vim.lsp.config (native)     | JETLS Julia LSP, `root_markers = {"Project.toml"}`    |
| `juliaformatter.lua` | kdheepak/JuliaFormatter.vim | ft=julia only                                         |
| `mason.lua`          | mason-org/mason.nvim        | Excludes julials from `automatic_enable`              |
| `treesitter.lua`     | nvim-treesitter             | `auto_install=false` (no tree-sitter CLI)             |
| `snacks-picker.lua`  | folke/snacks.nvim           | fd with `--hidden --follow --exclude .git`            |
| `pick-files.lua`     | folke/snacks.nvim           | `<leader><leader>` → files from project root, hidden  |
| `yazi.lua`           | mikavilpas/yazi.nvim        | `<leader>fy` current file, `<leader>fY` cwd           |
| `clipboard.lua`      | —                           | netrwPlugin disabled via `vim.g.loaded_netrwPlugin=1` |

### Clipboard chain

```
Neovim yank → OSC 52 escape sequence → Zellij (passes through) → Ghostty/MobaXterm → system clipboard
```

`vim.g.clipboard` set in `clipboard.lua` using `vim.ui.clipboard.osc52`
(Neovim 0.10+ built-in). No external clipboard provider needed.

### vim-slime / Zellij REPL workflow

```lua
vim.g.slime_target = "zellij"
vim.g.slime_default_config = {
  session_id = "current",
  relative_pane = "right",
  relative_move_back = true,
}
```

- `<leader>r` — send current line
- `<leader>R` — send paragraph
- `<leader>r` (visual) — send selection
- Typical layout: nvim left pane, Julia/Python REPL right pane

### JETLS setup

JETLS is configured via native Neovim LSP (`vim.lsp.config` / `vim.lsp.enable`),
not lspconfig. Requires:

```bash
julia --project=~/.julia/environments/jetls -e \
  'import Pkg; Pkg.add(url="https://github.com/aviatesk/JETLS.jl")'
```

`~/.julia/bin` must be on PATH (set in `system/.path`).
julials is explicitly disabled in `julia-lsp.lua` to suppress "client quit" errors.

## Yazi detail

### Plugin setup (`init.lua`)

- `full-border` with `ui.Border.PLAIN`
- Symlink display in status bar (link target shown)
- `duckdb` plugin initialised via `require("duckdb"):setup()`

### DuckDB previewer (`yazi.toml`)

Registered as both `prepend_previewers` and `prepend_preloaders` for:
csv, tsv, json, parquet, txt, xlsx, db, duckdb

### Keymap notes (`keymap.toml`)

- Uses `[[mgr.prepend_keymap]]` and `[[manager.prepend_keymap]]` — both spellings
  present (mgr is the canonical form; manager is an alias — both work)
- `<C-p>` Quick Look (`qlmanage`) — macOS only, no-op on Linux
- `H`/`L` for duckdb column scroll conflict with default yazi `H`/`L` (history)
  — overridden intentionally

## Zellij detail

### Keybind philosophy

`clear-defaults=true` — all bindings explicit. Modal system:

| Mode        | Entry    | Exit                      |
| ----------- | -------- | ------------------------- |
| pane        | `Ctrl-p` | `Ctrl-p` or `Esc`/`Enter` |
| tab         | `Ctrl-t` | `Ctrl-t` or `Esc`/`Enter` |
| resize      | `Ctrl-n` | `Ctrl-n` or `Esc`/`Enter` |
| move        | `Ctrl-h` | `Ctrl-h` or `Esc`/`Enter` |
| session     | `Ctrl-o` | `Ctrl-o` or `Esc`/`Enter` |
| scroll      | `Ctrl-s` | `Ctrl-s` or `Ctrl-c`      |
| locked      | `Ctrl-g` | `Ctrl-g`                  |
| tmux-compat | `Ctrl-b` | auto-exits after action   |

`Ctrl-q` quits Zellij from any mode except locked.

### Layouts

`default.kdl` — tab-bar + single shell pane + status-bar
`lazyvim.kdl` — tab-bar + `nvim` command pane (focus) + status-bar

### macOS session name

`.alias.macos` sets `zz="zellij a casper"` — attaches to named session
`casper` on macOS. On Linux `zz="zellij"` (new or attach default).

## Makefile detail

- `OS` detected via `bin/is-supported bin/is-macos macos linux`
- `HOMEBREW_PREFIX` detected via `is-arm64` → `/opt/homebrew` or `/usr/local`
- `linux` target: `core-linux link bun` (no brew, no cask, no mas)
- `core-linux-ci` target: minimal apt installs for GitHub Actions
- `link` target: stow-$(OS) + link-julia + stow runcom + stow XDG_PACKAGES
- `bun` installed via curl install script on both platforms

## bin/ scripts detail

| Script          | Purpose                                       | Notes                                        |
| --------------- | --------------------------------------------- | -------------------------------------------- |
| `dot`           | dotfiles CLI (`dot edit`, `dot update`, etc.) | `sub_update` calls `topgrade`                |
| `is-macos`      | exits 0 on macOS                              | tests `$OSTYPE =~ ^darwin`                   |
| `is-arm64`      | exits 0 on ARM64                              | tests `uname -m == arm64`                    |
| `is-executable` | exits 0 if arg is on PATH                     | uses `type`                                  |
| `is-supported`  | conditional echo or exit                      | 1-arg: exit code; 3-arg: echo branch         |
| `append`        | idempotent append to file                     | requires `pcregrep` — not in container       |
| `json`          | pretty-print JSON                             | prefers `jq`, falls back to `underscore-cli` |

## Common failure modes and fixes

| Symptom                                 | Cause                                             | Fix                                                                        |
| --------------------------------------- | ------------------------------------------------- | -------------------------------------------------------------------------- |
| `DOTFILES_DIR` empty / wrong            | `readlink` not executable or `$BASH_SOURCE` empty | Ensure stow symlink exists; `~/.dotfiles` fallback                         |
| `lsd: command not found`                | `lsd` not installed                               | Install lsd or change `.alias` `l`/`ll` to use `eza`                       |
| `pcregrep: command not found`           | `append` script used without pcregrep             | Install pcregrep or rewrite `append` with grep                             |
| fzf `Ctrl-R` not working                | `eval "$(fzf --bash)"` not reached                | Check `PS1` guard at top of `.bash_profile`; fzf must be ≥0.48             |
| `FZF_CTRL_R_OPTS pbcopy` error on Linux | pbcopy not available                              | Remove or guard `pbcopy` in `.fzf` with `is-macos`                         |
| JETLS not starting                      | `~/.julia/bin/jetls` missing                      | Run JETLS install in `init-perms-dev.sh` or manually                       |
| julials "client quit" error             | julials auto-enabled by Mason                     | `julia-lsp.lua` disables it; `mason.lua` excludes from `automatic_enable`  |
| Treesitter parser install fails         | `tree-sitter` CLI missing                         | `auto_install=false` in `treesitter.lua`                                   |
| Yazi `H`/`L` not scrolling duckdb       | keymap not loaded                                 | Check `keymap.toml` uses `[[manager.prepend_keymap]]`                      |
| Zellij opens sh not bash                | `$SHELL` not set to bash                          | Set in container env or Zellij `default_shell`                             |
| OSC 52 paste not working                | Terminal doesn't support OSC 52 paste             | Ghostty and MobaXterm support it; tmux needs `set -g allow-passthrough on` |
| `zoxide init bash` fails                | zoxide not installed                              | Guard with `command -v zoxide` in `.zoxide`                                |
| `npm completion` slow                   | npm not installed                                 | Guard with `is-executable npm` (already done)                              |
| `.completion` tmux errors               | Homebrew tmux completion missing on Linux         | Already guarded with `is-executable brew`                                  |

## macOS-specific notes

- `zz` attaches to named Zellij session `casper`
- `gg` opens Fork (GUI git client) via `$VISUAL_GIT`
- `d()` function opens both `$VISUAL` and `$VISUAL_GIT` on a path
- `cdf()` cds to frontmost Finder window
- `bundleid()` gets macOS app bundle ID and copies to clipboard
- Quick Look preview in Yazi via `qlmanage -p` (`<C-p>`)
- `ulimit -S -n 8192` set in `.env.macos`
- `BASH_SILENCE_DEPRECATION_WARNING=1` in `.exports` (macOS Catalina+)
