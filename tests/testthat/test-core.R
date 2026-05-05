test_that("load_colon returns a 2-arm OS cohort", {
  d <- load_colon()
  expect_s3_class(d, "tbl_df")
  expect_setequal(levels(d$treatment), c("Obs", "Lev+5FU"))
  expect_true(all(c("time", "status") %in% names(d)))
  expect_gt(nrow(d), 500)
})

test_that("add_biomarker hits target prevalence within tolerance", {
  d <- add_biomarker(load_colon(), prevalence = 0.4, seed = 1)
  prev <- mean(d$biomarker == "Positive")
  expect_gt(prev, 0.30)
  expect_lt(prev, 0.50)
})

test_that("fit_subgroup_hr returns three subgroups with positive HRs", {
  d <- add_biomarker(load_colon(), seed = 2)
  res <- fit_subgroup_hr(d)
  expect_setequal(unique(res$subgroup),
                  c("Overall", "Biomarker positive", "Biomarker negative"))
  expect_true(all(res$estimate > 0))
})

test_that("fit_interaction_cox returns coefs and an LRT p-value", {
  d <- add_biomarker(load_colon(), seed = 3)
  out <- fit_interaction_cox(d)
  expect_named(out, c("coefs", "lrt_p"))
  expect_true(is.numeric(out$lrt_p))
  expect_true(out$lrt_p >= 0 && out$lrt_p <= 1)
})
