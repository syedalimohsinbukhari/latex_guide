# Part 2: Core Typesetting (Chapters 5–8)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

\clearpage

## Chapter 5 — Text Formatting & Sectioning

Every document beyond a single page needs two things sorted out early: basic inline emphasis (bold, italic — for terms, warnings, foreign phrases) and a heading hierarchy that actually holds a long document together. Getting the second one wrong is what causes the most confusion later — a thesis with inconsistent section numbering, or a table of contents that silently drops a heading level, is almost always a symptom of never having set `tocdepth`/`secnumdepth` explicitly, or of nesting sections one level deeper than the document class expects.

This chapter covers both: `\section`/`\subsection`/`\subsubsection` for structured formatting, `\textbf`/`\textit` and friends for inline formatting, and `\tableofcontents` to generate a TOC from that structure automatically. It also covers two habits — starred (unnumbered) variants, and `setspace` for draft line-spacing — that show up constantly from here on, so it's worth having them settled before the rest of the guide starts assuming you know them.

::: objective

Format text (bold, italic), structure a document with sections/subsections, and generate a working table of contents.

:::

### Inline Formatting & Sectioning

Every document needs the same two building blocks early on: a way to emphasize individual words inline, and a heading hierarchy — `\section` down to `\subsubsection` — that `\tableofcontents` can turn into a working table of contents.

::: worked

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}

\title{Formatting \& Sectioning Basics}
\author{Your Name}

\begin{document}
    \maketitle
    \tableofcontents

    \section{Introduction}
    This is \textbf{bold} text and this is \textit{italic} text.
    You can also combine them: \textbf{\textit{bold italic}}.

    \subsection{Background}
    A subsection nested under the introduction.

    \subsubsection{Fine Detail}
    A subsubsection nested under the subsection.

\end{document}
```

::: nuance

Recompile twice if the table of contents looks empty or stale on the first try — LaTeX writes the TOC to an auxiliary file during compilation and reads it back in on the *next* compile. This is normal, not a bug.

:::

:::

### Line Breaks, Paragraphs & Non-Breaking Spaces

LaTeX treats a line break, a new paragraph, and a plain space as three separate things.
Mixing them up is what produces a paragraph with no indent, or a line that breaks in an ugly spot.

::: nuance

Three small habits worth getting right early, since you'll use all three constantly from here on:

- `\\` forces a line break without starting a new paragraph (no first-line indent) — you'll see it inside `align`/`gather` environments in later chapters.
- `\newline` behaves the same way in most contexts, but isn't universally interchangeable with `\\` — inside a `tabular` row, for instance, only `\\` works.
- A genuine new paragraph comes from a **blank line** in your source (or, equivalently, an explicit `\par`) — that's what actually gives you the indentation and spacing that "looks like" a new paragraph. `\\` alone does not do this; it only breaks the line.
- `~` inserts a non-breaking space — one LaTeX will never break a line on. Use it to keep short, related pieces of text glued together, like `Figure~5` or `Dr.~Smith`, so a line break can't land awkwardly between them. You'll use this constantly starting in Ch. 8, once `\cref`/`\ref` are introduced — `Figure~\cref{fig:...}` is the standard pairing.

:::

### Sentence-Ending Spacing

LaTeX tries to guess whether a period ends a sentence purely from the letter case right before it, and that heuristic breaks down around abbreviations and initials — worth knowing so the fix doesn't feel like a mystery the first time you need it.

::: nuance

LaTeX inserts extra space after what it assumes is the end of a sentence, and it guesses based on the character right before the period:

- A period after a **lowercase** letter is assumed to end a sentence, and gets the wider spacing by default — correct most of the time, but wrong for a lowercase abbreviation used mid-sentence, like "e.g." or "i.e.".
  Fix it with a backslash-space or `~` right after the period: `e.g.\ apples` or `e.g.~apples`.
- A period after an **uppercase** letter is assumed to be an abbreviation (an initial, or something like "NASA"), and gets the narrower spacing by default — wrong when that period genuinely ends the sentence.
  Fix it with `\@` right before the period: `NASA\@. We went...`

If you'd rather not think about this distinction at all, `\frenchspacing` in your preamble disables it entirely and uses the same spacing everywhere — a reasonable default some style guides prefer.

:::

### Starred Variants (`*`)

A pattern shows up here for the first time that recurs constantly for the rest of the guide — appending `*` to a command or environment name to turn off its automatic numbering — so it's worth learning as a general reflex rather than a one-off trick for `\section`.

::: nuance

Many LaTeX commands and environments have a **starred variant** — the same name with a `*` appended — which almost always means "the same thing, but unnumbered." The most common first encounter is an unnumbered section, useful for things like an "Acknowledgments" heading that shouldn't get a number:

```latex

\section{Introduction}      % numbered: "1  Introduction"
\section*{Acknowledgments}  % unnumbered: just "Acknowledgments"


```

A rule of thumb is, whenever you see a trailing `*` on a LaTeX command or environment, assume "same behavior, minus the automatic numbering" and check the specific case for any extra detail.

::: important

`\section*{}` also doesn't appear in the table of contents by default (since the TOC is built from numbered headings).
If you want it listed anyway, add this line right after the `\section*{}` call:

```latex

\addcontentsline{toc}{section}{Acknowledgments}
```

:::

:::

::: {.crosscheck title="The star-pattern cheat sheet"}

This same star pattern reappears throughout the guide, so it's worth recognizing on sight rather than re-learning each time:

- `equation*` (Ch. 9) — a display equation with no number.
- `align*` (Ch. 10) — multiple aligned equations, none numbered.
- `figure*`/`table*` — in two-column document classes (common in some journal templates), a float that spans both columns instead of sitting in just one.

:::

### Controlling TOC Depth & Heading Numbering

The document class quietly caps how deep the table of contents and heading numbers go, so a `\subsubsection` can look "wrong" for reasons that have nothing to do with how it was typed — two counters in the preamble are what actually control that depth.

::: nuance

By default, `\subsubsection` and `\paragraph` headings can silently disappear from the TOC, or appear unnumbered, which causes panic the first time it happens. Control both behaviors explicitly in your preamble:

```latex

\setcounter{tocdepth}{3} % include subsubsections in the TOC
\setcounter{secnumdepth}{3} % number them too
```

::: important

Heading depth in `article`:

1. `\section` = 1,
2. `\subsection` = 2,
3. `\subsubsection` = 3,
4. `\paragraph` = 4.

:::

Many universities leave `\paragraph` unnumbered by default — these two counters are how you take control of that instead of guessing why a heading looks "wrong."

:::

### Line Spacing with `setspace`

Draft and thesis formatting requirements frequently specify double or 1.5 line spacing, and hand-rolling that with `\vspace` or `\linespread` throws off table and math spacing elsewhere in the document — a dedicated package avoids the side effects.

::: nuance

Thesis offices often require double or 1.5 line spacing for draft submissions; journals usually want single spacing.
Don't reach for `\vspace` or `\linespread{2}` by hand — it distorts table and math spacing. Use the `setspace` package instead:

```latex

\documentclass{article}

\usepackage{setspace}

\begin{document}
    \doublespacing
    % ... rest of the document is now double-spaced ...

    \begin{singlespace}
        % a dense table or the abstract, 
        % kept readable even in an otherwise double-spaced document
    \end{singlespace}

\end{document}
```

::: nuance

`\onehalfspacing` and `\singlespacing` work the same way if you need those instead.

:::

::: crosscheck

Want to see the effects for yourself, with a working example, rather than just read about it?
`supplementary_materials.md` has a ready-made dense table you can paste in and toggle `singlespace` on/off around — see "Ch. 5 — Dense Table for Testing `setspace`."

:::

:::

::: exercise

1. Take your Ch. 4 capstone shell and add two more section levels (`\subsection`, `\subsubsection`) somewhere in the introduction.
2. Add `\tableofcontents` after `\maketitle` and recompile twice to see it populate.
3. Set `tocdepth`/`secnumdepth` to 3 and confirm your subsubsection now appears, numbered, in the TOC.

:::

::: capstone

- Draft real section headings for your paper (e.g. `Introduction`, `Methods`, `Results`, `Discussion`, `Conclusion`) instead of the single placeholder `\section{Introduction}` from Ch. 4.
- Decide whether your target format needs double-spacing (thesis draft) or single (journal submission), and set it with `setspace`.
- Confirm the TOC shows the depth you want.

:::

## Chapter 6 — Lists & Tables

Research writing constantly needs to present information as discrete points or structured data rather than flowing prose — a list of assumptions, a sequence of experimental steps, a table of measurements.
LaTeX handles both natively, but its *default* output for each is noticeably plain: bullets/numbers with no styling control, and tables ringed with the boxy vertical/horizontal rules typical of a spreadsheet rather than a printed page.
Neither is wrong, exactly, but neither is what you'll see in a published paper or a well-typeset thesis either.

This chapter starts from those defaults and builds up to what journals and thesis offices actually expect: customizable list labels (lettered, Roman numeral, tightly spaced), and tables built with `booktabs`'s minimal open rules and `siunitx`'s decimal-aligned numeric columns — plus fixes for the two problems wide tables run into (columns overflowing the page, and numbers that don't line up).

::: objective

Format lists and build clean, professional-looking tables — including wide tables and tables with aligned numeric data.

:::

### Lists: `itemize` & `enumerate`

LaTeX's two built-in list environments cover the two everyday cases out of the box: `itemize` for unordered/bulleted points, `enumerate` for numbered steps.

::: worked

```latex
\begin{itemize}
    \item First point
    \item Second point
    \item Third point
\end{itemize}

\begin{enumerate}
    \item Step one
    \item Step two
    \item Step three
\end{enumerate}


```

::: nuance

The `itemize` environment gives bullets; `enumerate` environment gives numbers.
Both can be nested inside each other.

:::
:::

### Customizing List Labels with `enumitem`

Default bullets and numbers cover most cases, but journal or thesis styles sometimes want something different — lettered sub-items, Roman numerals, or a tighter list in a dense layout.

::: nuance

The `enumitem` package handles all of it with one consistent syntax:

```latex

\documentclass{article}
\usepackage{enumitem}

\begin{document}

    \begin{enumerate}[label=(\alph*)]
     \item First
     \item Second
    \end{enumerate}
    % renders as (a), (b), ...

    \begin{enumerate}[label=\Roman*.]
     \item First
     \item Second
    \end{enumerate}
    % renders as I., II., ...

    \begin{itemize}[nosep, leftmargin=*]
     \item Tight, flush-left bullet
     \item No vertical space between items
    \end{itemize}

\end{document}
```
::: {.general title="Usage"}

- `label=`
    - Controls what marks each item — `\alph*`/`\Alph*` for lower/uppercase letters, `\roman*`/`\Roman*` for lower/uppercase Roman numerals, alongside the default `\arabic*`.
- `nosep`
    - Strips the vertical spacing between items, useful for a dense list inside a table cell or a tight layout.
- `leftmargin=*`
    - Flushes the list to the left margin instead of the default indent — common in some thesis styles that want lists aligned with body text.

:::

:::

### Professional Tables with `booktabs`

A plain `tabular` with `\hline` and vertical bars (`|c|c|`) technically works, but reads as dated compared to the open, rule-light tables standard in published papers — `booktabs` is the package that gets you there:

::: worked

```latex
\documentclass{article}
\usepackage{booktabs}

\begin{document}

    \begin{table}[htbp]
        \centering
        \caption{Sample thermal conductivity measurements}
        \label{tab:sample}
        \begin{tabular}{lcc}
            \toprule
            Material   & Conductivity (W/mK) & Temperature (K) \\
            \midrule
            Graphene A & 5000                & 300             \\
            Graphene B & 4200                & 350             \\
            \bottomrule
        \end{tabular}
    \end{table}

\end{document}
```

::: nuance

`booktabs` gives you `\toprule`, `\midrule`, and `\bottomrule` instead of `\hline` — no vertical rules at all, which is the field standard for professional tables.
A cheat sheet comparing the two styles is in the appendix.

:::

:::

### Multi-Row & Multi-Column Cells

A table cell sometimes needs to span more than one row or column instead of holding a single value — a group header that sits above two sub-columns ("Measurement" spanning "Trial 1" and "Trial 2"), or a sample name that applies to several data rows underneath it and shouldn't be repeated on every line. Plain `tabular` has no way to do either; two commands handle it, one column-wise and one row-wise:

::: worked

```latex

\documentclass{article}
\usepackage{multirow}

\begin{document}
    \begin{tabular}{lcc}
        \toprule
        \multirow{2}{*}{Sample}   & \multicolumn{2}{c}{Measurement}   \\
        & Trial 1 & Trial 2                 \\
        \midrule
        A                         & 10      & 12                      \\
        \bottomrule
    \end{tabular}
\end{document}
```

::: nuance

- `\multicolumn{cols}{align}{text}` is built into LaTeX already.
- `\multirow{rows}{width}{text}` (from the `multirow` package) is the one that needs an explicit `\usepackage`.

:::

:::

### Wide Tables: `sidewaystable` & `landscape`

A table with enough columns will overflow the page margins regardless of how well it's styled, and two packages fix that by rotating things 90 degrees — they differ only in *how much* they rotate.

#### `sidewaystable`

::: worked

```latex
\documentclass{article}

\usepackage{rotating}

\begin{document}
    \begin{sidewaystable}
        \centering
        \caption{A wide table of supplementary data}
        \begin{tabular}{cccccccc}
            \toprule
            ... 8 columns of data ...
            \bottomrule
        \end{tabular}
    \end{sidewaystable}
\end{document}
```

::: nuance

The one-line fix is the `rotating` package's `sidewaystable` environment — it rotates the entire table (and its caption) 90 degrees.
Great for supplementary-materials tables that just don't fit portrait orientation.

:::

:::

#### `landscape`

::: worked

```latex
\documentclass{article}
\usepackage{pdflscape}

\begin{document}
    \begin{landscape}
        \begin{table}[htbp]
            \centering
            \caption{An especially wide table, needing a full landscape page}
            \begin{tabular}{cccccccccc}
                \toprule
                ... 10 columns of data ...
                \bottomrule
            \end{tabular}
        \end{table}
    \end{landscape}
\end{document}
```

::: nuance

`sidewaystable` above rotates a single float on an otherwise-portrait page. Sometimes that's still not enough — a table wide enough that even a rotated float feels cramped, or you want a full landscape page with its own header and margins. That's a job for the `landscape` environment instead, from `lscape` (or `pdflscape` — the pdfLaTeX-safe version; use this one on Overleaf's default compiler, since it also sets the PDF's page-rotation metadata so viewers display it right-side-up).

:::

:::

::: important

1. `sidewaystable` rotates a float within an otherwise-portrait page; `landscape` rotates the physical page itself.
2. Reach for `sidewaystable` first — it's simpler and keeps everything else on the page portrait — and only switch to `landscape` when a single rotated float genuinely isn't wide enough.

:::

### Aligned Decimal Columns with `siunitx`

Numeric results (regression coefficients, experimental measurements) when laid out in a plain `c` column are not eye friendly, or eye catching, since the decimal points don't align down the column.
It also becomes hard to scan and a bit unprofessional-looking.

::: worked

```latex
\documentclass{article}
\usepackage{siunitx}

\begin{document}
    \begin{tabular}{l S[table-format=3.2]}
        \toprule
        {Sample} & {Conductivity (W/mK)} \\
        \midrule
        A        & 123.45                \\
        B        & 98.60                 \\
        \bottomrule
    \end{tabular}
\end{document}
```
::: nuance

The `siunitx` package's `S` column type fixes this — declare the decimal precision once, and every row's decimal point lines up automatically.

:::

:::

::: important

`S[table-format=3.2]` reserves 3 digits before and 2 after the decimal point, and aligns every row's decimal point vertically.
Note the curly braces around non-numeric header text (`{Sample}`, `{Conductivity...}`) — the `S` column expects numbers by default, so text needs to be explicitly wrapped.

:::

### Other Table Tricks

::: {.general title="Table cheat sheet"}

The tools below solve real, specific table problems, but aren't everyday defaults — reach for them only when you actually hit the edge case each one is for:

- **`@{}` column specifier** — removes the automatic padding LaTeX inserts between columns, for columns that should visually touch: `\begin{tabular}{l @{} c}`.
- **`\resizebox{\textwidth}{!}{...}`** (from `graphicx`, Ch. 7) — scales an entire table to fit the page width. Use sparingly: it shrinks the font along with everything else, which can make a table technically fit but practically unreadable.
- **`tablefootnote`** — a regular `\footnote` breaks inside a `table` float (it either silently disappears or lands on the wrong page); `tablefootnote` fixes that.
- **`threeparttable`** — for a table that needs *several* notes tied to the table's own width rather than the page's — a more formal notes block underneath, versus `tablefootnote`'s one quick note at a time.
- **`minipage`** — places a table next to text, or next to another small table, side by side rather than stacked.
- Row height can also be adjusted, globally or per-table, with `\arraystretch` — covered in full in Ch. 19, once `\renewcommand` has been introduced.

::: crosscheck

See `supplementary_materials.md` for a single table that puts several of these to work together — more useful to see combined than as isolated one-liners.

:::

:::

::: exercise

1. Recreate this data as a table using `booktabs`: `Sample,Value` / `A,12.5` / `B,7.3` / `C,150.25`
2. Do it twice: once with a plain `c` column, once with an `S[table-format=3.2]` column — compare how the decimals line up.
3. Bonus: wrap the same table in `sidewaystable` and observe the orientation change.
4. Reformat the `enumerate` list from the very first worked example using `enumitem`: switch it to lettered labels `(a)`, `(b)`, `(c)`, and tighten it with `nosep`.

::: nuance

When using the `S` column, wrap your column headers in curly braces, e.g. `{Value}`, so `siunitx` doesn't try to parse them as numbers and throw an "Invalid token" error.

:::

:::

::: capstone

Add a result table to your paper using the topic's own data (real or plausible placeholder numbers), with `booktabs` for the rules and `S` columns for any numeric measurements. If your table ends up especially wide or needs a footnoted value, this is also a good place to try `sidewaystable`/`landscape` or `tablefootnote` for real instead of just in the exercise.

:::

## Chapter 7 — Figures & Floats

Almost every research document needs to include images — plots, diagrams, photographs of apparatus — and LaTeX treats them as *floats*: elements the layout engine is free to place wherever it fits best on the page, rather than pinning exactly where you wrote the code. That's a deliberate design choice (it avoids ugly page breaks splitting a figure across two pages), but it's also the single most common source of "why did my figure end up three pages later than I put it" confusion for anyone coming from a word processor, where images stay exactly where you drop them.

This chapter covers `\includegraphics` and the `figure` environment for the basic case, placement specifiers and `\clearpage` for controlling *where* floats actually land, vector-vs-raster format choice, and `subcaption` for multi-panel figures — the building blocks for the labeled, cross-referenceable figures Chapter 8 will start pointing back to by number.

::: objective
Include images, caption and label them correctly, control where floats land on the page, and lay out multi-panel figures.
:::

### Including a Basic Figure with `\includegraphics`

Getting an image onto the page at all is the first hurdle — LaTeX has no native concept of an image file, so `\includegraphics` (from the `graphicx` package) is the command that bridges the gap, and wrapping it in a `figure` environment is what turns a bare image into a captioned, labeled, referenceable float.

::: worked

```latex
\documentclass{article}

\usepackage{graphicx}

\begin{document}

    \begin{figure}[htbp]
        \centering
        \includegraphics[width=0.6\textwidth]{example-image}
        \caption{A sample figure.}
        \label{fig:sample}
    \end{figure}

\end{document}
```

::: nuance

`example-image` is a built-in Overleaf/LaTeX placeholder (from the `mwe` package family) that renders without needing to upload a real file — useful while drafting before you have your actual figures ready.

:::

:::

### Float Placement Specifiers

That `[htbp]` in the figure's opening brackets looks like a fixed instruction, but LaTeX treats it as a ranked list of acceptable spots rather than a command to obey exactly — which is exactly why a figure can end up somewhere you didn't ask for.

::: important

The `[htbp]` argument is a *suggestion*, not a command:

- `h` (here),
- `t` (top of page),
- `b` (bottom),
- `p` (its own page).

LaTeX will override your preference if the figure doesn't fit — this is intentional, not a bug. Adding `!` (e.g. `[!htbp]`) tells LaTeX to relax some of its usual placement restrictions, which helps but doesn't guarantee "exactly here."
:::

### Controlling Where Floats Actually Land

Sometimes tweaking the placement letters isn't enough and a figure still queues up, drifting further from where you wrote it as body text accumulates — for that there are commands that force the issue outright instead of just suggesting.
Placement specifiers only *suggest* where a float should land — sometimes LaTeX still queues one up and drops it several pages later, once enough body text has accumulated to make room.

::: nuance

Three related commands, each doing a different amount of work:

- `\newpage`
    - Starts a new page. Doesn't touch any floats still waiting to be placed.
- `\clearpage`
    - Starts a new page *and* forces every pending float to flush and place before continuing. This is the actual fix for "my figure floated away from where I put it" — reach for it right before a section that shouldn't inherit the previous section's leftover floats.
- `\cleardoublepage`
    - The same as `\clearpage`, but also guarantees the next page is odd-numbered, inserting a blank page if needed. This only matters in two-sided (`twoside`) documents — see Ch. 20's `\frontmatter`/`\mainmatter`/`\backmatter`, which call this internally at every transition.

::: {.general title="\,"}
```latex
\section{Methods}
... several figures queued up, none placed yet ...

\clearpage
\section{Results}
% figures from the Methods section are forced to place here,
% before Results starts, instead of drifting further into the document
```
:::

::: crosscheck

See `supplementary_materials.md` for a full before/after example — a document with a genuinely stuck float, and the one-line fix.

:::

:::


### Vector vs. Raster Images

Once a figure lands where you want it, the next question is what kind of image file to feed `\includegraphics` in the first place — the format you choose decides whether it still looks crisp at print size or starts looking blurry the moment it's scaled up.

::: nuance

- **Vector** (PDF, EPS): scales to any size with no quality loss — ideal for line plots, diagrams, schematics.
- **Raster** (PNG, JPG): fixed resolution — fine for photos or screenshots, but can look blurry if scaled up.

:::

For anything you generate yourself, export as PDF whenever the source tool allows it.

### Handling Legacy `.eps` Figures

Vector is the right call in principle, but not every figure you inherit was exported in a format pdfLaTeX can actually read directly, and `.eps` files are the format most likely to turn up from older plotting tools.

::: nuance

Older figures — especially ones exported from `MATLAB` or `gnuplot` sometimes only come as `.eps` files.
It is a vector format `pdfLaTeX` can't include directly (only PDF/PNG/JPG).
If you're stuck with one and can't re-export it, `\usepackage{epstopdf}` converts it to PDF automatically at compile time:

::: {.general title="\,"}

```latex
\usepackage{epstopdf}
...
\includegraphics[width=0.6\textwidth]{old_plot.eps}
```

:::

::: important

This needs "shell escape" enabled for your compiler — if the conversion silently fails, that's usually why. The better fix, when possible, is re-exporting the figure as PDF from its source tool in the first place; treat `epstopdf` as a fallback for a figure you can't regenerate, not a habit.

:::

:::

### Multi-Panel Figures with `subcaption`

A single `\includegraphics` call handles one image, but plenty of results are best shown as several related panels side by side under one shared caption — that's a layout plain `figure` can't do alone, and `subcaption` is the package built for it.

::: worked

```latex
\documentclass{article}
\usepackage{subcaption}

\begin{document}
    \begin{figure}[htbp]
        \centering
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[width=\linewidth]{example-image-a}
            \caption{First panel}
            \label{fig:sub1}
        \end{subfigure}
        \hfill
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[width=\linewidth]{example-image-b}
            \caption{Second panel}
            \label{fig:sub2}
        \end{subfigure}
        \caption{Two panels side by side.}
        \label{fig:combined}
    \end{figure}

\end{document}
```

::: nuance

Each `subfigure` gets its own caption/label (`fig:sub1`, `fig:sub2`); the outer `figure` gets an overall caption/label (`fig:combined`) for referring to the pair as a whole.

:::

:::


::: nuance

The `caption` package (load it alongside `subcaption` above, which already depends on it) lets you adjust how every caption in the document looks — font size, and the separator between "Figure 1" and the caption text:

::: {.general title="\,"}

```latex
\usepackage{caption}
...
\captionsetup{font=small, labelsep=colon}
% "Figure 1: A sample figure." instead of the default 
% "Figure 1  A sample figure."
```

:::

:::

Set this once in the preamble to apply it document-wide, or scope it locally by wrapping it and the figure together in an extra pair of `{ }` — the same scoping trick Ch. 19 uses for `\renewcommand{\arraystretch}`.

::: important

The `subfigure` is deprecated.
`subcaption`, which this chapter uses throughout, is its modern replacement; if you see `\usepackage{subfigure}` in an old template or forum answer, swap it for `subcaption` instead.

:::

::: exercise

1. Build a 2×2 subfigure grid: extend the example above to four subfigures, arranged two per row. To force the third and fourth subfigures onto a new row, insert `\par` (or `\\`) right after the second `\end{subfigure}`, before starting the third `\begin{subfigure}` — then repeat the two-subfigure pattern for the bottom row. Just pressing Enter/leaving a blank line is **not** enough: LaTeX treats a newline as an ordinary space, not a line break, so without `\par`/`\\` your third subfigure will just sit awkwardly next to the second.
2. Deliberately create a stuck float:
    - Add three or four figures in a row with no body text between them, followed by a new `\section`. Recompile and note where they actually land — then add `\clearpage` right before the new section and recompile again to see the difference.

:::

::: capstone

Insert a placeholder figure into your paper (using `example-image` is fine for now) with a proper caption and label — this is what Ch. 8 will cross-reference. If you've got more than one figure queued up by the time you assemble the full paper, use `\clearpage` to make sure they land where you intend rather than drifting into the next section.

:::

## Chapter 8 — Cross-Referencing, Labels & Hyperlinks

Every figure, table, and section you've labeled so far (`fig:sample`, `tab:sample`, and so on, from Chapters 6–7) has been sitting unused — a `\label` on its own does nothing until something else points back to it with `\ref`. Manually typing "see Figure 3" is exactly the kind of thing that goes stale the moment you insert a new figure earlier in the document and every number after it shifts by one; automatic cross-referencing exists specifically so that renumbering is the compiler's problem, not yours.

This chapter covers `\ref`/`\cref` for that automatic numbering (including why `cleveref`'s load order relative to `hyperref` matters), the labeling-prefix convention (`fig:`, `tab:`, `sec:`, ...) used consistently throughout the rest of the guide, and `\hypersetup` for turning `hyperref`'s default loud link-boxes into the quiet colored-text links expected in a submitted PDF.

::: objective

Reference figures, tables, and sections by number automatically (so they never go stale), and set up hyperlinks that look professional instead of like a default web browser's blue-boxed mess.

:::

### Automatic Numbering with `\ref` and `\cref`

A `\label` is inert on its own.
It only becomes useful once something points back to it by number, and that's what the reference commands are for.
`cleveref`'s `\cref`/`\Cref` build on plain `\ref` by also supplying the right noun ("Figure", "Table", "Section") automatically, so renumbering — or retyping the wrong word — is never something you do by hand.

::: worked
```latex
\documentclass{article}
\usepackage{hyperref}
\usepackage{cleveref}

\begin{document}
    As shown in \cref{fig:sample} and \cref{tab:sample}.
    The results support the hypothesis.
    See \Cref{tab:sample} at the start of a sentence (capitalized).
\end{document}

```

::: important

- `\ref{fig:sample}` gives you just the number,
- `\cref{fig:sample}` (from `cleveref`) gives you the number *and* automatically prepends "Figure"/"Table"/"Section" as appropriate — one less thing to hand-type and get out of sync.
- `\Cref` capitalizes it for sentence starts.

:::

:::

::: important

Load `hyperref` near the very end of your preamble, and load `cleveref` immediately *after* `hyperref`.
Getting this backwards (loading `cleveref` before `hyperref`) is a classic source of broken or missing links — package load order matters more in LaTeX than in most other languages you may have used.

:::

### Styling Hyperlinks with `\hypersetup`

`hyperref` makes every cross-reference, citation, and URL clickable, but its out-of-the-box styling — thick colored boxes around every single link — reads like a rough draft rather than a submission-ready PDF. A single `\hypersetup` call swaps that for quiet, professional-looking links instead.

::: nuance
By default, `hyperref` draws loud colored boxes around every link and citation — fine on screen, unprofessional in a printed or submitted PDF. Set this up properly instead:

::: important
```latex
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    citecolor=blue,
    filecolor=blue,
    urlcolor=blue,
}
```
:::

`colorlinks=true` colors the link *text* rather than boxing it.
For a fully print-ready PDF with no visible link styling at all, use `hidelinks` instead.

:::

::: {.general title="Forward Note"}

`\eqref` for equation cross-references is coming in Ch. 9 once equations are introduced — the same `\label`/`\ref` mechanics apply.

:::

### The Labeling-Prefix Convention

Naming every `\label` consistently can look like a cosmetic habit, but in a document with hundreds of labels spread across a dozen chapters, it's what keeps a reference like `\label{intro}` from meaning three different things and colliding with itself.

::: nuance

Every `\label` in this guide so far has used a prefix — `fig:`, `tab:`, and so on — without ever naming the convention directly. Worth making explicit now that cross-referencing is the whole point of this chapter:

::: important

| Prefix       | For                  |
|--------------|----------------------|
| `fig:`       | Figures              |
| `tab:`       | Tables               |
| `eq:`        | Equations (Ch. 9)    |
| `sec:`/`ch:` | Sections/chapters    |
| `thm:`       | Theorems (Ch. 11)    |
| `alg:`       | Algorithms (Ch. 12)  |
| `def:`       | Definitions (Ch. 11) |

:::

:::

::: {.general title="What the prefix actually does/doesn't do"}

`cleveref` does *not* read the prefix text to decide whether to print "Figure" or "Table."
It determines that from the *counter* that was stepped when `\label` was called.
A `\caption` inside a `figure` steps the `figure` counter, a `\section` steps the `section` counter, and so on, via `\refstepcounter` working behind the scenes.

::: important

The prefix is a discipline **for you, the author**.
It prevents name collisions (`\label{intro}` could be a section, a figure, or a theorem in a 23-chapter document) and makes every `\ref`/`\cref` call in your source instantly scannable, without needing to jump to the label to know what it points to.

:::

:::

::: exercise

1. Take a document with a labeled figure and table where one `\label` and its matching `\ref`/`\cref` have been deliberately mistyped (e.g. `\label{fig:sampl}` vs `\cref{fig:sample}`). Recompile, note the `??` that appears in place of the number, and fix the mismatch.
2. Add the `\hypersetup` block above and recompile. Compare the look of your links before and after.
3. Bonus: audit the labels in your capstone paper so far. Confirm every one uses a consistent prefix (`fig:`, `tab:`, `sec:`, etc.), and fix any that don't.

:::

::: capstone

Cross-reference the result table (Ch. 6) and figure (Ch. 7) from your paper's body text using `\cref`, and apply the `colorlinks` setup so your capstone PDF looks presentation-ready rather than default-browser-blue.

:::
