test_that("template tests", {

  expect_identical(1, template(1))
  expect_identical(letters, template(letters))
  expect_null(NULL, template(NULL))
  
})
