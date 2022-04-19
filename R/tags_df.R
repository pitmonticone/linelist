#' Extract a data.frame of all tagged variables
#'
#' This function returns a `data.frame` of all the tagged variables stored in a
#' `linelist`. Note that the output is no longer a `linelist`, but a regular
#' `data.frame`.
#'
#' @param x a `linelist` object
#' 
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return A `data.frame` of tagged variables.
#' 

tags_df <- function(x) {
  checkmate::assertClass(x, "linelist")
  tags <- unlist(tags(x))
  out <- x[tags]
  names(out) <- names(tags)
  drop_linelist(out, remove_tags = TRUE)
}
