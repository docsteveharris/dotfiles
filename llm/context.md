## CONTEXT-SHORT

(80% of situations)

# Dotfiles — AI Assistant Context (Short)

## What this is

Personal dotfiles for a portable CLI development environment, used on:

- macOS ARM (home, Ghostty terminal, Docker Desktop)
- Ubuntu 24.04 inside a Docker container (work VM, accessed via MobaXterm/SSH)

Based on https://github.com/webpro/dotfiles — now significantly diverged.

## Repos

- Dotfiles: https://github.com/docsteveharris/dotfiles
- Container config: https://github.com/docsteveharris/jd

## Directory structure

```sh
dotfiles/
├── bin/ ← helper scripts (dot, is-macos, is-arm64, etc.)
├── config/ ← XDG config packages, stowed per-tool
│ ├── ghostty/
│ ├── git/
│ ├── julia/
│ │ ├── environments/dsbc/ ← Project.toml for @dsbc stacked env
│ │ └── startup.jl
│ ├── lazygit/
│ ├── nvim/ ← LazyVim config (nested git repo)
│ │ └── lua/
│ │ ├── config/ ← keymaps.lua, options.lua, autocmds.lua, lazy.lua
│ │ └── plugins/ ← per-plugin overrides
│ ├── yazi/
│ └── zellij/
│ └── layouts/ ← default.kdl, lazyvim.kdl
├── install/ ← Brewfile, Caskfile, npmfile etc. (macOS only)
├── macos/ ← macOS defaults scripts (macOS only)
├── Makefile ← install entrypoint
├── runcom/ ← .bash_profile, .bashrc (symlink), .inputrc
└── system/ ← sourced shell config fragments
├── .alias ← aliases (cross-platform)
├── .alias.macos ← macOS-only aliases
├── .completion ← bash completion setup
├── .env ← EDITOR, XDG dirs, shopt, history settings
├── .env.macos ← macOS-only env vars
├── .exports ← BASH_SILENCE_DEPRECATION_WARNING
├── .function ← core functions incl. y() yazi wrapper
├── .function_fs ← filesystem functions (cf, mk, duf, t, etc.)
├── .function_network ← network functions
├── .function_text ← text functions
├── .function_utils ← docx2md etc.
├── .function.macos ← macOS-only functions
├── .fzf ← fzf key-bindings and completion sourcing
├── .grep ← grep options and colors
├── .n ← N_PREFIX for node version manager
├── .path ← PATH construction (prepend-path guards)
├── .prompt ← bash prompt with git branch, container badge
└── .zoxide ← zoxide init
```

## Install / link mechanism

GNU Stow is used to symlink config into `$HOME`:

- `runcom/` stowed directly to `$HOME` → `~/.bash_profile`, `~/.inputrc`
- `config/<tool>/` each stowed to `$HOME` → `~/.config/<tool>/...`
- Julia config is **copied** (not stowed): `startup.jl` and `dsbc/Project.toml`
  copied by `make link-julia` (macOS) or `init-perms-dev.sh` (container)

```bash
make link      # stow everything + link-julia
make unlink    # remove all stow symlinks
````

## Shell startup chain

`.bash_profile` (= `.bashrc` symlink) sources in order:

1. `system/.function`, `system/.function_*` — functions first
2. `system/.n` — N_PREFIX
3. `system/.path` — PATH construction
4. `system/.env` — EDITOR, XDG, shopt, history
5. `system/.exports` — misc exports
6. `system/.alias` — aliases
7. `system/.fzf` — fzf key-bindings
8. `system/.grep` — grep options
9. `system/.prompt` — PS1 / PROMPT_COMMAND
10. `system/.completion` — bash completions
11. `system/.zoxide` — `eval "$(zoxide init bash)"`
12. macOS-only: `.env.macos`, `.alias.macos`, `.function.macos`
13. juliaup PATH guard (idempotent `case` check)
14. `eval "$(fzf --bash)"` — fzf shell integration (requires fzf 0.48+)

## Key aliases and functions

| Alias/Function | Expands to                                   | Notes                     |
| -------------- | -------------------------------------------- | ------------------------- |
| `nn`           | `y` (yazi wrapper)                           | changes cwd on exit       |
| `zz`           | `zellij` (Linux) / `zellij a casper` (macOS) |                           |
| `vv`           | `nvim`                                       |                           |
| `gg`           | `lazygit` (Linux) / `$VISUAL_GIT` (macOS)    |                           |
| `y()`          | yazi with cwd-file handoff                   | defined in `.function`    |
| `cf()`         | fzf into directory via fd                    | defined in `.function_fs` |
| `t()`          | `tree -AdL N`                                | defined in `.function_fs` |
| `reload`       | `source ~/.bash_profile`                     |                           |
| `venva`        | `source .venv/bin/activate`                  |                           |
| `fkill`        | fzf process picker → kill                    |                           |

## Tool stack

| Tool             | Config location                 | Notes                                              |
| ---------------- | ------------------------------- | -------------------------------------------------- |
| Neovim (LazyVim) | `config/nvim/`                  | nested git repo, tokyonight theme                  |
| Zellij           | `config/zellij/`                | `config.kdl` + 2 layouts                           |
| Yazi             | `config/yazi/`                  | duckdb previewer, full-border, toggle-pane plugins |
| fzf              | `system/.fzf` + `.bash_profile` | `eval "$(fzf --bash)"` for integration             |
| zoxide           | `system/.zoxide`                | `eval "$(zoxide init bash)"`                       |
| lazygit          | `config/lazygit/`               |                                                    |
| Ghostty          | `config/ghostty/`               | macOS only in practice                             |
| Julia            | `config/julia/`                 | startup.jl + @dsbc env                             |

## Neovim / LazyVim overview

- **Colorscheme**: tokyonight (set in `core.lua`)
- **Clipboard**: OSC 52 via `vim.g.clipboard` (`clipboard.lua`) — works over SSH/Zellij/MobaXterm
- **REPL**: vim-slime → Zellij (`slime.lua`), target pane = right
- **File picker**: Snacks.nvim with fd, hidden files included (`snacks-picker.lua`, `pick-files.lua`)
- **File manager**: yazi.nvim (`<leader>fy` / `<leader>fY`) (`yazi.lua`)
- **Julia LSP**: JETLS (`jetls.lua`); julials explicitly disabled (`julia-lsp.lua`)
- **Julia formatter**: JuliaFormatter.vim (`juliaformatter.lua`)
- **Treesitter**: `auto_install = false` (no tree-sitter CLI in container) (`treesitter.lua`)
- **Mason**: julials excluded from `automatic_enable` (`mason.lua`)
- **Key custom keymap**: `<leader>fw` → save file (`keymaps.lua`)

## Yazi overview

- **Plugins**: duckdb (data file preview), full-border, toggle-pane
- **Previewers**: csv, tsv, json, parquet, txt, xlsx, db, duckdb → duckdb plugin
- **Keymaps**: `T` max-preview toggle, `H`/`L` duckdb column scroll, `go` open in duckdb, `gu` open duckdb UI, `<C-p>` Quick Look (macOS)
- **Theme**: tokyo-night flavor
- **Layout**: `ratio = [1, 2, 5]`

## Zellij overview

- **Theme**: tokyo-night
- **Keybinds**: `clear-defaults=true` — fully custom, vim-style hjkl throughout
- **Mode entry**: `Ctrl-p` pane, `Ctrl-t` tab, `Ctrl-n` resize, `Ctrl-h` move, `Ctrl-o` session, `Ctrl-s` scroll, `Ctrl-g` locked
- **Layouts**: `default.kdl` (tab-bar + shell + status-bar), `lazyvim.kdl` (tab-bar + nvim + status-bar)
- **Startup tips**: disabled (`show_startup_tips false`)

## Julia setup

- **Global env**: Revise, OhMyREPL, Infiltrator, BenchmarkTools, Term
- **@dsbc stacked env**: DuckDB, DataFrames, CSV
  - `Project.toml` in dotfiles → copied to `~/.julia/environments/dsbc/`
  - `Manifest.toml` generated at runtime, not versioned
  - Activated via `push!(LOAD_PATH, "@dsbc")` in `startup.jl`
- **startup.jl** utilities: `peek(x,n)`, `cls()`, `@t expr`, `info(x)`
- **JETLS**: installed to `~/.julia/bin/jetls` by `init-perms-dev.sh`
- **Runic formatter**: installed to `~/.local/bin/runic` by `init-perms-dev.sh`

## Platform differences

| Behaviour           | macOS                                       | Container (Ubuntu 24.04) |
| ------------------- | ------------------------------------------- | ------------------------ |
| `zz` alias          | `zellij a casper`                           | `zellij`                 |
| `gg` alias          | `$VISUAL_GIT` (Fork)                        | `lazygit`                |
| pytools venv        | `~/opt/pytools-venv`                        | `/opt/pytools-venv`      |
| juliaup PATH        | `~/.juliaup/bin` (guard in `.bash_profile`) | same                     |
| fzf source          | Homebrew                                    | GitHub binary v0.62.0    |
| dircolors           | via `dircolors` binary                      | same                     |
| `.completion`       | Homebrew bash-completion@2                  | system `/usr/share/...`  |
| Julia/JETLS install | manual / `make link`                        | `init-perms-dev.sh`      |

## Known issues / TODOs

- `.fzf` sources Debian/Homebrew key-binding files that don't exist in container — harmless (guarded), but `eval "$(fzf --bash)"` in `.bash_profile` is the actual integration
- `FZF_CTRL_R_OPTS` uses `pbcopy` — only works on macOS; no-op on Linux
- `append` bin script requires `pcregrep` — not guaranteed in container
- `.completion` sources tmux completion from Homebrew — silently skipped on Linux
- `lsd` used in `.alias` for `l`/`ll`/`la`/`lt` — must be installed separately (not in container Dockerfile)
- `system/.alias.macos` overrides `zz` and `gg` — load order matters (macos sourced after base)

