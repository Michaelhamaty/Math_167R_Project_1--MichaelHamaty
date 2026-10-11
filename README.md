# How Fast Does Normal Happen?

This Math 167R project asks how the parent distribution affects the sample size required for the sampling distribution of a mean to become approximately Normal.

## Five cases and main result

- Standard Normal is exactly Normal at $n=1$.
- A symmetric six-sided die is practically Normal by $n=30$, although lattice steps remain measurable.
- Exponential is the slowest finite-variance case; a second seed moves the conservative threshold to $n=1000$.
- Binomial with size 5 and probability 0.10 is practically Normal by $n=200$, with a fine residual lattice.
- Standard Cauchy has no ordinary-CLT threshold because its mean and variance are undefined and its sample mean remains Cauchy.

The result is not a universal cutoff. Shape, tails, discreteness, assumptions, and the intended use all matter.

## Extra-credit and creative extensions

- Dependent machine failures use a conditional Exponential process. Alternating negative dependence increases effective sample size, but no calibration-band shape threshold appears through $n=2000$.
- Independent non-identical Bernoulli observations use probabilities from 0.90 to 0.50. A bounded independent-array approximation is practical by about $n=50$.
- The synthetic age-at-death mixture is practically Normal by about $n=75$. It is a graph-inspired mathematical distribution, not historical data.
- The creative heritage-language page compares three neutral equal-mean paths and includes one deterministic local interaction plus a complete static fallback. It is not observed cultural data or a sociological model.

## Repository guide

- `index.qmd` and `analyses/` contain the landing page and five detailed analyses.
- `extensions/` contains the extension hub and four additional investigations.
- `assets/` contains the local creative interaction.
- `R/` contains population definitions, simulation, diagnostics, and shared plots.
- `results/` contains deterministic compact summaries, calibration bands, sensitivity results, and session information.
- `scripts/` contains the build, render wrapper, and acceptance checks.
- `docs/` records methodology, curated AI interactions, the foundation review, and future designs.
- `references/code_sources.md` records code provenance and the planning-tool audit.
- `_site/index.html` is the committed website entry point.

## Reproduce the website

Requirements are R 4.6 or later, Quarto 1.10.18, ggplot2 4.0.3, and knitr 1.52.

```sh
Rscript scripts/build_results.R
Rscript scripts/build_extensions.R
quarto render
Rscript scripts/validate_simulation.R
Rscript scripts/validate_extensions.R
Rscript scripts/validate_project.R
node scripts/validate_interactive.js
python3 scripts/validate_links.py
```

The project wrapper `scripts/quarto render` selects the pinned local Quarto runtime when `.tools/quarto` is available. The rendered entry point is `_site/index.html`. This repository includes the rendered site, but not simulation caches or raw sample means.

## Reproducibility

All primary results use seed 631 and 10,000 repetitions per sample size. Exponential is rerun with seed 1631 across its transition region. Result generation uses base R, graphics use ggplot2, and tables use knitr. Caches are disabled, so a render recomputes its displayed simulations. `results/session-info.txt` records the runtime and package versions.

The dependent extension also uses seed 1631 to check burn-ins of 250, 500, and 1000. The creative browser tool uses 3,000 deterministic local repetitions for responsiveness; its authoritative static results use seed 631 and 10,000 repetitions.

## Documentation and future work

Selected AI-assisted iterations, criticisms, corrections, and verification steps are curated in `docs/ai_interaction_log.md`; no raw transcript or full student identifier is stored. Method choices live in `docs/methodology_decisions.md`, final weaknesses in `docs/foundation_review.md`, and the extension status plus remaining empirical boundary in `docs/future_extensions.md`.
