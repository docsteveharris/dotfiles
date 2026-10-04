---
name: <project-slug>
description: >
  Load this skill when working on [project name and brief description].
  Trigger words: [3–6 key terms from the project].
---

# <Project Name> Skill

When this skill is active, read the context files in `_context/` before
responding. Start with `manifest.yaml` to understand what documents exist,
then read `CONTEXT.md`, `GLOSSARY.md`, and `MEMORY.md`.

- `CONTEXT.md`    — project brief, stakeholders, open questions
- `GLOSSARY.md`   — acronyms, roles, organisations
- `MEMORY.md`     — decisions log; append new decisions here
- `manifest.yaml` — document index; read to know what files exist

Project root: `<absolute-path-to-project-root>/`

## Standing instructions

- When a decision is made, append a dated entry to `MEMORY.md`.
- When asked to add a document, add an entry to `manifest.yaml` and
  remind the user to run `bash _context/convert.sh`.
