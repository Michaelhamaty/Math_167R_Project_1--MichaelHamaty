# Extension Status and Remaining Future Work

The original submission remains frozen at five required populations. The four planned extensions are now implemented in a separate website section, with compact deterministic results and no historical-data claims. This file records what was delivered and the boundary for later work.

## Dependent machine failures

Implemented from the instructor-provided conditional Exponential model. The analysis contrasts dependent chains with iid resampling from the estimated marginal distribution, distinguishes conditional from marginal behavior, and reports effective sample size only as a descriptive finite-sample quantity.

The long-run marginal moments are labeled simulation references rather than exact theory. No ordinary iid CLT threshold is claimed.

## Non-identical Bernoulli observations

Implemented with independent Bernoulli observations whose probabilities change linearly from 0.90 to 0.50. The total is identified as Poisson-binomial, and its exact center and variance are compared with simulation and with an iid Bernoulli 0.70 reference.

The page shows the probability path first and evaluates the bounded-array variance condition instead of invoking an identical-distribution argument.

## Custom age-at-death mixture

Implemented using the instructor-defined two-component discrete population. The page labels it as synthetic and graph-inspired, separates parent multimodality from sample-mean behavior, and verifies the weights, support, mean, and standard deviation before simulation.

Any later historical comparison would require a credible dataset, transparent measurement limits, and a clear separation between observed evidence and this stylized mixture.

## Featured creative case: heritage-language retention

Implemented as a neutral three-path gallery of independent Bernoulli outcomes for stylized households or contextual positions. The page states that the model is a mathematical thought experiment, not a sociological model or observed cultural dataset.

The framing must not rank languages or communities, treat retention or shift as inherently better, or claim to explain assimilation, discrimination, education, migration, or policy. Independence must be identified as an unrealistic simplification because families and communities can influence one another. Cultural transmission should be described as complex and context-dependent.

The local interactive graphic lets a reader vary the probability path and sample size. A complete R-generated static gallery remains visible without JavaScript, and the browser simulation is clearly supplemental to the authoritative 10,000-run analysis.

## Remaining boundary

No named community, historical comparison, causal claim, or empirical dataset belongs in this version. A future real-data layer would require source provenance, measurement and sampling analysis, privacy review where applicable, and subject-matter review of the cultural framing before implementation.
