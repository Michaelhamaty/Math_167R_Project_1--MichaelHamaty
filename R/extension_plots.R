#ggplot2 adaptation: extension figures reuse the official package layering and faceting grammar.
extension_colors <- c(
  "dependent" = "#6f4e37",
  "matched marginal iid" = "#3a7697",
  "changing 0.90 to 0.50" = "#bd5b32",
  "fixed 0.70" = "#3a7697",
  "Stable" = "#3a7697",
  "Gradual increase" = "#56745f",
  "Gradual decrease" = "#8b4f79"
)

plot_dependent_chain <- function(segment) {
  ggplot2::ggplot(segment, ggplot2::aes(step, operating_time)) +
    ggplot2::geom_line(color = extension_colors[["dependent"]], linewidth = 0.65) +
    ggplot2::geom_point(color = extension_colors[["dependent"]], size = 0.85) +
    ggplot2::labs(x = "Failure index", y = "Operating time") + analysis_theme()
}

plot_dependent_rate_curve <- function() {
  data <- data.frame(previous_time = seq(0, 4, length.out = 400))
  data$next_rate <- dependent_rate(data$previous_time)
  data$next_expected_time <- 1 / data$next_rate
  ggplot2::ggplot(data, ggplot2::aes(previous_time, next_expected_time)) +
    ggplot2::geom_line(color = extension_colors[["dependent"]], linewidth = 1) +
    ggplot2::geom_vline(xintercept = 1, color = "#bd5b32", linetype = "22") +
    ggplot2::coord_cartesian(ylim = c(0, 4)) +
    ggplot2::labs(x = "Previous operating time", y = "Conditional expected next time") + analysis_theme()
}

plot_dependent_acf <- function(acf_data) {
  ggplot2::ggplot(acf_data, ggplot2::aes(lag, autocorrelation)) +
    ggplot2::geom_hline(yintercept = 0, color = "#899396", linewidth = 0.5) +
    ggplot2::geom_segment(ggplot2::aes(xend = lag, y = 0, yend = autocorrelation), color = extension_colors[["dependent"]], linewidth = 0.8) +
    ggplot2::geom_point(color = extension_colors[["dependent"]], size = 1.8) +
    ggplot2::scale_x_continuous(breaks = seq(2, max(acf_data$lag), by = 2)) +
    ggplot2::labs(x = "Lag", y = "Autocorrelation") + analysis_theme()
}

plot_extension_sampling <- function(means_data, summary_data, selected_n, variants, colors = extension_colors) {
  data <- means_data[means_data$n %in% selected_n & means_data$variant %in% variants, ]
  data$panel <- factor(paste(data$variant, paste0("n = ", data$n), sep = "\n"), levels = as.vector(outer(variants, paste0("n = ", selected_n), paste, sep = "\n")))
  selected_summary <- summary_data[summary_data$n %in% selected_n & summary_data$variant %in% variants, ]
  overlays <- do.call(rbind, lapply(seq_len(nrow(selected_summary)), function(index) {
    row <- selected_summary[index, ]
    center <- if (is.finite(row$theoretical_mean)) row$theoretical_mean else row$simulated_mean
    spread <- if (is.finite(row$theoretical_se)) row$theoretical_se else row$simulated_se
    x <- seq(center - 4.2 * spread, center + 4.2 * spread, length.out = 300)
    data.frame(variant = row$variant, n = row$n, x = x, density = stats::dnorm(x, center, spread))
  }))
  overlays$panel <- factor(paste(overlays$variant, paste0("n = ", overlays$n), sep = "\n"), levels = levels(data$panel))
  ggplot2::ggplot(data, ggplot2::aes(sample_mean, fill = variant)) +
    ggplot2::geom_histogram(ggplot2::aes(y = ggplot2::after_stat(density)), bins = 38, color = "white", linewidth = 0.2) +
    ggplot2::geom_line(data = overlays, ggplot2::aes(x, density), inherit.aes = FALSE, color = "#30373a", linewidth = 0.8) +
    ggplot2::facet_wrap(ggplot2::vars(panel), scales = "free", ncol = length(selected_n)) +
    ggplot2::scale_fill_manual(values = colors, guide = "none") +
    ggplot2::labs(x = "Sample average", y = "Density") + analysis_theme(base_size = 11)
}

plot_extension_qq <- function(means_data, selected_n, variants, colors = extension_colors) {
  data <- means_data[means_data$n %in% selected_n & means_data$variant %in% variants, ]
  pieces <- split(data, interaction(data$variant, data$n, drop = TRUE))
  qq_data <- do.call(rbind, lapply(pieces, function(piece) {
    standardized <- as.numeric(scale(piece$sample_mean))
    probabilities <- seq(0.01, 0.99, by = 0.01)
    data.frame(
      variant = unique(piece$variant), n = unique(piece$n),
      theoretical = stats::qnorm(probabilities),
      empirical = as.numeric(stats::quantile(standardized, probabilities, type = 8))
    )
  }))
  qq_data$panel <- factor(paste(qq_data$variant, paste0("n = ", qq_data$n), sep = "\n"), levels = as.vector(outer(variants, paste0("n = ", selected_n), paste, sep = "\n")))
  ggplot2::ggplot(qq_data, ggplot2::aes(theoretical, empirical, color = variant)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = "#30373a", linewidth = 0.6) +
    ggplot2::geom_point(size = 0.95, alpha = 0.82) +
    ggplot2::facet_wrap(ggplot2::vars(panel), ncol = length(selected_n)) +
    ggplot2::coord_equal() +
    ggplot2::scale_color_manual(values = colors, guide = "none") +
    ggplot2::labs(x = "Theoretical Normal quantile", y = "Standardized empirical quantile") + analysis_theme(base_size = 11)
}

plot_extension_trajectory <- function(summary_data, variants, bands, colors = extension_colors) {
  threshold <- stats::setNames(bands$threshold, bands$metric)
  selected <- summary_data[summary_data$variant %in% variants, ]
  long <- rbind(
    data.frame(variant = selected$variant, n = selected$n, metric = "|Skewness|", value = abs(selected$skewness), guidance = threshold[["absolute_skewness"]]),
    data.frame(variant = selected$variant, n = selected$n, metric = "|Excess kurtosis|", value = abs(selected$excess_kurtosis), guidance = threshold[["absolute_excess_kurtosis"]]),
    data.frame(variant = selected$variant, n = selected$n, metric = "Q-Q RMSE", value = selected$qq_rmse, guidance = threshold[["qq_rmse"]])
  )
  ggplot2::ggplot(long, ggplot2::aes(n, value, color = variant)) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = guidance), color = "#bd5b32", linetype = "22") +
    ggplot2::geom_line(linewidth = 0.75) +
    ggplot2::geom_point(size = 1.45) +
    ggplot2::facet_wrap(ggplot2::vars(metric), scales = "free_y", ncol = 1) +
    ggplot2::scale_x_log10(breaks = c(5, 10, 20, 50, 100, 500, 1000, 2000), minor_breaks = NULL) +
    ggplot2::scale_color_manual(values = colors) +
    ggplot2::labs(x = "Sample size, log scale", y = NULL, color = NULL) + analysis_theme(base_size = 11)
}

plot_effective_sample_size <- function(dependent_summary) {
  data <- dependent_summary[dependent_summary$variant == "dependent", ]
  ggplot2::ggplot(data, ggplot2::aes(n, effective_n)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = "#899396", linetype = "22") +
    ggplot2::geom_line(color = extension_colors[["dependent"]], linewidth = 0.9) +
    ggplot2::geom_point(color = extension_colors[["dependent"]], size = 1.8) +
    ggplot2::scale_x_log10(breaks = c(5, 10, 20, 50, 100, 500, 1000, 2000), minor_breaks = NULL) +
    ggplot2::scale_y_log10(breaks = c(5, 10, 20, 50, 100, 500, 1000, 2000, 3000), minor_breaks = NULL) +
    ggplot2::labs(x = "Nominal sample size", y = "Empirical effective sample size") + analysis_theme()
}

plot_probability_paths <- function(path_data, selected_n, colors = extension_colors) {
  data <- path_data[path_data$n == selected_n, ]
  ggplot2::ggplot(data, ggplot2::aes(position, probability, color = variant, linetype = variant)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::scale_color_manual(values = colors) +
    ggplot2::scale_y_continuous(limits = c(0, 1), labels = function(x) paste0(round(100 * x), "%")) +
    ggplot2::labs(x = "Ordered position", y = "Success probability", color = NULL, linetype = NULL) + analysis_theme()
}

plot_age_components <- function(distribution) {
  long <- rbind(
    data.frame(age = distribution$age, component = "Early component", weight = distribution$early_component),
    data.frame(age = distribution$age, component = "Adult component", weight = distribution$adult_component),
    data.frame(age = distribution$age, component = "Normalized population", weight = distribution$probability)
  )
  ggplot2::ggplot(long, ggplot2::aes(age, weight, color = component, linetype = component)) +
    ggplot2::geom_line(linewidth = 0.9) +
    ggplot2::scale_color_manual(values = c("Early component" = "#bd5b32", "Adult component" = "#3a7697", "Normalized population" = "#56745f")) +
    ggplot2::labs(x = "Synthetic age", y = "Weight or probability", color = NULL, linetype = NULL) + analysis_theme()
}
