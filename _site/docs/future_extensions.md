# Future Extensions

The first submission intentionally stops at the five required populations. The items below are designs only. They contain no extension simulations, numerical results, or historical claims.

## Dependent machine failures

This extension would use the instructor-provided conditional Exponential model to show how dependence breaks the simple independent-observation argument. The implementation should derive or simulate both conditional and marginal behavior, explain the shared source of dependence, and compare nominal sample size with an effective sample-size interpretation. A useful design would contrast independent failures with matched dependent failures while keeping marginal scales comparable.

Before implementation, the conditional generator and theoretical covariance should be checked directly against `course_docs/dependent_failure_process.html`. The page should avoid reusing the finite-variance threshold rubric until the correct dependent-limit conditions are stated.

## Non-identical Bernoulli observations

This extension would adapt the changing-probability basketball structure from `course_docs/non_identical_basketball_shots.html`. Independent Bernoulli observations would have probabilities $p_i$ that change with trial order. The analysis must distinguish this sum from a fixed-parameter Binomial random variable and compare the theoretical center and variance, $\sum p_i$ and $\sum p_i(1-p_i)$, with simulation.

A future page should make the probability path visible before showing the distribution of the average. It should state which triangular-array or bounded-variable limit condition is being used rather than invoking the identical-distribution CLT.

## Custom age-at-death mixture

This extension would use the irregular two-component discrete population in `course_docs/custom_age_at_death_distribution_monte_carlo.html`. It must be labeled as a stylized distribution created for mathematical exploration, not as fitted historical mortality data. The analysis should separate multimodality in the parent from the behavior of its sample mean and should verify all mixture weights, support values, mean, and variance before simulation.

Any later historical comparison would require a credible dataset, transparent measurement limits, and a clear separation between observed evidence and the stylized mixture.

## Featured creative case: heritage-language retention

The creative case would model independent Bernoulli observations for different households or communities under ordered contextual conditions, with retention probabilities that vary across observations. It must be presented as a simplified statistical thought experiment, not a sociological model or observed cultural dataset.

The framing must not rank languages or communities, treat retention or shift as inherently better, or claim to explain assimilation, discrimination, education, migration, or policy. Independence must be identified as an unrealistic simplification because families and communities can influence one another. Cultural transmission should be described as complex and context-dependent.

The reserved interactive graphic could let a reader vary a probability path and sample size, then observe the distribution of an average or total. The HTML must also include a complete static fallback showing several preselected paths, so the argument remains available without JavaScript interaction.

## Prerequisites

Before any extension begins, retain the existing deterministic seed contract, add case-specific theory assertions, define diagnostics appropriate to the changed assumptions, and complete a separate editorial review of claims and labels. No real-data layer should be added until the stylized required and extra-credit cases are sound.
