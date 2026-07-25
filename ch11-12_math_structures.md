# Part 4: Math Structures & Algorithms (Chapters 11–12)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

Where Part 3 was about everyday math notation, this part is about *structured blocks*: formally stated theorems/proofs, and algorithm pseudocode.

---

## Chapter 11 — Theorems, Definitions, Proofs (amsthm)

::: objective

Define reusable, numbered environments for theorems, lemmas, and definitions, and typeset proofs with the standard end-of-proof marker.

:::

::: worked

**defining and using a theorem**

```latex
\documentclass{article}
\usepackage{amsthm}
\usepackage{amsmath}

\newtheorem{theorem}{Theorem}

\begin{document}

\begin{theorem}
\label{thm:pythagoras}
For a right triangle with legs $a$, $b$ and hypotenuse $c$,
$a^2 + b^2 = c^2$.
\end{theorem}

\begin{proof}
Consider a square of side $a+b$ built from four copies of the
triangle arranged around a central square of side $c$. Comparing
areas gives $(a+b)^2 = c^2 + 4 \left(\tfrac{1}{2}ab\right)$, which
simplifies to $a^2 + b^2 = c^2$.
\end{proof}

\end{document}
```
`\newtheorem{theorem}{Theorem}` creates the `theorem` environment and tells LaTeX to label instances "Theorem 1," "Theorem 2," and so on. The `proof` environment comes built into `amsthm` — no `\newtheorem` needed for it — and automatically appends the end-of-proof symbol (∎) when you close it.

:::

::: nuance

**two brackets, two very different meanings**

`\newtheorem` takes an optional bracketed argument, but its meaning depends entirely on *where* the bracket goes — a genuinely easy pair to mix up. Here are both patterns as complete, copy-adaptable preambles:

```latex
% Option A: shared counter (one running number across all theorem types)
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
% Result: Theorem 1, Lemma 2, Corollary 3, Theorem 4, ...

% Option B: per-section numbering (resets every time a new section starts)
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}              % still shares theorem's counter
\newtheorem{definition}{Definition}[section]    % its own counter, also per-section
% Result (inside Section 1): Theorem 1.1, Lemma 1.2, Definition 1.1
% Result (inside Section 2): Theorem 2.1, ...
```
`[theorem]` placed right after `\newtheorem{lemma}` means "share *this* counter with the `theorem` environment already defined." `[section]` placed at the very end means "reset my own counter every time a new section starts, and prefix it with the section number." Same syntax shape, opposite purpose — read carefully before copying either pattern. Note in Option B that `lemma` can share `theorem`'s per-section counter *and* inherit its section-prefixed numbering automatically — you don't need to add `[section]` to `lemma` itself.

:::

::: nuance

**theorem styles (`\theoremstyle`)**

`amsthm` ships three built-in visual styles, declared with `\theoremstyle{...}` *before* the `\newtheorem` calls it should apply to:

```latex
\usepackage{amsthm}

% plain: bold heading, italic body — the default, for theorems/lemmas
\theoremstyle{plain}
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}[theorem]{Lemma}

% definition: bold heading, upright body — for definitions/examples
\theoremstyle{definition}
\newtheorem{definition}{Definition}
\newtheorem{example}{Example}

% remark: italic heading, upright body — for remarks/notes
\theoremstyle{remark}
\newtheorem{remark}{Remark}
```
The style you pick is a visual signal to the reader: `plain` says "this is a formal claim that gets proved," `definition` says "this is stating what a term means," `remark` says "this is context, not something requiring proof." Everything after a `\theoremstyle{...}` call uses that style until you declare a different one — that's why the three blocks above are ordered the way they are.

:::

::: worked

**definitions**

```latex
\newtheorem{definition}{Definition}
...
\begin{definition}
\label{def:convergence}
A sequence $(x_n)$ \emph{converges} to $L$ if for every
$\varepsilon > 0$ there exists $N$ such that $|x_n - L| < \varepsilon$
for all $n > N$.
\end{definition}
```
`definition` environments work exactly like `theorem` — they're just conventionally styled differently, per the `\theoremstyle` nuance above, since they're stating a term rather than a provable claim.

:::

::: nuance

**`\qedhere` for proofs ending in a displayed equation**

The `proof` environment's automatic ∎ symbol normally lands at the end of the last line. But if a proof ends with a displayed equation (`equation`, `align`, `\[...\]`), the ∎ can get pushed down to its own line by itself, floating awkwardly. Fix it by adding `\qedhere` right inside that final display:

```latex
\begin{proof}
Expanding and simplifying,
\[
  (a+b)^2 = a^2 + 2ab + b^2. \qedhere
\]
\end{proof}
```
`\qedhere` tells `amsthm` to place the ∎ symbol on this line instead of pushing a new one below.

:::

::: exercise

1. Define a `lemma` environment sharing the `theorem` counter, using the `[theorem]` syntax above.
2. State and prove a small lemma of your choosing (even a simple one, e.g. "the sum of two even integers is even") using your new environment and the built-in `proof` environment.
3. Cross-reference your lemma from a sentence elsewhere in the document using `\cref` (from Ch. 8) — confirm the number matches.

*Don't have a lemma in mind? `supplementary_materials.md` has a short bank of simple, classic theorems ("Ch. 11 — Simple Theorem Bank for Beginners") to pick from instead of inventing one from scratch. If you'd like to check your work against a solved reference afterward (not before — try it yourself first), exercise 2's exact suggested example is fully solved there too ("Ch. 11 — Exercise 2, Solved").*

:::

::: capstone

State one assumption or definition from your capstone topic formally, using a `definition` environment you define with `\newtheorem`.

:::

---

## Chapter 12 — Algorithms & Pseudocode

::: objective

Typeset a method or procedure as numbered, captioned pseudocode that can be referenced from your text like any other float.

:::

::: worked

**`algorithm2e`**

```latex
\usepackage[ruled,vlined]{algorithm2e}

\begin{algorithm}[htbp]
\caption{Gradient Descent}
\label{alg:gd}
\KwIn{learning rate $\eta$, initial point $x_0$, tolerance $\epsilon$}
\KwOut{approximate minimizer $x^*$}
$x \leftarrow x_0$\;
\While{$|\nabla f(x)| > \epsilon$}{
  $x \leftarrow x - \eta \nabla f(x)$\;
}
\Return{$x$}
\end{algorithm}
```
`\KwIn{}`/`\KwOut{}` label inputs and outputs, `\While{condition}{body}` handles loops, and `\;` marks the end of a pseudocode line (like a semicolon ending a line of real code). The outer `algorithm` environment behaves like the floats from Ch. 7 — `[htbp]` placement rules and captions work exactly the same way.

:::

### Reference: common `algorithm2e` commands
| Command | Purpose |
|---|---|
| `\KwIn{...}` | Input declaration |
| `\KwOut{...}` | Output declaration |
| `\While{cond}{body}` | While loop |
| `\For{cond}{body}` | For loop |
| `\If{cond}{body}` | Conditional branch |
| `\Else{body}` | Else branch |
| `\ElseIf{cond}{body}` | Else-if branch |
| `\Return{value}` | Return statement |
| `\;` | End of pseudocode line (see nuance below) |

The worked example above only exercises three of these (`\KwIn`, `\KwOut`, `\While`). Rather than manufacture an example for every remaining row, `supplementary_materials.md` ("Ch. 12 — Full Working Examples") has two short algorithms that between them put almost everything else in this table to use — `\For`, `\If`/`\ElseIf`/`\Else`, `\Return`. Anything left over is worth looking up directly in the package docs at this point.

::: nuance

**the `\;` line terminator**

Every line of pseudocode in `algorithm2e` should end with `\;`. This is the most common `algorithm2e` stumble: forget it, and LaTeX doesn't error out — it just runs the next statement onto the same visual line, so your pseudocode reads like a run-on sentence instead of a numbered procedure. If your algorithm compiles cleanly but looks visually wrong (lines mashed together that should be separate), a missing `\;` is the first thing to check.

:::

::: nuance

**what `ruled` and `vlined` actually do**

The worked example above loads `algorithm2e` as `\usepackage[ruled,vlined]{algorithm2e}` — two commonly used, optional formatting flags:

- **`ruled`** draws a horizontal rule at the top and bottom of the algorithm block, similar to how a table caption sits above `\toprule`/`\bottomrule` in Ch. 6.
- **`vlined`** draws vertical lines connecting the start and end of each loop/conditional block, making nested control flow easier to scan visually.

Both are optional — plain `\usepackage{algorithm2e}` works fine — but most published pseudocode uses at least `ruled`.

:::

::: nuance

**don't load both algorithm packages at once**

Two competing package families exist for this: `algorithm` + `algorithmic` (older, minimal) and `algorithm2e` (newer, more batteries-included, different command syntax). They define overlapping commands, so loading both in the same preamble produces confusing "already defined" errors. Pick one per document. This guide uses `algorithm2e` throughout, since its `\KwIn`/`\KwOut`/`\While`/`\For` syntax reads closer to plain English for a beginner — but you may encounter journal templates that specifically expect the other pair.

:::

::: worked

**the `algorithm` + `algorithmic` alternative (for reference)**

If a target journal's template specifically requires the older combination instead:
```latex
\usepackage{algorithm}
\usepackage{algorithmic}

\begin{algorithm}
\caption{Gradient Descent}
\label{alg:gd-alt}
\begin{algorithmic}
\STATE $x \leftarrow x_0$
\WHILE{$|\nabla f(x)| > \epsilon$}
  \STATE $x \leftarrow x - \eta \nabla f(x)$
\ENDWHILE
\RETURN $x$
\end{algorithmic}
\end{algorithm}
```
Same result, different syntax (`\STATE`, `\WHILE`/`\ENDWHILE` instead of algorithm2e's more concise brace blocks). Whichever pair you use, don't mix the two.

:::

::: nuance

**`algorithm2e` and `hyperref` can clash — follow the Golden Load Order**

`algorithm2e` has a documented history of caption/numbering quirks when combined with `hyperref` (loaded back in Ch. 8). If your algorithm's caption number looks wrong or its cross-reference doesn't match, double check you're following Ch. 8's Golden Load Order: load `algorithm2e` (like most content packages) *before* `hyperref`, with `hyperref` and then `cleveref` loaded last. This is the same rule already established in Ch. 8, just worth re-confirming here since it's the specific pairing that surfaces the problem most often.

:::

::: exercise

Typeset pseudocode for a method relevant to your own field (a simplified version is fine) using `algorithm2e`. Include at least one input/output declaration, one loop (`\While` or `\For`), and one conditional (`\If`/`\Else`).

:::

::: capstone

Add a methods algorithm block to your capstone paper describing the core procedure behind your topic (an experimental protocol, a numerical method, a computational pipeline — whatever fits), captioned and labeled so it can be cross-referenced from your text.

:::

---

*End of Part 4 (Ch. 11–12). Next: Part 5 — Bibliography & Citation Tools (Ch. 13–16).*
