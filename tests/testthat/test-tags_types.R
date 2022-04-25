test_that("tests for tags_types", {

  # Check functionality
  x <- tags_types()
  expect_identical(tags_names(), names(x))
  expect_is(x, "list")
  expect_true(all(sapply(x, is.character)))
  
})
