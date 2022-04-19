test_that("tests for rename", {

  if (require("dplyr")) {

    x <- make_linelist(cars, date_onset = "dist", date_outcome = "speed")
    
    # test errors
    msg <- "The following tags have lost their variable:\n date_onset:dist"
    expect_warning(rename(x, toto = dist), msg)
    expect_error(rename(x, toto = dist, lost_action = "error"), msg)
    
    # test functionalities
    ## basic case
    expect_identical(x, rename(x))
    
  }
})
