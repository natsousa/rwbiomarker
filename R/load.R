#' Load and clean the colon adjuvant chemotherapy cohort
#'
#' Loads `survival::colon`, restricts to the overall-survival event type
#' (`etype == 2`), keeps two arms — observation vs. Levamisole + 5-FU —
#' and returns a tidy tibble with sensible column types. This dataset is
#' used as a publicly available stand-in for an EHR-derived oncology
#' cohort.
#'
#' @return A [tibble][tibble::tibble-package] with one row per patient.
#' @export
#'
#' @examples
#' d <- load_colon()
#' table(d$treatment)
load_colon <- function() {
  d <- survival::colon
  d <- d[d$etype == 2, ]
  d <- d[d$rx %in% c("Obs", "Lev+5FU"), ]
  d$treatment <- factor(
    ifelse(d$rx == "Lev+5FU", "Lev+5FU", "Obs"),
    levels = c("Obs", "Lev+5FU")
  )
  d$sex <- factor(d$sex, levels = c(0, 1), labels = c("Female", "Male"))

  tibble::as_tibble(d[, c(
    "id", "age", "sex", "obstruct", "perfor", "adhere",
    "nodes", "differ", "extent", "surg",
    "treatment", "time", "status"
  )])
}
