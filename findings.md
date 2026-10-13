# Findings and Decisions

## Requirements

- The authoritative first run contains five population analyses and no implemented extensions.
- Final simulations use seed 631 and `B = 10000`; the sensitivity run uses seed 1631.
- The primary artifact is a static Quarto website with `_site/index.html` as its entry point.
- Authored prose has no em dash characters and authored R comments have no space after `#`.
- The approved extension phase adds dependent failures, non-identical Bernoulli observations, the synthetic age-at-death mixture, and a neutral heritage-language thought experiment while freezing the verified required results.
- Static extension results retain seed 631 and `B = 10000`; the dependent sensitivity uses seed 1631 and several burn-ins.
- The user requested complete removal of the two redundant introductory sections shown in the October 12 screenshots: "Why extend the project?" on the Extensions hub and "Beyond the iid foundation" on the landing page.

## Environment and repository findings

- Before initialization, Git resolved to the unrelated parent at `/Users/michaelhamaty/Developer`.
- A child repository now exists at the project path. Parent status hashes match before and after initialization.
- The supplied GitHub remote returned no refs before initialization and after the final read-only check.
- R 4.6.1, ggplot2 4.0.3, knitr 1.52, and the checksum-verified Quarto 1.10.18 archive are available.
- The two Project 1 HTML files have the same SHA-256 hash.

## Planning tooling audit

- Installed workspace-local planning-with-files v3.24.0 from commit `7056ed2f2b86a8a9e18840f625ac66a48fa07693`.
- Copied only the canonical repository skill and standalone Codex hooks. No plugin or global copy was enabled.
- Vendored scripts are unchanged. The POSIX hook commands set `XDG_CACHE_HOME` to the per-user temporary directory so hook snapshots work under the managed sandbox.
- The selected audit covers bounded context framing, attestation, containment, Codex session isolation, opt-out, Stop dispatch, catchup boundaries, and gated behavior.
- Automatic recovery reads project planning files only. Session catchup will not be used without explicit user authorization.
- Homebrew could not run Quarto's privileged macOS package installer noninteractively. The identical approved 1.10.18 release is installed from its publisher-verified archive under ignored `.tools/`.

## Statistical findings

- Normal sample means are exactly Normal for every positive sample size, so the theoretical answer is `n = 1`.
- The average of independent standard Cauchy observations is itself standard Cauchy for every sample size. Increasing `n` does not create an ordinary CLT result.
- The final finite-variance transition decisions must be computed, not prewritten.
- Normal calibration produced guidance bands of 0.10 for absolute skewness, 0.20 for absolute excess kurtosis, 0.03 for relative SE error, and 0.01490 for Q-Q RMSE.
- The calibrated Q-Q RMSE band is deliberately stringent. Even visually modest lattice effects can exceed it, so it must remain guidance rather than an automatic gate.
- Shapiro-Wilk W is recorded on the first deterministic 5,000 means for method exploration. Its p-value is excluded because large samples make it an overly sensitive decision rule.
- Final review fixed the practical thresholds at Normal 1, die 30, conservative Exponential 1000, and small Binomial 200. Cauchy has no threshold.
- Die Q-Q RMSE remains above the Normal-noise band because of lattice steps even when the global shape is useful.
- Exponential center and SE stabilize far earlier than its right-tail shape. Exact skewness and seed 1631 show that the apparent seed-631 success at $n=300$ is not stable; $n=1000$ is the conservative threshold.
- Exponential is the second-seed sensitivity case. The small Binomial remains a diagnostic-disagreement example because skewness settles while lattice-sensitive Q-Q RMSE does not.
- The post-review render confirms that sparse log-axis breaks remove the earlier trajectory label collisions and that added plot margins prevent clipping. The revised synthesis makes Cauchy ineligibility visible rather than leaving it outside the figure.
- Final regeneration produced byte-identical hashes for all four CSV files and `results/session-info.txt`. The implementation is deterministic under its documented runtime and seed contract.
- The final read-only remote check matched the pushed review commit, all original file hashes still match, and the unrelated parent repository status hash remains unchanged.
- Cauchy IQR remains near its theoretical value of 2 while maximum absolute means vary by orders of magnitude. Fixed-window histograms use all simulations in the density denominator and disclose excluded-tail fractions.

## Technical decisions

| Decision | Rationale |
|----------|-----------|
| Commit compact summaries, not raw sample means | Raw means are deterministic render intermediates and would add large generated files. |
| Calibrate numerical bands against the Normal simulation | This distinguishes practical Monte Carlo noise from material non-Normal shape. |
| Keep diagnostic disagreement visible | Each diagnostic detects a different feature and the specification forbids a forced score. |
| Keep non-iid cases outside `make_populations()` | Their generators and theoretical comparisons depend on an ordered process, not one iid marginal distribution. |
| Compare dependent chains with matched-marginal iid resampling | This isolates dependence without pretending the conditional baseline Exponential is the marginal distribution. |
| Use equal-mean creative paths | Stable 0.60, increasing 0.45 to 0.75, and decreasing 0.75 to 0.45 separate heterogeneity and ordering from average probability. |

## Extension exploration

- The instructor's dependent process is numerically stable at the specified parameters and has lag-1 autocorrelation near -0.365 after burn-in. Alternating negative dependence makes the empirical effective sample size larger than nominal `n` even though the sample-mean shape remains right-skewed at `n = 500`.
- The dependent grid requires adaptive extension beyond 500 before any shape transition can be described. The matched-marginal iid comparator will be generated as a streaming cumulative mean to avoid storing a 10,000 by 2,000 matrix.
- At `n = 2000`, the dependent sample mean still has skewness about 0.103 and Q-Q RMSE about 0.021, both just outside the Normal-calibration guidance. The correct result is no calibration-band threshold through 2000, not a forced pass.
- The changing Bernoulli path has exact mean 0.70 and a slightly smaller theoretical SE than fixed Bernoulli 0.70. The maximum individual variance share decreases toward zero as `n` grows.
- The synthetic age mixture reproduces the instructor values, with mean 49.9809755 and SD 27.6345157 after probability normalization.
- First visual inspection found all new plots legible except the nine-panel creative histogram, where the shared x-axis title crowded the final row. The creative figure receives extra height and bottom margin before browser QA.
- Non-identical Bernoulli reaches a practical global Normal shape by `n = 50`; its Q-Q RMSE remains strict because the average is lattice-valued.
- The synthetic age mixture reaches a defensible tested transition at `n = 75`, with small later Q-Q fluctuation interpreted as Monte Carlo noise rather than reversed convergence.
- All three creative paths are practically useful by `n = 50`. Increasing and decreasing paths have identical exact moments because they reverse the same probability multiset, while the stable path has slightly larger variance.
- The local browser policy blocks automated `file://` control, so interaction verification uses deterministic Node assertions and rendered-HTML accessibility checks rather than bypassing that security boundary.
- The extension documentation now distinguishes implemented work from any future empirical layer, and records the local Canvas and input-event provenance beside the interaction source.
- Fresh context-free review confirmed the extension statistics and cultural framing but found a real rendering defect: Markdown had escaped the indented interactive controls. Raw HTML fencing and runtime-aware Node validation now make the control contract executable rather than string-only.
- The review also identified mobile equation overflow, compressed age histograms, and two missing source attributions. Equations are split and horizontally contained, the age panels use disclosed free horizontal scales, and the Lindeberg-Feller and Mulberry32 foundations are now cited.
- The review verification exercised the repaired interaction at 390 pixels and found no remaining required defect. All extension validators and link checks passed afterward.
- The unrelated parent repository's global status changed during this long-running phase because of paths outside the nested project. The saved parent status still has the same `math_167R-proj1/` entry, every original project file matches its initial hash, and no command in this phase targeted a parent path.

## Issues encountered

- The requested additional AI-log examples can be grounded in two actual instructions from this project: checkpointing the current stage before extension work and removing two redundant sections entirely. Faithful paraphrases preserve the user's voice and control without fabricating an academic record.

| Issue | Resolution |
|-------|------------|
| Home-directory hook caches are unavailable inside the managed sandbox | Set the approved per-hook cache root to `${TMPDIR:-/tmp}`. |
| Homebrew's Quarto package required an interactive administrator password | Installed the official 1.10.18 archive locally after matching its published SHA-256 checksum. |
