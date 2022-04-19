test_that("tests for se_tags", {

  x <- make_linelist(cars, date_onset = "dist", age = "speed")

  # Check error messages
  msg <- "Can't subset columns that don't exist.\n\033[31m✖\033[39m Column `toto` doesn't exist."
  expect_error(select_tags(x, "toto"), msg, fixed = TRUE)
  
  # Check functionality
  expect_identical(select_tags(x, everything()), tags_df(x))
  expect_identical(ncol(select_tags(x)), 0L)
  
})
