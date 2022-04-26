test_that("tests for validate_type", {

  # Check errors
  msg <- "Assertion on 'x' failed: Must be of type 'atomic vector', not 'data.frame'."
  expect_error(validate_type(cars, "toto"), msg)

  msg <- "Allowed types for tag `toto` are not documented in `ref_types`"
  expect_error(validate_type(letters, "toto"), msg)

  msg <- "Assertion on 'x' failed: Must inherit from class 'numeric'/'integer'/'character', but has class 'factor'."
  expect_error(validate_type(factor(letters), "id"), msg)

  msg <- "Assertion on 'x' failed: Must inherit from class 'DNAbin', but has class 'character'."
  expect_error(
    validate_type(c("a", "t"),
                  "sequence",
                  tags_types(sequence = "DNAbin",
                             allow_extra = TRUE)),
    msg)
  
  # Check functionality
  expect_identical(letters, validate_type(letters, "id"))

  x <- validate_type(factor(letters), "id",
                     tags_types(id = c("character", "factor", "numeric")))
  expect_identical(factor(letters), x)


})
