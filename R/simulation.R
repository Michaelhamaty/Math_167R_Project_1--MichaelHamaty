#Course adaptation: this vectorized form implements the course's replicate-and-average simulation.
validate_simulation_inputs <- function(population, n_values, B, seed) {
  if (!is.list(population) || is.null(population$generator)) stop("population must define a generator.")
  if (!is.numeric(n_values) || length(n_values) == 0L || any(!is.finite(n_values)) || any(n_values < 1) || any(n_values != as.integer(n_values))) stop("n_values must contain positive integers.")
  if (length(B) != 1L || !is.numeric(B) || !is.finite(B) || B < 2 || B != as.integer(B)) stop("B must be an integer of at least 2.")
  if (length(seed) != 1L || !is.numeric(seed) || !is.finite(seed) || seed < 0 || seed != as.integer(seed)) stop("seed must be a nonnegative integer.")
  invisible(TRUE)
}

draw_sample_means <- function(population, n, B) {
  draws <- population$generator(n * B)
  if (length(draws) != n * B || any(!is.finite(draws))) stop("Generator returned an unexpected or non-finite result.")
  rowMeans(matrix(draws, nrow = B, ncol = n))
}

simulate_population <- function(population, n_values = population$n_values, B = 10000L, seed = 631L, keep_means = FALSE) {
  validate_simulation_inputs(population, n_values, B, seed)
  set.seed(as.integer(seed))
  summary_rows <- vector("list", length(n_values))
  mean_rows <- if (keep_means) vector("list", length(n_values)) else NULL
  for (index in seq_along(n_values)) {
    n <- as.integer(n_values[index])
    means <- draw_sample_means(population, n, as.integer(B))
    if (length(means) != B) stop("Simulation did not return exactly B sample means.")
    summary_rows[[index]] <- summarize_means(means, population, n, B, seed)
    if (keep_means) mean_rows[[index]] <- data.frame(population = population$id, n = n, sample_mean = means)
  }
  list(
    summary = do.call(rbind, summary_rows),
    means = if (keep_means) do.call(rbind, mean_rows) else NULL
  )
}

calibrate_bands <- function(normal_summary) {
  if (!all(normal_summary$population == "normal")) stop("Calibration requires only Normal results.")
  data.frame(
    metric = c("center_mcse_multiplier", "relative_se_error", "absolute_skewness", "absolute_excess_kurtosis", "qq_rmse"),
    threshold = c(
      max(3, 1.25 * max(abs(normal_summary$mean_error / normal_summary$mean_mcse))),
      max(0.03, 1.25 * max(normal_summary$relative_se_error)),
      max(0.10, 1.25 * max(abs(normal_summary$skewness))),
      max(0.20, 1.25 * max(abs(normal_summary$excess_kurtosis))),
      1.25 * max(normal_summary$qq_rmse)
    ),
    stringsAsFactors = FALSE
  )
}

apply_guidance_bands <- function(summary_data, bands) {
  threshold <- stats::setNames(bands$threshold, bands$metric)
  finite <- is.finite(summary_data$theoretical_se)
  summary_data$center_pass <- finite & abs(summary_data$mean_error) <= threshold[["center_mcse_multiplier"]] * summary_data$mean_mcse
  summary_data$se_pass <- finite & summary_data$relative_se_error <= threshold[["relative_se_error"]]
  summary_data$skew_pass <- finite & abs(summary_data$skewness) <= threshold[["absolute_skewness"]]
  summary_data$kurtosis_pass <- finite & abs(summary_data$excess_kurtosis) <= threshold[["absolute_excess_kurtosis"]]
  summary_data$qq_pass <- finite & summary_data$qq_rmse <= threshold[["qq_rmse"]]
  summary_data$all_numeric_pass <- summary_data$center_pass & summary_data$se_pass & summary_data$skew_pass & summary_data$kurtosis_pass & summary_data$qq_pass
  summary_data
}

first_stable_n <- function(population_summary) {
  ordered <- population_summary[order(population_summary$n), ]
  passes <- ordered$all_numeric_pass
  if (length(passes) < 3L) return(NA_integer_)
  for (index in seq_len(length(passes) - 2L)) {
    if (all(passes[index:(index + 2L)])) return(as.integer(ordered$n[index]))
  }
  NA_integer_
}
