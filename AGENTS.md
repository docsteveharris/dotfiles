# dotfiles 🤓

Standing instructions for any agent working in this directory.

## What this project is

Personal dotfiles for Steve's Mac (and Linux container) workstation: shell runcom, system settings, and configs for Yazi, LazyVim, Ghostty, Zellij, Git, tmux and the rest. Managed with a `Makefile` and GNU Stow; a `log.md` at the root records changes. The `_context/` directory is the AI project context for notes and working documents, mostly not committed.

## Where the context lives

Read these before responding. Start with `manifest.yaml` to see what
documents exist, then read the rest.

- `_context/CONTEXT.md` — project brief, stakeholders, open questions
- `_context/GLOSSARY.md` — acronyms, roles, organisations
- `_context/MEMORY.md` — decisions log; append new decisions here
- `_context/manifest.yaml` — document index; read to know what files exist
- `_context/docs/` — converted documents, read on demand
- \_context/LOG.md — human-maintained chronological change log (reverse chronological)

## Standing instructions

- When a decision is made, append a dated entry to `_context/MEMORY.md`.
- When asked to add a document, add an entry to `_context/manifest.yaml`
  and remind the user to run `bash _context/convert.sh`.
- Read the top entries of `log.md` before responding to setup questions; it is the human-side record of what changed and when.
- British English throughout. No em dashes or en dashes in drafted prose.
- `_context/` working files are private; assume they may be gitignored and never paste their contents outside this project.
