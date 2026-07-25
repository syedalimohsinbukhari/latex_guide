# Part 9: Capstone Assembly (Chapter 23)

*LaTeX for Research Students — a beginner's guide with examples, nuances & exercises*

*Authors: Syed Ali Mohsin Bukhari & Iqra Siddique · Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer)*

This chapter introduces no new LaTeX syntax. Every command, package, and technique below was already taught in Ch. 4–22 — this chapter's only job is to pull all of it together into one coherent, submission-ready document, and to catch the small consistency slips that creep in when a paper is built one Capstone Update at a time across 19 chapters.

---

## Chapter 23 — Capstone Assembly

::: objective

Assemble everything built across Ch. 4–22 into one complete, consistently formatted, submission-ready document — no new syntax, purely pulling the pieces together and finishing properly.

:::

::: worked

**the full inventory checklist**

Every Capstone Update from Ch. 4 onward added exactly one piece to your paper. Before assembling, confirm all of them are actually present, grouped here by category with their source chapter:

**Project shell & front matter**

- Topic, title, author, date, and abstract (Ch. 4)
- Real section headings, a settled spacing choice, and a table of contents at the right depth (Ch. 5)
- A full front-matter block — title page, table of contents, list of figures/tables, correct page numbering for your document class (Ch. 20)

**Content elements**

- A results table (Ch. 6)
- A figure with a proper caption and label (Ch. 7)
- Cross-references between them using `\cref`, with `colorlinks` styling applied (Ch. 8)
- The single most important equation in the paper, correctly formatted (Ch. 9)
- A derivation (2–4 steps) relevant to the topic (Ch. 10)
- One formal definition or assumption, in a `definition` environment (Ch. 11)
- A methods algorithm block, captioned and labeled (Ch. 12)

**References & front-matter tooling**

- A bibliography with at least 3 citations, including an online/software reference (Ch. 13)
- The citation style appropriate for your target journal (Ch. 14)
- A real reference library, via Zotero/Mendeley export (Ch. 15)
- An acronym list or nomenclature table, printed as front matter (Ch. 16)

**Visuals**

- A diagram — imported PDF or TikZ (Ch. 17)
- A data plot with axis labels, a legend if applicable, and error bars where relevant (Ch. 18)

**Structure & hygiene**

- Macros for any notation typed more than twice, with named operators via `\DeclareMathOperator` (Ch. 19)
- A proper multi-file structure with an appendix, and `comment` used to park anything not ready (Ch. 20)
- A tagged, submission-ready version (Git commit/tag or Overleaf History checkpoint) (Ch. 21)
- A clean compile with no unresolved errors (Ch. 22)

If any of these is missing, that's the gap to close before moving on — this chapter assumes all 19 are already in your document from working through the guide in order.

:::

::: worked

**the assembled skeleton**

Rather than repeat 19 chapters' worth of syntax here, a single compilable document threading every piece above together — in the correct structural order, using the graphene capstone topic as filler — is in `supplementary_materials.md` under "Ch. 23 — Full Assembled Skeleton." Use it as a structural map: the order sections appear in that skeleton is the order the pieces above slot into a real paper, not an arbitrary listing order.

:::

::: nuance

**a consistency pass**

Nineteen chapters' worth of Capstone Updates were written at different times, which is exactly how small inconsistencies creep in. Before considering the paper finished, check:

- **Citation style** — Ch. 14's chosen style is used for every citation in the document, not a mix of `\cite` and `\citep` left over from Ch. 13's first pass.
- **Number formatting** — `siunitx` (Ch. 9) is applied everywhere a number-with-unit appears, including any values added later in Ch. 10's derivation or Ch. 18's plot, not just the first equation it was introduced on.
- **Label prefixes** — Ch. 8's `fig:`/`tab:`/`eq:`/`alg:`/`def:` convention is followed for every label in the document, including ones added in later chapters after the convention might have slipped your mind.
- **Spacing rules** — Ch. 5's end-of-sentence spacing and `\\`/`\newline`/`\par` mechanics are applied consistently, not just in the sections drafted right after that chapter.

None of this is new syntax — it's a matter of re-reading the whole document once with each of these four specifically in mind, rather than trusting that a rule followed correctly in Ch. 9 was still being followed correctly by Ch. 18.

:::

::: nuance

**the final proofing pass**

Separate from the consistency pass above — this one is about compile-time correctness, not stylistic drift:

- Compile **at least twice** after the last edit, so cross-references (Ch. 8), citations (Ch. 13), and the table of contents (Ch. 5) all settle.
- Search the PDF for a literal `??` — a surviving one almost always means a reference or citation that never resolved, even after recompiling.
- Search for leftover placeholder text — the `[Working Title...]`-style brackets from Ch. 1–4, or any "TODO" left in a `comment` block (Ch. 20) that was meant to be temporary.
- Check that floats (Ch. 6's tables, Ch. 7's figures) didn't drift to an unexpected page after last-minute edits — a table that displaced to the very end of the document is easy to miss if you only reread the text, not the rendered PDF.

:::

::: worked

**the submission checklist**

Extends Ch. 21's camera-ready checklist with the fuller picture now that every chapter's contribution is in place:

- Every item from Ch. 21's camera-ready checklist (draft sections wrapped in `comment`, correct compiler, `\hypersetup` set appropriately, compiled twice, no placeholder text).
- Glossary or nomenclature (Ch. 16) is present and printed, not just defined in the preamble.
- Appendix (Ch. 20) is present if the paper has any supplementary derivations, extended data, or material that doesn't belong in the main body.
- Bibliography style (Ch. 14) matches what the target venue actually requires — not just "a style," but the specific one named in the venue's author guidelines.
- The consistency pass and final proofing pass above have both been run since the last substantive edit.

:::

::: exercise

Compile your assembled capstone paper start to finish. If anything breaks, resolve it using Ch. 22's techniques — read the log file, identify the error category, and bisect with `comment` if the cause isn't obvious — without pressing undo.

:::

::: capstone

Your paper is complete. Every chapter's contribution — from the project shell in Ch. 4 to the clean compile in Ch. 22 — is now one consistently formatted, submission-ready document.

:::

---

*End of Part 9 (Ch. 23). This is the final chapter of the guide — see the Appendix for reference material, and `supplementary_materials.md` for the full assembled skeleton.*
