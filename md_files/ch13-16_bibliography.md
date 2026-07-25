# Part 5: Bibliography & Citation Tools (Chapters 13–16)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

---

## Chapter 13 — Managing References with BibTeX/BibLaTeX

::: objective

Store citations in a `.bib` database file instead of typing them by hand, and understand the two competing citation systems (BibTeX and BibLaTeX) well enough to avoid the single most common cause of "my citations aren't showing up" panic.

:::

### Where do `.bib` entries actually come from?
Before diving into syntax: you're not expected to hand-type every field of every reference. Most literature databases will generate a ready-made BibTeX entry for you — you just copy-paste it into your `.bib` file. A few of the major ones:

- **arXiv** (arxiv.org) — the standard preprint server across physics, astronomy, math, and CS. On any paper's abstract page, look for an "Export citation" or "Export Bibtex Citation" link.
- **NASA ADS** (Astrophysics Data System, ui.adsabs.harvard.edu) — the standard literature search engine specifically for astronomy and astrophysics. Every record has an "Export Citation" button with a BibTeX option, and you can export an entire library at once.
- **Google Scholar** (scholar.google.com) — cross-field, not always as complete or accurate as a dedicated database, but broadly available. Click "Cite" under any result, then "BibTeX."
- **Field-specific alternatives:** INSPIRE-HEP for particle physics, PubMed/PubMed Central for biology and medicine, IEEE Xplore or the ACM Digital Library for CS/engineering.
- **Journal publisher websites** (ACS, IEEE, Springer, Elsevier, etc.) — the published (not preprint) version usually has a "Cite this article" or "Export citation" link with a BibTeX option directly on the article page.
- **Crossref** (via DOI) — if you only have a paper's DOI, `https://api.crossref.org/works/{DOI}` can return citation metadata. More technical than the sources above; only worth it if the other options don't have the paper.
- **JabRef** (jabref.org) — a free desktop app that manages a `.bib` file directly, rather than exporting from somewhere else. Paste in a DOI and JabRef fetches the full entry for you automatically, cleans up formatting, and lets you edit fields in a proper interface instead of hand-editing raw BibTeX text. Particularly handy once your `.bib` file has grown past a handful of entries and needs organizing.
- **Your own Zotero/Mendeley library** — covered in full in Ch. 15, but worth knowing now: once you've built a library there, exporting it to `.bib` is a single click.

Not every field or journal indexes through ADS specifically — it's an astronomy/astrophysics-specific tool. If your field isn't astronomy, arXiv (if your subfield uses it) or your field's own major database is the more likely first stop; Google Scholar works as a fallback across almost any field.

**A word of caution:** exported BibTeX entries aren't always clean. Fields get mangled by an odd export bug, DOIs are sometimes missing, author name formatting can be inconsistent between sources. Treat an exported entry as a solid starting point, not a guarantee — skim it before you trust it.

::: worked

**BibTeX (the classic system)**

```latex
% mybib.bib
@article{einstein1905,
  author  = {Einstein, A.},
  title   = {Zur Elektrodynamik bewegter K{\"o}rper},
  journal = {Annalen der Physik},
  year    = {1905},
  volume  = {322},
  number  = {10},
  pages   = {891--921}
}
```
```latex
% main.tex
\documentclass{article}
\usepackage{natbib}

\begin{document}

Einstein's original formulation \citep{einstein1905} remains
foundational.

\bibliographystyle{plain}
\bibliography{mybib}

\end{document}
```
`\cite{einstein1905}` (built into LaTeX) or `\citep{einstein1905}`/`\citet{einstein1905}` (from `natbib`, giving parenthetical vs. textual citation forms) pull the entry from `mybib.bib`. `\bibliographystyle{plain}` sets the formatting; `\bibliography{mybib}` (no `.bib` extension) points to the database file.

:::

::: worked

**BibLaTeX (the modern alternative)**

```latex
\documentclass{article}
\usepackage[backend=biber,style=numeric]{biblatex}
\addbibresource{mybib.bib}

\begin{document}

Einstein's original formulation \cite{einstein1905} remains
foundational.

\printbibliography

\end{document}
```
Same `.bib` file, different loading mechanism: `\usepackage{biblatex}` plus `\addbibresource{}` instead of `\bibliography{}`, and `\printbibliography` instead of `\bibliographystyle`+`\bibliography`. `biblatex` is more actively maintained and flexible (easier style-switching, better Unicode support); BibTeX+`natbib` is still extremely common, especially in older journal templates.

**Rule of thumb:** if a journal template already uses `natbib`, stick with it — don't swap systems mid-template. Starting a document from scratch with no imposed style? `biblatex` is the more modern default choice.

:::

::: nuance

**the citation commands you'll actually use**

`\cite{}` isn't the only citation command, and picking the right one changes how the citation reads in a sentence. Here are the ones you'll reach for most:

| What you want | natbib | biblatex | Renders roughly as |
|---|---|---|---|
| Parenthetical citation | `\citep{key}` | `\parencite{key}` | "...is well established (Smith, 2020)." |
| Textual/narrative citation | `\citet{key}` | `\textcite{key}` | "Smith (2020) showed that..." |
| Just the author name(s) | `\citeauthor{key}` | `\citeauthor{key}` | "Smith" |
| Just the year | `\citeyear{key}` | `\citeyear{key}` | "2020" |
| Plain `\cite` | `\cite{key}` | `\cite{key}` | Behavior depends on your chosen style — don't assume it looks the same as `\citep`/`\citet` |

In practice, `\citep`/`\parencite` and `\citet`/`\textcite` cover the large majority of citations you'll ever write — reach for those two first, and only look up the rest as a specific sentence needs them.

:::

::: nuance

**adding a page number or note — prenotes and postnotes**

Both systems accept up to **two** optional arguments in square brackets before the citation key:
```latex
\citep[p.~5]{einstein1905}
% -> (Einstein, 1905, p. 5)

\citep[see][p.~5]{einstein1905}
% -> (see Einstein, 1905, p. 5)
```
With one optional argument, it's treated as the **postnote** (typically a page or chapter reference) appended after the citation. With two, the first is the **prenote** (a word like "see" or "cf." placed before the citation) and the second is the postnote. This is the second optional argument Ali was trying to recall — `\cite[prenote][postnote]{key}`.

**A common mistake, using your own example as the case study:** `\cite[Good paper here]{Kaneko et al. 2006}` has two problems, both worth catching early:
1. The argument inside `{}` must be the `.bib` file's citation **key** (e.g. `kaneko2006`), not the human-readable author/year text. LaTeX has no way to look up "Kaneko et al. 2006" — it needs the exact key you defined in your `.bib` entry.
2. The bracketed text becomes a literal postnote printed after the citation — `\cite[Good paper here]{kaneko2006}` would render as something like "(Kaneko et al., 2006, Good paper here)," which is valid syntax but probably not the intent. Postnotes are conventionally short (a page number, "p. 12", "chap. 3"), not descriptive commentary about the paper.

The corrected version, assuming a page reference was actually intended:
```latex
\citep[p.~12]{kaneko2006}
% -> (Kaneko et al., 2006, p. 12)
```

:::

::: nuance

**useful `natbib` package options**

A few `\usepackage[...]{natbib}` options control the most common formatting decisions:
```latex
\usepackage[numbers,sort]{natbib}
```

- `numbers` — switches citations to numeric style (`[1]`, `[2]`) instead of the default author-year style.
- `sort` — sorts the keys inside a single multi-citation call (e.g. `\citep{a,b,c}`) into the order they appear in your bibliography, rather than the order you happened to type them.
- `sort&compress` — does what `sort` does, *and* collapses consecutive numeric citations into a range (`[1,2,3]` becomes `[1-3]`). Only meaningful when combined with `numbers`. Note the exact spelling: it's `sort&compress` (one combined option with an ampersand) — there's no separate standalone `compress` or `compact` option in natbib.

:::

### The Compiler Decision Tree

::: nuance

**the compiler decision tree**

This single setting causes more "citations show up as `[?]`" panic than anything else in this guide:

- Using `\bibliography{...}` (the classic system)? Set Overleaf's compiler to run **BibTeX**.
- Using `\usepackage{biblatex}` + `\addbibresource{...}`? Set Overleaf's compiler to run **Biber**.
- Seeing "No citation found" or `[?]` in your PDF? It's almost always this exact mismatch — check Overleaf's compiler dropdown before anything else.

:::

::: nuance

**citing a webpage or software**

Citing a tool, dataset, or website doesn't fit neatly into "article" or "book," but comes up constantly in research. With `biblatex`, use the `@online` entry type:
```latex
@online{comsol2023,
  author = {{COMSOL AB}},
  title  = {Heat Transfer Module User's Guide},
  year   = {2023},
  url    = {https://www.comsol.com/heat-transfer-module},
  note   = {Accessed: 2026-07-10}
}
```
With plain BibTeX, `@online` isn't a standard type — use `@misc` instead, moving the URL into `howpublished`:
```latex
@misc{comsol2023,
  author       = {{COMSOL AB}},
  title        = {Heat Transfer Module User's Guide},
  year         = {2023},
  howpublished = {\url{https://www.comsol.com/heat-transfer-module}},
  note         = {Accessed: 2026-07-10}
}
```
Either way, include an access-date `note` — web content changes or disappears, and reviewers may ask when you retrieved it. Make sure `\usepackage{url}` or `hyperref` (already loaded from Ch. 8) is present so `\url{}` renders instead of erroring.

:::

::: nuance

**not everyone uses a `.bib` file at all**

BibTeX/BibLaTeX are the right tool once you have more than a handful of references, but they're not the only option. Many mathematicians (and anyone writing a short paper with only a few citations) skip `.bib` files entirely and type the bibliography directly with `thebibliography` and `\bibitem`:

```latex
\begin{thebibliography}{9}

\bibitem{einstein1905}
A.~Einstein,
\emph{Zur Elektrodynamik bewegter K\"orper},
Annalen der Physik \textbf{322} (1905), no.~10, 891--921.

\bibitem{riemann1859}
B.~Riemann,
\emph{\"Uber die Anzahl der Primzahlen unter einer gegebenen Gr\"osse},
Monatsberichte der Berliner Akademie (1859).

\end{thebibliography}
```
You still cite these exactly the same way — `\cite{einstein1905}` works whether that key comes from a `.bib` file or a `\bibitem`. The `{9}` argument in `\begin{thebibliography}{9}` isn't a count of your references — it's a placeholder LaTeX uses to figure out how wide the numbering column should be (use `{9}` for up to 9 references, `{99}` for up to 99, and so on).

The trade-off: `thebibliography` is entirely manual — no database, no automatic sorting, no one-line style switching like Ch. 14 covers. You format and order every entry by hand, and changing citation style later means retyping the list yourself. That's fine for a short paper with a handful of references; it stops scaling once you're managing dozens or hundreds of citations across a thesis, which is exactly where BibTeX/BibLaTeX earn their keep.

:::

::: exercise

1. Build a `.bib` file with 5 references relevant to your field, pulled from arXiv/ADS/Google Scholar's export feature rather than typed by hand — or use the ready-made starter file for your capstone topic in `supplementary_materials.md` ("Ch. 13 — Starter `.bib` Files for the 4 Capstone Topics").
2. Make sure at least one entry is an `@online` (biblatex) or `@misc` (BibTeX) web/software citation.
3. Cite 3 of your 5 references in a short paragraph, and confirm your Overleaf compiler (BibTeX or Biber, matching your `\bibliography`/`biblatex` choice) is set correctly.
4. Optional: rewrite 2 of your 5 references as `\bibitem` entries in a `thebibliography` block instead, and cite them the same way — compare the manual effort against the `.bib` approach.

:::

::: capstone

Add your topic's starter `.bib` file (or your own 5 references) to your capstone project, and cite 3 sources in your paper's introduction — including the online/software reference.

:::

---

## Chapter 14 — Citation Styles for Journals & Conferences

::: objective

Switch between citation styles (numeric vs. author-year, IEEE vs. APA) without manually reformatting a single citation by hand.

:::

::: worked

**switching styles with BibTeX**

```latex
\bibliographystyle{plain}   % numeric, alphabetical by first author
\bibliographystyle{ieeetr}  % numeric, in order of first citation (IEEE)
\bibliographystyle{apalike} % author-year, APA-like
```
Change one word — the `\bibliographystyle{}` argument — and every citation and the entire reference list reformats automatically. This is the whole point of managing references through a `.bib` database instead of typing them by hand: formatting is separated from data.

:::

::: worked

**switching styles with BibLaTeX**

```latex
\usepackage[backend=biber,style=numeric]{biblatex}    % [1], [2], ...
\usepackage[backend=biber,style=authoryear]{biblatex}  % (Smith, 2020)
\usepackage[backend=biber,style=ieee]{biblatex}        % IEEE numeric
```
Same idea: the `style=` option controls formatting, independent of your citation data. (`style=ieee` requires the separate `biblatex-ieee` package, freely available on Overleaf/CTAN.)

:::

::: nuance

**journal-specific `.cls` and `.bst` files**

Most journals provide an official LaTeX template — a `.cls` (document class) and often a `.bst` (bibliography style) file specific to their house style. When you use one, it typically already sets `\bibliographystyle{}` (or the `biblatex` `style=`) for you — don't override it, even if the citations look unfamiliar. Journal submission systems check for exact compliance with their own style file.

:::

::: exercise

Take the 3 citations from Ch. 13's exercise and reformat them under two different styles — one numeric (`plain` or `ieeetr`), one author-year (`apalike`, or `authoryear` if using biblatex) — and compare how both the in-text citations and the reference list change.

:::

::: capstone

Pick the citation style appropriate for a real or hypothetical target journal in your field, switch to it, and confirm your paper still compiles cleanly with all citations resolving correctly.

:::

---

## Chapter 15 — Reference Managers + Overleaf

::: objective

Manage a growing reference library in Zotero or Mendeley, and keep it in sync with your Overleaf project's `.bib` file instead of retyping entries by hand.

:::

::: worked

**Zotero → Overleaf**

1. In Zotero, select the references you want, right-click → **Export Items** → format **BibTeX** → save as `references.bib`.
2. In Overleaf, upload `references.bib` into your project (or use Overleaf's built-in reference-sync integration, which can pull an entire Zotero/Mendeley library in automatically).
3. Reference the file exactly as in Ch. 13: `\bibliography{references}` (BibTeX) or `\addbibresource{references.bib}` (biblatex).

Mendeley works the same way in principle: **File → Export** → BibTeX format.

:::

::: nuance

**JabRef as a lighter, `.bib`-native alternative**

Zotero and Mendeley are general-purpose reference managers that happen to export to `.bib`. If you'd rather work with your `.bib` file directly instead of managing a separate library and exporting from it, **JabRef** (mentioned in Ch. 13) is built specifically around `.bib` files — there's no export step at all, since the `.bib` file *is* the library. Paste in a DOI, JabRef fetches and adds the entry; save, and your `.bib` file is already up to date. Upload that file to Overleaf the same way as any other `.bib` file from this chapter.

:::

::: nuance

**keep your citation keys stable**

When you re-export from Zotero/Mendeley after adding new references, existing keys (the `einstein1905`-style identifiers) can sometimes shift depending on export settings. If citations that used to work suddenly show `[?]` after a re-export, check whether the key you're citing in your `.tex` file still matches the key in the freshly exported `.bib` file — this is a sync issue, distinct from Ch. 13's compiler-mismatch nuance.

:::

::: exercise

Set up a Zotero (or Mendeley) library with at least 5 references, export it as a `.bib` file, and cite 3 of them in a scratch Overleaf project.

:::

::: capstone

Import a real reference library relevant to your capstone topic (even a small starter one) via Zotero/Mendeley export, replacing or supplementing the starter `.bib` file from Ch. 13.

:::

---

## Chapter 16 — Glossaries, Nomenclature & Acronyms

::: objective

Define acronyms and symbols once, reference them everywhere with a single command, and generate an automatic glossary/nomenclature list.

:::

::: worked

**the `glossaries` package**

```latex
\usepackage[acronym]{glossaries}
\makeglossaries

\newacronym{cnn}{CNN}{Convolutional Neural Network}
\newacronym{rnn}{RNN}{Recurrent Neural Network}

\begin{document}

A \gls{cnn} was used for image classification, while a \gls{rnn}
handled the sequential data. Later uses of the same terms — another
\gls{cnn} here — automatically stay abbreviated.

\printglossary[type=\acronymtype]

\end{document}
```
`\gls{cnn}` automatically expands to "Convolutional Neural Network (CNN)" the *first* time it's used, then just "CNN" every time after — no manual tracking of "have I defined this yet?" required. `\printglossary[type=\acronymtype]` generates the acronym list.

:::

::: nuance

**define once, reference with `\gls`**

The entire point of this package is that each acronym lives in one place. Decide halfway through writing that a term should be worded differently, or need to rename it? Fix the single `\newacronym{}` line — every `\gls{}` call updates automatically. Hand-typing "Convolutional Neural Network (CNN)" every time you first mention it in a new section is exactly the find-and-replace nightmare this package exists to prevent.

:::

::: worked

**a nomenclature/symbols list**

A symbols list is a *separate* glossary from your acronyms, so it needs its own declared type before you can define entries into it or print it on its own:
```latex
\usepackage[acronym]{glossaries}
\newglossary[slg]{symbols}{sym}{sbl}{List of Symbols}
\makeglossaries

\newglossaryentry{lambda}{
  type=symbols,
  name={$\lambda$},
  description={decay constant},
  sort={lambda}
}
```
```latex
Referenced in text: \gls{lambda} controls the rate of decay.
```
The same `glossaries` machinery handles a symbols list, not just acronyms — useful for a thesis's "List of Symbols" front matter. The `type=symbols` key is what routes this entry into the symbols glossary instead of the default one.

:::

::: nuance

**printing acronyms and symbols separately**

`\printglossary[type=\acronymtype]` (shown above) only prints the acronym list. If you've also defined a `symbols` type as above, print it with its own call:
```latex
\printglossary[type=\acronymtype, title={List of Acronyms}]
\printglossary[type=symbols, title={List of Symbols}]
```
Calling plain `\printglossary` with no `type` prints only the *default* glossary (neither acronyms nor your custom `symbols` type) — a common source of "why is my list empty?" confusion. Always match the `type=` in `\printglossary` to whatever `type=` you used when defining the entries.

:::

::: nuance

**compiling glossaries needs an extra step**

Unlike most packages, `glossaries` requires an additional compilation step beyond pdfLaTeX/XeLaTeX — a helper program (`makeglossaries`) that builds the sorted glossary file. Overleaf handles this automatically in most templates; if your glossary or acronym list shows up empty, that extra step not running is the first thing to check.

:::

::: exercise

Build a glossary of 8 acronyms or symbols relevant to your field using `\newacronym`/`\newglossaryentry`, use at least 3 of them with `\gls{}` in a short paragraph (including one repeated use, to see the auto-abbreviation behavior), and print the list. *(A quick-reference table of `\printglossary` scenarios is in `supplementary_materials.md` — "Ch. 16 — Glossary Printing Command Reference," if you want it side by side while working.)*

:::

::: capstone

Add an acronym list and/or a nomenclature table to your capstone paper for any recurring abbreviations or symbols in your topic, and print it as front matter.

:::

---

*End of Part 5 (Ch. 13–16). Next: Part 6 — Diagrams & Data Visualization (Ch. 17–18).*
