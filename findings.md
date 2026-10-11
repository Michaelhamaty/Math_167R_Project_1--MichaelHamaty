# Findings and Decisions

## Requirements

- The authoritative first run contains five population analyses and no implemented extensions.
- Final simulations use seed 631 and `B = 10000`; the sensitivity run uses seed 1631.
- The primary artifact is a static Quarto website with `_site/index.html` as its entry point.
- Authored prose has no em dash characters and authored R comments have no space after `#`.

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
- Cauchy IQR remains near its theoretical value of 2 while maximum absolute means vary by orders of magnitude. Fixed-window histograms use all simulations in the density denominator and disclose excluded-tail fractions.

## Technical decisions

| Decision | Rationale |
|----------|-----------|
| Commit compact summaries, not raw sample means | Raw means are deterministic render intermediates and would add large generated files. |
| Calibrate numerical bands against the Normal simulation | This distinguishes practical Monte Carlo noise from material non-Normal shape. |
| Keep diagnostic disagreement visible | Each diagnostic detects a different feature and the specification forbids a forced score. |

## Issues encountered

| Issue | Resolution |
|-------|------------|
| Home-directory hook caches are unavailable inside the managed sandbox | Set the approved per-hook cache root to `${TMPDIR:-/tmp}`. |
| Homebrew's Quarto package required an interactive administrator password | Installed the official 1.10.18 archive locally after matching its published SHA-256 checksum. |
