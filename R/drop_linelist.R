#' Remove the linelist class from an object
#'
#' Internal function. Used for dispatching to other methods.
#' 
#' @param x a `linelist` object
#'
#' @param remove_tags a `logical` indicating if tags should be removed from the
#'   attributes; defaults to `FALSE`
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @noRd
#' 
#' @return The function returns the same object without the `linelist` class.
#'
#' 

drop_linelist <- function(x, remove_tags = FALSE) {
  classes <- class(x)
  class(x) <- setdiff(classes, "linelist")
  if (remove_tags) {
    attr(x, "tags") <- NULL
  }
  x
}
