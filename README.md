# LaTeX for Research Students

A beginner's guide to LaTeX for STEM and research students — from a first
compiled document to a complete, submission-ready paper — with worked
examples, nuances, and exercises throughout. A running capstone project
threads through the chapters: starting in Chapter 4, you build one paper
piece by piece, so that by the end you have both the knowledge and a
finished document to show for it.

Read the finished guide: **[`LaTeX_for_Research_Students.pdf`](LaTeX_for_Research_Students.pdf)**

## Structure

The guide is organized into 9 Parts (23 chapters total), an Appendix of
reference material, and a Supplementary Materials file holding larger code
samples and datasets referenced from the chapters. All of it lives in the
`md_files/` folder; see [`md_files/00_index.md`](md_files/00_index.md) for
the full table of contents with links to every chapter and section.

| Part | Chapters | File |
|---|---|---|
| 1 — Foundations & Capstone Kickoff | 1–4 | `md_files/ch01-04_foundations.md` |
| 2 — Core Typesetting | 5–8 | `md_files/ch05-08_core_typesetting.md` |
| 3 — Math Mechanics | 9–10 | `md_files/ch09-10_math_mechanics.md` |
| 4 — Math Structures & Algorithms | 11–12 | `md_files/ch11-12_math_structures.md` |
| 5 — Bibliography & Citation Tools | 13–16 | `md_files/ch13-16_bibliography.md` |
| 6 — Diagrams & Data Visualization | 17–18 | `md_files/ch17-18_diagrams_data.md` |
| 7 — Macros & Templates | 19–20 | `md_files/ch19-20_macros_templates.md` |
| 8 — Collaboration & Diagnostics | 21–22 | `md_files/ch21-22_collaboration_diagnostics.md` |
| 9 — Capstone Assembly | 23 | `md_files/ch23_capstone_assembly.md` |

Plus `md_files/appendix.md` (cheat sheets and reference tables) and
`md_files/supplementary_materials.md` (larger worked examples and starter
datasets, including `md_files/ch18_sample_data.csv`).

Each chapter follows the same shape: an **Objective**, one or more
**Worked Examples**, **Nuance** call-outs for details that trip people up,
and an **Exercise** + **Capstone Update** to apply the chapter to your own
paper.

## Building the PDF

Requirements: [Pandoc](https://pandoc.org/) and a LaTeX engine (`pdflatex`,
e.g. from TeX Live), plus the LaTeX packages `authblk`, `orcidlink`, and `bm`
(all in a standard TeX Live install).

```bash
bash build_pdf.sh
```

This reads every chapter file directly from `md_files/`, assembles them via
[`callouts.lua`](callouts.lua) (a Pandoc filter that turns fenced Divs like
`::: objective` / `::: worked` / `::: nuance` into the guide's colored
call-out boxes), and writes `LaTeX_for_Research_Students.pdf` — no build
folder, nothing else touched.

## License

- **Guide content** (chapters, Appendix, Supplementary Materials, and the
  assembled PDF) — [CC BY 4.0](LICENSE). Share and adapt freely, with
  attribution.
- **Build tooling** (`build_pdf.sh`, `callouts.lua`) — [MIT](LICENSE-CODE).

## Authors

Syed Ali Mohsin Bukhari & Iqra Siddique.
Drafting assistant: Claude (Anthropic) · Reviewer: DeepSeek (High-Flyer).
