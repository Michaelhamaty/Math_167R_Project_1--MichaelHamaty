# Code Sources and Adaptations

| Source | Affected code | Adaptation |
|---|---|---|
| `course_docs/Math167R - Class 05 central_limit_theorem.html` | `R/simulation.R` | Repeated sampling and sample means are organized into reusable base R functions. |
| `course_docs/Math167R - Class 06 statistical_distributions_lesson for class.html` | `R/populations.R` | Course examples guide all distribution parameterizations. |
| [R stats distribution documentation](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Distributions.html) | `R/populations.R`, `R/diagnostics.R` | Standard random generators, density functions, and theoretical quantiles are used with explicit parameters. |
| [ggplot2 4.0.3 reference](https://ggplot2.tidyverse.org/reference/) | `R/plots.R`, `index.qmd` | Layers, facets, scales, and themes are assembled into a consistent static design. |
| [Quarto website documentation](https://quarto.org/docs/websites/) | `_quarto.yml`, QMD pages | The navigation, output directory, code folding, and static resource rules follow the documented website format. |
| `course_docs/dependent_failure_process.html` | `R/extensions.R`, `extensions/dependent-failures.qmd` | The instructor's conditional Exponential rate is implemented exactly; marginal moments are estimated from a deterministic long chain. |
| `course_docs/non_identical_basketball_shots.html` | `R/extensions.R`, `extensions/nonidentical-bernoulli.qmd` | The changing Bernoulli-probability example is generalized across the evaluated sample-size grid and analyzed as Poisson-binomial. |
| [IISc probability lecture notes: Lindeberg-Feller CLT](https://math.iisc.ac.in/~manju/PT2022/Lectures-part2.pdf) | `extensions/nonidentical-bernoulli.qmd`, `extensions/heritage-language.qmd` | The bounded independent-array eligibility argument is stated separately from the ordinary iid CLT. |
| `course_docs/custom_age_at_death_distribution_monte_carlo.html` | `R/extensions.R`, `extensions/age-mixture.qmd` | The instructor's two component weights and support are normalized into a synthetic discrete population. |
| [MDN Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) and [MDN input event](https://developer.mozilla.org/en-US/docs/Web/API/Element/input_event) | `assets/heritage-interactive.js` | A local deterministic canvas display responds to labeled native controls without a network or package dependency. |
| [Mulberry32 JavaScript reference](https://github.com/cprosche/mulberry32) | `assets/heritage-interactive.js` | The small noncryptographic generator is adapted only to make the 3,000-run teaching display repeatable for a selected control state. |
| [GitHub Pages custom workflow documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages) | `.github/workflows/pages.yml` | The official checkout, Pages configuration, artifact upload, permission, environment, and deployment structure publishes the already verified `_site` directory. |

## Planning and recovery tooling

Planning-with-files release `v3.24.0` is pinned to commit `7056ed2f2b86a8a9e18840f625ac66a48fa07693`. The repository contains only `.agents/skills/planning-with-files/`, `.codex/hooks.json`, and `.codex/hooks/` from that release. Vendored scripts are unchanged. The seven POSIX hook commands add `XDG_CACHE_HOME="${TMPDIR:-/tmp}"` because the managed environment cannot write the default home cache.

The selected upstream audit ran 182 tests: 171 passed, 10 optional tests were skipped, and one Darwin-only test was environment-inapplicable because it deliberately writes to sandbox-blocked `/var/tmp`. The reviewed tooling uses bounded nonce-framed context, plan attestation, symlink containment, project and session isolation, and no automatic transcript replay or network upload path.
