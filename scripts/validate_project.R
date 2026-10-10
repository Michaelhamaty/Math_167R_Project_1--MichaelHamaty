source("R/populations.R")
source("R/diagnostics.R")
source("R/simulation.R")

required_pages <- file.path("_site", c("index.html", "analyses/normal.html", "analyses/die.html", "analyses/exponential.html", "analyses/binomial.html", "analyses/cauchy.html"))
stopifnot(all(file.exists(required_pages)))

diagnostics <- utils::read.csv("results/diagnostics.csv")
stopifnot(all(diagnostics$B == 10000L), all(diagnostics$seed == 631L))
stopifnot(identical(sort(unique(diagnostics$population)), sort(c("normal", "die", "exponential", "binomial", "cauchy"))))
stopifnot(nrow(diagnostics) == 79L)

decisions <- utils::read.csv("results/decisions.csv")
expected_n <- c(normal = 1L, die = 30L, exponential = 300L, binomial = 200L)
observed_n <- stats::setNames(decisions$smallest_defensible_n[decisions$population != "cauchy"], decisions$population[decisions$population != "cauchy"])
stopifnot(identical(observed_n[names(expected_n)], expected_n))
stopifnot(is.na(decisions$smallest_defensible_n[decisions$population == "cauchy"]))

authored <- c(
  "AGENTS.md", "README.md", "index.qmd", "_quarto.yml",
  list.files("analyses", pattern = "\\.qmd$", full.names = TRUE),
  list.files("R", pattern = "\\.R$", full.names = TRUE),
  list.files("scripts", pattern = "\\.(R|py)$", full.names = TRUE),
  list.files("docs", pattern = "\\.md$", full.names = TRUE),
  list.files("references", pattern = "\\.md$", full.names = TRUE)
)
contents <- lapply(authored, readLines, warn = FALSE, encoding = "UTF-8")
names(contents) <- authored
em_dash_character <- intToUtf8(8212)
em_dash_hits <- vapply(contents, function(lines) any(grepl(em_dash_character, lines, fixed = TRUE)), logical(1))
if (any(em_dash_hits)) stop("Em dash found in: ", paste(names(em_dash_hits)[em_dash_hits], collapse = ", "))

r_files <- c(list.files("R", pattern = "\\.R$", full.names = TRUE), list.files("scripts", pattern = "\\.R$", full.names = TRUE))
for (path in r_files) {
  parse(path)
  lines <- readLines(path, warn = FALSE)
  if (any(grepl("^\\s*# ", lines))) stop("Spaced R comment found in ", path)
}

qmd_files <- c("index.qmd", list.files("analyses", pattern = "\\.qmd$", full.names = TRUE))
for (path in qmd_files) {
  lines <- readLines(path, warn = FALSE)
  in_chunk <- FALSE
  for (line in lines) {
    if (grepl("^```\\{r", line)) in_chunk <- TRUE
    if (in_chunk && grepl("^\\s*# ", line)) stop("Spaced R comment found in chunk: ", path)
    if (in_chunk && grepl("^```\\s*$", line)) in_chunk <- FALSE
  }
}

all_lines <- unlist(contents, use.names = FALSE)
matches <- regmatches(all_lines, gregexpr("(?<![0-9])[0-9]{7,10}(?![0-9])", all_lines, perl = TRUE))
possible_ids <- setdiff(unique(unlist(matches)), "10000")
if (length(possible_ids)) stop("Investigate possible full identifier(s): ", paste(possible_ids, collapse = ", "))

cat("Project validation passed.\n")
