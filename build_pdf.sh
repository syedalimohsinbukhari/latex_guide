#!/usr/bin/env bash
#
# Build a single combined PDF of "LaTeX for Research Students" from the
# individual Markdown files. The source .md files are read directly from THIS
# folder every run — nothing is copied, and there is no build folder to
# maintain (assembly happens in an auto-deleted system temp dir).
#
# Requirements: pandoc + a LaTeX engine (pdflatex / TeX Live), and the LaTeX
# packages authblk, orcidlink, bm (all in a standard TeX Live install).
#
# Usage:  bash build_pdf.sh
# Output: LaTeX_for_Research_Students.pdf  (next to this script)

set -euo pipefail
cd "$(dirname "$0")"                 # always operate on this folder's files
HERE="$(pwd)"
OUT="LaTeX_for_Research_Students.pdf"

# 0) Sanity: tools present?
command -v pandoc   >/dev/null || { echo "ERROR: pandoc not found in PATH";   exit 1; }
command -v pdflatex >/dev/null || { echo "ERROR: pdflatex not found in PATH"; exit 1; }

# Portable "modification time of a file" (GNU date -r, else BSD/macOS stat -f).
mtime() { date -r "$1" '+%Y-%m-%d %H:%M:%S' 2>/dev/null \
       || stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' "$1" 2>/dev/null \
       || echo '?'; }

B="$(mktemp -d)"
trap 'rm -rf "$B"' EXIT

FILES=(
#  ch01-04_foundations.md
#  ch05-08_core_typesetting.md
  ch09-10_math_mechanics.md
#  ch11-12_math_structures.md
#  ch13-16_bibliography.md
#  ch17-18_diagrams_data.md
#  ch19-20_macros_templates.md
#  ch21-22_collaboration_diagnostics.md
#  ch23_capstone_assembly.md
#  appendix.md
#  supplementary_materials.md
)

# 2) Show exactly which source files (and versions) are going in.
echo "Reading source files from: $HERE"
for f in "${FILES[@]}"; do
  [ -f "$f" ] || { echo "ERROR: missing $f"; exit 1; }
  printf '  %s  (modified %s)\n' "$f" "$(mtime "$f")"
done

# 3) Preamble (title page + math packages + unicode maps) as a real .tex header.
#    Kept out of YAML on purpose: Pandoc misreads the `---` rules inside the
#    chapters as metadata blocks and would drop front-matter settings.
cat > "$B/header.tex" <<'TEX'
\usepackage[a4paper, twoside, showframe]{geometry}
\usepackage{authblk}
\usepackage[most]{tcolorbox}
\usepackage{orcidlink}
% Callout box styles (paired with callouts.lua). Colors live here — change one line and every box of that type updates.
% Most types get their own chapter-scoped counter ("auto counter, number within=chapter"), so titles
% read e.g. "Worked Example 9.1" — the first worked example in Chapter 9 — and reset at each new chapter.
% Objective/Capstone Update are capped at one per chapter by convention, so they skip the sub-counter
% and print just the chapter number directly (\thechapter, synced by callouts.lua) — "Objective 9".
\newtcolorbox{objectivebox}{enhanced,breakable,colback=teal!4, colframe=teal!55!black, fonttitle=\bfseries,title=Objective~\thechapter}
\newtcolorbox[auto counter, number within=chapter]{workedbox}{enhanced,breakable,colback=black!3, colframe=black!45, fonttitle=\bfseries,title=Worked Example~\thetcbcounter}
\newtcolorbox[auto counter, number within=chapter]{nuancebox}{enhanced,breakable,colback=blue!4, colframe=blue!55!black, fonttitle=\bfseries,title=Nuance~\thetcbcounter}
\newtcolorbox[auto counter, number within=chapter]{exercisebox}{enhanced,breakable,colback=orange!5, colframe=orange!75!black, fonttitle=\bfseries,title=Exercise~\thetcbcounter}
\newtcolorbox{capstonebox}{enhanced,breakable,colback=violet!5, colframe=violet!60!black, fonttitle=\bfseries,title=Capstone Update~\thechapter}
\newtcolorbox[auto counter, number within=chapter]{importantbox}{enhanced,breakable,colback=red!5, colframe=red!75!black, fonttitle=\bfseries,title=Important~\thetcbcounter}
\newtcolorbox[auto counter, number within=chapter]{generalbox}[1]{enhanced,breakable,colback=gray!8, colframe=gray!60!black, fonttitle=\bfseries,title=General~\thetcbcounter~---~#1}
\newtcolorbox[auto counter, number within=chapter]{crosscheckbox}[1]{enhanced,breakable,colback=cyan!5, colframe=cyan!70!black, fonttitle=\bfseries,title=Cross-Check~\thetcbcounter~---~#1}
\usepackage{amsmath}\usepackage{amssymb}
\usepackage{bm}
% Let pages end short instead of stretching to fill.
% Prevents the "Infinite glue shrinkage found in box being split" error that longtables (Pandoc's rendering of
% Markdown tables) can trigger at page breaks.
\raggedbottom
\DeclareUnicodeCharacter{2192}{\ensuremath{\rightarrow}}
\DeclareUnicodeCharacter{00B7}{\textperiodcentered}
\DeclareUnicodeCharacter{220E}{\ensuremath{\blacksquare}}
\DeclareUnicodeCharacter{00D7}{\ensuremath{\times}}
\title{LaTeX for Research Students\\[4pt]\large A beginner's guide with examples, nuances \& exercises}
\renewcommand\title[1]{}
\author[1, 2]{Syed Ali Mohsin Bukhari\,\orcidlink{0000-0002-4232-3874}}
\author[3, 4, 5]{Iqra Siddique\,\orcidlink{0009-0000-2515-6616}}
\affil[1]{Department of Applied Mathematics and Statistics, Institute of Space Technology, Islamabad 44000, Pakistan}
\affil[2]{Space and Astrophysics Research Lab (SARL), National Centre of GIS and Space Applications (NCGSA), Islamabad 44000, Pakistan}
\affil[3]{Gran Sasso Science Institute (GSSI), Viale Crispi 7, I-67100 L'Aquila, Italy}
\affil[4]{Dipartimento di Fisica, Università di Trento, Via Sommarive 14 I-38123 Trento, Italy}
\affil[5]{INFN Laboratori Nazionali del Gran Sasso, Via Acitelli 22, I-67100 Assergi, L'Aquila, Italy}
\makeatletter\renewcommand\author[2][]{}\makeatother
\date{\today\\[6pt]{\small Drafting assistant: Claude (Anthropic) \textperiodcentered{} Reviewer: DeepSeek (High-Flyer)}}
\renewcommand\date[1]{}
\makeatletter\let\oldmaketitle\maketitle\renewcommand\maketitle{\oldmaketitle\clearpage}\makeatother
TEX

# 4) Body: intro paragraphs from 00_index.md (between the YAML block and the
#    manual "## Contents" listing; Pandoc's --toc generates the real TOC),
#    then every chapter, stripping the repeated subtitle + byline lines.
awk 'f==2 && /^## Contents$/{exit} f==2{print} /^---$/{f++}' 00_index.md > "$B/body.md"
for f in "${FILES[@]}"; do
  printf '\n\n' >> "$B/body.md"
  sed -E '/^\*LaTeX for Research Students — a beginner/d; /^\*Authors: Syed Ali Mohsin Bukhari/d' "$f" >> "$B/body.md"
done

# 5) Compile into the temp dir first (never straight onto the target file, so a
#    locked/open output PDF can't cause a half-written or stale result).
#    -f markdown-yaml_metadata_block => treat chapter `---` as horizontal rules.
pandoc "$B/body.md" -f markdown-yaml_metadata_block \
  --metadata title="LaTeX for Research Students" \
  --toc --toc-depth=2 -H "$B/header.tex" \
  --lua-filter callouts.lua \
  --pdf-engine=pdflatex \
  -V documentclass=book \
  -V classoption=twoside \
  --top-level-division=part \
  -V colorlinks=true -V linkcolor=RoyalBlue -V urlcolor=RoyalBlue -V toccolor=black \
  -o "$B/out.pdf"

# 6) Move the freshly built PDF into place. If the target is locked (open in a viewer), say so clearly and drop the
# new build next to it instead of leaving you with a silent stale file.
if cp -f "$B/out.pdf" "$OUT" 2>/dev/null; then
  echo "-----------------------------------------------------------"
  echo "OK  Built $OUT"
  echo "    pages:    $(pdfinfo "$OUT" 2>/dev/null | awk '/Pages/{print $2}')"
  echo "    written:  $(mtime "$OUT")"
  echo "    path:     $HERE/$OUT"
  echo "-----------------------------------------------------------"
  echo "If a viewer still shows the old version, it is caching the file —"
  echo "close and reopen it (Preview/Acrobat don't auto-reload; Okular/Evince do)."
else
  ALT="LaTeX_for_Research_Students.new.pdf"
  cp -f "$B/out.pdf" "$ALT" 2>/dev/null || true
  echo "-----------------------------------------------------------" >&2
  echo "ERROR: could not overwrite $OUT." >&2
  echo "It is almost certainly OPEN in a PDF viewer that locks the file." >&2
  echo "  -> Close the PDF, then run this script again." >&2
  [ -f "$ALT" ] && echo "  -> For now, the fresh build was saved as: $ALT" >&2
  echo "-----------------------------------------------------------" >&2
  exit 1
fi
