# [Project Name]

Standing instructions for any agent working in this directory.

## What this project is

<!-- TODO: 2–4 sentences. Keep this short; CONTEXT.md holds the detail. -->

## Where the context lives

Read these before responding. Start with `manifest.yaml` to see what
documents exist, then read the rest.

- `_context/CONTEXT.md`    — project brief, stakeholders, open questions
- `_context/GLOSSARY.md`   — acronyms, roles, organisations
- `_context/MEMORY.md`     — decisions log; append new decisions here
- `_context/manifest.yaml` — document index; read to know what files exist
- `_context/docs/`         — converted documents, read on demand

## Standing instructions

- When a decision is made, append a dated entry to `_context/MEMORY.md`.
- When asked to add a document, add an entry to `_context/manifest.yaml`
  and remind the user to run `bash _context/convert.sh`.
- <!-- TODO: project-specific rules: audience, terminology, format, tone -->
