#' subset columns of a linelist object
#'
#' This function works similarly to `dplyr::select` but can in addition refer to
#' tagged variables.
#'
#' @param x a `linelist` object
#'
#' @exportS3Method dplyr::select
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` with selected columns.
#'
#' @examples
#' # basic use of the function
#' if (require(outbreaks)) {
#' measles_hagelloch_1861
#' x <- make_linelist(measles_hagelloch_1861, date_onset = "date_of_prodrome")
#' tags(x)
#' }
#' 

select.linelist <- function(.data, ...) {
  # Strategy
  # --------
  # We want to be able to select variables by their original names or
  # using tags, with minimal overhead for the user. Current strategy is to add
  # columns for the tagged variables and then dispatch to the next select method
  # after removing the linelist class from the object. Tags are re-added to the
  # object. And tag whose variable has been removed is removed too.
  x <- .data
  tags <- unlist(tags(x))
  tags_df <- x[tags]
  names(tags_df) <- names(tags)
  full_df <- drop_linelist(cbind(tags_df, x))

  out <- select(full_df, ...)
  class(out) <- c("linelist", class(out))
  out
}
