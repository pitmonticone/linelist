#' Checks the content of a linelist object
#'
#' This function evalutes the validity of a `linelist` object by checking the
#' object class, its tags, and the types of the tagged variables.
#'
#' @export
#'
#' @param x a `linelist` object
#'
#' @inheritParams validate_types
#'
#' @inheritParams set_tags
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return If checks pass, a `linelist` object; otherwise issues an error.
#'
#' @seealso [`validate_types`](validate_types) to check if tagged variables have
#'   the right classes

validate_linelist <- function(x, ref_types = tags_types(), allow_extra = FALSE) {

  checkmate::assert_class(x, "linelist")
  validate_tags(x)
  validate_types(x, ref_types)
  
  x
}
