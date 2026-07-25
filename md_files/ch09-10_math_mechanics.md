# Part 3: Math Mechanics (Chapters 9–10)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

\clearpage

## Chapter 9 — Inline & display math basics/fonts & units

Math is where LaTeX earns its reputation — an equation that would be a fight with an equation editor elsewhere is a few lines of markup here, and it renders consistently every time instead of drifting out of alignment across a long document.

This chapter covers the basics everything else in Part 3 builds on: inline vs. display math, Greek letters and sub/superscripts, and the font/unit conventions (roman vs. italic, `siunitx`, `bm`) that separate a professionally typeset paper from an obviously beginner one.

::: objective

Typeset inline and display equations correctly, use Greek letters and sub/superscripts, and get the font and unit conventions right from the start — the habits that separate a professionally typeset paper from an obviously beginner one.

:::

### Inline vs. display math

The same equation can sit inline within a sentence, or be set apart on its own numbered line — LaTeX uses different syntax for each, and mixing them up is an easy first mistake.

::: worked

```latex
\documentclass{article}
\usepackage{amsmath}

\begin{document}
    Einstein's mass-energy equivalence, written inline, is $E = mc^2$.
    The same relationship, set apart and automatically numbered:

    \begin{equation}
        E = mc^2
        \label{eq:mass-energy}
    \end{equation}

    Two related equations, aligned at the equals sign and each numbered:

    \begin{align}
        F &= ma       \label{eq:newton2} \\
        W &= Fd       \label{eq:work}
    \end{align}
\end{document}
```

:::

::: important

- `$...$` is inline math — it flows within a sentence.
- `equation` is display math with automatic numbering. It can be references with `\eqref{eq:mass-energy}` or `\cref{eq:mass-energy}`. The same `\label`/reference mechanics from Ch. 8, just applied to an equation.
- `\eqref` wraps the number in parentheses (`(1)`), which is the standard convention for equation references; `\cref` instead produces "Equation (1)" with the word spelled out. Either is correct, just pick one convention and stay consistent.
- Need an equation with *no* number at all? `equation*` is the starred, unnumbered variant. See Ch. 5's "star convention" nuance if that's new to you.
- `align` (from `amsmath`, loaded above) numbers *every* line and aligns them at the `&` marker. The & signa is typically placed right before the `=` sign.

:::

### Greek letters and sub/superscripts

Variable names and exponents in physics and math notation lean heavily on Greek letters and sub/superscripts, both typed with plain-text shortcuts rather than any special input method.

::: worked

```latex
\documentclass{article}

\begin{document}
    The decay follows $N(t) = N_0 e^{-\lambda t}$, where $\lambda$ is the
    decay constant.
    Summing over $i = 1, \dots, n$:
    \[
        S = \sum_{i=1}^{n} x_i^2
    \]
\end{document}
```

:::

::: important

- Greek letters are typed by name:
    - `\alpha`, `\beta`, `\gamma`, `\theta`, `\pi`, `\sigma`, `\omega` for lowercase,
    - `\Gamma`, `\Delta`, `\Theta`, `\Pi`, `\Sigma`, `\Omega` (capitalized command) for the uppercase forms that differ from Latin letters.
- Subscripts use `_`, superscripts use `^`; wrap multi-character sub/superscripts in braces (`x_{i,j}^{2}`), since `x_i,j^2` would only attach `i` to the subscript.

:::


### Italics vs. Roman in Math

Math mode italicizes every letter by default, which is correct for a variable but wrong for a handful of other things that just happen to also be letters.

::: nuance

Letters in math mode render in italic by default, which is correct for single-letter variables ($x$, $y$, $\alpha$), but wrong for a few other things:

- **Vectors/matrices** should be bold, not italic; see the `bm` nuance below.
- **Units** should be upright/roman, not italic; see `siunitx` below.
- **Plain English words** inside math mode (like "if" in a `cases` block, covered in Ch. 10) need `\text{}`, or LaTeX renders them as multiplied variables.

::: worked

```latex
\documentclass{article}

\begin{document}
    % correct: x is italic automatically, no extra command needed
    $x^2 + y^2 = r^2$
    
    % correct: \mathrm{} for upright text/units inside an equation
    $F = 5\ \mathrm{N}$
    
    % WRONG: don't reach for \textit inside math mode
    $\textit{x}^2$
\end{document}
```
:::

:::

::: important 

Never use `\textit{}` inside math mode to italicize a variable.
`\textit{}` is a *text-mode* command; using it in math mode produces inconsistent spacing and kerning compared to LaTeX's own math italics. 
Just write `$x$` — it's already italic automatically.

:::

### Formatting Units

A number with a unit can be typed by hand correctly, but staying consistent about it across a 40-page document with hundreds of units is the part that actually goes wrong.

::: nuance

You *can* write units manually, and it's not wrong:

::: worked

```latex
\documentclass{article}
\usepackage{amsmath}

\begin{document}
    % manual approach — technically correct
    $10\,\text{keV}$
    % or, equivalently
    $10\,\mathrm{keV}$
\end{document}
```
:::

Both use tools you already have: `\,` for the thin space between number and unit, `\text{}`/`\mathrm{}` to keep the unit upright instead of italic.
Nothing here is broken.

:::

#### `siunitx`: The solution

The catch is consistency, not correctness. 
Across a 40-page thesis with hundreds of units, it's easy to forget the `\,` on line 200 when you remembered it on line 20, mix `\text{}` and `\mathrm{}` inconsistently, or format `\times 10^{-3}` one way in one equation and another way elsewhere.
None of these individually breaks compilation, they just make the document look inconsistent, which readers (and reviewers) notice even if they can't say why.

::: nuance

The `siunitx` package's `\SI{value}{unit}` command removes that risk entirely by enforcing the same spacing and formatting every time, automatically:

::: worked

```latex
\documentclass{article}
\usepackage{siunitx}

\begin{document}
    The measured velocity was \SI{5}{\meter\per\second}.
    The sample mass was \SI{10.2}{\kilogram}.
    A unit can also be shown on its own, without a value, using
    \si{\meter\per\second}.
\end{document}
```

:::

`\SI{}{}` inserts the correct thin space between number and unit and renders the unit upright. 
Manual `\,\text{}` is fine for a one-off; `siunitx` is what you want the moment a document has more than a handful of units to stay consistent across.

:::


### Bold Vectors & Greek Letters with `bm`

LaTeX's standard bold command quietly fails on Greek letters, which is a surprising first encounter for anyone typesetting a bold coefficient vector because the default LaTeX font doesn't cover Greek symbols.

::: nuance

For bold vectors or bold Greek symbols (common in statistics/ML notation — a coefficient vector $\bm{\beta}$, for instance), use the `bm` package:


::: worked

```latex
\documentclass{article}
\usepackage{bm}

\begin{document}
    The regression coefficients $\bm{\beta}$ minimize the loss function.
    A bold Latin vector works the same way: $\bm{v}$.
\end{document}
```

:::

`\boldsymbol{}` (from `amsmath`) is a lighter alternative that covers most Greek letters too, but `bm` handles more symbol combinations, so it's the one used throughout this guide.

:::

### Putting It Together

A single short derivation that combines display equations, `\bm{}`, and `\SI{}{}` in one place is worth more than seeing each of them in isolation.

::: worked

```latex
\documentclass{article}
\usepackage{amsmath}
\usepackage{siunitx}
\usepackage{bm}

\begin{document}
    Newton's second law relates force and acceleration:
    \begin{equation}
        \mathbf{F} = m\bm{a}
        \label{eq:newton2}
    \end{equation}
    where $m$ is mass in \si{\kilogram} and $\bm{a}$ is acceleration in
    \si{\meter\per\second\squared}.

    A measured force of \SI{12.5}{\newton} acting on a \SI{2}{\kilogram}
    mass gives an acceleration of \SI{6.25}{\meter\per\second\squared}.
\end{document}
```

:::

::: exercise

1. Transcribe these into LaTeX (use `align` for anything spanning more than one line):
    - $a^2 + b^2 = c^2$
    - $\int_0^\infty e^{-x} dx = 1$ *(we'll fix this integral's spacing properly in Ch. 10)*
    - $\lim_{x \to 0} \frac{\sin x}{x} = 1$
    - A vector dot product: $\bm{u} \cdot \bm{v} = |\bm{u}||\bm{v}|\cos\theta$
    - A bold Greek coefficient: $\hat{y} = \bm{\beta}^T \bm{x}$
2. Find a professionally typeset equation from a textbook or paper in your field (a screenshot is fine), and write the LaTeX that would reproduce it. Check your version against the rules above: is anything that should be bold left plain? Any unit set in italics that shouldn't be? 

::: crosscheck

Sample target equations are collected in `supplementary_materials.md` — see "Ch. 9 — Reverse-Engineering Sample Targets."

:::

:::

::: capstone

Typeset the single most important equation in your capstone paper — the one that defines your key result or model — using correct roman/bold conventions and `\SI{}{}` for any units involved.

:::


## Chapter 10 — Advanced Math: Matrices, Multi-line Equations, Cases

Chapter 9 covered single equations; real derivations are rarely just one line — they're matrices, branching definitions, and multi-step algebra that each need their own environment to typeset cleanly.

This chapter covers `pmatrix`/`bmatrix`/`vmatrix` for matrices, `cases` for piecewise functions, `align`/`split` for multi-step derivations, and the delimiter-sizing and spacing details that make a finished derivation look deliberately typeset rather than dumped from a text editor.

::: objective

Typeset matrices, piecewise functions, and multi-step derivations, and control delimiter sizing and spacing so equations look deliberate rather than cramped or oversized.

:::

### Matrices

A matrix is just a grid inside brackets, and the bracket style is a one-word swap once you know the environment name to change.

::: worked

```latex
\documentclass{article}
\usepackage{amsmath}

\begin{document}
    \[
        A = \begin{pmatrix}
                1 & 2 \\
                3 & 4
        \end{pmatrix}
    \]
\end{document}
```

:::

::: nuance

`pmatrix` gives parentheses; swap the environment name for a different bracket style
 
- `bmatrix` for square brackets, 
- `vmatrix` for a determinant (single vertical bars), 
- `Vmatrix` for double vertical bars. 

The `&` (column separator)/`\\` (row separator) syntax  stays the same across all of them.

:::

### Piecewise Functions with `cases`

A function defined differently across a few conditions needs its branches aligned under one shared brace, which is exactly what the `cases` environment is for.

::: {.general title="Usecase of `cases`"}

```latex
\[
    f(x) =
    \begin{cases}
        x^2  & \text{if } x \geq 0 \\
        -x^2 & \text{if } x < 0
    \end{cases}
\]
```
::: nuance

Note the `\text{}` around "if". 
Without it, "if" renders in italic math font as though it were two multiplied variables ($i$ times $f$) and it'll look wrong and read worse. 
Any plain-English word inside math mode needs `\text{}` around it.

:::

:::

### Multi-Step Derivations

A derivation that unfolds over several lines needs every line aligned at the same operator, and a choice about whether each intermediate step gets its own equation number.

::: worked

```latex
\documentclass{article}

\begin{document}
    \begin{align}
    (a+b)^2 &= (a+b)(a+b)           \\
            &= a^2 + ab + ba + b^2  \\
            &= a^2 + 2ab + b^2
    \end{align}
\end{document}
```

:::

::: important

`align` numbers every line by default. 
If you only want the *final* line numbered, wrap a `split` block inside a single `equation` instead:

:::

::: worked

```latex
\begin{equation}
    \begin{split}
    (a+b)^2 &= (a+b)(a+b)     \\
        &= a^2 + ab + ba + b^2 \\
        &= a^2 + 2ab + b^2
    \end{split}
\end{equation}
```

Use `align*` (with an asterisk) if you want *no* line numbered at all — the same starred-variant pattern as `\section*{}` from Ch. 5, applied here to equations.

:::

### Controlling Fraction Size

A fraction's default size depends on whether it's inline or in a display equation, and three commands exist for overriding that default in either direction.

::: nuance

**`\tfrac`, `\dfrac`, and `\displaystyle`**

A fraction's size normally depends on context: `$\frac{1}{2}$` written inline renders small and compact to fit the line; the same `\frac{1}{2}` inside a display equation (`\[...\]`, `equation`, `align`) renders larger, in what's called "display style." Three commands (all from `amsmath`) let you override that default in either direction:

- **`\displaystyle`** forces display-style sizing even inline — `$\displaystyle\frac{1}{2}$` renders full-size in the middle of a sentence. Useful occasionally, but can disrupt line spacing if overused.
- **`\dfrac{}{}`** is shorthand for exactly that, applied just to one fraction: `\dfrac{1}{2}` always renders at display size, wherever it's used.
- **`\tfrac{}{}`** is the opposite shorthand: always renders at the smaller, inline ("text style") size, even inside a display equation — handy for a small fraction that would otherwise look oversized as part of a larger expression.

:::

### Delimiter Sizing

`\left`/`\right` auto-sizing is convenient but not always the right call — a simple fraction wrapped in it often ends up more oversized than the expression actually needs.

::: nuance

**Size Matters: delimiter sizing**

`\left(` and `\right)` auto-size to match their contents — convenient, but easy to overdo. Wrapping a simple fraction in `\left( \right)` often produces oversized, over-spaced parentheses:

```latex
% often too large / spaced-out for something this simple
$\left( \frac{1}{2} \right)$

% better: a manual, smaller, tighter size
$\bigl( \tfrac{1}{2} \bigr)$
```
The manual sizing commands, from smallest to largest, are `\bigl`/`\bigr`, `\Bigl`/`\Bigr`, `\biggl`/`\biggr`, `\Biggl`/`\Biggr` (each pair is the left/right delimiter respectively). Pick whichever size actually matches your content instead of defaulting to `\left`/`\right` every time. Note the deliberate use of `\tfrac` rather than `\frac` here too — per the nuance above, it keeps the fraction at its natural compact size instead of forcing display-style sizing into an already-tight expression.

:::

### One-Sided Delimiters

Showing a function evaluated between two bounds needs a tall bar on the right and deliberately nothing on the left to match it.

::: nuance

**one-sided delimiters: `\left. ... \right|`**

Evaluating a function or antiderivative between two bounds needs a vertical bar sized to match the expression's height, but nothing on the left side to match it:

```latex
\[
    \int_0^1 x \, dx = \left. \frac{x^2}{2} \right|_{0}^{1} = \frac{1}{2}
\]
```
`\left.` (a left delimiter followed immediately by a period) tells LaTeX "size the right delimiter to match, but draw nothing on the left." `\right|` then draws a properly sized vertical bar, with the bounds as its subscript/superscript (`_{0}^{1}`). This is the standard way to show a function evaluated at bounds — you'll use it constantly whenever a derivation is followed by "evaluated from $a$ to $b$."

:::

### Math Spacing

LaTeX doesn't insert any breathing room around math operators or differentials on its own — everything you see spaced out in a polished equation was spaced out on purpose.

::: nuance

**Math spacing: `\,` and `\!`**

Differentials in integrals look cramped without a small gap before them:
```latex
% cramped — the "dx" runs right into "x"
$\int_0^1 x dx$

% correct — a thin space before the differential
$\int_0^1 x \, dx$
```
`\,` inserts a thin space; `\!` inserts a *negative* thin space (pulls two elements closer together) — useful for tightening nested exponents or an overly loose double integral. These are small, cosmetic details, but exactly the kind that make a derivation look deliberately typeset rather than dumped from a text editor.

:::

::: exercise

1. Typeset the coefficient matrix and right-hand-side vector of a 2-equation linear system as a single matrix equation, using `pmatrix`.
2. Typeset a 3-branch piecewise function with `cases`, remembering `\text{}` around any English words.
3. Take one `\left( \right)` expression (your own, or from Ch. 9's exercises) and rewrite it using `\bigl`/`\bigr` instead — compare the rendered size.
4. Revisit the integral from Ch. 9's exercise 1 ($\int_0^\infty e^{-x} dx = 1$) and add the thin space: $\int_0^\infty e^{-x} \, dx = 1$.
5. Typeset $\int_0^2 x^2 \, dx = \left. \dfrac{x^3}{3} \right|_{0}^{2} = \dfrac{8}{3}$ using `\left.`/`\right|`.

:::

::: capstone

Add a real derivation relevant to your capstone topic (2–4 steps is plenty) using `align` or `split`, and tighten the spacing around any integrals or products with `\,`.

:::

---

*End of Part 3 (Ch. 9–10). Next: Part 4 — Math Structures & Algorithms (Ch. 11–12).*
