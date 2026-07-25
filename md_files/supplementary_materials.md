# Supplementary Materials

Companion assets referenced from the main chapter files — sample data, larger snippets, and anything too bulky to sit inline in a chapter without breaking its flow. Each entry is tagged with the chapter it supports.

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

---

## Ch. 5 — Dense Table for Testing `setspace`

Ch. 5 explains `\doublespacing`, `\onehalfspacing`, `\singlespacing`, and wrapping a section in `singlespace` — but there's nothing dense enough in that chapter to actually *see* the effect on. Paste the snippet below into your capstone project (or a scratch file) and toggle the `singlespace` wrapper on/off around the table to compare.

```latex
\documentclass{article}
\usepackage{setspace}

\begin{document}
\doublespacing

\section{Testing Line Spacing}
This paragraph is double-spaced by default, as set by \verb|\doublespacing|
above. Notice the extra vertical space between these lines compared to
normal single-spaced text.

\begin{singlespace}
\begin{table}[htbp]
\centering
\caption{Sample dense dataset for spacing comparison}
\label{tab:dense-demo}
\begin{tabular}{lccccc}
\hline
Sample & Trial 1 & Trial 2 & Trial 3 & Trial 4 & Mean \\
\hline
A01 & 12.3 & 11.8 & 12.5 & 12.1 & 12.18 \\
A02 & 15.6 & 15.2 & 15.9 & 15.4 & 15.53 \\
A03 & 9.8  & 10.1 & 9.6  & 9.9  & 9.85  \\
A04 & 22.1 & 21.8 & 22.4 & 22.0 & 22.08 \\
A05 & 18.4 & 18.0 & 18.7 & 18.3 & 18.35 \\
A06 & 7.2  & 7.5  & 7.1  & 7.3  & 7.28  \\
A07 & 30.5 & 30.1 & 30.8 & 30.3 & 30.43 \\
A08 & 5.9  & 6.1  & 5.8  & 6.0  & 5.95  \\
A09 & 27.3 & 27.0 & 27.6 & 27.2 & 27.28 \\
A10 & 14.0 & 13.7 & 14.3 & 13.9 & 13.98 \\
\hline
\end{tabular}
\end{table}
\end{singlespace}

This paragraph, after the table, returns to being double-spaced again,
since \verb|\doublespacing| is still in effect outside the
\verb|singlespace| environment.

\end{document}
```

**What to look for:** the paragraphs before and after the table have visibly more line spacing than the ten rows inside it. Try deleting the `\begin{singlespace}`/`\end{singlespace}` pair and recompiling — the table rows spread out to match the double spacing and become noticeably harder to scan. That contrast is the whole point of the nuance in Ch. 5.

*(Note: this table uses plain `\hline` rules rather than `booktabs`, since `booktabs` isn't introduced until Ch. 6 — feel free to swap in `\toprule`/`\midrule`/`\bottomrule` once you get there.)*

---

## Ch. 6 — Full Working Example: Table "Dark Arts" Combined

A single compilable table pulling together several of Ch. 6's edge-case tools: `@{}`, `\resizebox`, `tablefootnote`, `minipage` (placed alongside the table), and the multi-row header hack. Realistic scenario: a table with a wrapped header, a couple of footnoted values, and a note underneath.

```latex
\documentclass{article}
\usepackage{booktabs}
\usepackage{graphicx}
\usepackage{tablefootnote}

\begin{document}

\begin{table}[htbp]
\centering
\caption{Detector readings by sample, with wrapped header and footnoted values}
\label{tab:dark-arts}
\resizebox{\textwidth}{!}{%
\begin{tabular}{l @{} c c c}
\toprule
Sample & \begin{tabular}[c]{@{}c@{}}No. of\\detectors\end{tabular} & Reading (mV) & Uncertainty \\
\midrule
A01 & 3 & 452.1\tablefootnote{Measured at 300K.} & $\pm$ 2.4 \\
A02 & 4 & 398.7 & $\pm$ 1.9 \\
A03 & 2 & 511.0\tablefootnote{Repeated measurement; see notes.} & $\pm$ 3.1 \\
\bottomrule
\end{tabular}%
}
\end{table}

\begin{minipage}{0.9\textwidth}
\small
\textit{Note:} readings above were collected over three trials each;
see the supplementary dataset for raw values.
\end{minipage}

\end{document}
```
**What each tool is doing:** `\resizebox{\textwidth}{!}{...}` wraps the whole `tabular` so it scales to fit the page width — the `!` tells it to scale the height automatically to match, preserving proportions. `@{}` right after the first `l` column removes the padding between "Sample" and the wrapped-header column, since they should sit close together. The wrapped header itself is a small `tabular` nested inside a single cell — the pragmatic hack for a two-line header, versus `multirow`'s proper multi-row *data* cells. `tablefootnote` lets the two footnotes actually render at the bottom of the page instead of silently failing, which is what a plain `\footnote` would do inside this `table` float. The `minipage` below places a narrower note block directly under the table, independent of the table's own width.

*(If you need several distinct notes tied specifically to the table's own width rather than the page's, `threeparttable` is the more formal alternative to the `tablefootnote` calls above — it wraps the whole table plus a dedicated notes block as one unit. Worth reaching for once a table needs more than one or two footnotes.)*

---

## Ch. 7 — Full Working Example: A Stuck Float, Before and After `\clearpage`

Demonstrates the exact problem `\clearpage` solves: figures queued up with no body text to "anchor" them can drift several pages past where they were placed in the source.

```latex
\documentclass{article}
\usepackage{graphicx}
\usepackage{lipsum}   % dummy body text only

\begin{document}

\section{Methods}
\lipsum[1]

\begin{figure}[htbp]
\centering
\rule{0.5\textwidth}{3cm}
\caption{Experimental setup.}
\label{fig:setup}
\end{figure}

\begin{figure}[htbp]
\centering
\rule{0.5\textwidth}{3cm}
\caption{Calibration curve.}
\label{fig:calibration}
\end{figure}

% No \clearpage here yet -- both figures above are still "pending"
% and may not render before this point in the document.

\section{Results}
\lipsum[2]

\end{document}
```
Compile this version first and notice where the two figures actually land — likely not right after the Methods text, and possibly drifting into or past the Results section too, since LaTeX is still looking for the best place to slot them in.

Now add `\clearpage` right before `\section{Results}`:
```latex
\begin{document}
\begin{figure}
\end{figure}

\clearpage
\section{Results}
\lipsum[2]

\end{document}
```
Recompile. Both figures are now forced to place before `\clearpage` takes effect — guaranteed to appear before the Results section starts, instead of potentially drifting into it.

---

## Ch. 9 — Reverse-Engineering Sample Targets

Ch. 9's exercise 2 asks you to reverse-engineer a professionally typeset equation into LaTeX code. If you don't have a paper handy, work from the five targets below instead. Each renders in the compiled PDF exactly as it should look — your job is to write the LaTeX that reproduces it, then compile and compare. They rise in difficulty and together exercise most of Ch. 9's mechanics: subscripts and superscripts, `\frac`, roots, Greek letters, operators with limits, and spacing.

Try each one before looking at the source. Because these are typeset from LaTeX, the markup is available if you get stuck — but you'll learn far more by getting your own version to match first.

**Target 1 — the quadratic formula.** Exercises `\frac`, `\sqrt`, `\pm`, and a superscript.

$$x = \frac{-b \pm \sqrt{b^{2} - 4ac}}{2a}$$

**Target 2 — the derivative as a limit.** Exercises `\lim` with an underset, a nested `\frac`, and function-argument parentheses.

$$f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

**Target 3 — the normal distribution's density.** Exercises Greek letters (`\mu`, `\sigma`, `\pi`), an exponential with a stacked fraction in the exponent, and `\sqrt`.

$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} \, e^{-\frac{(x-\mu)^{2}}{2\sigma^{2}}}$$

**Target 4 — a finite sum with bounds.** Exercises `\sum` with sub/superscript limits and a squared term.

$$S_n = \sum_{i=1}^{n} i^{2} = \frac{n(n+1)(2n+1)}{6}$$

**Target 5 — a physical quantity with units.** Exercises subscripts, a superscript on a unit, and the thin-space `\,` between value and unit (Ch. 9's units nuance).

$$E_{k} = \tfrac{1}{2} m v^{2} = 3.2 \times 10^{-19}\,\mathrm{J}$$

*(No answer key is provided on purpose — the point is to build the markup yourself. The `$$...$$` source above is your check.)*

---

## Ch. 11 — Simple Theorem Bank for Beginners

Ch. 11's exercise asks you to state and prove your own lemma. If you'd rather work from existing, uncontroversial material than invent something from scratch, here are a few classic, easy statements to pick from — pick one and typeset it as a `theorem`, `lemma`, or `definition`:

- **Pythagorean theorem:** for a right triangle with legs $a$, $b$ and hypotenuse $c$, $a^2+b^2=c^2$. *(Already used as the worked example in Ch. 11 — pick a different one if you want practice beyond copying it.)*
- **Triangle inequality:** for any real numbers $a$, $b$, $|a+b| \le |a|+|b|$.
- **Sum of two even integers is even:** if $m=2j$ and $n=2k$ for integers $j,k$, then $m+n=2(j+k)$ is also even.
- **Product of two odd integers is odd:** if $m=2j+1$ and $n=2k+1$, then $mn = 2(2jk+j+k)+1$ is odd.
- **Density of rationals:** between any two distinct rational numbers $p < q$, there exists another rational number $r$ with $p < r < q$ (e.g. $r = \tfrac{p+q}{2}$).
- **Euclid's theorem (informal statement):** there is no largest prime number — the list of primes never ends.

These are deliberately simple — the point of the exercise is practicing the LaTeX mechanics (`\newtheorem`, `\theoremstyle`, `proof`, `\qedhere`, cross-referencing), not the mathematical difficulty.

---

## Ch. 11 — Exercise 2, Solved (Full Working Example)

Ch. 11's exercise 2 asks you to "state and prove a small lemma of your choosing (e.g. 'the sum of two even integers is even')." Below is that exact example, fully solved, as a complete, compilable document — also folding in theorem styles, a shared counter, and `\qedhere` from the rest of the chapter. Between this and the Pythagorean theorem worked example already in the main chapter, that's two fully solved references to learn from; exercises 1 and 3 (sharing the counter yourself, and cross-referencing) are left for you to do.

```latex
\documentclass{article}
\usepackage{amsthm}
\usepackage{amsmath}
\usepackage{hyperref}
\usepackage{cleveref}

\theoremstyle{plain}
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}[theorem]{Lemma}

\theoremstyle{definition}
\newtheorem{definition}{Definition}

\theoremstyle{remark}
\newtheorem{remark}{Remark}

\begin{document}

\begin{definition}
\label{def:even}
An integer $n$ is \emph{even} if $n = 2k$ for some integer $k$.
\end{definition}

\begin{lemma}
\label{lem:sum-even}
The sum of two even integers is even.
\end{lemma}

\begin{proof}
Let $m = 2j$ and $n = 2k$ for integers $j,k$, as in \cref{def:even}. By
\cref{def:even}, $m+n$ is even exactly when it equals $2$ times an
integer:
\[
  m + n = 2j + 2k = 2(j+k). \qedhere
\]
\end{proof}

\begin{remark}
\Cref{lem:sum-even} generalizes: the sum of any even number of odd
integers is also even, though that is not proved here.
\end{remark}

\end{document}
```

---

## Ch. 12 — Full Working Examples (Covering Most Reference-Table Commands)

Ch. 12's reference table lists nine `algorithm2e` commands, but the chapter's single worked example only exercises three of them (`\KwIn`, `\KwOut`, `\While`). The two examples below, between them, put almost every remaining command from the table into actual use — `\For`, `\If`/`\ElseIf`/`\Else`, `\Return`, and `\;` throughout. Anything not covered here (rarer commands like `\ForEach` or `\Repeat`/`\Until`) is worth looking up directly in the `algorithm2e` package documentation at this point in the guide.

A single, complete, compilable document with two algorithms — Example 1 exercises branching plus a `\For` loop; Example 2 exercises a `\While` loop with a `\Return` inside it. Between them, nearly every command in the reference table is used at least once.

```latex
\documentclass{article}
\usepackage{amsmath}
\usepackage[ruled,vlined]{algorithm2e}

\begin{document}

\begin{algorithm}[htbp]
\caption{Classify Samples by Threshold}
\label{alg:classify}
\KwIn{samples $S = \{s_1, \dots, s_n\}$, thresholds $t_1 < t_2$}
\KwOut{list of labels $L$}
$L \leftarrow \emptyset$\;
\For{$i \leftarrow 1$ \KwTo $n$}{
  \If{$s_i < t_1$}{
    append "Low" to $L$\;
  }
  \ElseIf{$s_i < t_2$}{
    append "Medium" to $L$\;
  }
  \Else{
    append "High" to $L$\;
  }
}
\Return{$L$}
\end{algorithm}

\begin{algorithm}[htbp]
\caption{Halving Search}
\label{alg:halving}
\KwIn{sorted list $A$ of length $n$, target value $x$}
\KwOut{index of $x$ in $A$, or $-1$ if not found}
$\text{lo} \leftarrow 1$\; $\text{hi} \leftarrow n$\;
\While{$\text{lo} \leq \text{hi}$}{
  $\text{mid} \leftarrow \lfloor (\text{lo}+\text{hi})/2 \rfloor$\;
  \If{$A[\text{mid}] = x$}{
    \Return{$\text{mid}$}
  }
  \ElseIf{$A[\text{mid}] < x$}{
    $\text{lo} \leftarrow \text{mid} + 1$\;
  }
  \Else{
    $\text{hi} \leftarrow \text{mid} - 1$\;
  }
}
\Return{$-1$}
\end{algorithm}

\end{document}
```

Between the chapter's own worked example and these two, every command in Ch. 12's reference table has now been used in a real algorithm at least once.

---

## Ch. 13 — Starter `.bib` Files for the 4 Capstone Topics

Ch. 13's exercise and Capstone Update both assume you have references to work with. Rather than send you hunting for real papers before you've even seen what a `.bib` file looks like, here's a ready-made starter file for each of the 4 capstone topics from Ch. 4 — 5 entries each, with at least one `@online` (biblatex) and one `@misc` (software) entry per topic, matching Ch. 13's nuance on citing web resources and software.

*A note on accuracy: several entries below (Balandin et al. 2008, Robbins & Monro 1951, Boyd & Vandenberghe 2004, Michaelis & Menten 1913, Lineweaver & Burk 1934, Cornish-Bowden, Timoshenko & Goodier) are real, well-known works in their respective fields, included so the starter files feel like genuine literature rather than obvious placeholders. A few others (e.g. the Hibbeler "article" entry) are fabricated for illustration. Treat this whole file as dummy practice data for learning `.bib` syntax — if you later switch your capstone to your own real research topic, replace these with your actual sources.*

**Topic 1 — Physics: Thermal conductivity of graphene composites**
```latex
@article{balandin2008superior,
  author  = {Balandin, A. A. and Ghosh, S. and Bao, W. and Calizo, I. and Teweldebrhan, D. and Miao, F. and Lau, C. N.},
  title   = {Superior Thermal Conductivity of Single-Layer Graphene},
  journal = {Nano Letters},
  year    = {2008},
  volume  = {8},
  number  = {3},
  pages   = {902--907}
}

@article{ghosh2010dimensional,
  author  = {Ghosh, S. and Bao, W. and Nika, D. L. and Subrina, S. and Pokatilov, E. P. and Lau, C. N. and Balandin, A. A.},
  title   = {Dimensional Crossover of Thermal Transport in Few-Layer Graphene},
  journal = {Nature Materials},
  year    = {2010},
  volume  = {9},
  pages   = {555--558}
}

@inproceedings{shahil2012graphene,
  author    = {Shahil, K. M. F. and Balandin, A. A.},
  title     = {Graphene--Multilayer Graphene Nanocomposites as Highly Efficient Thermal Interface Materials},
  booktitle = {Proceedings of the IEEE Nanotechnology Materials and Devices Conference},
  year      = {2012},
  pages     = {45--48}
}

@online{comsol2023thermal,
  author = {{COMSOL AB}},
  title  = {Heat Transfer Module User's Guide},
  year   = {2023},
  url    = {https://www.comsol.com/heat-transfer-module},
  note   = {Accessed: 2026-07-10}
}

@misc{matlab2023,
  author       = {{MathWorks}},
  title        = {MATLAB, version 9.14 (R2023a)},
  year         = {2023},
  howpublished = {Software},
  note         = {The MathWorks Inc., Natick, MA}
}
```

**Topic 2 — CS/Math: Convergence analysis of a gradient descent algorithm**
```latex
@article{robbins1951stochastic,
  author  = {Robbins, H. and Monro, S.},
  title   = {A Stochastic Approximation Method},
  journal = {The Annals of Mathematical Statistics},
  year    = {1951},
  volume  = {22},
  number  = {3},
  pages   = {400--407}
}

@book{boyd2004convex,
  author    = {Boyd, S. and Vandenberghe, L.},
  title     = {Convex Optimization},
  publisher = {Cambridge University Press},
  year      = {2004}
}

@inproceedings{bottou2010large,
  author    = {Bottou, L.},
  title     = {Large-Scale Machine Learning with Stochastic Gradient Descent},
  booktitle = {Proceedings of COMPSTAT'2010},
  year      = {2010},
  pages     = {177--186}
}

@online{ruder2016overview,
  author = {Ruder, S.},
  title  = {An Overview of Gradient Descent Optimization Algorithms},
  year   = {2016},
  url    = {https://ruder.io/optimizing-gradient-descent/},
  note   = {Accessed: 2026-07-10}
}

@misc{python2023,
  author       = {{Python Software Foundation}},
  title        = {Python Language Reference, version 3.11},
  year         = {2023},
  howpublished = {Software}
}
```

**Topic 3 — Engineering: Stress-strain analysis of a cantilever beam**
```latex
@book{timoshenko1970theory,
  author    = {Timoshenko, S. P. and Goodier, J. N.},
  title     = {Theory of Elasticity},
  publisher = {McGraw-Hill},
  year      = {1970},
  edition   = {3rd}
}

@book{gere2012mechanics,
  author    = {Gere, J. M. and Goodno, B. J.},
  title     = {Mechanics of Materials},
  publisher = {Cengage Learning},
  year      = {2012},
  edition   = {8th}
}

@article{hibbeler2016cantilever,
  author  = {Hibbeler, R. C.},
  title   = {Deflection Analysis of Cantilever Beams under Distributed Loading},
  journal = {Journal of Structural Engineering},
  year    = {2016},
  volume  = {142},
  number  = {4},
  pages   = {112--120}
}

@online{ansys2023beam,
  author = {{ANSYS Inc.}},
  title  = {Structural Analysis Guide: Beam Elements},
  year   = {2023},
  url    = {https://www.ansys.com/products/structures},
  note   = {Accessed: 2026-07-10}
}

@misc{solidworks2023,
  author       = {{Dassault Syst\`emes}},
  title        = {SolidWorks Simulation, 2023 Edition},
  year         = {2023},
  howpublished = {Software}
}
```

**Topic 4 — Biology/Chem: Reaction rate of enzyme kinetics**
```latex
@article{michaelis1913kinetik,
  author  = {Michaelis, L. and Menten, M. L.},
  title   = {Die Kinetik der Invertinwirkung},
  journal = {Biochemische Zeitschrift},
  year    = {1913},
  volume  = {49},
  pages   = {333--369}
}

@article{lineweaver1934determination,
  author  = {Lineweaver, H. and Burk, D.},
  title   = {The Determination of Enzyme Dissociation Constants},
  journal = {Journal of the American Chemical Society},
  year    = {1934},
  volume  = {56},
  number  = {3},
  pages   = {658--666}
}

@book{cornishbowden2012fundamentals,
  author    = {Cornish-Bowden, A.},
  title     = {Fundamentals of Enzyme Kinetics},
  publisher = {Wiley-Blackwell},
  year      = {2012},
  edition   = {4th}
}

@online{nist2023enzyme,
  author = {{National Institute of Standards and Technology}},
  title  = {Enzyme Kinetics Reference Database},
  year   = {2023},
  url    = {https://www.nist.gov/enzyme-kinetics-reference},
  note   = {Accessed: 2026-07-10}
}

@misc{graphpad2023,
  author       = {{GraphPad Software}},
  title        = {GraphPad Prism, version 10},
  year         = {2023},
  howpublished = {Software}
}
```

**Using these with plain BibTeX instead of biblatex:** rename every `@online` entry above to `@misc`, and move its `url` field into `howpublished = {\url{...}}` — per Ch. 13's nuance on the `@online`/`@misc` distinction.

---

## Ch. 16 — Glossary Printing Command Reference

Quick reference for the most common `\printglossary` scenarios, assuming the setup from Ch. 16 (`\usepackage[acronym]{glossaries}`, plus `\newglossary[slg]{symbols}{sym}{sbl}{List of Symbols}` if you're also using a symbols list):

```latex
% Acronyms only:
\printglossary[type=\acronymtype]

% A symbols list, if you declared one with \newglossary and used type=symbols:
\printglossary[type=symbols]

% Everything defined without an explicit type= (the default glossary):
\printglossary

% Separate, titled lists for both acronyms and symbols in the same document:
\printglossary[type=\acronymtype, title={List of Acronyms}]
\printglossary[type=symbols, title={List of Symbols}]
```

Remember: `\printglossary` with no `type=` only prints entries that were *also* defined with no `type=`. If every entry you defined has an explicit `type=`, a bare `\printglossary` call will print nothing — always match the `type=` on the way in with the `type=` on the way out.

---

## Ch. 17 — Full Working Example: Neural Network Architecture Diagram

Ch. 17's own worked example is a deliberately minimal 3-box pipeline, since TikZ is flagged as elective and the chapter doesn't want to scare anyone off. If you want to see how far TikZ scales when a diagram actually needs it, here's a fully-commented, more complex example: a fully-connected feedforward network with 4 inputs, two hidden layers of 3 neurons each, and 1 output.

```latex
\documentclass{article}
\usepackage{tikz}
\usetikzlibrary{positioning}

\begin{document}

\begin{figure}[htbp]
\centering
% \layersep controls the horizontal spacing between layers. Defined as a
% plain macro (not a TikZ style option) so it can be reused in coordinate
% arithmetic below.
\def\layersep{2.5cm}

\begin{tikzpicture}[
  neuron/.style={draw, circle, minimum size=0.8cm},
  every node/.style={font=\small}
]

% --- Input layer: 4 neurons, stacked vertically and labeled x_1..x_4 ---
\foreach \i in {1,...,4} {
  \node[neuron] (I-\i) at (0, -\i*1.2) {$x_{\i}$};
}

% --- Hidden layer 1: 3 neurons, vertically offset to sit roughly centered
% relative to the 4 inputs above ---
\foreach \i in {1,...,3} {
  \node[neuron] (H1-\i) at (\layersep, -\i*1.2 - 0.6) {};
}

% --- Hidden layer 2: 3 neurons, same vertical layout as hidden layer 1 ---
\foreach \i in {1,...,3} {
  \node[neuron] (H2-\i) at (2*\layersep, -\i*1.2 - 0.6) {};
}

% --- Output layer: a single neuron ---
\node[neuron] (O) at (3*\layersep, -3.0) {$y$};

% --- Connections: input -> hidden layer 1, fully connected (4x3 = 12 edges) ---
\foreach \i in {1,...,4} {
  \foreach \j in {1,...,3} {
    \draw[->] (I-\i) -- (H1-\j);
  }
}

% --- Connections: hidden layer 1 -> hidden layer 2, fully connected (3x3 = 9 edges) ---
\foreach \i in {1,...,3} {
  \foreach \j in {1,...,3} {
    \draw[->] (H1-\i) -- (H2-\j);
  }
}

% --- Connections: hidden layer 2 -> output (3 edges) ---
\foreach \i in {1,...,3} {
  \draw[->] (H2-\i) -- (O);
}

% --- Layer labels, placed above the first node in each column.
% Requires the "positioning" library loaded above for the "above=...of" syntax. ---
\node[above=0.6cm of I-1, align=center] {Input\\Layer};
\node[above=0.6cm of H1-1, align=center] {Hidden\\Layer 1};
\node[above=0.6cm of H2-1, align=center] {Hidden\\Layer 2};
\node[above=0.8cm of O, align=center] {Output};

\end{tikzpicture}
\caption{A fully connected feedforward network: 4 inputs, two hidden
layers of 3 neurons each, and a single output.}
\label{fig:nn-architecture}
\end{figure}

\end{document}
```

**What each section is doing, in plain terms:**

- The `\foreach` loops (from `pgffor`, loaded automatically with `tikz`) place each layer's neurons in one pass instead of writing out every `\node` individually — 4 inputs, 3+3 hidden neurons, and 1 output, all from four short loops.
- Each neuron is named systematically (`I-1`...`I-4`, `H1-1`...`H1-3`, `H2-1`...`H2-3`, `O`) so the connection loops can refer to them by name rather than by coordinate.
- The three connection blocks are nested `\foreach` loops — "for every neuron in this layer, draw an arrow to every neuron in the next layer" — which is what makes the network "fully connected" without hand-writing all 24 individual `\draw` commands.
- `\layersep` is a plain TeX macro (`\def`), not a TikZ style key, which is why it can be used directly inside coordinate arithmetic like `(\layersep, ...)` and `(2*\layersep, ...)`.
- The `positioning` library (`\usetikzlibrary{positioning}`) is what enables the `above=0.6cm of I-1` syntax used for the layer labels — without loading it, that syntax would fail.

---

## Ch. 18 — Sample Dataset (`ch18_sample_data.csv`)

A real, standalone `.csv` file (not just a table to copy-paste) is included alongside this guide: `ch18_sample_data.csv`. It has 8 rows, an uncertainty column, and is shaped like enzyme-kinetics-style saturation data — usable directly with Ch. 18's `table[x=..., y=..., col sep=comma]` syntax and its error-bar syntax.

```csv
concentration,rate,error
1,2.1,0.15
2,3.8,0.22
3,5.2,0.18
4,6.9,0.25
5,8.1,0.20
6,8.9,0.30
7,9.3,0.28
8,9.5,0.32
```

---

## Ch. 18 — Full Working Example (Complete Document)

A single, complete, compilable document that reads `ch18_sample_data.csv` directly (rather than typing data inline) and plots it with error bars — put this `.tex` file in the same Overleaf project folder as `ch18_sample_data.csv` for it to compile.

```latex
\documentclass{article}
\usepackage{pgfplots}
\usepackage{pgfplotstable}
\pgfplotsset{compat=1.18}

\begin{document}

\begin{figure}[htbp]
\centering
\begin{tikzpicture}
\begin{axis}[
  xlabel={Concentration (mM)},
  ylabel={Reaction Rate},
]
\addplot+[
  error bars/.cd,
  y dir=both,
  y explicit,
] table[
  x=concentration,
  y=rate,
  y error=error,
  col sep=comma
] {ch18_sample_data.csv};
\end{axis}
\end{tikzpicture}
\caption{Reaction rate vs.\ substrate concentration, with error bars
read directly from \texttt{ch18\_sample\_data.csv}.}
\label{fig:enzyme-kinetics}
\end{figure}

\end{document}
```
`y error=error` tells pgfplots to pull the error-bar size for each point from the CSV's `error` column, instead of typing `+- (x,y)` values by hand as in the chapter's inline example — the natural approach once your uncertainties are already sitting in a data file alongside the measurements themselves.

---

## Ch. 20 — Full Working Example: Two-Column Layout with a Spanning Figure

Ch. 20's two-column nuance covers `\onecolumn`/`\twocolumn` and `figure*`/`table*` as isolated snippets — this shows them working together in a compilable two-column article, including the placement restriction the chapter mentions (starred floats reliably support only `[t]`/`[p]`).

```latex
\documentclass[twocolumn]{article}
\usepackage{graphicx}
\usepackage{lipsum}   % dummy body text only, to make column wrapping visible — remove in a real document

\begin{document}

\title{A Two-Column Layout Example}
\author{Your Name}
\maketitle

\section{Introduction}
\lipsum[1]

\begin{figure*}[t]
\centering
\rule{0.9\textwidth}{4cm}   % placeholder box standing in for a wide diagram
\caption{A wide figure spanning both columns — for instance, a full
experimental setup diagram or a multi-panel results figure.}
\label{fig:wide-example}
\end{figure*}

\section{Methods}
\lipsum[2]

\begin{figure}[htbp]
\centering
\rule{0.4\textwidth}{3cm}   % placeholder box standing in for a single-column figure
\caption{A regular figure, confined to one column.}
\label{fig:narrow-example}
\end{figure}

\lipsum[3]

\end{document}
```
**What to notice:** the `figure*` sits above both columns at the top of the page, breaking the two-column flow, while the regular `figure` right after it stays confined to a single column and lets text flow around it as usual. Swap the `\rule{...}{...}` placeholders for a real `\includegraphics{...}` call once you have an actual image — the rules are here only so the example compiles without one.

*(Uses `lipsum` purely to generate enough filler text for column-wrapping to actually be visible in this standalone example — not something to keep in your own document.)*

---

## Ch. 20 — Full Working Example: Front/Back-Matter Skeleton (`book` Class)

A minimal but complete `book`-class document walking through the full `\frontmatter` → `\mainmatter` → `\appendix` → `\backmatter` structure from Ch. 20, using the graphene capstone topic as filler content.

```latex
\documentclass[12pt]{book}
\usepackage{amsmath}

\begin{document}

\frontmatter

\title{Thermal Conductivity of Graphene Composites: A Capstone Study}
\author{Your Name}
\date{\today}
\maketitle
\thispagestyle{empty}

\tableofcontents
\listoffigures
\listoftables

\mainmatter

\chapter{Introduction}
\label{ch:intro}
This chapter introduces the capstone problem: characterizing thermal
conductivity in graphene-based composite materials.

\chapter{Methods}
\label{ch:methods}
Measurement and simulation methods used throughout this study are
described here.

\chapter{Results and Discussion}
\label{ch:results}
Results referenced from \cref{ch:methods} are presented and interpreted.

\appendix

\chapter{Supplementary Derivations}
\label{app:derivations}
Additional derivations too lengthy for the main chapters are collected
here.

\backmatter

\chapter{Bibliography}
\label{ch:bibliography}
% In a real document, replace this placeholder with \bibliography{}
% (Ch. 13) or \printbibliography (Ch. 13-16), not manually-typed content.

\end{document}
```
**Walking through the structure:**

- `\frontmatter` sets roman-numeral page numbers for everything that follows, up until `\mainmatter`. `\thispagestyle{empty}` right after `\maketitle` keeps the title page free of a visible page number, even though the page is still counted internally.
- `\mainmatter` resets to arabic page 1 and switches chapter numbering back on, so the three `\chapter` calls that follow become "Chapter 1," "Chapter 2," "Chapter 3" as expected.
- `\appendix` switches to lettered chapters ("Appendix A") without leaving `\mainmatter`'s arabic page numbering — it doesn't need `\mainmatter` to be called again.
- `\backmatter` switches chapters back to unnumbered automatically — a plain `\chapter{Bibliography}` here already behaves like `\chapter*{Bibliography}` would elsewhere, so there's no need to add a `*` just because you're in back matter.

---

## Ch. 23 — Full Assembled Skeleton (Every Chapter, One Document)

The capstone paper itself was set up in Ch. 4 as `article` class, not `book` — so unlike the `book`-class skeleton above (which exists purely to demonstrate the `\frontmatter`/`\mainmatter`/`\backmatter` mechanism), this one builds front matter the manual way Ch. 20 covers for `article`/`report`. It threads every technique from Ch. 4–22 into one compilable document, using the graphene capstone topic. Kept as a single file for readability here; a real project this size would split into `\input` files per Ch. 20 (preamble, sections, bibliography) — commented pointers below mark where those splits would go.

```latex
\documentclass[12pt]{article}
\usepackage[utf8]{inputenc}                      % Ch. 3

% ---------- Preamble: would live in its own \input file per Ch. 20 ----------
\usepackage{amsmath, amssymb}                    % Ch. 9
\usepackage{siunitx}                             % Ch. 9
\usepackage{bm}                                  % Ch. 9
\usepackage{graphicx}                            % Ch. 7
\usepackage{booktabs}                            % Ch. 6
\usepackage{enumitem}                            % Ch. 6
\usepackage{caption}                             % Ch. 7
\usepackage[ruled,vlined]{algorithm2e}           % Ch. 12
\usepackage[acronym]{glossaries}                 % Ch. 16
\usepackage[style=numeric,backend=biber]{biblatex}  % Ch. 13-14
\addbibresource{graphene.bib}                    % Ch. 13 starter .bib, Topic 1
\usepackage{comment}                             % Ch. 20
\usepackage{tikz}                                % Ch. 17
\usepackage{pgfplots}                            % Ch. 18
\pgfplotsset{compat=1.18}
\usepackage[colorlinks=true, linkcolor=blue, citecolor=blue]{hyperref}  % Ch. 8
\usepackage{cleveref}                            % Ch. 8

\newtheorem{definition}{Definition}              % Ch. 11
\newcommand{\R}{\mathbb{R}}                      % Ch. 19
\DeclareMathOperator{\argmin}{arg\,min}          % Ch. 19

\makeglossaries                                  % Ch. 16
\newacronym{tc}{TC}{Thermal Conductivity}

\title{Thermal Conductivity of Graphene-Based Composite Materials}
\author{Iqra Siddique \and Syed Ali Mohsin Bukhari}
\date{\today}

\begin{document}

% ---------- Front matter: manual equivalent, article has no \frontmatter (Ch. 20) ----------
\pagenumbering{roman}
\maketitle
\thispagestyle{empty}

\begin{abstract}
This capstone paper characterizes thermal conductivity (\gls{tc}) in
graphene-based composite materials, combining a steady-state
conduction model with measured results.
\end{abstract}

\tableofcontents
\listoffigures
\listoftables
\printglossary[type=\acronymtype]

\clearpage
\pagenumbering{arabic}

% ---------- Body: would split into \input{sections/...} files per Ch. 20 ----------
\section{Introduction}
\label{sec:intro}
Graphene composites exhibit exceptional \gls{tc}, motivating the
steady-state model developed in Section~\ref{sec:methods} and tested
against the results in Section~\ref{sec:results}.

\begin{comment}
\section{Old literature-review draft -- not ready for review}
Parked here per Ch. 20 until the related-work section is finalized.
\end{comment}

\section{Methods}
\label{sec:methods}

\begin{definition}
\label{def:steady-state}
A system is in \emph{steady-state thermal conduction} if the
temperature at every point is independent of time.
\end{definition}

\begin{algorithm}[htbp]
\caption{Finite-difference thermal conductivity estimation}
\label{alg:fd}
\KwIn{temperature grid $T$, thermal diffusivity $\alpha$, grid spacing $\Delta x$}
\KwOut{steady-state temperature field}
\Repeat{convergence}{
  \For{each interior grid point}{
    update $T$ using the discretized heat equation\;
  }
}
\end{algorithm}

Heat flow (\cref{fig:setup}) follows Fourier's law:
\begin{equation}
\label{eq:fourier}
q = -k \nabla T
\end{equation}
where $k$ is reported in \si{\watt\per\meter\per\kelvin}. Expanding
\cref{eq:fourier} in one dimension gives a short derivation:
\begin{align}
q_x &= -k \, \frac{dT}{dx} \\
\int q_x \, dx &= -k \int dT
\end{align}

\section{Results}
\label{sec:results}

\begin{table}[htbp]
\centering
\caption{Measured thermal conductivity by composite fraction.}
\label{tab:results}
\begin{tabular}{@{} l S[table-format=2.1] @{}}
\toprule
{Sample} & {$k$ (\si{\watt\per\meter\per\kelvin})} \\
\midrule
Pure graphene   & 25.0 \\
10\% composite  & 18.4 \\
20\% composite  & 14.2 \\
\bottomrule
\end{tabular}
\end{table}

\begin{figure}[htbp]
\centering
\begin{tikzpicture}
  \node[draw, rectangle] (a) at (0,0) {Sample};
  \node[draw, rectangle] (b) at (3,0) {Heat Source};
  \draw[->] (b) -- (a);
\end{tikzpicture}
\caption{Experimental heat-flow setup.}
\label{fig:setup}
\end{figure}

\begin{figure}[htbp]
\centering
\begin{tikzpicture}
\begin{axis}[
  xlabel={Composite fraction (\%)},
  ylabel={$k$ (\si{\watt\per\meter\per\kelvin})}
]
\addplot coordinates {(0,25.0) (10,18.4) (20,14.2)};
\end{axis}
\end{tikzpicture}
\caption{Thermal conductivity versus composite fraction (\cref{tab:results}).}
\label{fig:plot}
\end{figure}

Results agree with \citet{balandin2008superior} and confirm the trend
reported in \citep{shahil2012graphene}.

% ---------- Back matter ----------
\printbibliography

\appendix
\section{Extended Derivation}
\label{app:derivation}
The full multi-step derivation behind \cref{eq:fourier}, too long for
the main methods section, is collected here.

\end{document}
```

**Walking through where each chapter's piece landed:**

- **Preamble** (Ch. 3, 9, 19): `inputenc`, `siunitx`/`bm` for math conventions, and the `\R`/`\argmin` macros from Ch. 19 — all defined once, used throughout.
- **Front matter** (Ch. 4, 16, 20): title/author/date/abstract from Ch. 4, wrapped in the manual roman-numeral/`\clearpage`/arabic-numeral pattern Ch. 20 gives for non-`book` classes, with the acronym list (Ch. 16) printed alongside the TOC/LOF/LOT.
- **Ch. 11's `definition`** and **Ch. 12's `algorithm2e` block** open the Methods section as structured content, ahead of the prose.
- **Ch. 9's key equation** and **Ch. 10's derivation** sit together, cross-referenced with `\cref` (Ch. 8) rather than a bare `Section~\ref`.
- **Ch. 6's table** and **Ch. 7/17's diagram** and **Ch. 18's pgfplots chart** all carry labels in Ch. 8's prefix convention (`tab:`, `fig:`) and are cross-referenced from the text, not just captioned in isolation.
- **Ch. 13's citations** appear in Ch. 14's chosen style (`biblatex`/numeric here — swap for whatever your target journal requires) via `\citet`/`\citep`, pulling from the same starter `graphene.bib` introduced in Ch. 13.
- **Ch. 20's `comment`** parks an unfinished section without deleting it, and the `\appendix` block holds overflow material exactly as Ch. 20 describes.
- Not shown inline, since they're processes rather than markup: Ch. 15's reference-manager sync, Ch. 21's Git tag/History checkpoint, and Ch. 22's log-reading discipline — all still required before this skeleton is actually submission-ready, per Ch. 23's checklist.

*(Compiling this for real needs Biber, not BibTeX, per the `biblatex` choice above — Ch. 13's compiler decision tree — plus the extra `makeglossaries` run Ch. 16 flags for the glossary to populate.)*

---
