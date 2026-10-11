# Code Sources and Adaptations

| Source | Affected code | Adaptation |
|---|---|---|
| `course_docs/Math167R - Class 05 central_limit_theorem.html` | `R/simulation.R` | Repeated sampling and sample means are organized into reusable base R functions. |
| `course_docs/Math167R - Class 06 statistical_distributions_lesson for class.html` | `R/populations.R` | Course examples guide all distribution parameterizations. |
| [R stats distribution documentation](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Distributions.html) | `R/populations.R`, `R/diagnostics.R` | Standard random generators, density functions, and theoretical quantiles are used with explicit parameters. |
| [ggplot2 4.0.3 reference](https://ggplot2.tidyverse.org/reference/) | `R/plots.R`, `index.qmd` | Layers, facets, scales, and themes are assembled into a consistent static design. |
| [Quarto website documentation](https://quarto.org/docs/websites/) | `_quarto.yml`, QMD pages | The navigation, output directory, code folding, and static resource rules follow the documented website format. |

## Planning and recovery tooling

Planning-with-files release `v3.24.0` is pinned to commit `7056ed2f2b86a8a9e18840f625ac66a48fa07693`. The repository contains only `.agents/skills/planning-with-files/`, `.codex/hooks.json`, and `.codex/hooks/` from that release. Vendored scripts are unchanged. The seven POSIX hook commands add `XDG_CACHE_HOME="${TMPDIR:-/tmp}"` because the managed environment cannot write the default home cache.

The selected upstream audit ran 182 tests: 171 passed, 10 optional tests were skipped, and one Darwin-only test was environment-inapplicable because it deliberately writes to sandbox-blocked `/var/tmp`. The reviewed tooling uses bounded nonce-framed context, plan attestation, symlink containment, project and session isolation, and no automatic transcript replay or network upload path.
