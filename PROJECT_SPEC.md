# How Fast Does Normal Happen?

## Project specification

**Subtitle:** A Monte Carlo Investigation of Population Shape, Sample Size, and the Limits of the \(n=30\) Rule  
**Author:** Michael Hamaty  
**Course:** Math 167R  
**Primary seed:** `631`, representing student ID suffix `0631`  
**Primary output:** A polished Quarto website with `index.html` as the entry point

## 1. Purpose of this specification

This document is the implementation contract for the first complete build of the project. A future autonomous coding agent must be able to begin with this repository, read this specification and the repository instructions, complete the required project, verify it, commit its work in meaningful phases, and leave enough state for another agent to resume without reconstructing the conversation.

This specification distinguishes three kinds of information:

1. Required work for the first autonomous run.
2. Controlled exploration that the agent may perform while developing the method.
3. Extra-credit and creative work that must be designed for the future but not implemented in the first run.

The first run must prioritize statistical correctness, reproducibility, interpretation, and presentation quality. It must not spend implementation time on optional extensions before the required foundation is complete.

## 2. Source-of-truth hierarchy

When sources conflict, use this order:

1. `course_docs/RULES.md`
2. `course_docs/clt_project_1_student_guidance.qmd`
3. `course_docs/Math167R - Class 06 project_1_clt_monte_carlo.html`
4. This `PROJECT_SPEC.md`
5. `AGENTS.md`
6. The two course lesson documents containing code examples
7. The three instructor-provided extra-credit examples
8. Live planning files and implementation notes

The two primary assignment documents are:

- `course_docs/clt_project_1_student_guidance.qmd`
- `course_docs/Math167R - Class 06 project_1_clt_monte_carlo.html`

The current required population list comes from the later student guidance. It overrides the older project HTML where the older file suggests approximately twelve analyses.

The required populations are:

1. Standard Normal
2. Six-sided die
3. Exponential with rate \(1\)
4. Binomial with `size = 5` and `prob = 0.10`
5. Standard Cauchy

The following are future work and must not be implemented in the first run:

- dependent machine-failure process;
- independent but non-identically distributed Bernoulli process;
- custom age-at-death mixture;
- the featured creative application described in Section 18.

## 3. Scientific purpose

### 3.1 Primary research question

> How does the population distribution affect the sample size required for the sampling distribution of the mean to become approximately normal?

### 3.2 Broader interpretive question

> When is an average a trustworthy summary, and when do population shape or failed assumptions make it misleading?

The primary question must lead the introduction because it directly answers the assignment. The broader question must emerge through the analysis and guide the conclusion and future applications.

### 3.3 Supporting questions

The completed project must answer:

1. Is \(n=30\) universally sufficient?
2. Which populations converge most quickly?
3. Which finite-variance populations converge most slowly?
4. How do symmetry, skewness, and discreteness affect convergence?
5. Does agreement with the theoretical standard error occur at the same time as approximate normality?
6. When graphical and numerical diagnostics disagree, what is each diagnostic detecting?
7. How stable are the conclusions under nearby sample sizes and a different seed?
8. What does the Cauchy population reveal about the limitations of the ordinary CLT?

### 3.4 Statistical posture

This is an exploratory Monte Carlo investigation. Trial and error is part of the scientific process. The report must not pretend that every method was selected before any results were observed.

Exploration is permitted under these conditions:

1. Candidate methods are tested for a stated reason.
2. Failed or discarded methods are recorded briefly in `findings.md`.
3. A method is abandoned when it becomes misleading, redundant, excessively complicated, or forced.
4. The reason for abandonment is recorded.
5. After the final evidence standard is selected, all five populations are rerun consistently.
6. The final report distinguishes exploratory choices from theoretical facts.
7. Contradictory evidence is retained and interpreted.

## 4. Scope of the first autonomous run

### 4.1 Required implementation

The first run must produce:

- one Quarto analysis for each required population;
- a reusable but simple R simulation layer;
- a shared diagnostic layer;
- a consistent static visual system;
- a reproducibility experiment using a second seed;
- a cross-population synthesis;
- an executive conclusion;
- a polished Quarto website rendered to HTML;
- a clear README;
- a curated AI-interaction record;
- a code-source record;
- continuously updated planning files;
- meaningful Git history;
- a foundation review describing improvements needed before future work.

### 4.2 Explicitly excluded implementation

The first run must not:

- implement any of the three extra-credit simulations;
- implement the featured creative case;
- add interactive plots to the required analyses;
- introduce real historical or cultural data;
- introduce a database, web application, dashboard framework, or API;
- add machine learning;
- add complexity merely to appear sophisticated;
- continue polishing optional features while required analysis remains incomplete.

### 4.3 Definition of completion

The first run is complete only when:

1. All five required analyses are complete and rendered.
2. The final synthesis directly answers the primary and supporting questions.
3. The reproducibility experiment is complete.
4. The common method is applied consistently.
5. The website renders successfully from a clean R session.
6. Code provenance follows `course_docs/RULES.md`.
7. The README explains reproduction.
8. The AI-interaction record exists.
9. Planning files reflect the actual final state.
10. Git contains coherent milestone commits.
11. `docs/foundation_review.md` identifies weaknesses and prerequisites for future work.
12. Extra-credit and creative analyses remain unimplemented.

## 5. Scientific roles of the five populations

### 5.1 Standard Normal

Role: calibration case.

- Population: \(N(0,1)\)
- Mean: \(0\)
- Standard deviation: \(1\)
- Theoretical sampling distribution: exactly Normal for every positive \(n\)
- Theoretical standard error: \(1/\sqrt n\)
- Expected conclusion: normality is present at \(n=1\), subject only to Monte Carlo noise in the displayed diagnostics

This case establishes how the diagnostics behave when the target is truly Normal. It should help calibrate expectations for finite simulation noise.

### 5.2 Six-sided die

Role: bounded, symmetric, discrete population.

- Values: \(1,2,3,4,5,6\), equally likely
- Mean: \(3.5\)
- Variance: \(35/12\)
- Standard deviation: \(\sqrt{35/12}\)
- Theoretical standard error: \(\sqrt{35/12}/\sqrt n\)

This case studies how a visibly discrete sampling distribution becomes practically continuous and bell-shaped. The interpretation must distinguish discreteness from asymmetry.

### 5.3 Exponential

Role: strongly right-skewed continuous population.

- Rate: \(1\)
- Mean: \(1\)
- Standard deviation: \(1\)
- Theoretical standard error: \(1/\sqrt n\)

This case studies gradual reduction in skewness and tail asymmetry under averaging.

### 5.4 Small Binomial

Role: zero-heavy, skewed, discrete population.

- Distribution: \(\operatorname{Binomial}(5,0.10)\)
- Mean: \(5(0.10)=0.5\)
- Variance: \(5(0.10)(0.90)=0.45\)
- Standard deviation: \(\sqrt{0.45}\)
- Theoretical standard error: \(\sqrt{0.45}/\sqrt n\)

Use `binom_size` for the Binomial trial count so it is not confused with the sample size `n`.

This case shows that discreteness alone is not the central problem. Strong asymmetry and concentration near zero can delay convergence.

### 5.5 Standard Cauchy

Role: failure of the finite-moment assumptions behind the ordinary CLT.

- Location: \(0\)
- Scale: \(1\)
- Population mean: undefined
- Population variance: undefined
- Theoretical standard error \(\sigma/\sqrt n\): unavailable

The report must never describe the location as a mean or the scale as a standard deviation. It must never fabricate an SE comparison. Increasing \(n\) does not make the ordinary CLT apply.

The mean remains the primary statistic because the assignment concerns sample means. A comparison with the sample median may appear as a clearly labeled secondary demonstration of robustness. It must not replace the sample-mean analysis.

## 6. Reproducibility and seeds

Use:

```r
student_seed <- 631
set.seed(student_seed)
```

Display the suffix as `0631` in prose if needed, but use integer `631` in R.

Requirements:

1. Set the seed immediately before each complete population experiment.
2. Do not change the primary seed to improve results.
3. Use the same primary seed convention across the five analyses.
4. Use `reproducibility_seed <- 1631` for the required second-seed experiment.
5. Perform the second-seed experiment on the most genuinely borderline finite-variance case discovered during the analysis.
6. If two cases are equally borderline, prefer the small Binomial case.
7. Compare exact values, the selected transition region, and the final scientific conclusion.
8. Record `sessionInfo()` in the reproducibility material.

Do not store the full student ID anywhere in the repository.

## 7. Monte Carlo design

### 7.1 Repetition count

Use:

```r
B <- 10000
```

The report must explain that `n` is the number of observations in one sample while `B` is the number of repeated samples.

The agent may use a smaller `B` during rapid visual prototyping. All final reported results must use `B = 10000` unless a documented performance problem makes that impractical. If `B` changes, rerun all affected final results consistently and explain why.

### 7.2 Initial sample-size grids

Use the following as the initial exploratory grids:

- Normal: `c(1, 2, 5, 10, 30, 50, 100)`
- Die: `c(1, 2, 3, 5, 10, 15, 20, 30, 50, 100)`
- Exponential: `c(1, 2, 3, 5, 10, 15, 20, 30, 40, 50, 75, 100, 150, 200)`
- Small Binomial: `c(1, 2, 3, 5, 10, 15, 20, 30, 40, 50, 75, 100, 150, 200, 300, 500)`
- Cauchy: `c(1, 2, 5, 10, 30, 100, 500, 1000)`

These are starting points, not predetermined conclusions.

### 7.3 Adaptive refinement

For the die, Exponential, and small Binomial cases:

1. Run the broad grid.
2. Find the interval where the combined evidence changes from inadequate to plausibly adequate.
3. Add sample sizes inside that interval.
4. Continue until the smallest defensible region can be described without false precision.
5. Check the next two larger evaluated sample sizes for stability.
6. If evidence moves backward at a nearby larger \(n\), investigate Monte Carlo variability before concluding that convergence reversed.

The final conclusion may be a smallest tested value or a transition range. A range is preferable when the evidence does not support a precise boundary.

### 7.4 Simulation output contract

The reusable simulation function must return tidy results with at least:

- population identifier;
- sample size `n`;
- repetition count `B`;
- seed;
- simulated sample means;
- simulated mean of the sample means;
- simulated standard deviation of the sample means;
- theoretical mean when defined;
- theoretical standard error when defined;
- relative standard-error difference when defined;
- skewness;
- excess kurtosis;
- selected numerical Q-Q diagnostic if retained;
- notes for undefined quantities.

Keep the function interface simple. Do not build an object-oriented framework.

## 8. Developing the evidence standard

### 8.1 Seven-step protocol

This protocol must appear before the empirical results in the final project:

1. Establish the scientific question.
2. Build and verify a minimal reusable simulation.
3. Explore candidate diagnostics.
4. Experiment with visual forms.
5. Develop an operational evidence standard from the exploration.
6. Rerun the complete analysis consistently.
7. Verify, interpret, and render the final results.

### 8.2 Required evidence categories

Every finite-variance population must be evaluated using:

1. Theoretical eligibility for the ordinary CLT.
2. Simulated mean compared with the theoretical mean.
3. Simulated standard error compared with \(\sigma/\sqrt n\).
4. Skewness.
5. Excess kurtosis.
6. Histogram shape with a theoretical Normal overlay where meaningful.
7. Normal Q-Q plot.
8. Stability across nearby larger sample sizes.

The agent must explore a numerical Q-Q discrepancy because the instructor explicitly raised that idea. A standardized Q-Q RMSE or a closely related, interpretable measure is preferred. If it proves unstable, redundant, or difficult to explain, it may be removed from the final decision standard. The attempt and the reason for removal must remain in `findings.md` and the AI-interaction record.

Shapiro-Wilk may be explored. Its p-value must not determine the conclusion because `B = 10000` makes formal tests sensitive to small, practically unimportant deviations. If used, report the statistic and explain the sensitivity. Respect the function's sample-size limit.

### 8.3 Decision process for “normal enough”

Do not create a single weighted normality score.

During the calibration and pilot work, the agent must write `docs/methodology_decisions.md` containing:

- retained diagnostics;
- discarded diagnostics and reasons;
- the practical interpretation of each retained diagnostic;
- any numerical guidance bands;
- the visual criteria used;
- the stability requirement;
- the treatment of disagreement.

For a finite-variance population, the smallest defensible \(n\) or transition range must satisfy all of the following:

1. The ordinary CLT assumptions relevant to the simulated process are satisfied.
2. Empirical center and standard error behave consistently with theory within Monte Carlo variation.
3. Numerical shape diagnostics fall within the final documented practical bands.
4. Histogram and Q-Q evidence show no material remaining feature that would make a Normal approximation misleading for the project's purpose.
5. The conclusion persists at the next two larger evaluated sample sizes.

If the categories disagree, do not force a pass or fail. Explain the disagreement, identify what each diagnostic detects, and make a conservative evidence-based judgment.

The Normal case must serve as a finite-simulation calibration. Numerical diagnostics will not equal their population targets exactly even when the sampling distribution is truly Normal.

The Cauchy case is evaluated differently. Its purpose is to show that the ordinary framework is unavailable and that apparent local smoothness does not repair undefined moments or unstable tails.

## 9. Required repeated analysis structure

Each population analysis must use the same main structure:

1. **Question and role**
2. **Population and theoretical properties**
3. **Prediction before simulation**
4. **Experimental design**
5. **Numerical evidence**
6. **Interpretation of agreements and conflicts**
7. **Visual synthesis**
8. **Selected smallest defensible \(n\), transition range, or “none”**
9. **Limitations and surprise**
10. **Short conclusion**

The theory and numerical evidence must appear before the main visual synthesis. Visualizations must connect the evidence rather than substitute for it.

## 10. Visual system

### 10.1 Principles

The required analyses use static graphics. The graphics must be attractive, restrained, and interpretable without interaction.

Requirements:

- use a consistent theme;
- use accessible contrast;
- avoid unnecessary gradients and effects;
- avoid excessive rounded containers;
- use color consistently by population;
- use comparable scales when comparison is statistically meaningful;
- state when axes differ because common scales would hide important behavior;
- include descriptive captions;
- avoid decorative charts that do not support a question;
- never hide Cauchy extremes without explicitly explaining truncation or robust axis limits.

### 10.2 Population color mapping

Use a restrained, colorblind-aware mapping. The implementation may tune exact hex values while preserving distinct roles:

- Normal: deep blue
- Die: teal
- Exponential: amber or orange
- Small Binomial: violet
- Cauchy: brick red

Use neutral gray for theoretical references and a contrasting dark line for theoretical Normal overlays.

### 10.3 Repeated visualizations

Each finite-variance analysis should include:

1. Population distribution plot.
2. Sampling-distribution panels for a small \(n\), a transition-region \(n\), and a larger \(n\).
3. Theoretical Normal overlay on the sampling-distribution panels.
4. Q-Q panels for the same selected sample sizes.
5. Diagnostic trajectories over \(n\).
6. Empirical-to-theoretical standard-error comparison.

The Cauchy analysis should include:

1. Population shape with a tail warning.
2. Sampling-mean distributions at increasing \(n\).
3. Tail-aware summaries or quantiles.
4. Q-Q or other visuals that expose persistent heavy tails.
5. An optional mean-versus-median stability comparison.

### 10.4 Cross-population centerpiece

Create one static comparison figure that shows the convergence evidence across the five cases. A matrix, aligned trajectory display, or annotated comparison plot is acceptable. It must make the following visible:

- the Normal baseline;
- fast versus slow convergence among finite-variance cases;
- the absence of an ordinary-CLT result for Cauchy;
- the location of \(n=30\) as a reference, not a universal boundary.

### 10.5 Interactivity

Do not add interactive plots to the required first-run analyses.

Reserve one interactive visualization for the future featured creative case. It may allow a reader to vary the changing Bernoulli probabilities or sample size and observe the resulting sampling distribution. It must function inside the future HTML output and have a static fallback.

## 11. HTML and editorial design

### 11.1 Publication format

Build a Quarto website with:

- `index.html` as the clear entry point;
- a persistent table of contents;
- linked analysis pages;
- consistent navigation;
- custom SCSS or CSS;
- responsive layouts;
- code folding where appropriate;
- numbered sections where they improve navigation.

The website is the primary presentation artifact. The source `.qmd` files remain independently readable.

### 11.2 Editorial appearance

The design must feel sharp, academic, and intentional.

Preferred typography:

- headings: Source Serif 4, with Georgia as fallback;
- body and navigation: Source Sans 3, with a clean system sans-serif fallback;
- code: IBM Plex Mono or Source Code Pro, with monospace fallback.

Use licensed, reproducible font delivery. If remote font delivery is used, provide sensible local fallbacks.

Use organized callouts for:

- research questions;
- theoretical facts;
- interpretation cautions;
- final decisions;
- limitations.

Do not create a bubbly product dashboard. Avoid emoji-heavy headings, oversized pills, gratuitous cards, decorative gradients, and random motion.

### 11.3 Writing style

Project prose must:

- use direct sentences;
- avoid em dashes;
- avoid canned AI transitions;
- avoid inflated claims;
- avoid repeating a conclusion in slightly different words;
- distinguish evidence from interpretation;
- explain contradictions honestly;
- use precise statistical language;
- avoid claiming proof when the project provides simulation evidence;
- avoid phrases such as “clearly” when a figure or number should carry the claim.

Use first-person plural sparingly when describing project decisions, such as “we treated normality as a practical judgment.” Use neutral academic voice for theory and results.

Every important figure caption should state:

1. what is plotted;
2. what comparison matters;
3. how the figure contributes to the conclusion.

## 12. Code design and provenance

### 12.1 Simplicity

Prefer a small number of plain R functions. Avoid unnecessary abstraction, metaprogramming, class systems, deeply nested pipelines, and large dependency stacks.

Suggested separation:

- population definitions;
- simulation;
- diagnostics;
- plotting;
- report-specific calls.

### 12.2 Course-code priority

When possible, adapt code directly from:

- `course_docs/Math167R - Class 05 central_limit_theorem.html`
- `course_docs/Math167R - Class 06 statistical_distributions_lesson for class.html`

When the course examples do not cover a required technique, use one of the permitted external foundations:

- official documentation;
- Stack Overflow;
- GeeksforGeeks.

Prefer official documentation when it provides a clear foundation.

### 12.3 Comment style

R comments must not contain a space between `#` and the text.

Examples:

```r
#Adapted from Math167R Class 05 central_limit_theorem.html
```

```r
#Foundation: R stats documentation for qqnorm()
```

```r
#Load ggplot2 for consistent statistical graphics
```

Comments must explain purpose, provenance, assumptions, or a non-obvious decision. Do not add comments that merely restate simple syntax. Do not use conversational AI language in comments.

Each nontrivial function or plotting approach must have a nearby foundation comment. Also maintain `references/code_sources.md` with the source, affected file or function, and adaptation summary.

### 12.4 Package policy

Use the smallest package set that supports a high-quality result. Base R should handle random generation and core statistics. Additional packages are acceptable for consistent graphics, tidy summaries, tables, and Quarto output when they materially improve clarity.

Do not use `renv` unless environment inspection shows it is already suitable and adds little friction. Record package versions through `sessionInfo()` at minimum.

## 13. Repository architecture

Target structure:

```text
.
├── AGENTS.md
├── PROJECT_SPEC.md
├── README.md
├── _quarto.yml
├── index.qmd
├── course_docs/
├── analyses/
│   ├── 01_normal.qmd
│   ├── 02_die.qmd
│   ├── 03_exponential.qmd
│   ├── 04_binomial_small.qmd
│   └── 05_cauchy.qmd
├── R/
│   ├── populations.R
│   ├── simulation.R
│   ├── diagnostics.R
│   └── plots.R
├── docs/
│   ├── methodology_decisions.md
│   ├── ai_interaction_log.md
│   ├── foundation_review.md
│   └── future_extensions.md
├── references/
│   └── code_sources.md
├── styles/
│   └── theme.scss
├── results/
│   └── diagnostics.csv
├── task_plan.md
├── findings.md
└── progress.md
```

Generated Quarto support directories must follow Quarto conventions and `.gitignore` policy. Commit the final rendered website if the repository is intended to display the HTML directly or through GitHub Pages. Do not commit disposable caches unless required for reliable rendering.

## 14. Reader journey

### 14.1 Landing page

The `index.qmd` landing page must contain:

1. Project title and concise subtitle.
2. Executive overview.
3. Primary research question.
4. Explanation of population versus sampling distribution.
5. Plain-language CLT statement and assumptions.
6. Why \(n=30\) is a rule of thumb.
7. Seven-step experimental protocol.
8. Concise cross-population summary.
9. Main comparison visualization.
10. Direct answer to the primary question.
11. Links to the five detailed analyses.
12. Reproducibility information.
13. Future-work preview.

### 14.2 Analysis pages

Each analysis page follows Section 9 and uses the shared visual language.

### 14.3 Final synthesis

The synthesis must include a table with at least:

- population;
- relevant CLT conditions;
- selected smallest defensible \(n\), transition range, or none;
- skewness at the selected point when meaningful;
- excess kurtosis at the selected point when meaningful;
- standard-error agreement when meaningful;
- stability result;
- primary conclusion.

The synthesis must state that no universal threshold was established if that is what the evidence shows. It must not prewrite numerical conclusions before simulations are complete.

## 15. Required documentation

### 15.1 README

The README must explain:

- the scientific question;
- the five required populations;
- the main result after analysis;
- repository structure;
- prerequisites;
- how to render the website;
- where to find the final HTML;
- how reproducibility is handled;
- how AI assistance was documented;
- where future extensions are described.

### 15.2 AI-interaction record

`docs/ai_interaction_log.md` must be curated for the course requirement. It must show meaningful iterations rather than raw chat history.

For each selected interaction, record:

1. Initial prompt or concise faithful excerpt.
2. What the response proposed.
3. What weakness, error, or unanswered question was identified.
4. The follow-up prompt or correction.
5. How the result improved.
6. How the code or conclusion was verified.

### 15.3 Foundation review

`docs/foundation_review.md` is required before the first run may finish. It must identify:

- remaining analytical weaknesses;
- results that deserve more sensitivity analysis;
- visualizations worth refining;
- code that could be simplified;
- prose that should receive human review;
- possible additional diagnostics;
- prerequisites for extra-credit implementation;
- prerequisites for the featured creative case;
- any limitation that could affect interpretation.

This document is a handoff for the next phase, not an excuse to leave required work incomplete.

### 15.4 Future extensions

`docs/future_extensions.md` must describe the future work in Section 18. It must not contain completed extension results during the first run.

## 16. Git and recovery workflow

### 16.1 Repository boundary

The current workspace has previously appeared inside a broader Git repository rooted above the project directory. Before implementation:

1. Verify the Git top-level directory.
2. Inspect the supplied remote repository safely.
3. Preserve all `course_docs` files.
4. Establish this project as its own repository connected to:
   `https://github.com/Michaelhamaty/Math_167R_Project_1--MichaelHamaty.git`
5. Do not overwrite remote or local work.
6. If remote and local histories both contain work, reconcile them explicitly and non-destructively.

### 16.2 Planning files

Use:

- `task_plan.md` for phases, active work, and completion state;
- `findings.md` for discoveries, decisions, failed approaches, and statistical observations;
- `progress.md` for implementation log, commands, render results, tests, and handoff state.

At the start of every resumed session, read:

1. `AGENTS.md`
2. `PROJECT_SPEC.md`
3. `task_plan.md`
4. `findings.md`
5. `progress.md`

### 16.3 Update cadence

- Update `task_plan.md` when a phase begins, changes, or completes.
- Update `findings.md` after meaningful discoveries, design changes, or abandoned approaches.
- Update `progress.md` after implementation, rendering, testing, and before stopping.
- Before every milestone commit, reconcile all three files with actual repository state.
- Keep entries concise enough that a new agent can orient quickly.

### 16.4 Commit and push cadence

Create one coherent commit per verified milestone. Push verified milestone commits to the configured GitHub remote so recovery does not depend on one machine or one usage window.

Suggested sequence:

```text
plan: establish project architecture
feat: add reusable simulation engine
analysis: complete normal calibration
analysis: complete six-sided die investigation
analysis: complete exponential investigation
analysis: complete small binomial investigation
analysis: complete cauchy stress test
docs: add cross-distribution synthesis
style: finalize HTML presentation
test: verify reproducible rendering
docs: record foundation review and future work
```

Do not commit broken generated output as a completed milestone. Do not rewrite shared history or use destructive Git commands.

## 17. Autonomous execution behavior

Use `planning-with-files` autonomous mode after the specification, repository instructions, and hooks have been audited and approved.

The autonomous agent must:

1. Continue through the required phases without waiting for routine confirmation.
2. Prefer simple, working methods.
3. Abandon a method when it is being forced.
4. Record the abandoned method and reason in `findings.md`.
5. Use safe alternatives when a package or visualization technique is unavailable.
6. Never reduce correctness to preserve a decorative feature.
7. Keep planning files and Git milestones synchronized.
8. Stop optional work when it threatens required quality.
9. Complete the foundation review before declaring completion.

The agent must not interpret autonomous mode as permission to:

- change project scope;
- implement future extensions;
- invent historical claims;
- hide failed tests;
- alter the seed to improve results;
- overwrite user work;
- push secrets or personal identifiers;
- bypass repository or tool safety rules.

## 18. Future work, not first-run implementation

### 18.1 Instructor-provided extra-credit cases

Document eventual implementation plans for:

1. **Dependent machine failures**
   - Studies dependence.
   - Uses the instructor-provided conditional exponential model.
   - Must discuss effective sample size and conditional versus marginal distributions.

2. **Non-identical Bernoulli observations**
   - Studies independent observations with changing probabilities.
   - Uses the instructor-provided basketball structure as the mathematical foundation.
   - Must distinguish fixed Binomial trials from changing Bernoulli probabilities.

3. **Custom age-at-death mixture**
   - Studies an irregular two-component discrete population.
   - Must state that the distribution is stylized and not fitted historical mortality data.

### 18.2 Featured creative case

The featured creative case is **stylized heritage-language retention under changing probabilities**.

It must be labeled prominently as a creative, simplified simulation. It must not be presented as observed cultural data or a validated sociological model.

Safe conceptual structure:

- observations represent different households or communities under ordered generational or contextual conditions;
- each observation is Bernoulli;
- observations are independent by simplifying assumption;
- retention probabilities vary across observations;
- the statistical question concerns the sampling behavior of an average under non-identical probabilities.

Respectful framing requirements:

- do not rank languages or communities;
- do not describe language retention or language shift as inherently superior or inferior;
- do not make claims about any named ethnic, national, religious, or immigrant group without credible data and appropriate scope;
- do not imply that the model explains real assimilation, discrimination, education, migration, or policy effects;
- discuss independence as an unrealistic simplification;
- state that families and communities may influence one another;
- treat cultural transmission as complex and context-dependent.

The eventual interactive visualization may allow the reader to vary a probability path and sample size, then observe the simulated distribution of an average or total. It must have a static fallback and must function inside the rendered HTML.

### 18.3 Possible later empirical layer

A real dataset may be considered only after the stylized required and extra-credit work is sound. Any empirical layer must:

1. use a credible source;
2. explain sampling and measurement limitations;
3. separate observed data from stylized assumptions;
4. avoid causal conclusions unsupported by the design;
5. remain optional.

## 19. Implementation phases

The planning system should instantiate these phases:

### Phase 0: Environment and repository safety

- verify Git boundary and remote;
- inspect R and Quarto availability;
- inspect relevant package availability;
- preserve course documents;
- create initial planning files;
- record environment findings.

### Phase 1: Project skeleton and design system

- create repository structure;
- configure Quarto website;
- create restrained editorial theme;
- create documentation placeholders;
- render a minimal site.

### Phase 2: Reusable simulation foundation

- implement population definitions;
- implement Monte Carlo simulation;
- implement core diagnostics;
- implement initial static plots;
- verify theoretical values;
- document code sources.

### Phase 3: Calibration and method exploration

- complete the Normal calibration;
- pilot Exponential and Cauchy contrasts;
- test candidate numerical Q-Q diagnostics;
- test visual layouts;
- record failed approaches;
- finalize `docs/methodology_decisions.md`;
- rerun affected work consistently.

### Phase 4: Required population analyses

- complete Normal;
- complete die;
- complete Exponential;
- complete small Binomial;
- complete Cauchy;
- refine adaptive grids where needed;
- commit and push each verified analysis milestone.

### Phase 5: Reproducibility and synthesis

- select the borderline case;
- rerun it with seed `1631`;
- complete comparison table;
- create comparison visualization;
- answer the research questions;
- write the executive conclusion from actual results.

### Phase 6: Editorial and HTML refinement

- refine typography and spacing;
- review captions and callouts;
- confirm responsive layout;
- remove unnecessary visual effects;
- confirm no em dashes remain in project prose;
- confirm code comments use the required style;
- confirm navigation and links.

### Phase 7: Verification and handoff

- render from a clean session;
- run all available checks;
- inspect warnings and errors;
- verify sources and provenance;
- update README and AI record;
- write foundation review;
- write future extension plan;
- reconcile planning files;
- commit and push the verified final milestone.

## 20. Acceptance tests

The agent must verify at least:

### Statistical checks

- Normal theoretical mean and SD are correct.
- Die theoretical mean and variance are correct.
- Exponential theoretical mean and SD are correct.
- Small Binomial theoretical mean and variance are correct.
- Cauchy mean, variance, and theoretical SE are marked unavailable.
- Empirical finite-variance SE values approach theoretical SE values.
- The primary seed reproduces identical results.
- The second-seed experiment produces a documented comparison.

### Structural checks

- all required files exist;
- all internal links resolve;
- the site navigation includes all five analyses;
- `index.html` is generated;
- no required analysis is replaced by a future-work note;
- no extra-credit implementation appears in the first-run result.

### Style checks

- essentially I do not want it to look like a plain AI made html file. AI use is permitted, it is not
   like I am trying to avoid getting caught using AI, I simply want it to look pretty. 
- no em dash character appears in authored project prose;
- code comments begin with `#` and no following space;
- all nontrivial external code foundations are recorded;
- figures use consistent labels and captions;
- HTML does not depend on the future interactive component.

### Recovery checks

- `task_plan.md` names the current or final phase accurately;
- `findings.md` records important decisions and abandoned approaches;
- `progress.md` records the latest render and test result;
- Git status is understood and intentional;
- verified milestones are pushed to the project remote;
- a new agent can identify the next action from the files alone.

## 21. Final handoff standard

At completion, a new reader should be able to answer the following:

- What was investigated?
- Why were these five populations selected?
- How was the simulation conducted?
- What counted as approximately normal?
- How did each population behave?
- Is \(n=30\) universal?
- Why does Cauchy behave differently?
- How reproducible are the conclusions?
- Which methods were tried and discarded?
- How can the site be rendered again?
- What should be improved before extra-credit and creative work begins?

If the repository cannot answer these questions through its files and rendered HTML, the first run is not complete. Results and analyzation should be anambiguos and easy to interpret. 

Very important: When you reach your final handoff, I want you to send a fresh agent to review the final form, however, you need to hand this fresh agent some handoff of what it should be looking for. I want it to review the graphs and make sure nothing is overlapping and that it is a clean graph, review all the text, and offer suggestions for revisions or ways the 'foundation' can be improved. It should have context of the extra credit + creative work and make suggestions for future steps upon completion of the first final handoff. 
