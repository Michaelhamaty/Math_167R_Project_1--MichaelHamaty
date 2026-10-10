validate_numeric_vector <- function(x, name) {
  if (!is.numeric(x) || length(x) < 2L || any(!is.finite(x))) {
    stop(name, " must contain at least two finite numeric values.")
  }
  invisible(TRUE)
}

#Course adaptation: moment summaries extend the course's base R summary workflow.
moment_skewness <- function(x) {
  validate_numeric_vector(x, "x")
  scale_value <- stats::sd(x)
  if (scale_value == 0) return(0)
  mean(((x - mean(x)) / scale_value)^3)
}

excess_kurtosis <- function(x) {
  validate_numeric_vector(x, "x")
  scale_value <- stats::sd(x)
  if (scale_value == 0) return(-3)
  mean(((x - mean(x)) / scale_value)^4) - 3
}

#Course adaptation: Q-Q coordinates follow the lesson's Normal comparison, summarized by RMSE.
qq_rmse <- function(x, probabilities = seq(0.01, 0.99, by = 0.01)) {
  validate_numeric_vector(x, "x")
  standardized <- (x - mean(x)) / stats::sd(x)
  empirical <- as.numeric(stats::quantile(standardized, probabilities, names = FALSE, type = 8))
  theoretical <- stats::qnorm(probabilities)
  sqrt(mean((empirical - theoretical)^2))
}

shapiro_w_value <- function(x, maximum = 5000L) {
  validate_numeric_vector(x, "x")
  selected <- x[seq_len(min(length(x), maximum))]
  unname(stats::shapiro.test(selected)$statistic)
}

summarize_means <- function(means, population, n, B, seed) {
  validate_numeric_vector(means, "means")
  finite_variance <- is.finite(population$variance)
  theoretical_se <- if (finite_variance) sqrt(population$variance / n) else NA_real_
  simulated_mean <- mean(means)
  simulated_se <- stats::sd(means)
  data.frame(
    population = population$id,
    label = population$short_label,
    n = n,
    B = B,
    seed = seed,
    theoretical_mean = population$mean,
    theoretical_se = theoretical_se,
    simulated_mean = if (finite_variance) simulated_mean else NA_real_,
    simulated_se = if (finite_variance) simulated_se else NA_real_,
    mean_error = if (finite_variance) simulated_mean - population$mean else NA_real_,
    mean_mcse = if (finite_variance) theoretical_se / sqrt(B) else NA_real_,
    relative_se_error = if (finite_variance) abs(simulated_se / theoretical_se - 1) else NA_real_,
    skewness = if (finite_variance) moment_skewness(means) else NA_real_,
    excess_kurtosis = if (finite_variance) excess_kurtosis(means) else NA_real_,
    qq_rmse = if (finite_variance) qq_rmse(means) else NA_real_,
    shapiro_w = if (finite_variance) shapiro_w_value(means) else NA_real_,
    q01 = unname(stats::quantile(means, 0.01, type = 8)),
    q10 = unname(stats::quantile(means, 0.10, type = 8)),
    q25 = unname(stats::quantile(means, 0.25, type = 8)),
    median = stats::median(means),
    q75 = unname(stats::quantile(means, 0.75, type = 8)),
    q90 = unname(stats::quantile(means, 0.90, type = 8)),
    q99 = unname(stats::quantile(means, 0.99, type = 8)),
    iqr = stats::IQR(means, type = 8),
    max_abs = max(abs(means)),
    stringsAsFactors = FALSE
  )
}
