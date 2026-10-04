---
name: project-setup
description: >
  Load this skill when asked to set up a new AI project context, scaffold
  a _context directory, initialise a project, or create context files for
  a new project. Trigger phrases: "set up context", "initialise project",
  "scaffold context", "new project context", "create _context".
---

# Project Setup Skill

This skill scaffolds a complete `_context/` directory structure for a new
project, following the standard AI project context workflow. It also writes
an `AGENTS.md` at the project root, which is what a Raycast Project reads
from its working directory.

The Raycast Project is the primary mechanism. A Project reads `AGENTS.md`
from its working directory automatically, in every chat, with no skill
loading required. Do not create a nested skill inside the project: it would
duplicate `AGENTS.md` and drift out of step with it.

## What you will do

When this skill is loaded, follow these steps in order. Do not skip steps.
Confirm the project root with the user before writing any files.

### Step 1 — Confirm the project root

Ask the user to confirm the full path to the project root directory if it
is not already clear from context. You need the absolute path.

### Step 2 — Read the existing directory

Use the filesystem MCP to:
- List the top-level project directory
- List any immediate subdirectories
- Read any existing markdown, text, or converted files that look like
  project documentation (proposals, briefs, notes, emails)

Use what you find to inform the content of the context files. Do not
invent content — only include what is evidenced in the existing files.

### Step 3 — Create the directory structure

Create the following directories if they do not already exist:

```
<project-root>/AGENTS.md
<project-root>/_context/
<project-root>/_context/docs/
<project-root>/_converted/
<project-root>/inbox/
```

### Step 4 — Write CONTEXT.md

Write `<project-root>/_context/CONTEXT.md` using the template below,
populated with what you have learned from the existing files.

Template structure:
- What this project is (2–4 sentences)
- [Name]'s role
- Key dates (if known)
- Structure / workstreams (if known)
- Key stakeholders (if known)
- Open questions / tensions (if known)

Leave sections blank with a `<!-- TODO -->` comment rather than inventing
content.

### Step 5 — Write GLOSSARY.md

Write `<project-root>/_context/GLOSSARY.md` with three tables:
- Organisations (abbreviation, full name, role)
- Roles (role title, person, notes)
- Key concepts (term, definition)

Populate only from what is evidenced in the existing files.

### Step 6 — Write MEMORY.md

Write `<project-root>/_context/MEMORY.md` with a single dated entry
(today's date) recording:
- That the `_context/` structure was initialised
- Any key positions or decisions already evident from the existing files
- Any unresolved questions identified

### Step 7 — Write manifest.yaml

Write `<project-root>/_context/manifest.yaml` following this structure:

```yaml
# manifest.yaml
# Single source of truth for all project documents.
#
# Two sections:
#   documents: files that need conversion via convert.sh
#              originals live in _converted/ after first processing
#   readable:  files already in markdown/text; model reads directly via MCP
#
# Conversion rules (automatic, by extension):
#   .docx        → pandoc --track-changes=all (preserves comments/edits)
#   .pdf         → markitdown (body) + pdfannots second pass (*_annots.md)
#   .md          → copied directly to docs/, added to readable: section
#   .webloc etc  → skipped
#   everything else → markitdown
#
# To convert:   bash _context/convert.sh
# To add a doc: add entry here and re-run convert.sh

documents:
  # Add entries here for files that need conversion
  # - src:   "_converted/filename.docx"
  #   out:   "docs/filename.md"
  #   desc:  "One-line description"
  #   group: "workstream"

readable:
  # Add entries here for files already in markdown/text
  # - path:  "subfolder/filename.md"
  #   desc:  "One-line description"
  #   group: "workstream"
```

Populate `readable:` with any `.md` or `.txt` files already in the project
that are worth including. Leave `documents:` empty — the user will populate
it via the inbox workflow or by asking the model to add entries.

### Step 8 — Copy convert.sh from templates

Read the template convert.sh from:
`~/.config/agents/skills/project-setup/templates/convert.sh`

Write it verbatim to `<project-root>/_context/convert.sh`.
Then make it executable:
```bash
chmod +x "<project-root>/_context/convert.sh"
```

### Step 9 — Write AGENTS.md at the project root

Write `<project-root>/AGENTS.md` using the template at
`~/.config/agents/skills/project-setup/templates/AGENTS.md`, populated with
project-specific details.

This file is the seam between the `_context/` scaffold and Raycast Projects.
A Raycast Project reads `AGENTS.md` from its working directory before the
project's own instructions and memory, so anything written here is picked up
automatically in every chat in the project, with no skill loading required.

This is the only place the standing instructions should live. Do not also
write a nested skill under `_context/skills/`: two copies of the same rules
will drift apart, and the Project already does the job automatically.

Keep it short. It is a pointer and a rulebook, not a brief: the detail belongs
in `_context/CONTEXT.md`. Do not duplicate content between the two.

### Step 10 — Report back

Summarise what was created:
- List all files written
- List any `<!-- TODO -->` gaps in the context files that need filling
- Remind the user to:
  1. Create a Raycast Project (Settings → AI → Projects) and set its working
     directory to the project root. This is what makes `AGENTS.md` apply
     automatically in every chat in the project.
  2. Run `bash _context/convert.sh` after adding documents to the manifest
  3. Drop new documents in `inbox/` for ongoing conversion

Do not tell the user to register a skills directory. The Project and
`AGENTS.md` replace the nested skill.

## Conversion rules (for reference when populating the manifest)

| Extension | Tool | Notes |
|---|---|---|
| `.docx` | pandoc | Preserves track changes and comments |
| `.pdf` | markitdown + pdfannots | Body text + separate annotations file |
| `.md` | none | Copied directly, added to readable: |
| `.webloc`, `.inetloc`, `.mailloc` | skipped | URL shortcuts |
| everything else | markitdown | .eml, .rtf, .txt, .html etc. |

## Templates location

All blank templates live at:
`~/.config/agents/skills/project-setup/templates/`

Read them if you need to check the canonical structure of any file.
