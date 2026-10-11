#ggplot2 adaptation: layers, facets, scales, and themes follow the official package reference.
analysis_theme <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size, base_family = "Avenir Next") +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", color = "#173f47"),
      plot.subtitle = ggplot2::element_text(color = "#40545a"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold", color = "#173f47"),
      legend.position = "bottom",
      plot.caption = ggplot2::element_text(color = "#53666b", hjust = 0),
      plot.margin = ggplot2::margin(14, 18, 14, 28),
      panel.spacing = grid::unit(0.9, "lines")
    )
}

plot_parent_population <- function(population, seed = 631L) {
  set.seed(seed)
  if (population$id %in% c("die", "binomial")) {
    values <- if (population$id == "die") 1:6 else 0:5
    probabilities <- if (population$id == "die") rep(1 / 6, 6) else stats::dbinom(values, size = 5, prob = 0.10)
    data <- data.frame(value = values, probability = probabilities)
    ggplot2::ggplot(data, ggplot2::aes(value, probability)) +
      ggplot2::geom_col(fill = population$color, width = 0.72) +
      ggplot2::scale_x_continuous(breaks = values) +
      ggplot2::labs(x = "Population value", y = "Probability") + analysis_theme()
  } else {
    limit <- population$support
    data <- data.frame(value = seq(limit[1], limit[2], length.out = 500))
    data$density <- population$density(data$value)
    ggplot2::ggplot(data, ggplot2::aes(value, density)) +
      ggplot2::geom_area(fill = population$color, alpha = 0.72) +
      ggplot2::geom_line(color = population$color, linewidth = 0.7) +
      ggplot2::labs(x = "Population value", y = "Density") + analysis_theme()
  }
}

plot_sampling_distributions <- function(means_data, population, selected_n, x_limits = NULL, facet_scales = "free_y") {
  data <- means_data[means_data$n %in% selected_n, ]
  data$n_label <- factor(paste0("n = ", data$n), levels = paste0("n = ", selected_n))
  if (is.null(x_limits)) {
    theoretical <- do.call(rbind, lapply(selected_n, function(n) {
      standard_error <- sqrt(population$variance / n)
      x <- seq(population$mean - 4.2 * standard_error, population$mean + 4.2 * standard_error, length.out = 300)
      data.frame(n = n, x = x, density = stats::dnorm(x, population$mean, standard_error))
    }))
    theoretical$n_label <- factor(paste0("n = ", theoretical$n), levels = paste0("n = ", selected_n))
    return(ggplot2::ggplot(data, ggplot2::aes(sample_mean)) +
      ggplot2::geom_histogram(ggplot2::aes(y = ggplot2::after_stat(density)), bins = 42, fill = population$color, color = "white", linewidth = 0.25) +
      ggplot2::geom_line(data = theoretical, ggplot2::aes(x, density), inherit.aes = FALSE, color = "#30373a", linewidth = 0.9) +
      ggplot2::facet_wrap(ggplot2::vars(n_label), scales = facet_scales, ncol = min(3, length(selected_n))) +
      ggplot2::labs(x = "Sample mean", y = "Density") + analysis_theme())
  }
  breaks <- seq(x_limits[1], x_limits[2], length.out = 51)
  bin_width <- breaks[2] - breaks[1]
  pieces <- split(data, data$n)
  bins <- do.call(rbind, lapply(pieces, function(piece) {
    inside <- piece$sample_mean[piece$sample_mean >= x_limits[1] & piece$sample_mean <= x_limits[2]]
    counts <- hist(inside, breaks = breaks, plot = FALSE)$counts
    data.frame(
      n = unique(piece$n),
      midpoint = head(breaks, -1) + bin_width / 2,
      density = counts / (nrow(piece) * bin_width)
    )
  }))
  bins$n_label <- factor(paste0("n = ", bins$n), levels = paste0("n = ", selected_n))
  ggplot2::ggplot(bins, ggplot2::aes(midpoint, density)) +
    ggplot2::geom_col(fill = population$color, color = "white", linewidth = 0.25, width = bin_width) +
    ggplot2::facet_wrap(ggplot2::vars(n_label), scales = "free_y", ncol = min(3, length(selected_n))) +
    ggplot2::coord_cartesian(xlim = x_limits) +
    ggplot2::labs(x = "Sample mean", y = "Density") + analysis_theme()
}

plot_qq_comparison <- function(means_data, population, selected_n) {
  data <- means_data[means_data$n %in% selected_n, ]
  pieces <- split(data, data$n)
  qq_data <- do.call(rbind, lapply(pieces, function(piece) {
    standardized <- as.numeric(scale(piece$sample_mean))
    probabilities <- seq(0.01, 0.99, by = 0.01)
    data.frame(
      n = unique(piece$n),
      theoretical = stats::qnorm(probabilities),
      empirical = as.numeric(stats::quantile(standardized, probabilities, type = 8))
    )
  }))
  qq_data$n_label <- factor(paste0("n = ", qq_data$n), levels = paste0("n = ", selected_n))
  ggplot2::ggplot(qq_data, ggplot2::aes(theoretical, empirical)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = "#bd5b32", linewidth = 0.7) +
    ggplot2::geom_point(color = population$color, size = 1.1, alpha = 0.82) +
    ggplot2::facet_wrap(ggplot2::vars(n_label), ncol = min(3, length(selected_n))) +
    ggplot2::coord_equal() +
    ggplot2::labs(x = "Theoretical Normal quantile", y = "Standardized empirical quantile") + analysis_theme()
}

plot_diagnostic_trajectory <- function(summary_data, population, bands) {
  threshold <- stats::setNames(bands$threshold, bands$metric)
  long <- rbind(
    data.frame(n = summary_data$n, metric = "|Skewness|", value = abs(summary_data$skewness), guidance = threshold[["absolute_skewness"]]),
    data.frame(n = summary_data$n, metric = "|Excess kurtosis|", value = abs(summary_data$excess_kurtosis), guidance = threshold[["absolute_excess_kurtosis"]]),
    data.frame(n = summary_data$n, metric = "Q-Q RMSE", value = summary_data$qq_rmse, guidance = threshold[["qq_rmse"]])
  )
  ggplot2::ggplot(long, ggplot2::aes(n, value)) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = guidance), color = "#bd5b32", linetype = "22") +
    ggplot2::geom_line(color = population$color, linewidth = 0.8) +
    ggplot2::geom_point(color = population$color, size = 1.7) +
    ggplot2::facet_wrap(ggplot2::vars(metric), scales = "free_y", ncol = 1) +
    ggplot2::scale_x_log10(breaks = c(1, 5, 10, 50, 100, 500, 1000, 2000), minor_breaks = NULL) +
    ggplot2::labs(x = "Sample size, log scale", y = NULL) + analysis_theme()
}

plot_se_comparison <- function(summary_data, population) {
  data <- rbind(
    data.frame(n = summary_data$n, type = "Empirical", se = summary_data$simulated_se),
    data.frame(n = summary_data$n, type = "Theory", se = summary_data$theoretical_se)
  )
  ggplot2::ggplot(data, ggplot2::aes(n, se, color = type)) +
    ggplot2::geom_line(linewidth = 0.85) +
    ggplot2::geom_point(size = 1.6) +
    ggplot2::scale_x_log10(breaks = c(1, 5, 10, 50, 100, 500, 1000, 2000), minor_breaks = NULL) +
    ggplot2::scale_color_manual(values = c(Empirical = population$color, Theory = "#bd5b32")) +
    ggplot2::labs(x = "Sample size, log scale", y = "Standard error", color = NULL) + analysis_theme()
}
