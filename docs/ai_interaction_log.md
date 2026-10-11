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

**Initial response.** A mechanical distance-to-band calculation selected the die at its largest grid value, and an initial qualitative correction selected the small Binomial.

**Criticism.** That choice measured a lattice artifact, not scientific uncertainty about the transition.

**Improvement.** A fresh review compared simulation with exact Exponential skewness, $2/\sqrt{n}$. It showed that the seed-631 estimate at $n=300$ was unusually favorable, so Exponential replaced the Binomial as the sensitivity case.

**Verification.** With seed 1631 and $B=10000$, Exponential skewness was 0.188 at $n=300$ and 0.112 at 500. Both exceed the 0.10 guidance. At $n=1000$, both seeds fall inside the skewness and Q-Q guidance, supporting the revised conservative threshold.

## Example 4: designing the extension phase

**Prompt.** Extend the completed project with the three instructor-defined extra-credit cases and a creative heritage-language case, while using the project hooks for a long-running implementation.

**Initial response.** Preserve the verified five-case foundation, add a separate non-iid simulation layer, build four new analysis pages plus an Extensions hub, and reserve interaction for the creative page.

**Unanswered question.** The documents fixed the respectful framing but did not choose the exact probability path for the creative case.

**Follow-up.** Use a neutral gallery containing stable, gradually increasing, and gradually decreasing stylized paths.

**Improvement.** The three paths share average probability 0.60, allowing the analysis to isolate heterogeneity and order without presenting one direction as a real cultural trajectory.

**Verification.** Assertions verify the dependent rate, positive finite chains, exact Bernoulli center and SE, normalized age probabilities, equal creative-path means, and probability-path reversal. Two clean builds reproduce compact outputs. A fresh reviewer caught escaped interactive controls, narrow-screen equation overflow, an unhelpful shared age-plot scale, and two missing provenance records. The controls were converted to raw HTML, runtime-aware Node checks were added, formulas were split and contained, the age panels received disclosed free x scales, and exact sources were recorded before the final eleven-page render.
