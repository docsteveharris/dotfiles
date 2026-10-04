#!/usr/bin/env bash
# convert.sh — convert source documents to Markdown for AI context
#
# Conversion rules (by file extension, no manifest field needed):
#   .docx        → pandoc --track-changes=all -t gfm  (preserves comments/edits)
#   .pdf         → markitdown (body text) + pdfannots second pass (*_annots.md)
#   everything else → markitdown
#
# Two modes:
#   1. Manifest mode: reads manifest.yaml documents: section, converts listed
#      files. Skips up-to-date files.
#   2. Inbox mode: discovers all files in inbox/, converts them, moves
#      originals to _converted/, appends stub entries to manifest.yaml.
#
# Run from anywhere; script locates itself.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST="$SCRIPT_DIR/manifest.yaml"
DOCS="$SCRIPT_DIR/docs"
INBOX="$ROOT/inbox"
CONVERTED="$ROOT/_converted"

mkdir -p "$DOCS"

# ---------------------------------------------------------------------------
# Dependency checks
# ---------------------------------------------------------------------------
for cmd in yq markitdown pandoc pdfannots; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd not found." >&2
    case "$cmd" in
      yq)          echo "  Install: brew install yq" >&2 ;;
      markitdown)  echo "  Install: uv tool install 'markitdown[all]'" >&2 ;;
      pandoc)      echo "  Install: brew install pandoc" >&2 ;;
      pdfannots)   echo "  Install: uv tool install pdfannots" >&2 ;;
    esac
    exit 1
  fi
done

# ---------------------------------------------------------------------------
# convert_file <src_path> <out_path>
# Selects converter by extension; runs pdfannots second pass for PDFs.
# ---------------------------------------------------------------------------
convert_file() {
  local src_path="$1"
  local out_path="$2"
  local ext="${src_path##*.}"
  ext="${ext,,}"  # lowercase

  case "$ext" in
    docx)
      pandoc "$src_path" -t gfm --track-changes=all -o "$out_path"
      ;;
    pdf)
      # First pass: body text
      markitdown "$src_path" -o "$out_path"
      # Second pass: annotations (stem_annots.md alongside the body text file)
      local annots_path="${out_path%.md}_annots.md"
      pdfannots "$src_path" -o "$annots_path" 2>/dev/null || true
      # Remove empty annotations file to avoid clutter
      if [[ -f "$annots_path" && ! -s "$annots_path" ]]; then
        rm "$annots_path"
      else
        echo "  Annotations: $(basename "$annots_path")"
      fi
      ;;
    *)
      markitdown "$src_path" -o "$out_path"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Mode 1: manifest-driven conversion
# ---------------------------------------------------------------------------
echo "==> Manifest mode"

count=$(yq '.documents | length' "$MANIFEST")

for i in $(seq 0 $((count - 1))); do
  src=$(yq ".documents[$i].src" "$MANIFEST")
  out=$(yq ".documents[$i].out" "$MANIFEST")

  src_path="$ROOT/$src"
  out_path="$SCRIPT_DIR/$out"

  if [[ ! -f "$src_path" ]]; then
    echo "SKIP (not found):    $src"
    continue
  fi

  if [[ -f "$out_path" && "$out_path" -nt "$src_path" ]]; then
    echo "SKIP (up to date):   $out"
    continue
  fi

  echo "Converting: $src → _context/$out"
  convert_file "$src_path" "$out_path"
done

# ---------------------------------------------------------------------------
# Mode 2: inbox processing
# ---------------------------------------------------------------------------
echo ""
echo "==> Inbox mode"

# Extensions to skip entirely
SKIP_EXTS=("webloc" "inetloc" "mailloc" "DS_Store" "localized")

is_skipped() {
  local ext="${1##*.}"
  ext="${ext,,}"
  for skip in "${SKIP_EXTS[@]}"; do
    [[ "$ext" == "$skip" ]] && return 0
  done
  return 1
}

shopt -s nullglob
inbox_files=("$INBOX"/*)
shopt -u nullglob

if [[ ${#inbox_files[@]} -eq 0 ]]; then
  echo "Inbox is empty."
else
  for src_path in "${inbox_files[@]}"; do
    filename="$(basename "$src_path")"
    ext="${filename##*.}"
    ext_lower="${ext,,}"

    # Skip unwanted file types
    if is_skipped "$filename"; then
      echo "SKIP (excluded type): $filename"
      continue
    fi

    # .md files: already readable — move to docs/ and add to readable: section
    if [[ "$ext_lower" == "md" ]]; then
      out_path="$DOCS/$filename"
      echo "Readable:   inbox/$filename → _context/docs/$filename"
      cp "$src_path" "$out_path"
      mv "$src_path" "$CONVERTED/$filename"
      # Add to readable: section if not already present
      rel_path="_context/docs/$filename"
      if ! yq ".readable[] | select(.path == \"$rel_path\")" "$MANIFEST" | grep -q .; then
        yq -i ".readable += [{\"path\": \"$rel_path\", \"desc\": \"TODO: add description\", \"group\": \"inbox\"}]" "$MANIFEST"
        echo "Added to manifest (readable): $rel_path"
      fi
      continue
    fi

    # All other files: convert
    # Derive a clean output name: lowercase, spaces→underscores, strip extension, add .md
    out="${filename%.*}"
    out="${out// /_}"
    out="${out,,}.md"
    out_path="$DOCS/$out"

    echo "Converting: inbox/$filename → _context/docs/$out"
    convert_file "$src_path" "$out_path"

    echo "Moving:     inbox/$filename → _converted/$filename"
    mv "$src_path" "$CONVERTED/$filename"

    # Append stub entry to manifest.yaml documents: section if not already present
    if ! yq ".documents[] | select(.out == \"docs/$out\")" "$MANIFEST" | grep -q .; then
      yq -i ".documents += [{\"src\": \"_converted/$filename\", \"out\": \"docs/$out\", \"desc\": \"TODO: add description\", \"group\": \"inbox\"}]" "$MANIFEST"
      echo "Added to manifest (documents): docs/$out"
    fi
  done
fi

echo ""
echo "Done."
