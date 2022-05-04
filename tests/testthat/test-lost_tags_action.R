test_that("tests for lost_tags_action", {

  lost_tags_action("error", quiet = TRUE)
  expect_identical(get_lost_tags_action(), "error")

  x <- lost_tags_action(cars, "warning", quiet = TRUE)
  expect_identical(get_lost_tags_action(), "warning")
  expect_identical(x, cars)

  lost_tags_action("none", quiet = TRUE)
  expect_identical(get_lost_tags_action(), "none")

  lost_tags_action("warning", quiet = TRUE)
  expect_identical(get_lost_tags_action(), "warning")

})
