source("R/populations.R")
source("R/diagnostics.R")
source("R/simulation.R")

populations <- make_populations()
B <- 10000L
seed <- 631L

results <- lapply(populations, function(population) {
  simulate_population(population, B = B, seed = seed)$summary
})
diagnostics <- do.call(rbind, results)
bands <- calibrate_bands(diagnostics[diagnostics$population == "normal", ])
diagnostics <- apply_guidance_bands(diagnostics, bands)

finite_ids <- c("normal", "die", "exponential", "binomial")
stable_n <- vapply(finite_ids, function(id) first_stable_n(diagnostics[diagnostics$population == id, ]), integer(1))
decisions <- data.frame(
  population = c(finite_ids, "cauchy"),
  numeric_stable_n = c(stable_n, NA_integer_),
  conclusion = c("Exact Normal", rep("Requires visual synthesis", 3), "No ordinary-CLT threshold"),
  stringsAsFactors = FALSE
)

finite_diagnostics <- diagnostics[diagnostics$population %in% c("die", "exponential", "binomial"), ]
finite_diagnostics$distance <- pmax(
  abs(finite_diagnostics$skewness) / bands$threshold[bands$metric == "absolute_skewness"],
  abs(finite_diagnostics$excess_kurtosis) / bands$threshold[bands$metric == "absolute_excess_kurtosis"],
  finite_diagnostics$qq_rmse / bands$threshold[bands$metric == "qq_rmse"]
)
borderline <- finite_diagnostics[order(abs(finite_diagnostics$distance - 1), match(finite_diagnostics$population, c("binomial", "exponential", "die"))), ][1, ]
second_population <- populations[[borderline$population]]
second_n <- sort(unique(c(borderline$n, second_population$n_values[second_population$n_values > borderline$n][1:2])))
second_n <- second_n[is.finite(second_n)]
second_seed <- simulate_population(second_population, n_values = second_n, B = B, seed = 1631L)$summary

dir.create("results", showWarnings = FALSE)
utils::write.csv(diagnostics, "results/diagnostics.csv", row.names = FALSE, na = "")
utils::write.csv(bands, "results/calibration_bands.csv", row.names = FALSE)
utils::write.csv(decisions, "results/decisions.csv", row.names = FALSE, na = "")
utils::write.csv(second_seed, "results/second_seed.csv", row.names = FALSE, na = "")

session_lines <- capture.output(sessionInfo())
writeLines(c(
  paste("Quarto 1.10.18"),
  paste("ggplot2", as.character(utils::packageVersion("ggplot2"))),
  paste("knitr", as.character(utils::packageVersion("knitr"))),
  "",
  session_lines
), "results/session-info.txt")

cat("Wrote deterministic summaries for", nrow(diagnostics), "population and sample-size combinations.\n")
cat("Second-seed case:", borderline$population, "near n =", borderline$n, "\n")
