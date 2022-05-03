test_that("tests for [ operator", {

  x <- make_linelist(cars, id = "speed", age = "dist")

  # errors
  msg <- "The following tags have lost their variable:\n age:dist"
  expect_warning(x[, 1], msg)
  msg <- "The following tags have lost their variable:\n age:dist"
  expect_error(x[, 1, lost_action = "error"], msg)
  msg <- "The following tags have lost their variable:\n id:speed, age:dist"
  expect_warning(x[, NULL], msg)

  # functionalities
  expect_identical(x, x[])
  expect_identical(x, x[,])
  expect_null(ncol(x[, 1, drop = TRUE]))
  expect_identical(x[, 1, drop = TRUE], cars[, 1])

})
