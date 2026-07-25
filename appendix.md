# Appendix

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

Reference material, not narrative teaching — everything below assumes you've already read the chapter it points back to, and exists purely so you don't have to go hunting for a command you've seen once before. Where something is fully explained elsewhere in the guide, this appendix links to it rather than re-teaching it; a few items (page geometry, dimension keywords, spacing glue) are genuinely new, since they didn't fit naturally into any single chapter's narrative.

- [Appendix](#appendix)
  - [A.1 — Symbol \& Command Cheat Sheet](#a1--symbol--command-cheat-sheet)
  - [A.2 — Table Formatting Cheat Sheet](#a2--table-formatting-cheat-sheet)
    - [`minipage` — and how it differs from `subfigure`](#minipage--and-how-it-differs-from-subfigure)
  - [A.3 — Page Layout \& Spacing Reference](#a3--page-layout--spacing-reference)
  - [A.4 — Common Package Reference Table](#a4--common-package-reference-table)
  - [A.5 — Compiler Comparison](#a5--compiler-comparison)
  - [A.6 — `tikz-cd` and `chemfig` Starter Snippets](#a6--tikz-cd-and-chemfig-starter-snippets)
  - [A.7 — Quick Troubleshooting Checklist](#a7--quick-troubleshooting-checklist)
  - [A.8 — Starter `.bib` Files](#a8--starter-bib-files)
  - [A.9 — `hypersetup` Snippet](#a9--hypersetup-snippet)

---

## A.1 — Symbol & Command Cheat Sheet

**Greek letters** — type the name; capitalize the command for the uppercase form where it differs from a Latin letter:

| Lowercase | Command | Uppercase | Command |
|---|---|---|---|
| $\alpha$ | `\alpha` | — | *(looks like Latin A)* |
| $\beta$ | `\beta` | — | *(looks like Latin B)* |
| $\gamma$ | `\gamma` | $\Gamma$ | `\Gamma` |
| $\delta$ | `\delta` | $\Delta$ | `\Delta` |
| $\epsilon$ / $\varepsilon$ | `\epsilon` / `\varepsilon` | — | *(looks like Latin E)* |
| $\theta$ | `\theta` | $\Theta$ | `\Theta` |
| $\lambda$ | `\lambda` | $\Lambda$ | `\Lambda` |
| $\mu$ | `\mu` | — | *(looks like Latin M)* |
| $\pi$ | `\pi` | $\Pi$ | `\Pi` |
| $\sigma$ | `\sigma` | $\Sigma$ | `\Sigma` |
| $\phi$ / $\varphi$ | `\phi` / `\varphi` | $\Phi$ | `\Phi` |
| $\omega$ | `\omega` | $\Omega$ | `\Omega` |

**Common math operators** — built in: `\sin`, `\cos`, `\tan`, `\log`, `\ln`, `\exp`, `\max`, `\min`, `\lim`, `\sup`, `\inf`. Need one that isn't built in (`argmin`, `rank`, `trace`, ...)? Declare it once with `\DeclareMathOperator` — full explanation and worked examples in Ch. 19.

**Accents:** `\hat{x}`, `\bar{x}`, `\dot{x}`, `\ddot{x}`, `\tilde{x}`, `\vec{x}`.

**Bold and vectors:** `\mathbf{}` bolds Latin letters only — it does *not* bold Greek letters (`\mathbf{\beta}` silently fails). Use `\bm{}` (the `bm` package) for bold Latin *and* Greek alike — full explanation in Ch. 9.

**Delimiter sizing**, smallest to largest: `\bigl(`/`\bigr)`, `\Bigl(`/`\Bigr)`, `\biggl(`/`\biggr)`, `\Biggl(`/`\Biggr)` — pick the size that matches your content instead of defaulting to auto-sizing `\left(`/`\right)` every time. Full explanation and the one-sided-delimiter variant (`\left. ... \right|`) in Ch. 10.

**Spacing in math mode:** `\,` (thin space, e.g. before a differential: `\int x \, dx`), `\!` (negative thin space, pulls things together) — Ch. 10. `\quad`/`\qquad` (fixed 1em/2em spaces, useful for separating side conditions like "$\quad x > 0$") — see A.3 below.

---

## A.2 — Table Formatting Cheat Sheet

**Rules — old style vs. the field standard:**
```latex
% dated — hand-drawn rules on every row, vertical bars
\begin{tabular}{|c|c|}
\hline
A & B \\
\hline
\end{tabular}

% field standard — booktabs, no vertical rules
\begin{tabular}{cc}
\toprule
A & B \\
\bottomrule
\end{tabular}
```
Full explanation in Ch. 6.

**Merging cells:** `\multicolumn{cols}{align}{text}` (built into LaTeX) spans columns; `\multirow{rows}{width}{text}` (needs `\usepackage{multirow}`) spans rows.
```latex
\begin{tabular}{lcc}
\toprule
\multirow{2}{*}{Sample} & \multicolumn{2}{c}{Measurement} \\
                         & Trial 1 & Trial 2 \\
\midrule
A & 10 & 12 \\
\bottomrule
\end{tabular}
```
Full explanation in Ch. 6.

**Aligned decimals:** `siunitx`'s `S` column type aligns every row's decimal point. Remember to wrap non-numeric header text in `{}`.
```latex
\begin{tabular}{l S[table-format=3.2]}
\toprule
{Sample} & {Value} \\
\midrule
A & 123.45 \\
B & 98.60  \\
\bottomrule
\end{tabular}
```
Full explanation in Ch. 6 and Ch. 9.

**Wide or oversized tables:** `sidewaystable` (from `rotating`) rotates a single float; the `landscape` environment (from `pdflscape`) rotates the whole physical page when even a rotated float isn't enough. Full explanation and examples in Ch. 6.

**Scaling a table to fit the page:** `\resizebox{\textwidth}{!}{...}` — use sparingly, since it shrinks the font along with everything else.
```latex
\resizebox{\textwidth}{!}{%
\begin{tabular}{cccccccc}
\toprule
Col1 & Col2 & Col3 & Col4 & Col5 & Col6 & Col7 & Col8 \\
\midrule
1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 \\
\bottomrule
\end{tabular}%
}
```

**Multi-row header cell hack, paired with `\arraystretch`:** nesting a small `tabular` inside a single cell wraps a long header onto two lines — reach for `multirow` first when it's a genuine data cell, and treat this as the pragmatic fallback for header labels specifically. Row height often needs loosening to match, via `\arraystretch` (full explanation in Ch. 19), scoped to just this table with an extra pair of `{ }`:
```latex
{\renewcommand{\arraystretch}{1.3}
\begin{tabular}{l @{} c}
\toprule
Sample & \begin{tabular}[c]{@{}c@{}}No. of\\detectors\end{tabular} \\
\midrule
A01 & 3 \\
\bottomrule
\end{tabular}
}
```

**Other edge-case tools:** `@{}` removes inter-column padding (used above, between `l` and the wrapped-header column); `tablefootnote` makes footnotes actually render inside a `table` float; `threeparttable` is a more formal alternative to `tablefootnote` if a table needs several notes at once. Full explanation in Ch. 6.

### `minipage` — and how it differs from `subfigure`

**Example 1 — two small tables side by side:**
```latex
\begin{minipage}{0.48\textwidth}
\centering
\begin{tabular}{lc}
\toprule
Sample & Value \\
\midrule
A & 12.5 \\
\bottomrule
\end{tabular}
\end{minipage}
\hfill
\begin{minipage}{0.48\textwidth}
\centering
\begin{tabular}{lc}
\toprule
Sample & Value \\
\midrule
B & 7.3 \\
\bottomrule
\end{tabular}
\end{minipage}
```

**Example 2 — a table next to explanatory text:**
```latex
\begin{minipage}{0.55\textwidth}
\begin{tabular}{lc}
\toprule
Sample & Value \\
\midrule
A & 12.5 \\
\bottomrule
\end{tabular}
\end{minipage}
\hfill
\begin{minipage}{0.4\textwidth}
\small
A single measurement, included here as an example
of a table sitting beside its own explanatory note.
\end{minipage}
```

**`minipage` vs. `subfigure`:** both place things side by side, but they solve different problems. `subfigure` (Ch. 7, via `subcaption`) is specifically for multiple *numbered, captioned* image panels within one `figure` — each gets its own label (`fig:sub1`, `fig:sub2`), and the pair shares an overall caption. `minipage` is a general-purpose box with no captioning system of its own — reach for it for tables, mixed table-and-text layouts, or anything side-by-side that doesn't need individual sub-numbering. If you're laying out multiple images that should each get their own "Figure 1a"/"Figure 1b" style label, use `subfigure`; for everything else side-by-side, `minipage` is the simpler tool.

---

## A.3 — Page Layout & Spacing Reference

*(New material — this is genuinely reference-only content that didn't fit any single chapter's narrative, unlike the sections above.)*

**Page geometry** — `geometry` overrides your document class's default margins:
```latex
\usepackage[margin=1in]{geometry}
% or, for individual sides:
\usepackage[left=1.5in, right=1in, top=1in, bottom=1in]{geometry}
% paper size, if you need something other than the class default:
\usepackage[a4paper, margin=1in]{geometry}
```
Set it once near the top of the preamble — it overrides most documentclass-level defaults. Useful the moment a university thesis format specifies exact margins (a common requirement this guide's authors ran into directly).

**Dimension keywords** — which one to reach for:

| Keyword | Meaning | Typical use |
|---|---|---|
| `\textwidth` | Full width of the body text on the page | Sizing a figure/table to the whole page: `\includegraphics[width=\textwidth]{...}` |
| `\linewidth` | Width of the current line — adapts to context | Inside a `minipage`, `figure`, or list, where the available width is narrower than the full page |
| `\columnwidth` | Width of a single column | Specifically in two-column layouts (Ch. 20) |

`\linewidth` is the more flexible default inside floats and lists, since it automatically adjusts; `\textwidth` stays fixed regardless of context, which occasionally causes an image to overflow a `minipage` if used there by mistake.

**Spacing commands (outside math mode):**

| Command | Effect |
|---|---|
| `\hspace{1cm}` | Fixed horizontal space |
| `\hfill` | Flexible horizontal space — pushes content to opposite edges |
| `\vspace{1cm}` | Fixed vertical space |
| `\vspace*{1cm}` | Same, but survives at the top of a page (plain `\vspace` can get silently dropped there) |
| `\vfill` | Flexible vertical space — pushes content to the top/bottom of the page |
| `\hrule` | A horizontal line (rarely needed directly — use `booktabs` for tables, Ch. 6) |
| `\quad` | Fixed 1em space — common in math mode (Ch. 9–10), occasionally used for manual text indentation |
| `\qquad` | Fixed 2em space — same use cases as `\quad`, just wider |

---

## A.4 — Common Package Reference Table

| Package | Purpose | First used | Load-order notes |
|---|---|---|---|
| `inputenc` | Declares UTF-8 source encoding (pdfLaTeX only) | Ch. 3 | None |
| `amsmath` | Core math environments (`align`, `cases`, `split`), `\dfrac`/`\tfrac` | Ch. 9 | Load before `amssymb` |
| `amssymb` | Extra math symbols, `\mathbb{}` | Ch. 19 | — |
| `bm` | Bold Greek and Latin math symbols | Ch. 9 | — |
| `siunitx` | `\SI{}{}`, aligned `S` table columns | Ch. 6, Ch. 9 | — |
| `graphicx` | `\includegraphics`, image inclusion | Ch. 3 (exercise), Ch. 7 (taught) | — |
| `setspace` | `\doublespacing`/`\onehalfspacing`/`singlespace` | Ch. 5 | — |
| `enumitem` | Custom list labels and spacing | Ch. 6 | — |
| `booktabs` | `\toprule`/`\midrule`/`\bottomrule` | Ch. 6 | — |
| `multirow` | `\multirow{}{}{}` | Ch. 6 | — |
| `rotating` | `sidewaystable` | Ch. 6 | — |
| `pdflscape` | `landscape` environment (pdfLaTeX-safe) | Ch. 6 | — |
| `tablefootnote` | Footnotes that work inside table floats | Ch. 6 | — |
| `threeparttable` | Formal multi-note table blocks | Ch. 6 (optional) | — |
| `epstopdf` | Auto-converts legacy `.eps` figures | Ch. 7 (optional) | Needs shell-escape |
| `caption` | Caption font/label-separator customization | Ch. 7 | Load alongside `subcaption` |
| `subcaption` | Subfigures (`subfigure` **package** is deprecated — don't use it) | Ch. 7 | — |
| `hyperref` | Clickable cross-references and links | Ch. 8 | Load near the **end** of the preamble |
| `cleveref` | `\cref`/`\Cref` — auto-prefixed references | Ch. 8 | Load immediately **after** `hyperref` |
| `amsthm` | `\newtheorem`, `\theoremstyle`, `proof` | Ch. 11 | — |
| `algorithm2e` | Pseudocode (`\KwIn`, `\For`, `\If`...) | Ch. 12 | Don't load alongside `algorithm`/`algorithmic` |
| `algorithm`+`algorithmic` | Alternative pseudocode package pair | Ch. 12 | Don't load alongside `algorithm2e` |
| `natbib` | `\citep`/`\citet` citation commands (BibTeX backend) | Ch. 13 | — |
| `biblatex` | `\parencite`/`\textcite`, `\printbibliography` (Biber backend) | Ch. 13 | Don't load alongside `natbib` |
| `url` | `\url{}` for clickable plain URLs | Ch. 13 | — |
| `glossaries` | Acronyms, symbols lists, `\gls` | Ch. 16 | — |
| `tikz` | Vector diagrams | Ch. 17 (elective) | — |
| `tikz-cd` | Commutative diagrams | Ch. 17 (elective) | — |
| `chemfig` | Chemical structure diagrams | Ch. 17 (elective) | — |
| `pgfplots` | Data plots from CSV/inline data | Ch. 18 | — |
| `pgfplotstable` | Reading external `.csv` files into `pgfplots` | Ch. 18 | — |
| `comment` | Hide a draft block with `\begin{comment}...\end{comment}` | Ch. 20 | — |
| `geometry` | Margins, paper size | A.3 (this appendix) | Set once, early in the preamble |

**Golden load order, restated:** most packages don't care about order, but two do — `hyperref` goes near the end of the preamble, `cleveref` immediately after it, and never load both `natbib` and `biblatex`, or both `algorithm2e` and `algorithm`/`algorithmic`, in the same document.

---

## A.5 — Compiler Comparison

| | pdfLaTeX | XeLaTeX | LuaLaTeX |
|---|---|---|---|
| **Default in this guide** | Yes | No | No |
| **Custom fonts (`fontspec`)** | Not supported | Supported | Supported |
| **Unicode source files** | Needs `inputenc` (Ch. 3) | Native | Native |
| **Compile speed** | Fastest | Slower | Slowest |
| **Journal/template compatibility** | Assumed by most packages and templates | Common for non-Latin scripts or custom typography | Common when Lua scripting is needed |

**Hard rule** (first introduced in Ch. 2): if you use the `fontspec` package to change fonts, you *must* compile with XeLaTeX or LuaLaTeX — pdfLaTeX can't process it. If you don't need custom fonts, stick with pdfLaTeX; most journals require it for submission, and most packages assume it by default.

---

## A.6 — `tikz-cd` and `chemfig` Starter Snippets

See Ch. 17's "Nuance: field-specific TikZ libraries" for both.

---

## A.7 — Quick Troubleshooting Checklist

A fast first-pass reference — Ch. 22 (once drafted) will cover diagnostics in full depth. Until then:

- **Compile fails immediately** — check the *first* red error in the log, not the last one; with "Stop on first error" enabled (Ch. 2), this is usually the very next thing Overleaf shows you.
- **`Undefined control sequence`** — a typo'd command name, or a package that defines it was never loaded.
- **`Missing $ inserted`** — a math-only character (`_`, `^`) used outside math mode, or an unclosed `$`.
- **A strange error on the line *after* where the real mistake is** — classic symptom of an unclosed brace `{` on the previous line; LaTeX doesn't notice until it hits the next command (Ch. 2).
- **`??` in place of a number** — a `\label`/`\ref`/`\cref` mismatch; check the label spelling on both ends (Ch. 8).
- **A figure or table lands pages away from where you placed it** — LaTeX's float algorithm queued it; force it to flush with `\clearpage` (Ch. 7).
- **"No citation found" / empty bibliography** — almost always a compiler/backend mismatch: BibTeX for `\bibliography{}` (`natbib`), Biber for `\printbibliography` (`biblatex`) — check Overleaf's compiler settings (Ch. 13).
- **Two packages fighting each other** — don't load `natbib` and `biblatex` together, or `algorithm2e` and `algorithm`/`algorithmic` together (Ch. 12, Ch. 13).

---

## A.8 — Starter `.bib` Files

See `supplementary_materials.md` → "Ch. 13 — Starter `.bib` Files for the 4 Capstone Topics."

---

## A.9 — `hypersetup` Snippet

Ready to paste — professional link styling instead of the default colored boxes (full explanation in Ch. 8):
```latex
\hypersetup{
  colorlinks=true,
  linkcolor=blue,
  citecolor=blue,
  filecolor=blue,
  urlcolor=blue,
}
```
For a fully print-ready PDF with no visible link styling at all, use `hidelinks` instead of the block above.

---

*End of Appendix.*
