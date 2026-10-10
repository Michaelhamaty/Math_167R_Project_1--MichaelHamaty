source("R/populations.R")
source("R/diagnostics.R")
source("R/simulation.R")

populations <- make_populations()
stopifnot(identical(names(populations), c("normal", "die", "exponential", "binomial", "cauchy")))
stopifnot(populations$normal$mean == 0, populations$normal$variance == 1)
stopifnot(populations$die$mean == 3.5, isTRUE(all.equal(populations$die$variance, 35 / 12)))
stopifnot(populations$exponential$mean == 1, populations$exponential$variance == 1)
stopifnot(populations$binomial$mean == 0.5, populations$binomial$variance == 0.45)
stopifnot(is.na(populations$cauchy$mean), is.na(populations$cauchy$variance))

for (population in populations) {
  set.seed(1)
  stopifnot(length(population$generator(17L)) == 17L)
}

invalid_calls <- list(
  function() simulate_population(populations$normal, n_values = 0, B = 10, seed = 1),
  function() simulate_population(populations$normal, n_values = 1.5, B = 10, seed = 1),
  function() simulate_population(populations$normal, n_values = 1, B = 1, seed = 1),
  function() simulate_population(populations$normal, n_values = 1, B = 10, seed = -1)
)
for (call in invalid_calls) stopifnot(inherits(try(call(), silent = TRUE), "try-error"))

first <- simulate_population(populations$normal, n_values = c(1, 3), B = 200L, seed = 631L, keep_means = TRUE)
second <- simulate_population(populations$normal, n_values = c(1, 3), B = 200L, seed = 631L, keep_means = TRUE)
stopifnot(identical(first, second))
stopifnot(all(table(first$means$n) == 200L))

cauchy <- simulate_population(populations$cauchy, n_values = c(1, 10), B = 200L, seed = 631L)$summary
stopifnot(all(is.na(cauchy$theoretical_mean)), all(is.na(cauchy$theoretical_se)))
stopifnot(all(is.na(cauchy$skewness)), all(is.na(cauchy$excess_kurtosis)))

cat("Simulation validation passed.\n")
