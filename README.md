# How Fast Does Normal Happen?

This Math 167R project uses Monte Carlo simulation to compare the rate at which sample means approach a Normal distribution for five parent populations.

## Reproduce the website

Requirements are R 4.6 or later, Quarto 1.10.18, ggplot2 4.0.3, and knitr 1.52.

```sh
Rscript scripts/build_results.R
quarto render
Rscript scripts/validate_project.R
```

The rendered entry point is `_site/index.html`. This repository includes the rendered site, but not simulation caches or raw sample means.
