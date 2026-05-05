#' Estimate treatment effect overall and within biomarker subgroups
#'
#' Fits an unadjusted Cox proportional hazards model of treatment on
#' overall survival in (i) the full cohort, (ii) biomarker-positive
#' patients, and (iii) biomarker-negative patients. Returns a tidy
#' tibble suitable for a forest plot.
#'
#' @param data Output of [add_biomarker()].
#'
#' @return A tibble with columns `subgroup`, `term`, `estimate`
#'   (HR), `conf.low`, `conf.high`, `p.value`, `n`, `events`.
#' @export
#'
#' @examples
#' d <- add_biomarker(load_colon(), seed = 1)
#' fit_subgroup_hr(d)
fit_subgroup_hr <- function(data) {
  do_fit <- function(d, label) {
    fit <- survival::coxph(
      survival::Surv(time, status) ~ treatment, data = d
    )
    out <- broom::tidy(fit, exponentiate = TRUE, conf.int = TRUE)
    out$subgroup <- label
    out$n      <- nrow(d)
    out$events <- sum(d$status, na.rm = TRUE)
    out
  }
  dplyr::bind_rows(
    do_fit(data,                                              "Overall"),
    do_fit(dplyr::filter(data, .data$biomarker == "Positive"), "Biomarker positive"),
    do_fit(dplyr::filter(data, .data$biomarker == "Negative"), "Biomarker negative")
  )
}

#' Test the treatment x biomarker interaction
#'
#' Fits a Cox model with a `treatment * biomarker` interaction adjusted
#' for age, sex and number of positive lymph nodes, and returns the
#' tidied coefficients along with a likelihood-ratio p-value for the
#' interaction term.
#'
#' @param data Output of [add_biomarker()].
#'
#' @return A list with elements `coefs` (tidy tibble of HRs) and
#'   `lrt_p` (numeric, p-value for the interaction LRT).
#' @export
#'
#' @examples
#' d <- add_biomarker(load_colon(), seed = 1)
#' fit_interaction_cox(d)
fit_interaction_cox <- function(data) {
  full  <- survival::coxph(
    survival::Surv(time, status) ~ treatment * biomarker + age + sex + nodes,
    data = data
  )
  reduced <- survival::coxph(
    survival::Surv(time, status) ~ treatment + biomarker + age + sex + nodes,
    data = data
  )
  lrt <- stats::anova(reduced, full)
  list(
    coefs = broom::tidy(full, exponentiate = TRUE, conf.int = TRUE),
    lrt_p = lrt$`Pr(>|Chi|)`[2]
  )
}
