# Part 7: Macros & Templates (Chapters 19–20)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

---

## Chapter 19 — Custom Commands & Preamble Management

::: objective

Define reusable macros for notation you type repeatedly, and avoid the most common way custom commands silently break or collide.

:::

::: worked

**`\newcommand` basics**

```latex
\usepackage{amssymb}  % for \mathbb — separate from amsmath, load both
...
\newcommand{\R}{\mathbb{R}}
\newcommand{\norm}[1]{\lVert #1 \rVert}

...

For any $x \in \R$, $\norm{x} \geq 0$.
```
`\newcommand{\name}{replacement}` defines a zero-argument macro. `\newcommand{\name}[1]{replacement using #1}` defines one that takes an argument — `#1` stands in for whatever you pass in braces when you call it (`\norm{x}` expands to `\lVert x \rVert`). `\lVert`/`\rVert` come from `amsmath` (already loaded from Ch. 9); `\mathbb{}` specifically needs `amssymb`, a separate package worth loading alongside it.

:::

::: worked

**multiple arguments**

```latex
\newcommand{\deriv}[2]{\frac{d#1}{d#2}}
...
$\deriv{y}{x}$   % renders as a dy/dx fraction

\newcommand{\vect}[1]{\bm{#1}}   % wraps the bm package from Ch. 9
...
$\vect{v}$   % bold v, without retyping \bm{} every time
```
Macros can take multiple arguments (`#1`, `#2`, ... up to `#9`), and can wrap commands you've already learned so you don't have to remember the underlying syntax every time you need it.

:::

::: nuance

**an optional argument with a default value**

`\newcommand` can also define a macro with **one optional argument** (with a default value you specify) followed by any number of required arguments:
```latex
\newcommand{\deriv}[3][x]{\frac{d#2}{d#1^{#3}}}

\deriv{y}{2}     % no optional argument supplied -> defaults to x -> dy/dx^2
\deriv[t]{y}{3}  % optional argument supplied as t -> dy/dt^3
```
The syntax is `\newcommand{\name}[n][default]{...}`, where `n` is the *total* number of arguments including the optional one, and `default` is what `#1` becomes if you don't supply it in square brackets at call time. `#1` always refers to the optional argument; `#2`, `#3`, ... are the required ones. This is less commonly needed than the plain multi-argument form above, but useful once you're building a small library of your own macros — for something like a derivative command where the variable is almost always `x`, but occasionally needs to be something else.

:::

::: nuance

**macros can reuse other macros you've already defined**

A `\newcommand` definition can reference another macro you've already defined, letting you build more specific notation on top of general notation instead of repeating yourself:
```latex
\newcommand{\R}{\mathbb{R}}
\newcommand{\Rn}{\R^n}   % reuses \R from above
...
A vector in $\Rn$ has $n$ real-valued components.
```
`\Rn` expands to `\mathbb{R}^n` by way of `\R` — if you ever redefine `\R` itself, `\Rn` updates automatically along with it, the same "fix it in one place" benefit Ch. 16 highlighted for `\gls`.

:::

::: nuance

**name clashes with package-defined commands**

If you `\newcommand{\R}{...}` and later load a package that already defines `\R` (some do), you'll get a `Command \R already defined` error. Two ways to handle it:

- Rename your macro to something more specific (`\Real` instead of `\R`).
- Use `\renewcommand{\R}{...}` instead — this overrides an existing definition rather than erroring on the clash, but only do this deliberately, since it also silently changes that command's behavior everywhere else in your document, including anywhere a package was relying on its original meaning.

:::

::: nuance

**`\renewcommand` for adjusting built-in package settings — `\arraystretch`**

`\renewcommand` isn't only for overriding your own macros on a name clash — it's also the standard way to adjust settings that packages expose as commands rather than options. The most common example, useful directly with the tables from Ch. 6: LaTeX's default table rows sit close together, which can look cramped with tall content (multi-line cells, larger fonts). Loosen it with:
```latex
{\renewcommand{\arraystretch}{1.5}
\begin{tabular}{lcc}
\toprule
Sample & Trial 1 & Trial 2 \\
\midrule
A & 10 & 12 \\
\bottomrule
\end{tabular}
}
```
Wrapping the `\renewcommand` and the table together in an extra pair of `{ }` scopes the change to just that table, instead of stretching every table row for the rest of the document. `1.5` is a common value (1.5× the default row height) — adjust to taste.

:::

::: nuance

**`\DeclareMathOperator` for custom math operators**

Typing "argmin" or "rank" directly in math mode renders it in italics, as if it were several multiplied variables ($a$ times $r$ times $g$...) instead of a single operator name — the same issue Ch. 10 covered for the word "if" inside `cases`. Fix it once, for good, with `\DeclareMathOperator` (from `amsmath`):
```latex
\DeclareMathOperator{\argmin}{arg\,min}
\DeclareMathOperator{\rank}{rank}
...
$\hat{\theta} = \argmin_{\theta} \, \mathcal{L}(\theta)$
$\rank(A) = 3$
```
Once declared, `\argmin` and `\rank` behave exactly like built-in operators such as `\sin` or `\max` — upright text, correct spacing, and subscripts/limits positioned properly underneath. If you need both `\argmin` and `\argmax`, declare both separately — neither is built into LaTeX, but once declared, both behave identically to the built-in operators.

:::

::: exercise

Define 3 macros for notation you use repeatedly in your own field: at least one plain text-replacement macro (like `\R` for a set), one that takes an argument (like `\norm{}` or `\deriv{}{}`), and one custom operator via `\DeclareMathOperator`. Optional: try an argument with a default value, or a macro that reuses one you've already defined.

:::

::: capstone

Find at least one expression you've typed more than twice in your capstone paper and replace it with a macro. If your field uses a named operator not built into LaTeX (argmin, rank, softmax, trace, etc.), declare it properly with `\DeclareMathOperator` instead of leaving it in italics.

:::

---

## Chapter 20 — Thesis/Paper Templates, Multi-file Projects & Appendices

::: objective

Split a long document into manageable per-chapter files, adopt a proper thesis or journal template instead of assembling one from scratch, assemble correct front/back matter, add a correctly-numbered appendix, and switch to two-column layout when a template requires it.

:::

::: worked

**splitting a document with `\input`**

```latex
% main.tex
\documentclass{report}
\begin{document}

\input{chapters/introduction}
\input{chapters/methods}
\input{chapters/results}

\end{document}
```
```latex
% chapters/introduction.tex
\chapter{Introduction}
This chapter introduces the problem...
```
`\input{filename}` (no `.tex` extension needed) pulls that file's content in at exactly that point, as if you'd pasted it there directly — nothing special happens around it.

:::

::: nuance

**a separate preamble file is a good convention, not a requirement**

`\input` isn't only for splitting up the body — the same mechanism works for the preamble. Once you've accumulated a dozen `\usepackage` lines and a handful of `\newcommand`/`\DeclareMathOperator` definitions from Ch. 19, it's a common (optional) convention to move all of that into its own file:
```latex
% main.tex
\documentclass{article}
\input{preamble}

\begin{document}
\input{chapters/introduction}
...
\end{document}
```
```latex
% preamble.tex
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{bm}
...
\newcommand{\R}{\mathbb{R}}
\DeclareMathOperator{\argmin}{arg\,min}
...
```
Nothing about this is required — a single-file preamble works fine for a short paper. It earns its keep once your document (or your set of macros) grows large enough that scrolling past all of it just to get to the actual content becomes annoying, or when you're reusing the same preamble across multiple documents (a thesis and its related papers, for instance).

:::

::: nuance

**`\input` vs. `\include`**

`\include{filename}` does the same basic job, but with two differences that matter on long documents:

- It forces a page break before and after the included content.
- Combined with `\includeonly{chapters/results}` in the preamble, it lets you recompile *just* the listed files while treating the others as already compiled — much faster than recompiling an entire 100-page thesis every time you tweak one chapter.

`\input` has neither behavior — no forced page breaks, no partial-recompilation support. For a short document this doesn't matter; for a full thesis, `\include`/`\includeonly` can turn a two-minute compile into a two-second one while you're actively editing a single chapter.

:::

::: worked

**using a university/journal template**

Most universities and journals distribute an official `.cls` file (often as a ready-made Overleaf template project) rather than expecting you to assemble margins, fonts, and front matter yourself:
```latex
\documentclass{ourthesis}   % provided by your university, not a built-in class
\usepackage{...}            % any extra packages the template doesn't already load

\begin{document}
\input{frontmatter}
\input{chapters/introduction}
...
\end{document}
```
Don't fight the template's existing formatting decisions (margins, spacing, front-matter order) — if a required section looks "wrong," the template usually already provides the correct command for it. Check the template's own documentation/comments before overriding anything with the tools from Ch. 5–8.

:::

::: worked

**front matter, main matter, and back matter (`book` class)**

```latex
\documentclass[12pt]{book}
\usepackage{...}

\begin{document}

\frontmatter
\title{A Study of Something Interesting}
\author{Your Name}
\maketitle
\thispagestyle{empty}

\tableofcontents
\listoffigures
\listoftables

\mainmatter
\input{chapters/introduction}
\input{chapters/methods}
...

\appendix
\input{chapters/derivations}

\backmatter
\bibliography{mybib}

\end{document}
```
`\frontmatter`, `\mainmatter`, and `\backmatter` are `book`-class-specific commands — unlike `\appendix` below, which works the same way in `article`, `report`, and `book`, these three only exist in `book` (and classes built on it). They structure a document into its three natural zones and handle two things automatically: `\frontmatter` switches to roman-numeral page numbers and unnumbered chapters, fitting for a title page, table of contents, and preface; `\mainmatter` switches back to arabic numerals restarting at 1, and chapters resume being numbered; `\backmatter` keeps arabic numbering but switches chapters back to unnumbered — the conventional place for a bibliography or index. All three also handle the page-parity cleanup (`\cleardoublepage`, see Ch. 7) needed for a clean transition between zones in two-sided documents.

`\thispagestyle{empty}` right after `\maketitle` suppresses the header/footer/page number for just that one page (the title page) — as opposed to `\pagestyle{...}`, which would change the style for the rest of the document. `\tableofcontents`, `\listoffigures`, and `\listoftables` each generate their listing automatically from every `\caption`/`\section`/`\chapter` already in the document — same as any cross-referencing (Ch. 8), they need a second compile pass to populate correctly.

Where `\appendix` fits relative to all this: the conventional order is `\frontmatter` → `\mainmatter` → numbered chapters → `\appendix` → lettered appendix chapters → `\backmatter` → unnumbered back matter. `\appendix` doesn't touch page numbering or which "matter" you're in — it only affects chapter/section numbering, layered on top of whichever zone you're currently in.

:::

::: nuance

**the same structure without `book` class**

`article` and `report` — including many university thesis classes built on `report`, not `book` — don't define `\frontmatter`/`\mainmatter`/`\backmatter` at all; check your specific class before assuming they exist. Without them, build the same front-matter behavior by hand:
```latex
\documentclass{report}
...
\begin{document}

\pagenumbering{roman}
\maketitle
\thispagestyle{empty}
\tableofcontents
\listoffigures
\listoftables

\pagenumbering{arabic}   % also resets the page counter to 1 — no separate \setcounter needed
\chapter{Introduction}
...

\end{document}
```
There's no manual equivalent for the numbered-vs-unnumbered chapter switching `\frontmatter`/`\mainmatter`/`\backmatter` handle automatically in `book` — in `report`/`article`, every `\chapter`/`\section` is numbered by default regardless of where it falls, `\appendix` aside.

:::

::: worked

**appendices**

```latex
\appendix

\chapter{Additional Derivations}   % report/book classes
\label{app:derivations}
...
```
```latex
\appendix

\section{Additional Derivations}   % article class (no \chapter available)
\label{app:derivations}
...
```
`\appendix` is a single command, called once, that resets the relevant counter and switches everything after it to letter-based numbering — "Appendix A," "Appendix B," instead of continuing the numeric sequence from the main body. This works the same way in `article`, `report`, and `book` alike; you don't need to manually touch `\thesection` yourself in any of the standard classes, since `\appendix` already handles that internally. The only time you'd add something like `\renewcommand{\thesection}{\Alph{section}}` by hand is with a custom class (e.g. a university thesis `.cls`) that doesn't define `\appendix` the standard way, or if you specifically want different numbering (Roman numerals instead of letters, for instance). In a `book`-class document, `\appendix` sits between `\mainmatter` and `\backmatter` — see the front/back-matter example above.

:::

::: nuance

**two-column layouts and spanning floats**

Some journal templates require the body — or parts of it — in two-column format:
```latex
\documentclass[twocolumn]{article}
```
or switch mid-document, if only one section needs it:
```latex
\onecolumn
... single-column content, e.g. a title page or abstract ...
\twocolumn
... two-column content resumes ...
```
**Nuance:** `\twocolumn` (and `\onecolumn`) force a page break when they execute — the layout doesn't wrap mid-paragraph, it jumps to a fresh page. Use `\twocolumn`/`\onecolumn` at a natural section boundary, not mid-paragraph, or the page break will land somewhere unexpected. If the switch happens inside a float-heavy section, pair it with `\clearpage` (Ch. 7) beforehand to flush pending floats first — otherwise a float queued for one-column placement can end up trying to place itself across the layout boundary.

A regular `figure`/`table` in two-column mode is constrained to a single column's width — too narrow for a wide diagram or data table. The starred variants, first mentioned as a forward pointer in Ch. 5's star-convention nuance, solve this:
```latex
\begin{figure*}[t]
\centering
\includegraphics[width=\textwidth]{wide_diagram}
\caption{A figure spanning both columns.}
\label{fig:wide}
\end{figure*}
```
`figure*`/`table*` span the full text width instead of one column. One placement restriction worth knowing: spanning floats are reliable only with top-of-page (`[t]`) or a dedicated float page (`[p]`) — LaTeX can't slot a full-width object "here" in the middle of a single narrow column, so `h`/`b` are effectively ignored for starred floats in standard document classes.

:::

::: nuance

**hiding a draft section with the `comment` package**

Commenting out a large block by putting `%` at the start of every line doesn't scale. If you want to temporarily exclude a whole section that isn't ready for review, wrap it instead:
```latex
\usepackage{comment}
...
\begin{comment}
\section{Draft: Not Ready Yet}
This entire section is hidden from the compiled PDF until the
\texttt{comment} block around it is removed.
\end{comment}
```
Nothing between `\begin{comment}` and `\end{comment}` is processed at all — useful for parking an unfinished section without deleting it or fighting with dozens of `%` symbols.

:::

::: exercise

1. Split a short document into 2-3 chapter files using `\input`.
2. Build a front-matter block: a title page with `\thispagestyle{empty}`, a `\tableofcontents`, and at least one of `\listoffigures`/`\listoftables` — using `\frontmatter`/`\mainmatter` if you're in `book` class, or `\pagenumbering{roman}`/`\pagenumbering{arabic}` by hand otherwise.
3. Add an appendix with at least one entry, using `\appendix` followed by `\chapter{}` (report/book) or `\section{}` (article).
4. Wrap one section in `\begin{comment}...\end{comment}` and confirm it disappears from the compiled PDF, then remove the wrapper and confirm it reappears.
5. Optional, if your field's journal template uses two columns: try `\documentclass[twocolumn]{article}` and place one `figure*` that spans both columns.

:::

::: capstone

Migrate your capstone paper into a proper multi-file structure (even if it's just 2-3 `\input` files), assemble a real front-matter block (title page, table of contents, list of figures/tables — with page numbering handled correctly for your document class), add an appendix for any supplementary derivations or data, and use `comment` to park any section that isn't ready for review yet.

:::

---

*End of Part 7 (Ch. 19–20). Next: Part 8 — Collaboration & Diagnostics (Ch. 21–22).*
