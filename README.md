# How Fast Does Normal Happen?

Math 167R Central Limit Theorem project by Michael Hamaty.

## Start here

**[Open the complete project website](https://michaelhamaty.github.io/Math_167R_Project_1--MichaelHamaty/)**

Please click through **every tab in the website header**: Synthesis, Normal, Die, Exponential, Small Binomial, Cauchy, and every page in the Extensions menu. Each tab contains a separate part of the analysis.

## Project question and conclusion

This project asks how population shape and CLT assumptions affect the sample size needed for a sample mean to look approximately Normal. The five required cases are Standard Normal, a six-sided die, Exponential(rate 1), Binomial(size 5, probability 0.10), and Standard Cauchy.

The main conclusion is that 30 is not a universal cutoff. The required cases range from exactly Normal at $n=1$ to no ordinary-CLT threshold at all. The website explains each conclusion and includes three extra-credit analyses plus one creative extension.

## Reproducibility

Primary simulations use seed 631 and 10,000 repetitions. The committed website is also available at `_site/index.html`. Source analyses are in `index.qmd`, `analyses/`, and `extensions/`; reusable R code is in `R/`; compact results are in `results/`.

To rebuild locally, use R 4.6 or later, Quarto 1.10.18, ggplot2 4.0.3, and knitr 1.52:

```sh
Rscript scripts/build_results.R
Rscript scripts/build_extensions.R
scripts/quarto render
```

Method decisions are recorded in `docs/methodology_decisions.md`. Curated AI prompts and corrections are in `docs/ai_interaction_log.md`. Remaining limitations and possible future empirical work are in `docs/foundation_review.md` and `docs/future_extensions.md`.
