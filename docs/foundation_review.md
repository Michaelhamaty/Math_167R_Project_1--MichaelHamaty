# Foundation Review

## First-run foundation

The completed site keeps the original deterministic iid simulation interface and five required populations as a frozen regression baseline. The extension layer adds a separate process-aware interface for dependent and non-identical observations, compact committed results, a shared graphical system, and assertions for the exact or simulation-reference quantities that anchor each case. This separation prevents the extension analyses from silently inheriting iid assumptions.

## Valid fixes from visual and editorial review

- The original Cauchy histogram inherited bin widths from extreme values, which made the central window unreadable. It now computes fixed bins inside the declared window, uses all 10,000 means in the density denominator, and reports the fraction outside the window.
- Filtered diagnostic tables initially displayed source row numbers as an unlabeled first column. Every rendered table now suppresses them explicitly.
- The landing page initially repeated its title in the hero. The hero now carries a distinct thesis line.
- Captions now state what is plotted, the relevant comparison, and why the comparison matters. Every figure has alternative text.
- The desktop landing page and a 367 by 730 responsive view were inspected. Navigation collapses cleanly, tables remain exposed to assistive technology, and the code-fold controls remain reachable.
- A fresh context-free reviewer found that the initial Exponential $n=300$ decision depended on an unusually favorable seed-631 skewness estimate. The sensitivity case was reassigned to Exponential and the conservative threshold was raised to $n=1000$.
- The reviewer also identified missing theoretical overlays, SE comparisons, two crowded trajectory axes, landing-page teaching sections, and README content. These were treated as required first-run fixes.

## Remaining weaknesses

- The reported sample sizes are practical whole-distribution judgments, not universal cutoffs. Tail probabilities and continuity-sensitive tasks can require larger samples.
- Q-Q RMSE is calibrated against one seed and one evaluated Normal grid. The practical floors prevent overfitting to that run, but a larger calibration study could quantify its Monte Carlo distribution more directly.
- Histogram appearance still depends on bin choices. The paired Q-Q plots and numerical diagnostics reduce, but do not eliminate, that subjectivity.
- Shapiro-Wilk W is computed for audit but adds little interpretive value. A future simplification could remove it from the result-generation code after preserving the documented rejection.
- Automated checks verify source rules, results, and links, but not pixel-level layout. Visual inspection remains part of the release process.
- The pinned Quarto archive lives in ignored `.tools/`, so a fresh clone requires a compatible Quarto installation even though the rendered site is committed.
- The dependent-process marginal mean and variance are simulation references from a long deterministic chain, not exact theoretical moments. A substantially different process would need its own convergence study.
- Browser automation could not open the local `file://` site under the managed browser policy. The interactive calculation and rendered accessibility structure were tested with Node, while the complete static gallery was inspected directly.
- Discrete Bernoulli averages retain visible lattice effects in tail-sensitive Q-Q diagnostics after their central shape is practically useful. That disagreement is a limitation of the approximation, not a failed computation.
- Fresh extension review found that indented HTML controls had been escaped by the renderer even though a string-only validator passed. The interaction now uses an explicit raw-HTML block, and the Node validator executes initialization against a minimal DOM and canvas contract before checking rendered controls.
- The same review prompted separately contained display equations, disclosed per-panel age-distribution scales, and exact provenance for the independent-array theorem and deterministic browser generator.

## Sensitivity and future prerequisites

The extension phase now includes theory assertions for dependence and non-identical observations, framework-specific diagnostics, a respectful-framing review, and a static fallback for the creative interaction. Any future empirical layer still needs documented provenance, measurement limitations, subject-matter review, and a strict separation from the stylized assumptions used here.

## Simplification opportunities

The next maintenance pass could centralize repeated page setup and table formatting in one small helper file. That change should preserve transparent R code on each page and should be accepted only if it reduces duplication without hiding the simulation logic students are expected to explain.
