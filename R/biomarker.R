#' Attach a simulated tumor biomarker to a cohort
#'
#' Adds a binary biomarker (e.g., MSI-high vs MSS) to the input cohort.
#' The latent score is correlated with tumor differentiation grade so
#' the biomarker has biological plausibility, then thresholded to hit a
#' user-specified prevalence.
#'
#' @param data A data frame produced by [load_colon()] (must contain a
#'   `differ` column).
#' @param prevalence Numeric in (0, 1). Target proportion of biomarker
#'   positive patients.
#' @param seed Integer. RNG seed for reproducibility.
#'
#' @return The input tibble with a `biomarker` factor column appended,
#'   levels `c("Negative", "Positive")`.
#'
#' @importFrom stats rnorm quantile
#' @export
#'
#' @examples
#' d <- add_biomarker(load_colon(), prevalence = 0.30, seed = 1)
#' prop.table(table(d$biomarker))
add_biomarker <- function(data, prevalence = 0.35, seed = 7) {
  stopifnot(prevalence > 0, prevalence < 1)
  stopifnot("differ" %in% names(data))
  set.seed(seed)
  n <- nrow(data)
  differ <- ifelse(is.na(data$differ), 2, data$differ)
  lp <- as.numeric(scale(differ)) * 0.4 + stats::rnorm(n, sd = 0.8)
  thr <- stats::quantile(lp, 1 - prevalence)
  data$biomarker <- factor(
    ifelse(lp >= thr, "Positive", "Negative"),
    levels = c("Negative", "Positive")
  )
  data
}
