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

decisions <- data.frame(
  population = c("normal", "die", "exponential", "binomial", "cauchy"),
  clt_eligible = c(TRUE, TRUE, TRUE, TRUE, FALSE),
  smallest_defensible_n = c(1L, 30L, 1000L, 200L, NA_integer_),
  conclusion = c("Exact Normal", "Normal enough at n = 30", "Normal enough at n = 1000", "Normal enough at n = 200", "No ordinary-CLT threshold"),
  key_caveat = c("Monte Carlo noise only", "Residual lattice", "Residual right-tail sensitivity", "Residual lattice", "Mean and variance undefined"),
  stringsAsFactors = FALSE
)

second_population <- populations$exponential
second_n <- c(300L, 500L, 750L, 1000L, 1500L)
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
cat("Second-seed case: Exponential from n = 300 through 1500\n")
