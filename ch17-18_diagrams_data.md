# Part 6: Diagrams & Data Visualization (Chapters 17–18)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

---

## Chapter 17 — Diagrams: Vector Graphics Workflow & TikZ (Elective)

::: objective

Get a diagram into your paper the way most researchers actually do it, and know when — if ever — TikZ is worth reaching for instead.

:::

### The primary path: draw elsewhere, export as vector PDF
For most research diagrams — flowcharts, block diagrams, schematics, conceptual figures — the fastest and most reliable path is:
1. Draw the diagram in PowerPoint, Google Slides, Inkscape, or any tool you're already comfortable with.
2. Export/save it as a **PDF** (vector format) — not PNG or JPG. PowerPoint: File → Export → PDF. Inkscape: File → Export As → PDF.
3. Include it exactly like any other figure from Ch. 7:

::: worked

**including the exported PDF like any other figure**

```latex
\usepackage{graphicx}
...
\begin{figure}[htbp]
\centering
\includegraphics[width=0.7\textwidth]{my-diagram.pdf}
\caption{Overview of the experimental setup.}
\label{fig:setup}
\end{figure}
```

:::

This is what roughly 90% of researchers actually do, and it's a completely legitimate, professional-quality workflow — a vector PDF from PowerPoint or Inkscape scales cleanly and looks identical to a hand-coded diagram once it's sitting in your paper.

::: nuance

**PowerPoint's PDF export can leave a white margin**

PowerPoint's PDF export often includes extra white space around your diagram — the exported PDF is slide-shaped, not diagram-shaped, so `\includegraphics` renders a mostly-empty page instead of a tight crop. Two fixes:

- **In PowerPoint:** File → Export → Create PDF/XPS, then check the "Minimum size" option before saving. Inkscape's PDF export crops to content by default and usually doesn't have this problem.
- **In LaTeX, after the fact:** crop it yourself with `graphicx`'s `trim`/`clip`:
  ```latex
  \includegraphics[trim=1cm 1cm 1cm 1cm, clip, width=0.7\textwidth]{my-diagram.pdf}
  ```
  The four `trim` values are left/bottom/right/top margins to cut away, in that order.

:::

::: nuance

**TikZ is powerful, but it's elective**

TikZ (via the `tikz` package) draws diagrams directly in LaTeX code — precise, version-controlled, and automatically matched to your document's fonts. It's also notoriously steep to learn, and can slow compilation noticeably on complex diagrams. **This guide flags it as elective**: nothing later depends on it, and choosing PowerPoint/Inkscape instead is not a lesser approach. Only invest the time in TikZ if you specifically want diagrams generated from code — for reproducibility, or a diagram that needs to update automatically alongside changing data.

:::

::: worked

**a minimal TikZ diagram**

```latex
\usepackage{tikz}
...
\begin{figure}[htbp]
\centering
\begin{tikzpicture}
  \node[draw, rectangle] (a) at (0,0) {Input};
  \node[draw, rectangle] (b) at (3,0) {Process};
  \node[draw, rectangle] (c) at (6,0) {Output};
  \draw[->] (a) -- (b);
  \draw[->] (b) -- (c);
\end{tikzpicture}
\caption{A minimal three-stage pipeline.}
\label{fig:pipeline}
\end{figure}
```
`\node[draw, rectangle] (a) at (x,y) {text}` places a labeled box at coordinates `(x,y)` and names it `a` for later reference. `\draw[->] (a) -- (b)` draws an arrow between two named nodes. Coordinates are in the document's default unit (roughly centimeters) unless you specify otherwise.

:::

::: nuance

**`(0,0)` isn't fixed at the center of the picture**

`(0,0)` is just your coordinate origin — positive x goes right, positive y goes up — not a fixed "center" of the final image. TikZ automatically sizes the picture's bounding box to fit whatever you draw, so where `(0,0)` ends up visually depends entirely on the other coordinates you use. If all your nodes happen to sit at positive coordinates, `(0,0)` will appear near a corner, not the middle — nothing to fix, just don't expect centering that isn't actually happening.

:::

::: nuance

**field-specific TikZ libraries**

If TikZ is worth learning for your field specifically, two extensions handle domain-specific diagrams far more concisely than raw `tikzpicture`:

- **`tikz-cd`** — for commutative diagrams (common in pure math, category theory):
  ```latex
  \usepackage{tikz-cd}
  ...
  \begin{tikzcd}
  A \arrow[r] \arrow[d] & B \arrow[d] \\
  C \arrow[r]           & D
  \end{tikzcd}
  ```

- **`chemfig`** — for chemical structure diagrams:
  ```latex
  \usepackage{chemfig}
  ...
  \chemfig{H-C(-[2]H)(-[6]H)-H}
  ```

:::

::: exercise

Pick one simple diagram (3-5 boxes/arrows is plenty) and reproduce it two ways: once as an exported vector PDF from PowerPoint/Inkscape, once as a minimal TikZ picture. Compare how long each approach actually took — that comparison is the whole point of the "elective" framing above. *(If you want to see how far TikZ can scale before you decide whether it's worth it for you, `supplementary_materials.md` has a fully-commented, more complex example — "Ch. 17 — Full Working Example: Neural Network Architecture Diagram.")*

:::

::: capstone

Add one diagram to your capstone paper — a system overview, experimental setup, or conceptual figure — using whichever method (imported PDF or TikZ) fits your comfort level and time budget.

:::

---

## Chapter 18 — Plotting Data with PGFPlots

::: objective

Plot real data — line plots, scatter plots, error bars — directly from LaTeX, so your figures automatically share fonts and styling with the rest of your paper.

:::

::: worked

**a simple line plot**

```latex
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}
...
\begin{figure}[htbp]
\centering
\begin{tikzpicture}
\begin{axis}[
  xlabel={Time (s)},
  ylabel={Temperature (K)},
]
\addplot coordinates {
  (0, 300) (1, 310) (2, 325) (3, 335) (4, 340)
};
\end{axis}
\end{tikzpicture}
\caption{Temperature rise over time.}
\label{fig:temp-plot}
\end{figure}
```
`pgfplots` is built on TikZ, so it shares the same `tikzpicture` wrapper. `\pgfplotsset{compat=1.18}` locks in a specific version of pgfplots' default behavior — always set this, since defaults have shifted across versions and an unset `compat` can make your plot look subtly different depending on which TeX Live version compiles it. The `axis` environment auto-generates axes, tick marks, and labels; `\addplot coordinates {...}` supplies the data points directly.

:::

::: nuance

**importing from an external `.csv` instead of typing data by hand**

Typing data points inline doesn't scale past a handful of values. For a real dataset, import it directly:
```latex
\usepackage{pgfplotstable}
...
\begin{axis}[xlabel={Time (s)}, ylabel={Temperature (K)}]
\addplot table[x=time, y=temp, col sep=comma] {data.csv};
\end{axis}
```
where `data.csv` has a header row (`time,temp`) followed by your rows of numbers. `col sep=comma` tells pgfplots the file is comma-separated — use `col sep=tab` instead for tab-separated data. *(A ready-made copy of exactly this dataset, as an actual `.csv` file, is in the guide's supplementary materials — see `ch18_sample_data.csv` — so you can test this without building your own file first.)*

:::

::: nuance

**two ways this silently goes wrong**

- **Wrong file path.** The `.csv` path is relative to your main `.tex` file's location, not to where you happen to be looking in Overleaf's file browser. If your data file is in a subfolder (e.g. `data/experiment.csv`), you must include that folder in the path: `{data/experiment.csv}`. Get the path wrong and the compiler either errors on a missing file or — depending on your LaTeX distribution — just renders an empty axis with no visible warning.
- **Column name mismatch.** `x=time, y=temp` must match your CSV's header row *exactly*, including capitalization and spacing. `x=Time` when your header says `time` (lowercase) won't silently fall back to the right column — it fails to find that column, and the plot comes out empty or pgfplots reports it can't find a column by that name. If your plot looks blank, check the header spelling before assuming the data itself is wrong.

:::

::: worked

**scatter plot with a legend**

```latex
\begin{axis}[
  xlabel={Concentration (mM)},
  ylabel={Reaction Rate},
  legend pos=north west,
]
\addplot[only marks, mark=*] coordinates {(1,2.1) (2,3.8) (3,5.2) (4,6.9)};
\addlegendentry{Trial 1}
\addplot[only marks, mark=square*] coordinates {(1,1.9) (2,3.5) (3,5.0) (4,6.5)};
\addlegendentry{Trial 2}
\end{axis}
```
`only marks` (instead of the default connected line) produces a scatter plot; `mark=*`/`mark=square*` distinguish the two series visually; `\addlegendentry{}` labels each series in the legend, matched to the `\addplot` calls in the same order they appear.

:::

::: worked

**error bars**

```latex
\addplot+[
  error bars/.cd,
  y dir=both,
  y explicit,
]
coordinates {
  (1, 2.1) +- (0, 0.2)
  (2, 3.8) +- (0, 0.3)
  (3, 5.2) +- (0, 0.25)
};
```
`error bars/.cd, y dir=both, y explicit` turns on vertical error bars in both directions; each coordinate's `+- (x-error, y-error)` supplies the bar size for that specific point.

:::

::: exercise

Plot a small dataset (5-8 points) of your own choosing with `pgfplots`, including error bars on at least 3 points and a legend if you have more than one data series. *(No dataset handy? `ch18_sample_data.csv` in the supplementary materials has 8 points with an uncertainty column ready to plot — see "Ch. 18 — Full Working Example" for a complete document using it.)*

:::

::: capstone

Add a data plot to your capstone paper's results section — real data if you have it, plausible placeholder numbers otherwise — with axis labels, a legend if applicable, and error bars if your data has associated uncertainty.

:::

---

*End of Part 6 (Ch. 17–18). Next: Part 7 — Macros & Templates (Ch. 19–20).*
