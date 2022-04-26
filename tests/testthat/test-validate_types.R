test_that("tests for validate_types", {

  # test errors
  msg <- "Assertion on 'x' failed: Must inherit from class 'factor', but has class 'numeric'."
  expect_error(validate_types(x, ref_types = tags_types(age = "factor")), msg)

  x <- make_linelist(cars, age = "speed", gender = "dist")
  msg <- "Assertion on 'x' failed: Must inherit from class 'character'/'factor', but has class 'numeric'."
  expect_error(validate_types(x), msg)
  
  # test functionalities
  x <- make_linelist(cars, age = "speed")
  expect_identical(x, validate_types(x))

  x <- make_linelist(cars, age = "speed", outcome = "dist")
  expect_identical(x, validate_types(x, ref_types = tags_types(outcome = "numeric")))

})
