### Status — Work in Progress

**Only Chapters 1–9 (Parts 1–3) are fully furnished** — polished, complete, and ready to read.

**Chapter 10 is currently being reworked** — design decisions, headings, and section-level content are actively being revised.

**Chapters 11–23 (Parts 4–9), the Appendix, and the Supplementary Materials are drafted but not finished** — the instructional content is there, but it still needs fleshing out and structural/visual polish before it matches the standard of Chapters 1–9.

\clearpage
\thispagestyle{empty}
\clearpage

### LaTeX for Research Students: What it is?

This guide takes you from your first compiled document to a complete, submission-ready research paper.
It's written for students in STEM and other research fields who are new to LaTeX, and it assumes no prior experience — just a willingness to work through the examples and exercises as you go. A running capstone project threads through the chapters: starting in Chapter 4 you build one paper piece by piece, so that by the end you have both the knowledge and a finished document to show for it.

The material is organized into nine Parts (Chapters 1–23), followed by an Appendix of reference material and a Supplementary Materials file holding larger code samples and datasets referenced from the chapters.

\clearpage
\thispagestyle{empty}
\clearpage

# Part 1: Foundations & Capstone Kickoff (Chapters 1–4)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

## Chapter 1 — Why LaTeX for Research Writing

Every research document eventually raises the same question: why fight with markup and a compiler instead of just clicking bold in a word processor? It doesn't pay off for everything — but for the kind of writing this guide is aimed at, it pays off often enough that most STEM researchers end up using it sooner or later.

This chapter covers what LaTeX actually is, the concrete reasons researchers reach for it over Word, and — just as importantly — the cases where it isn't the right tool, so the choice to use it is deliberate rather than automatic.

::: objective

Understand what LaTeX actually is, why research papers and theses are so often written in it, and when it's the right tool for the job.

:::

### What LaTeX is
LaTeX is a *typesetting system*, not a word processor. Instead of clicking buttons to make text bold or center a heading, you write plain text with markup commands, and a compiler turns that markup into a formatted PDF. A Word document is WYSIWYG ("what you see is what you get"); a LaTeX document is closer to "what you *describe* is what you get."

::: worked

```latex
\documentclass{article}

\begin{document}
    Hello, research world.
\end{document}
```

::: nuance

Compiling this produces a properly typeset PDF page — margins, fonts, and spacing all handled by LaTeX's rules, not by you nudging things around manually.

:::

:::

### Why researchers reach for it

A handful of concrete advantages come up again and again once you've used it on a real project:

- **Math typesets beautifully and consistently.** An equation with nested fractions, summations, or matrices is a few lines of markup instead of a fight with an equation editor.
- **Long documents stay consistent.** Change the font size of every section heading in a 200-page thesis with one line, not 40 manual edits.
- **Bibliographies are managed, not typed.** Citations and reference lists are generated from a database file — add a source once, cite it anywhere (Part IV covers this in depth).
- **It's the default for most STEM journals.** Many journals provide official LaTeX templates (`.cls` files) and *prefer* or *require* LaTeX submissions.
- **Plain text plays well with version control.** A `.tex` file is just text, so tools like Git track meaningful changes (Ch. 21 picks this up).

### When Word might still be fine
LaTeX has a learning curve. For a one-page memo, a quick letter, or a document with no math and no references, Word (or Google Docs) will get you there faster. LaTeX pays off as documents get longer, more mathematical, and more collaborative — which describes most research writing, but not all writing.

*(Context chapter — no formal exercise. If you want a first taste, try compiling the snippet above once you reach Ch. 2.)*

## Chapter 2 — Setting Up Overleaf & Your First Document

Chapter 1 made the case for LaTeX in the abstract; this one gets an actual compiled PDF in front of you, which matters more than any argument for why the tool is worth learning.

This chapter covers creating an Overleaf account and project, compiling your first document, and two settings — compiler choice and "stop on first error" — that are easy to skip past but save real time once documents get more complex.

::: objective

Create an Overleaf account, start a project, understand the compile button, and produce your first compiled PDF.

:::

### Getting set up

1. Go to overleaf.com and create a free account (a university email often unlocks extra features).
2. Click **New Project → Blank Project**. This opens an editor pane (your `.tex` code) next to a PDF preview pane.
3. Click the green **Recompile** button. Overleaf runs the LaTeX compiler and renders the PDF on the right.

No local software install is required — this is why Overleaf is the recommended starting point for this guide.
Replace the default project content with:

::: worked

```latex
\documentclass{article}

\title{My First LaTeX Document}
\author{Your Name}
\date{\today}

\begin{document}

    \maketitle
    
    \section{Introduction}
    This is my first properly structured LaTeX document.
    It has a title, an author, a date, and a numbered section.

\end{document}
```

:::

Recompile, and you should see a title block (title, author, today's date) followed by a numbered section.
The `\maketitle` command is what actually renders the title/author/date you declared above it — forgetting this call is a common first mistake (nothing shows up even though you set a title).

### Choosing a Compiler

Overleaf's compiler choice quietly decides which packages even work, which is worth knowing before a font package mysteriously fails to compile.
It lets you choose the compiler under the project's **Menu → Compiler**. 
This matters more than it looks:

::: important

If you use the `fontspec` package to change fonts, you *must* compile with `XeLaTeX` or `LuaLaTeX` — `pdfLaTeX` can't process it.
If you don't need custom fonts, stick with `pdfLaTeX`; most journals require it for submission, and most packages assume it by default.

:::

### Stopping at the First Error

Left on Overleaf's default "Always compile," a single missing `$` can cascade into fifty confusing follow-on errors that all trace back to one broken line.

::: important

Open the **Recompile** dropdown (small arrow next to the button) and check **"Stop on first error."** 
Stopping at the first error tells you exactly which line broke — turn this on now, you'll thank yourself in Ch. 3.
The error LaTeX reports will likely point to the line *after* the missing brace (e.g., your `\author{...}` line), not the `\title{...}` line that's actually broken. 
This is normal — LaTeX doesn't realize a brace is unclosed until it hits the *next* command. 
When you see a strange error, always check the line above first.

:::

::: exercise

Create and compile a title page for a fictional paper:

1. Set a `\title{}`, two `\author{}` names separated by `\and`, and `\date{}`.
2. Add one section with two sentences of placeholder text.
3. Confirm "Stop on first error" is enabled, then deliberately delete the closing `}` on your title, and recompile — read the error message before fixing it.

:::

## Chapter 3 — Anatomy of a .tex File and Survival Debugging

Every `.tex` file you'll ever open — yours or someone else's — is built from the same two zones and the same handful of moving parts, so recognizing them on sight is what turns an unfamiliar file from intimidating into just another document.

This chapter covers that anatomy (preamble vs. body, document class, packages, options), plus the minimum debugging habits — reading the compile log, and compiling often — needed to survive your first real errors without panicking.

::: objective

Understand the parts of a `.tex` file (preamble vs. body, document class, packages) well enough to read *any* LaTeX file, and learn the minimum debugging skills to survive your first errors.

:::

### The two zones of every document

::: worked

```latex
\documentclass[12pt]{article}   % <- PREAMBLE starts here
\usepackage{amsmath}            %    packages, settings, custom commands
\usepackage{graphicx}           %    (nothing here is "printed")

\begin{document}                % <- BODY starts here
This text appears in the PDF.   %    everything you write here is rendered
\end{document}                  % <- document ends
```

:::

- **Preamble** (everything before `\begin{document}`): declares the document class, loads packages, and configures global settings. Nothing here appears in the output.
- **Body** (between `\begin{document}` and `\end{document}`): the actual content that gets typeset.
- **Document class** (`\documentclass{article}`): sets the overall document type (`article`, `report`, `book`, or a university/journal-specific class). It determines what section levels exist and how they're numbered.
- **Packages** (`\usepackage{...}`): each one adds a capability — `amsmath` for advanced math, `graphicx` for images, and so on. You'll accumulate a standard set of these as you go through this guide.

### Document Class & Package Options

Both `\documentclass` and `\usepackage` accept a bracketed list of options that tweak behavior without changing the class or package name itself — worth recognizing as one consistent syntax rather than memorizing each occurrence separately.

::: nuance

The `[12pt]` font size in `\documentclass[12pt]{article}` above, and the `[utf8]` option in `\usepackage[utf8]{inputenc}` later in this chapter, are both **options** — a comma-separated list in square brackets that configures how the class or package behaves, separate from the class/package name itself.

:::

::: {.general title="`documentclass' options"}

A few common `\documentclass` options worth knowing by name, even before you need them:

- **Font size**
  - `10pt` (the default if you omit this), `11pt`, `12pt` — sets the base text size for the whole document.
- **`twoside`/`oneside`**
  - Whether the document is meant for double-sided printing, which affects margins (alternating sides for binding) and page-parity behavior (Ch. 7's `\cleardoublepage`).
  - `article` and `report` default to `oneside`; only `book` defaults to `twoside`.
- **`twocolumn`**
  - Starts the entire document in two-column layout from the first page.
  - Ch. 20 covers switching mid-document with `\onecolumn`/`\twocolumn` instead, but if the *whole* document needs two columns, as most two-column journal templates do, setting it here as a class option is simpler than switching manually.
- **`draft`**
  - Speeds up compiling by replacing images with outlined boxes and flagging overfull lines with a black bar in the margin.
  - Useful while iterating on a long document; remove it before your final compile.

Multiple options are comma-separated: `\documentclass[12pt,twoside,draft]{report}`.

::::

### Character Encoding with `inputenc`

Typing an accented letter or a pasted "smart quote" directly into a pdfLaTeX source file needs one extra declaration before the compiler interprets it correctly instead of choking on it.

`\usepackage[utf8]{inputenc}` declares that your source `.tex` file is written in UTF-8 — this is what lets pdfLaTeX correctly interpret non-ASCII characters typed directly into the file (accented letters, "smart quotes" pasted from elsewhere, and so on). It's specific to pdfLaTeX: XeLaTeX and LuaLaTeX (Ch. 2's compiler nuance) are UTF-8-native by default and don't need it — loading `inputenc` alongside them is harmless, just redundant.

### Survival Basics: reading the log without panicking
When a document compile fails, Overleaf highlights the offending line and shows a message in the log panel below the editor. The two most common first errors:

| Message                      | Usual cause                                                                                |
|------------------------------|--------------------------------------------------------------------------------------------|
| `Undefined control sequence` | You typo'd a command name, or forgot to load the package that defines it                   |
| `Missing $ inserted`         | You used a math-only character (like `_` or `^`) outside math mode, or left a `$` unclosed |

**The habit that saves the most time:** compile *often* — after every few lines, not after writing a whole page. If something breaks, you know it's in the last few lines you added, not buried somewhere in 200 lines of text. Combined with "Stop on first error" from Ch. 2, this turns debugging from a hunt into a quick glance.

(This is deliberately the *minimum* survival kit. Ch. 22 returns to debugging in full depth once you've hit enough real errors to appreciate it.)

::: worked

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{graphicx}

\title{Anatomy of a LaTeX File}
\author{Your Name}

\begin{document}
    \maketitle
    
    \section{Preamble vs Body}
    Everything above this document's begin-document tag is configuration.
    Everything below it is content.

\end{document}
```

:::

This snippet compiles cleanly as-is.
The exercise below will have you introduce a deliberate error yourself, so you get practice diagnosing one rather than hunting for a phantom bug.

::: exercise

1. Build the document skeleton above from scratch (don't copy-paste) so the structure sticks.
2. Deliberately break it: remove the `\usepackage{graphicx}` line, then add `\includegraphics{}` anywhere in the body. Recompile and read the resulting `Undefined control sequence` error — this is exactly what it looks like when you use a command without loading the package that defines it.
3. Fix it (restore the `\usepackage{graphicx}` line), recompile, and confirm the PDF renders cleanly.

:::

## Chapter 4 — Capstone Kickoff: Choosing Your Topic & Project Setup

The first three chapters covered LaTeX in the abstract — what it is, how to compile it, what a file is made of. This chapter is where that knowledge turns into an actual, evolving document: you pick a topic and stand up a minimal project shell, and every chapter from here through Ch. 23 adds one more piece to it.

::: objective

Choose a capstone topic and set up the minimal, compiling project shell that every later chapter's Capstone Update will build onto.

:::

### The Capstone Project
Starting now, every remaining chapter (5 through 22) ends with a short **Capstone Update** — you apply that chapter's lesson directly to one evolving paper. By Ch. 23, you'll have assembled a complete, submission-formatted document built piece by piece.

### Step 1 — Pick a topic
Choose whichever of these four fits your field (or is closest to your own research — feel free to substitute your real topic once you're comfortable):

1. **Physics:** Thermal conductivity of graphene composites.
2. **CS/Math:** Convergence analysis of a gradient descent algorithm.
3. **Engineering:** Stress-strain analysis of a cantilever beam.
4. **Biology/Chem:** Reaction rate of enzyme kinetics.

Starter `.bib` files (5 dummy references each) for all four topics are provided in the guide's supplementary materials, so you'll have real citations to work with from Part IV onward regardless of which you pick.

### Step 2 — Set up the project shell
Create a fresh Overleaf project and start it with a minimal, honest skeleton — no content yet, just the scaffolding every later chapter will build onto:

::: worked

```latex
\documentclass[12pt]{article}
\usepackage[utf8]{inputenc}

\title{[Working Title — will be refined in Ch. 5]}
\author{Your Name}
\date{\today}

\begin{document}
    \maketitle
    
    \begin{abstract}
        [Placeholder: one-sentence summary of your chosen topic. 
        Will be expanded as later chapters add content.]
    \end{abstract}
    
    \section{Introduction}
    % Content added starting in Ch. 5

\end{document}
```

:::

Compile it once now to confirm the shell is error-free before building on it.

Don't worry if the abstract wording isn't perfect yet — it's a placeholder. 
You'll rewrite it properly once later chapters give you actual content (results, methods) to summarize.

::: capstone

Create your project shell:

- Pick one of the four topics (or your own, if you're confident enough to skip the training wheels).
- Set the title, author, date, and a one-line abstract placeholder as shown above.
- Compile successfully — this file is what every following chapter's Capstone Update will extend.

:::
