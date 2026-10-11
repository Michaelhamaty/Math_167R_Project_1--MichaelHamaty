#Course adaptation: process definitions follow the three instructor-provided extension examples.
validate_extension_inputs <- function(n_values, B, seed) {
  if (!is.numeric(n_values) || !length(n_values) || any(!is.finite(n_values)) || any(n_values < 1) || any(n_values != as.integer(n_values))) stop("n_values must contain positive integers.")
  if (length(B) != 1L || !is.numeric(B) || !is.finite(B) || B < 2 || B != as.integer(B)) stop("B must be an integer of at least 2.")
  if (length(seed) != 1L || !is.numeric(seed) || !is.finite(seed) || seed < 0 || seed != as.integer(seed)) stop("seed must be a nonnegative integer.")
  invisible(TRUE)
}

probability_path <- function(n, start_probability, end_probability) {
  if (length(n) != 1L || !is.numeric(n) || n < 1 || n != as.integer(n)) stop("n must be a positive integer.")
  endpoints <- c(start_probability, end_probability)
  if (any(!is.finite(endpoints)) || any(endpoints <= 0) || any(endpoints >= 1)) stop("Probabilities must lie strictly between zero and one.")
  seq(start_probability, end_probability, length.out = as.integer(n))
}

summarize_extension_means <- function(means, case_id, label, variant, framework, n, B, seed, theoretical_mean = NA_real_, theoretical_se = NA_real_, reference_mean = NA_real_, reference_sd = NA_real_, ordinary_clt_eligible = FALSE, notes = "") {
  validate_numeric_vector(means, "means")
  target_mean <- if (is.finite(theoretical_mean)) theoretical_mean else reference_mean
  simulated_mean <- mean(means)
  simulated_se <- stats::sd(means)
  mean_error <- if (is.finite(target_mean)) simulated_mean - target_mean else NA_real_
  mean_mcse <- simulated_se / sqrt(B)
  relative_se_error <- if (is.finite(theoretical_se)) abs(simulated_se / theoretical_se - 1) else NA_real_
  data.frame(
    case_id = case_id,
    label = label,
    variant = variant,
    framework = framework,
    n = as.integer(n),
    B = as.integer(B),
    seed = as.integer(seed),
    theoretical_mean = theoretical_mean,
    theoretical_se = theoretical_se,
    reference_mean = reference_mean,
    reference_sd = reference_sd,
    simulated_mean = simulated_mean,
    simulated_se = simulated_se,
    mean_error = mean_error,
    mean_mcse = mean_mcse,
    relative_se_error = relative_se_error,
    skewness = moment_skewness(means),
    excess_kurtosis = excess_kurtosis(means),
    qq_rmse = qq_rmse(means),
    q01 = unname(stats::quantile(means, 0.01, type = 8)),
    q25 = unname(stats::quantile(means, 0.25, type = 8)),
    median = stats::median(means),
    q75 = unname(stats::quantile(means, 0.75, type = 8)),
    q99 = unname(stats::quantile(means, 0.99, type = 8)),
    ordinary_clt_eligible = ordinary_clt_eligible,
    notes = notes,
    stringsAsFactors = FALSE
  )
}

simulate_probability_case <- function(case_id, label, variant, start_probability, end_probability, n_values, B = 10000L, seed = 631L, keep_means = FALSE, notes = "") {
  validate_extension_inputs(n_values, B, seed)
  set.seed(as.integer(seed))
  summaries <- vector("list", length(n_values))
  mean_rows <- if (keep_means) vector("list", length(n_values)) else NULL
  path_rows <- vector("list", length(n_values))
  for (index in seq_along(n_values)) {
    n <- as.integer(n_values[index])
    probabilities <- probability_path(n, start_probability, end_probability)
    uniforms <- matrix(stats::runif(B * n), nrow = B, ncol = n)
    draws <- uniforms < rep(probabilities, each = B)
    means <- rowMeans(draws)
    theoretical_mean <- mean(probabilities)
    theoretical_se <- sqrt(sum(probabilities * (1 - probabilities))) / n
    summaries[[index]] <- summarize_extension_means(
      means, case_id, label, variant, "independent non-identical Bernoulli",
      n, B, seed, theoretical_mean, theoretical_se,
      ordinary_clt_eligible = FALSE, notes = notes
    )
    summaries[[index]]$max_variance_share <- max(probabilities * (1 - probabilities)) / sum(probabilities * (1 - probabilities))
    if (keep_means) mean_rows[[index]] <- data.frame(case_id = case_id, variant = variant, n = n, sample_mean = means)
    path_rows[[index]] <- data.frame(case_id = case_id, variant = variant, n = n, position = seq_len(n), probability = probabilities)
  }
  list(
    summary = do.call(rbind, summaries),
    means = if (keep_means) do.call(rbind, mean_rows) else NULL,
    paths = do.call(rbind, path_rows)
  )
}

make_age_distribution <- function() {
  age <- 0:100
  early_component <- 0.045 * exp(-age / 5)
  adult_component <- 0.030 * exp(-0.5 * ((age - 65) / 10)^2)
  weight <- early_component + adult_component
  probability <- weight / sum(weight)
  data.frame(age = age, early_component = early_component, adult_component = adult_component, probability = probability, percent = 100 * probability)
}

make_age_population <- function() {
  distribution <- make_age_distribution()
  population_mean <- sum(distribution$age * distribution$probability)
  population_variance <- sum((distribution$age - population_mean)^2 * distribution$probability)
  list(
    id = "age_mixture",
    label = "Synthetic Age-at-Death Mixture",
    short_label = "Synthetic Age Mixture",
    generator = function(n) sample(distribution$age, size = n, replace = TRUE, prob = distribution$probability),
    density = NULL,
    support = c(-0.5, 100.5),
    mean = population_mean,
    variance = population_variance,
    color = "#56745f",
    n_values = c(1, 2, 5, 10, 20, 30, 50, 75, 100, 150, 200, 300),
    distribution = distribution
  )
}

dependent_rate <- function(previous_time, baseline_rate = 1, beta = 1.25, reference_time = 1) {
  rate <- baseline_rate * exp(beta * (previous_time - reference_time))
  if (any(!is.finite(rate)) || any(rate <= 0)) stop("Dependent rate became non-finite or non-positive.")
  rate
}

simulate_dependent_reference <- function(retained = 1000000L, burn_in = 10000L, seed = 631L) {
  validate_extension_inputs(1L, retained, seed)
  if (burn_in < 1 || burn_in != as.integer(burn_in)) stop("burn_in must be a positive integer.")
  set.seed(as.integer(seed))
  total <- as.integer(retained + burn_in)
  values <- numeric(total)
  rates <- numeric(total)
  rates[1] <- 1
  values[1] <- stats::rexp(1, rate = rates[1])
  for (index in 2:total) {
    rates[index] <- dependent_rate(values[index - 1])
    values[index] <- stats::rexp(1, rate = rates[index])
  }
  keep <- seq.int(burn_in + 1L, total)
  list(values = values[keep], rates = rates[keep])
}

simulate_dependent_case <- function(reference_values, n_values = c(5, 10, 20, 30, 50, 75, 100, 200, 500, 750, 1000, 1500, 2000), B = 10000L, seed = 631L, burn_in = 500L, keep_means = FALSE) {
  validate_extension_inputs(n_values, B, seed)
  validate_numeric_vector(reference_values, "reference_values")
  if (burn_in < 1 || burn_in != as.integer(burn_in)) stop("burn_in must be a positive integer.")
  set.seed(as.integer(seed))
  previous <- stats::rexp(B, rate = 1)
  for (step in seq_len(as.integer(burn_in))) previous <- stats::rexp(B, rate = dependent_rate(previous))
  maximum_n <- max(n_values)
  cumulative <- numeric(B)
  requested <- stats::setNames(seq_along(n_values), as.character(n_values))
  dependent_means <- vector("list", length(n_values))
  for (step in seq_len(maximum_n)) {
    previous <- stats::rexp(B, rate = dependent_rate(previous))
    cumulative <- cumulative + previous
    key <- as.character(step)
    if (key %in% names(requested)) dependent_means[[requested[[key]]]] <- cumulative / step
  }
  iid_cumulative <- numeric(B)
  iid_means <- vector("list", length(n_values))
  for (step in seq_len(maximum_n)) {
    iid_cumulative <- iid_cumulative + sample(reference_values, B, replace = TRUE)
    key <- as.character(step)
    if (key %in% names(requested)) iid_means[[requested[[key]]]] <- iid_cumulative / step
  }
  reference_mean <- mean(reference_values)
  reference_sd <- stats::sd(reference_values)
  summary_rows <- vector("list", 2L * length(n_values))
  mean_rows <- if (keep_means) vector("list", 2L * length(n_values)) else NULL
  for (index in seq_along(n_values)) {
    n <- as.integer(n_values[index])
    dependent <- dependent_means[[index]]
    matched <- iid_means[[index]]
    dependent_summary <- summarize_extension_means(
      dependent, "dependent_failure", "Dependent Machine Failures", "dependent",
      "dependent conditional Exponential process", n, B, seed,
      reference_mean = reference_mean, reference_sd = reference_sd,
      ordinary_clt_eligible = FALSE,
      notes = "Marginal center and spread are estimated from a long reference chain."
    )
    dependent_summary$iid_reference_se <- reference_sd / sqrt(n)
    dependent_summary$effective_n <- reference_sd^2 / stats::var(dependent)
    matched_summary <- summarize_extension_means(
      matched, "dependent_failure", "Dependent Machine Failures", "matched marginal iid",
      "iid resampling from estimated marginal", n, B, seed,
      reference_mean = reference_mean, reference_sd = reference_sd,
      ordinary_clt_eligible = TRUE,
      notes = "Comparator resamples the estimated marginal and removes serial dependence."
    )
    matched_summary$iid_reference_se <- reference_sd / sqrt(n)
    matched_summary$effective_n <- reference_sd^2 / stats::var(matched)
    summary_rows[[2L * index - 1L]] <- dependent_summary
    summary_rows[[2L * index]] <- matched_summary
    if (keep_means) {
      mean_rows[[2L * index - 1L]] <- data.frame(case_id = "dependent_failure", variant = "dependent", n = n, sample_mean = dependent)
      mean_rows[[2L * index]] <- data.frame(case_id = "dependent_failure", variant = "matched marginal iid", n = n, sample_mean = matched)
    }
  }
  list(summary = do.call(rbind, summary_rows), means = if (keep_means) do.call(rbind, mean_rows) else NULL)
}

dependent_reference_summary <- function(reference, maximum_lag = 20L) {
  values <- reference$values
  autocorrelation <- as.numeric(stats::acf(values, lag.max = maximum_lag, plot = FALSE)$acf)[-1]
  list(
    summary = data.frame(
      seed = 631L,
      retained = length(values),
      mean = mean(values),
      sd = stats::sd(values),
      minimum = min(values),
      maximum = max(values),
      lag1_autocorrelation = autocorrelation[1]
    ),
    acf = data.frame(lag = seq_along(autocorrelation), autocorrelation = autocorrelation),
    segment = data.frame(step = seq_len(120L), operating_time = values[seq_len(120L)], failure_rate = reference$rates[seq_len(120L)])
  )
}

make_creative_scenarios <- function() {
  data.frame(
    variant = c("Stable", "Gradual increase", "Gradual decrease"),
    start_probability = c(0.60, 0.45, 0.75),
    end_probability = c(0.60, 0.75, 0.45),
    stringsAsFactors = FALSE
  )
}
