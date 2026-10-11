#Course adaptation: population parameterizations follow the supplied distribution lesson.
make_populations <- function() {
  list(
    normal = list(
      id = "normal",
      label = "Standard Normal",
      short_label = "Normal",
      generator = function(n) stats::rnorm(n),
      density = function(x) stats::dnorm(x),
      support = c(-4, 4),
      mean = 0,
      variance = 1,
      color = "#0d6973",
      n_values = c(1, 2, 5, 10, 20, 30, 50, 100)
    ),
    die = list(
      id = "die",
      label = "Six-Sided Die",
      short_label = "Die",
      generator = function(n) sample.int(6, n, replace = TRUE),
      density = NULL,
      support = c(0.5, 6.5),
      mean = 3.5,
      variance = 35 / 12,
      color = "#3a7697",
      n_values = c(1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 25, 30, 40, 50, 75, 100)
    ),
    exponential = list(
      id = "exponential",
      label = "Exponential, Rate 1",
      short_label = "Exponential",
      generator = function(n) stats::rexp(n, rate = 1),
      density = function(x) stats::dexp(x, rate = 1),
      support = c(0, 7),
      mean = 1,
      variance = 1,
      color = "#bd5b32",
      n_values = c(1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 25, 30, 40, 50, 75, 100, 150, 200, 300, 500, 750, 1000, 1500, 2000)
    ),
    binomial = list(
      id = "binomial",
      label = "Binomial, Size 5 and p = 0.10",
      short_label = "Small Binomial",
      generator = function(n) stats::rbinom(n, size = 5, prob = 0.10),
      density = NULL,
      support = c(-0.5, 5.5),
      mean = 0.5,
      variance = 0.45,
      color = "#8b4f79",
      n_values = c(1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 25, 30, 40, 50, 60, 75, 100, 125, 150, 200, 300, 500)
    ),
    cauchy = list(
      id = "cauchy",
      label = "Standard Cauchy",
      short_label = "Cauchy",
      generator = function(n) stats::rcauchy(n),
      density = function(x) stats::dcauchy(x),
      support = c(-10, 10),
      mean = NA_real_,
      variance = NA_real_,
      color = "#755b38",
      n_values = c(1, 2, 5, 10, 30, 100, 500, 1000)
    )
  )
}

get_population <- function(id) {
  populations <- make_populations()
  if (!is.character(id) || length(id) != 1L || !id %in% names(populations)) {
    stop("Unknown population identifier.")
  }
  populations[[id]]
}
