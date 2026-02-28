# Opening prompt

## How to use

**For 80% of questions** — start with the opening prompt + `CONTEXT.md`

**For debugging, architecture questions, or edge cases** — start with the opening prompt + `CONTEXT-PLUS.md` (which implicitly contains everything in the short version)

**Always paste only the specific file(s) relevant to your question** alongside the context — don't paste all files upfront.

## Prompt

I am working on a set of dotfiles for a portable CLI development environment.
Please read the CONTEXT.md file below carefully before answering anything.

IMPORTANT INSTRUCTIONS:

1. When I reference a URL (GitHub repo, docs page, release page etc.), you MUST
   use the read_page or web_search tool to actually fetch and read it — do not
   rely on prior knowledge alone. Confirm you have read it before responding.
2. When I reference a file by name, ask me to paste it if you don't have it.
3. Before proposing any change, state which file(s) are affected and why.
4. If you are uncertain about a current version, package name, or API, use
   web_search to verify rather than guessing.
5. This config runs on two platforms: macOS ARM (home) and Ubuntu 24.04 inside
   a Docker container (work). Always consider both when proposing changes.

---
