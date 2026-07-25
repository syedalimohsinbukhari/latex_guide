# Part 8: Collaboration & Diagnostics (Chapters 21–22)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

---

## Chapter 21 — Version Control, Collaboration & Journal Submission

::: objective

Set up version control for a LaTeX project — via Overleaf's Git integration or its simpler History panel — collaborate with co-authors using track changes and comments, and prepare a clean, submission-ready PDF.

:::

::: worked

**Overleaf's Git integration**

```
# From Overleaf: Menu -> Git, then copy the clone URL it gives you
git clone https://git.overleaf.com/xxxxxxxxxxxx myproject
cd myproject

# edit locally in any editor, then:
git add .
git commit -m "Add methods section"
git push origin master

# to pull changes made back on Overleaf's website:
git pull origin master
```
This clones your Overleaf project as a real Git repository — edit it locally, push, and the changes appear back in your Overleaf project (and vice versa with `git pull`). *(Git access is tied to your Overleaf plan — check your account if the Git option isn't visible under Menu.)*

:::

::: nuance

**not every student needs Git**

Git is the gold standard, but not everyone comes in with a CS background — common in biology/chemistry labs, for instance. Overleaf's built-in **History** panel (the clock icon in the top toolbar) tracks every compile automatically, with no setup at all, and lets you revert to any previous version directly. If the Git workflow above feels like overkill, History covers the same core need — "let me get back an earlier version" — with zero configuration.

:::

::: nuance

**track changes and comments**

Toggle **Review mode** (top toolbar) to turn on Word-style tracked changes — insertions and deletions appear in color, attributed to whoever made them, and can be accepted or rejected individually. Select any text and click the comment icon to leave a note without touching the text itself. Both are the natural first stop for collaborating with a co-author who doesn't want to touch Git at all — exactly the audience the History panel above also serves.

:::

::: nuance

**working offline — a TeX distribution plus an editor**

Everything so far assumes Overleaf. Working locally needs two separate pieces: a **TeX distribution** (the actual compiler and package library) and an **editor**. A common combination:

- **TeX Live** — download from `tug.org/texlive` (or install via your OS's package manager). The **basic** scheme installs a minimal core, with missing packages added manually via `tlmgr` (TeX Live's own package manager) as you need them; the **full** scheme installs everything upfront instead, if you'd rather not think about it again.
- **MiKTeX** — download from `miktex.org`. Installs a small base by default and prompts to install any missing package on-the-fly, the first time a document actually needs it — a similar philosophy to TeX Live's basic scheme, just automated.
- **TeXStudio** — download from `texstudio.org`, works on top of either distribution above. It auto-detects your installed compiler in most cases; set your default (pdfLaTeX/XeLaTeX/LuaLaTeX — the same decision as Ch. 2, just made once in Options instead of per-project) and you get the same edit/compile/preview loop Overleaf gives you, running entirely on your own machine.

:::

::: nuance

**real Git, via the terminal**

Once you're working locally, Git works on a `.tex` project exactly like it would on any code project — nothing LaTeX-specific about it, since (as Ch. 1 pointed out) a `.tex` file is just plain text:
```
git init
git add .
git commit -m "Initial draft"
git remote add origin <your-repository-url>
git push -u origin main
```
This is the "real" version of what Overleaf's Git bridge gives you in the browser — run directly from a terminal, alongside TeXStudio or whichever editor you're using.

:::

::: nuance

**PyCharm as a workaround, not a recommendation**

If you'd rather have Git's visual tools — diffs, branch graphs, merge conflict resolution — built into your editor instead of typed at a terminal, PyCharm (or any JetBrains IDE) plus the community `TeXiFy-IDEA` plugin gets you LaTeX editing and compiling alongside PyCharm's polished built-in Git support. This is a genuine workaround some people use, not a purpose-built LaTeX tool — worth it specifically if you already live in a JetBrains IDE and want Git's GUI more than you want an editor designed for LaTeX first. TeXStudio remains the more natural choice if you're starting from scratch.

:::

::: worked

**a camera-ready checklist**

Before calling a PDF submission-ready:

- Every draft-only section is wrapped in `\begin{comment}...\end{comment}` (Ch. 20), not just commented out with stray `%` signs.
- The compiler matches what the journal/thesis office actually requires (Ch. 2).
- `\hypersetup` (Ch. 8) is set appropriately — `colorlinks` for a digital submission, `hidelinks` if the venue wants no visible link styling at all.
- The document has been compiled at least twice since the last edit, so cross-references (Ch. 8), the bibliography (Ch. 13), and the table of contents (Ch. 5) are all fully settled, not showing stale `??` marks.
- No leftover placeholder text (`[Working Title...]`-style brackets from Ch. 1–4) remains anywhere in the document.

:::

::: exercise

1. Either link an Overleaf project to Git and make two commits, or practice reverting to a previous version using the History panel.
2. Turn on Review mode, make a tracked edit, and accept or reject it.
3. Optional, if you want to try the offline route: install TeXStudio plus TeX Live or MiKTeX, and compile a document you've already built in Overleaf — confirm it produces the same PDF.

:::

::: capstone

Tag or save a "submission-ready" version of your capstone paper — a Git commit/tag, an Overleaf History checkpoint, or a local Git commit if you tried the offline route — and run through the camera-ready checklist above before considering it done.

:::

---

## Chapter 22 — Troubleshooting Common Errors (Full Reference)

::: objective

Read a full LaTeX log file rather than just the first red error, recognize the most common error categories on sight, and isolate a broken section methodically instead of guessing line by line.

:::

::: worked

**what's actually in a log file**

A compile log is mostly noise — package load messages, font substitution notes, and warnings that don't stop compilation. The parts that matter:
```
! Undefined control sequence.
l.12 \RRR
         {x}
?
```

- A line starting with `!` is an actual **error** — this is what stopped the compile.
- The `l.12` line tells you exactly which source line LaTeX was processing when it gave up.
- Anything *not* starting with `!` — package messages, font warnings, `Overfull \hbox` notices — is informational. Safe to skim past on a first read, unless the compile genuinely failed and nothing else explains why.
- `LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right.` is a **warning**, not an error — it means exactly what Ch. 8 and Ch. 9 already told you: compile again so references/citations settle.

:::

::: nuance

**error message reference table**

Expands on the short version already seen in Ch. 3:

| Error | Typical cause |
|---|---|
| `Undefined control sequence` | A typo'd command name, or the package that defines it was never loaded. |
| `Missing $ inserted` | A math-only character (`_`, `^`) used outside math mode, or an unclosed `$`. |
| `Missing } inserted` / `Runaway argument?` | An unclosed brace `{` — usually reported on the line *after* the real culprit, since LaTeX doesn't notice until it hits the next command (Ch. 2). |
| `! LaTeX Error: File 'xxx.sty' not found` | The package genuinely isn't installed — rare on Overleaf (everything's preinstalled), more common on a fresh local TeX Live "basic" install (Ch. 21) that hasn't fetched it yet. |
| `Environment X undefined` | A typo in `\begin{}`/`\end{}`, or the package defining that environment was never loaded. |
| `! Package babel Error` / similar package-specific errors | Read the message itself — package errors usually name the exact problem, unlike the generic errors above. |

:::

::: nuance

**isolating an error by bisection**

When it's not obvious which of several hundred lines broke, don't read them all — cut the search in half repeatedly:
1. Wrap the back half of the document in `\begin{comment}...\end{comment}` (Ch. 20) and recompile.
2. If the error disappears, it was in the commented-out half — move the boundary and repeat inside that half.
3. If the error remains, it's in the half still active — repeat there instead.
Each round halves the amount of document left to suspect, the same binary-search logic used well outside LaTeX, converging on the exact broken line in a handful of recompiles instead of a linear scan.

:::

::: exercise

Debug each of these independently — each has exactly one deliberate error:
1. **Easiest:**
   ```latex
   \documentclass{article}
   \begin{document}
   \textbf{Hello, world.}
   \textitt{This is a test.}
   \end{document}
   ```
   *(Hint: one of these two formatting commands isn't a real command.)*
2. **Medium:**
   ```latex
   \documentclass{article}
   \usepackage{amsmath}
   \begin{document}
   The result is $x^2 + y^2 = r^2.
   \end{document}
   ```
   *(Hint: count the dollar signs.)*
3. **Harder:**
   ```latex
   \documentclass{article}
   \begin{document}
   \begin{itemize}
     \item First point
     \item Second point
   \end{enumerate}
   \end{document}
   ```
   *(Hint: the error names an environment — but check both the `\begin` and the `\end`.)*

:::

::: capstone

Intentionally break your capstone paper — remove a package it depends on, mismatch a brace, or misspell an environment name — then fix it using only the log file, without pressing undo.

:::

---

*End of Part 8 (Ch. 21–22). Next: Part 9 — Capstone Assembly (Ch. 23).*
