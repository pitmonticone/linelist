#' Tag a variable using its name
#'
#' This function will tag a pre-defined type of variable in a `data.frame` by
#' adding a named attribute identifying the column name.
#'
#' @param x a `data.frame` or a `tibble`, with at least one column
#'
#' @param var_type a `character` indicating the generic data to be tagged
#'
#' @param var_name a `character` or an `integer` indicating the columns of the
#'   dataset corresponding to this type of data
#'
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns the original object with an additional
#'   attribute.
#'
#' @details If used several times, the previous tag is removed silently.
#'
#' @examples
#' # basic use of the function
#' template(1)
#' 

tag_variable <- function(x, var_type, var_name) {

  # assert inputs
  checkmate::assertDataFrame(x, min.cols = 1)
  checkmate::assertCharacter(var_type, len = 1L)
  if (is.numeric(var_name)) {
    checkmate::assertNumber(var_name, lower = 1, upper = ncol(x), finite = TRUE)
    var_name <- names(x)[var_name]
  }
  checkmate::assertChoice(var_name, choices = names(x))

  # create tags attribute if needed; this is a named list used to store the
  # variable name corresponding to known variable types
  if (is.null(attr(x, "tags"))) {
    attr(x, "tags") <- list()
  }

  # extract the tags list, add new values, re-add to the object
  tags <- attr(x, "tags")
  tags[[var_type]] <- var_name
  attr(x, "tags") <- tags
  
  x
}
