test_that("tests for drop_linelist", {

  # Check functionality
  x <- make_linelist(cars)
  drop_x <- drop_linelist(x)
  expect_identical(class(drop_x), "data.frame")
  expect_identical(tags(x), attr(drop_x, "tags"))
  expect_null(attr(drop_linelist(x, TRUE), "tags"))
  
})
