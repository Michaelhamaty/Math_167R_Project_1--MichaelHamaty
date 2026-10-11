# Methodology Decisions

## Statistical contract

Each final simulation uses 10,000 repetitions and seed 631. A second run uses seed 1631 for the most borderline finite-variance case. All sample means are retained during a page render but only compact summaries are committed.

For a finite-variance population, the analysis first verifies the ordinary CLT assumptions. The simulated center must fall within the larger of three Monte Carlo standard errors or the Normal calibration allowance. The relative standard-error discrepancy must fall within the larger of 3 percent or 1.25 times the largest Normal discrepancy.

The Normal simulation sets practical guidance bands for absolute skewness, absolute excess kurtosis, and Q-Q RMSE. The realized bands are 0.10, 0.20, and 0.01490, respectively. These are guidance, not a weighted score or automatic verdict.

## Retained diagnostics

- Center error checks whether the sample means are centered where theory predicts.
- Empirical versus theoretical standard error checks the $1/\sqrt{n}$ scaling.
- Moment skewness detects asymmetry.
- Excess kurtosis detects tail and peak differences not captured by skewness.
- Q-Q RMSE summarizes 99 standardized empirical quantiles from 0.01 through 0.99.
- Histograms and Q-Q plots expose discreteness, curvature, and tails that a scalar can hide.

Shapiro-Wilk W was explored on the first deterministic 5,000 sample means. It is retained in the reproducibility table for audit only, not as evidence in the final verdict. At this simulation size, the p-value is too sensitive to serve as a practical approximation rule.

## Visual and stability rules

A threshold is acceptable only when the histogram and Q-Q plot have no material feature that would make a Normal approximation misleading. The judgment must persist at the next two larger evaluated sample sizes. Disagreement is reported directly. In particular, a lattice distribution can remain above the Normal-calibrated Q-Q RMSE even after its overall shape is useful.

The selected thresholds after visual review and sensitivity analysis are $n=1$ for Normal by exact theory, $n=30$ for the die, $n=1000$ as a conservative Exponential threshold, and $n=200$ for the small Binomial. Cauchy has no ordinary-CLT threshold.

## Cauchy contract

The standard Cauchy mean and variance are undefined, so theoretical standard error and moment comparisons are unavailable. The sample mean remains standard Cauchy for every sample size. The analysis therefore compares tail-aware quantiles and IQR with their theoretical values, exposes the count outside any displayed window, and never treats clipped axes as deleted observations.

## Borderline sensitivity case

Exponential is the genuinely most borderline finite-variance result. Although seed 631 produced skewness 0.096 at $n=300$, the exact sampling skewness is $2/\sqrt{300}=0.115$, above the practical band. Seed 1631 produced skewness 0.188 at 300 and 0.112 at 500. The second run therefore covers $n=300$, 500, 750, 1000, and 1500. Both seeds support $n=1000$ as a conservative threshold, while the remaining Q-Q fluctuation at 1500 is retained as Monte Carlo disagreement.
