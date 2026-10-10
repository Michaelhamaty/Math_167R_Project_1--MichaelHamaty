# Curated AI Interaction Log

## Example 1: turning a theorem into a measurable rule

**Prompt.** Design a reproducible evidence standard for deciding when a sampling distribution is Normal enough without reducing the decision to one test.

**Initial response.** Combine center, standard error, skewness, excess kurtosis, Q-Q discrepancy, and plots, with thresholds calibrated from the exact-Normal case.

**Criticism.** The first version treated every numerical band too much like a gate. That would reject lattice-valued sample means long after the Normal approximation is useful.

**Improvement.** The bands became guidance. Visual shape, theoretical eligibility, and persistence over two larger sample sizes remain required, and every disagreement is reported.

**Verification.** The Normal calibration was regenerated with seed 631 and 10,000 repetitions. The die results confirmed that discreteness can dominate Q-Q RMSE while skewness, kurtosis, and the global histogram have settled.

## Example 2: handling Cauchy honestly

**Prompt.** Make the Cauchy analysis comparable without inventing a population mean, variance, or standard error.

**Initial response.** Use robust quantiles and a fixed central plotting window.

**Criticism.** A fixed window alone can hide the most important extreme means and distort a density histogram if bin widths are set by the full range.

**Improvement.** The revised plot fixes bin width inside the declared window, states how many means lie outside it, and pairs the picture with quantiles, IQR, and maximum absolute values computed from all simulations.

**Verification.** The simulated IQR remains near the standard-Cauchy theoretical value of 2 across sample sizes, as stability under averaging predicts.

## Example 3: selecting the sensitivity run

**Prompt.** Choose the genuinely most borderline finite-variance case for a second seed.

**Initial response.** A mechanical distance-to-band calculation selected the die at its largest grid value.

**Criticism.** That choice measured a lattice artifact, not scientific uncertainty about the transition.

**Improvement.** The small Binomial was selected because its shape, skewness band, and Q-Q lattice disagreement create the closest interpretive boundary at $n=200$.

**Verification.** The seed 1631 run uses the same $B=10000$ at $n=200$, 300, and 500 and is compared with seed 631 using the same diagnostics.
