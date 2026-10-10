# Task Plan: How Fast Does Normal Happen?

## Goal
Build, verify, commit, and push the complete five-population Central Limit Theorem Monte Carlo Quarto website defined by `PROJECT_SPEC.md`.

## Next Step
Commit each verified population analysis, then complete the synthesis and second-seed comparison.

## Current Phase
Phase 4

## Phases

### Phase 0: Environment and repository safety
- [x] Verify and isolate the Git boundary
- [x] Connect the empty GitHub remote
- [x] Install pinned workspace planning files
- [x] Validate hooks and install Quarto
- **Status:** complete

### Phase 1: Project skeleton and design system
- [x] Create the Quarto site structure
- [x] Add the editorial theme and documentation shells
- [x] Render the minimal site
- **Status:** complete

### Phase 2: Reusable simulation foundation
- [x] Implement populations, simulation, diagnostics, and plots
- [x] Add deterministic validation
- [x] Verify theoretical values and reproducibility
- **Status:** complete

### Phase 3: Calibration and method exploration
- [x] Calibrate with Standard Normal
- [x] Pilot Exponential and Cauchy
- [x] Freeze and document the evidence standard
- **Status:** complete

### Phase 4: Required population analyses
- [x] Complete Normal
- [x] Complete die
- [ ] Complete Exponential
- [ ] Complete small Binomial
- [ ] Complete Cauchy
- **Status:** in_progress

### Phase 5: Reproducibility and synthesis
- [ ] Run the second-seed experiment
- [ ] Build the comparison table and centerpiece
- [ ] Write conclusions from actual results
- **Status:** pending

### Phase 6: Editorial and visual quality
- [ ] Apply prose and code-style checks
- [ ] Inspect desktop and narrow layouts
- [ ] Fix every visual or accessibility defect
- **Status:** pending

### Phase 7: Verification and handoff
- [ ] Render from a clean R session
- [ ] Run all acceptance checks
- [ ] Complete a fresh-agent review and revisions
- [ ] Reconcile documentation, commits, and remote state
- **Status:** pending

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Use the five later-guidance populations only | The higher-priority student guidance overrides the older twelve-analysis brief. |
| Use pinned planning-with-files v3.24.0 at commit 7056ed2 | This is the audited release selected in the approved plan. |
| Use gated root planning mode | It adds bounded Stop enforcement to autonomous behavior while keeping the three required files at repository root. |
| Use base R, ggplot2, and knitr only | The installed packages cover the required analysis without an unnecessary dependency stack. |

## Errors Encountered
| Error | Resolution |
|-------|------------|
| Initial writes to protected `.agents` and `.codex` paths were denied | Repeated the approved copy with narrowly scoped elevated access. |
| The audit environment lacked pytest | Ran the upstream unittest modules instead. |
| One upstream audit test writes to sandbox-blocked `/var/tmp` | Documented as environment-inapplicable; all other selected tests pass with the temp cache override. |
| Homebrew downloaded Quarto 1.10.19 but its package installer required interactive administrator authentication | Use the official release archive in the ignored project-local `.tools/` directory and verify its published checksum. |
