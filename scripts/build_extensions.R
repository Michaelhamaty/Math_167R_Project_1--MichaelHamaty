source("R/diagnostics.R")
source("R/simulation.R")
source("R/extensions.R")

B <- 10000L
primary_seed <- 631L

bind_extension_rows <- function(...) {
  frames <- list(...)
  columns <- unique(unlist(lapply(frames, names), use.names = FALSE))
  aligned <- lapply(frames, function(frame) {
    missing <- setdiff(columns, names(frame))
    for (name in missing) frame[[name]] <- NA
    frame[, columns, drop = FALSE]
  })
  do.call(rbind, aligned)
}

reference <- simulate_dependent_reference(retained = 1000000L, burn_in = 10000L, seed = primary_seed)
reference_outputs <- dependent_reference_summary(reference)
dependent <- simulate_dependent_case(reference$values, B = B, seed = primary_seed, burn_in = 500L)

sensitivity_rows <- lapply(c(250L, 500L, 1000L), function(burn_in) {
  result <- simulate_dependent_case(reference$values, n_values = c(100, 500, 2000), B = B, seed = 1631L, burn_in = burn_in)$summary
  result <- result[result$variant == "dependent", ]
  result$burn_in <- burn_in
  result
})
dependent_sensitivity <- do.call(rbind, sensitivity_rows)

bernoulli_n <- c(5, 10, 20, 30, 50, 75, 100, 200, 500)
bernoulli_changing <- simulate_probability_case(
  "nonidentical_bernoulli", "Non-identical Bernoulli", "changing 0.90 to 0.50",
  0.90, 0.50, bernoulli_n, B, primary_seed,
  notes = "The sample total is Poisson-binomial, not ordinary Binomial."
)$summary
bernoulli_fixed <- simulate_probability_case(
  "nonidentical_bernoulli", "Non-identical Bernoulli", "fixed 0.70",
  0.70, 0.70, bernoulli_n, B, primary_seed,
  notes = "Matched iid Bernoulli comparator with the same average probability."
)$summary

age_population <- make_age_population()
age_base <- simulate_population(age_population, B = B, seed = primary_seed)$summary
age_summary <- data.frame(
  case_id = "age_mixture",
  label = age_population$label,
  variant = "synthetic mixture",
  framework = "iid finite-variance discrete population",
  n = age_base$n,
  B = age_base$B,
  seed = age_base$seed,
  theoretical_mean = age_base$theoretical_mean,
  theoretical_se = age_base$theoretical_se,
  reference_mean = NA_real_,
  reference_sd = NA_real_,
  simulated_mean = age_base$simulated_mean,
  simulated_se = age_base$simulated_se,
  mean_error = age_base$mean_error,
  mean_mcse = age_base$mean_mcse,
  relative_se_error = age_base$relative_se_error,
  skewness = age_base$skewness,
  excess_kurtosis = age_base$excess_kurtosis,
  qq_rmse = age_base$qq_rmse,
  q01 = age_base$q01,
  q25 = age_base$q25,
  median = age_base$median,
  q75 = age_base$q75,
  q99 = age_base$q99,
  ordinary_clt_eligible = TRUE,
  notes = "Synthetic graph-inspired distribution, not historical mortality data."
)

creative_n <- c(10, 20, 30, 50, 75, 100, 150, 200)
scenarios <- make_creative_scenarios()
creative_rows <- lapply(seq_len(nrow(scenarios)), function(index) {
  scenario <- scenarios[index, ]
  simulate_probability_case(
    "heritage_language", "Stylized Heritage-Language Retention", scenario$variant,
    scenario$start_probability, scenario$end_probability,
    creative_n, B, primary_seed,
    notes = "Creative simplified model with independent observations; not observed cultural data."
  )$summary
})
creative_summary <- do.call(rbind, creative_rows)

extension_diagnostics <- bind_extension_rows(dependent$summary, bernoulli_changing, bernoulli_fixed, age_summary, creative_summary)

extension_decisions <- data.frame(
  case_id = c("dependent_failure", "nonidentical_bernoulli", "age_mixture", "heritage_language"),
  ordinary_iid_clt = c(FALSE, FALSE, TRUE, FALSE),
  generalized_or_iid_framework = c("Dependent-process approximation", "Bounded independent-array CLT", "Ordinary iid CLT", "Bounded independent-array CLT"),
  smallest_defensible_n = c(NA_integer_, 50L, 75L, 50L),
  conclusion = c("No calibration-band threshold through n = 2000", "Practical Normal shape by n = 50", "Practical Normal shape by n = 75", "Static gallery is practically Normal by n = 50"),
  key_caveat = c("Marginal theory is simulation-referenced and dependence remains", "Lattice-sensitive Q-Q RMSE stays above calibration", "Synthetic graph-inspired population, not historical data", "Creative independent model, not observed cultural data"),
  stringsAsFactors = FALSE
)

utils::write.csv(extension_diagnostics, "results/extension_diagnostics.csv", row.names = FALSE, na = "")
utils::write.csv(reference_outputs$summary, "results/dependent_reference.csv", row.names = FALSE, na = "")
utils::write.csv(reference_outputs$acf, "results/dependent_acf.csv", row.names = FALSE, na = "")
utils::write.csv(dependent_sensitivity, "results/dependent_sensitivity.csv", row.names = FALSE, na = "")
utils::write.csv(age_population$distribution, "results/age_distribution.csv", row.names = FALSE, na = "")
utils::write.csv(scenarios, "results/creative_scenarios.csv", row.names = FALSE, na = "")
utils::write.csv(extension_decisions, "results/extension_decisions.csv", row.names = FALSE, na = "")

cat("Wrote extension summaries for", nrow(extension_diagnostics), "case, variant, and sample-size combinations.\n")
