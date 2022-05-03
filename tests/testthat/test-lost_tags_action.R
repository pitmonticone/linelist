test_that("tests for lost_tags_action", {

  lost_tags_action("error")
  expect_identical(get_lost_tags_action(), "error")

  x <- lost_tags_action(cars, "warning")
  expect_identical(get_lost_tags_action(), "warning")
  expect_identical(x, cars)

  lost_tags_action("none")
  expect_identical(get_lost_tags_action(), "none")

})
