test_that("tests for prune_tags", {

  x <- make_linelist(cars, age = "speed")
  names(x) <- c("toto", "titi")

  # Check warnings
  msg <- "The following tags have lost their variable:\n age->speed"
  expect_warning(prune_tags(x, TRUE), msg)
  
  # Check functionality
  expect_length(tags(prune_tags(x, FALSE)), 0)
    
})
