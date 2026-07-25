This guide takes you from your first compiled document to a complete, submission-ready research paper. It's written for students in STEM and other research fields who are new to LaTeX, and it assumes no prior experience — just a willingness to work through the examples and exercises as you go. A running capstone project threads through the chapters: starting in Chapter 4 you build one paper piece by piece, so that by the end you have both the knowledge and a finished document to show for it.

The material is organized into nine Parts (Chapters 1–23), followed by an Appendix of reference material and a Supplementary Materials file holding larger code samples and datasets referenced from the chapters.

---

## Contents

- **[Part 1 — Foundations & Capstone Kickoff](ch01-04_foundations.md)**
    - [Chapter 1 — Why LaTeX for Research Writing](ch01-04_foundations.md#chapter-1--why-latex-for-research-writing)
    - [Chapter 2 — Setting Up Overleaf & Your First Document](ch01-04_foundations.md#chapter-2--setting-up-overleaf--your-first-document)
    - [Chapter 3 — Anatomy of a .tex File + Survival Debugging](ch01-04_foundations.md#chapter-3--anatomy-of-a-tex-file--survival-debugging)
    - [Chapter 4 — Capstone Kickoff: Choosing Your Topic & Project Setup](ch01-04_foundations.md#chapter-4--capstone-kickoff-choosing-your-topic--project-setup)

- **[Part 2 — Core Typesetting](ch05-08_core_typesetting.md)**
    - [Chapter 5 — Text Formatting & Sectioning](ch05-08_core_typesetting.md#chapter-5--text-formatting--sectioning)
    - [Chapter 6 — Lists & Tables](ch05-08_core_typesetting.md#chapter-6--lists--tables)
    - [Chapter 7 — Figures & Floats](ch05-08_core_typesetting.md#chapter-7--figures--floats)
    - [Chapter 8 — Cross-Referencing, Labels & Hyperlinks](ch05-08_core_typesetting.md#chapter-8--cross-referencing-labels--hyperlinks)

- **[Part 3 — Math Mechanics](ch09-10_math_mechanics.md)**
    - [Chapter 9 — Inline & Display Math Basics + Math Fonts & Units](ch09-10_math_mechanics.md#chapter-9--inline--display-math-basics--math-fonts--units)
    - [Chapter 10 — Advanced Math: Matrices, Multi-line Equations, Cases](ch09-10_math_mechanics.md#chapter-10--advanced-math-matrices-multi-line-equations-cases)

- **[Part 4 — Math Structures & Algorithms](ch11-12_math_structures.md)**
    - [Chapter 11 — Theorems, Definitions, Proofs (amsthm)](ch11-12_math_structures.md#chapter-11--theorems-definitions-proofs-amsthm)
    - [Chapter 12 — Algorithms & Pseudocode](ch11-12_math_structures.md#chapter-12--algorithms--pseudocode)

- **[Part 5 — Bibliography & Citation Tools](ch13-16_bibliography.md)**
    - [Chapter 13 — Managing References with BibTeX/BibLaTeX](ch13-16_bibliography.md#chapter-13--managing-references-with-bibtexbiblatex)
    - [Chapter 14 — Citation Styles for Journals & Conferences](ch13-16_bibliography.md#chapter-14--citation-styles-for-journals--conferences)
    - [Chapter 15 — Reference Managers + Overleaf](ch13-16_bibliography.md#chapter-15--reference-managers--overleaf)
    - [Chapter 16 — Glossaries, Nomenclature & Acronyms](ch13-16_bibliography.md#chapter-16--glossaries-nomenclature--acronyms)

- **[Part 6 — Diagrams & Data Visualization](ch17-18_diagrams_data.md)**
    - [Chapter 17 — Diagrams: Vector Graphics Workflow & TikZ (Elective)](ch17-18_diagrams_data.md#chapter-17--diagrams-vector-graphics-workflow--tikz-elective)
    - [Chapter 18 — Plotting Data with PGFPlots](ch17-18_diagrams_data.md#chapter-18--plotting-data-with-pgfplots)

- **[Part 7 — Macros & Templates](ch19-20_macros_templates.md)**
    - [Chapter 19 — Custom Commands & Preamble Management](ch19-20_macros_templates.md#chapter-19--custom-commands--preamble-management)
    - [Chapter 20 — Thesis/Paper Templates, Multi-file Projects & Appendices](ch19-20_macros_templates.md#chapter-20--thesispaper-templates-multi-file-projects--appendices)

- **[Part 8 — Collaboration & Diagnostics](ch21-22_collaboration_diagnostics.md)**
    - [Chapter 21 — Version Control, Collaboration & Journal Submission](ch21-22_collaboration_diagnostics.md#chapter-21--version-control-collaboration--journal-submission)
    - [Chapter 22 — Troubleshooting Common Errors (Full Reference)](ch21-22_collaboration_diagnostics.md#chapter-22--troubleshooting-common-errors-full-reference)

- **[Part 9 — Capstone Assembly](ch23_capstone_assembly.md)**
    - [Chapter 23 — Capstone Assembly](ch23_capstone_assembly.md#chapter-23--capstone-assembly)

- **[Appendix](appendix.md)** — symbol, table, page-layout, package, and compiler cheat sheets; a troubleshooting checklist; and starter-snippet references.

- **[Supplementary Materials](supplementary_materials.md)** — larger code samples, full working examples, sample datasets, and starter `.bib` files referenced from the chapters. A standalone dataset, [`ch18_sample_data.csv`](ch18_sample_data.csv), supports Chapter 18.
    - [Ch. 5 — Dense Table for Testing `setspace`](supplementary_materials.md#ch-5--dense-table-for-testing-setspace)
    - [Ch. 6 — Full Working Example: Table "Dark Arts" Combined](supplementary_materials.md#ch-6--full-working-example-table-dark-arts-combined)
    - [Ch. 7 — Full Working Example: A Stuck Float, Before and After `\clearpage`](supplementary_materials.md#ch-7--full-working-example-a-stuck-float-before-and-after-clearpage)
    - [Ch. 9 — Reverse-Engineering Sample Targets](supplementary_materials.md#ch-9--reverse-engineering-sample-targets)
    - [Ch. 11 — Simple Theorem Bank for Beginners](supplementary_materials.md#ch-11--simple-theorem-bank-for-beginners)
    - [Ch. 11 — Exercise 2, Solved (Full Working Example)](supplementary_materials.md#ch-11--exercise-2-solved-full-working-example)
    - [Ch. 12 — Full Working Examples (Covering Most Reference-Table Commands)](supplementary_materials.md#ch-12--full-working-examples-covering-most-reference-table-commands)
    - [Ch. 13 — Starter `.bib` Files for the 4 Capstone Topics](supplementary_materials.md#ch-13--starter-bib-files-for-the-4-capstone-topics)
    - [Ch. 16 — Glossary Printing Command Reference](supplementary_materials.md#ch-16--glossary-printing-command-reference)
    - [Ch. 17 — Full Working Example: Neural Network Architecture Diagram](supplementary_materials.md#ch-17--full-working-example-neural-network-architecture-diagram)
    - [Ch. 18 — Sample Dataset (`ch18_sample_data.csv`)](supplementary_materials.md#ch-18--sample-dataset-ch18_sample_datacsv)
    - [Ch. 18 — Full Working Example (Complete Document)](supplementary_materials.md#ch-18--full-working-example-complete-document)
    - [Ch. 20 — Full Working Example: Two-Column Layout with a Spanning Figure](supplementary_materials.md#ch-20--full-working-example-two-column-layout-with-a-spanning-figure)
    - [Ch. 20 — Full Working Example: Front/Back-Matter Skeleton (`book` Class)](supplementary_materials.md#ch-20--full-working-example-frontback-matter-skeleton-book-class)
    - [Ch. 23 — Full Assembled Skeleton (Every Chapter, One Document)](supplementary_materials.md#ch-23--full-assembled-skeleton-every-chapter-one-document)
