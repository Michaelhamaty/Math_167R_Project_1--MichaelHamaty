# Repository Guidance

Read `PROJECT_SPEC.md` before making changes. When sources conflict, use this order: `course_docs/RULES.md`, the student guidance QMD, the Project 1 HTML, `PROJECT_SPEC.md`, this file, the two lesson documents, the three future examples, then live planning notes.

On every resumed session, read `task_plan.md`, `findings.md`, and `progress.md`, then inspect Git status and the latest validation result.

The first run covers only Standard Normal, a six-sided die, Exponential(rate 1), Binomial(size 5, probability 0.10), and Standard Cauchy. Do not implement extra-credit cases, the creative heritage-language case, historical data, or interactive graphics.

Use seed 631, second seed 1631, and final `B = 10000`. Never store the full student ID. Treat the Cauchy mean, variance, and theoretical standard error as undefined. Preserve and interpret disagreement among diagnostics.

Adapt R foundations from `course_docs` first. Cite every other nontrivial foundation nearby and in `references/code_sources.md`. Prefer simple base R functions plus ggplot2 and knitr. R comments must use `#NoSpace`. Authored project prose must contain no em dash characters.

Stop and fix every failed validation before committing. Use non-destructive Git only. Update and re-attest the planning files before each verified milestone commit and push. Rebuild with `Rscript scripts/build_results.R`, render with `scripts/quarto render` when the pinned local runtime is present, and validate with `Rscript scripts/validate_simulation.R`, `Rscript scripts/validate_project.R`, and `python3 scripts/validate_links.py`.

Before final handoff, request a fresh-agent review of every rendered page, graph, and major conclusion. Implement valid first-run fixes and record future-only suggestions without expanding scope.
