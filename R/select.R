#' subset columns of a linelist object
#'
#' This function works similarly to `dplyr::select` but can in addition refer to
#' tagged variables. We recommend referring to variables and tags by their
#' names: using `logical` and `integer` may have unexecpted results due to how
#' regular variables and tagged variables are combined (see details).
#'
#' @param .data a `linelist` object
#'
#' @param ... the variables to select, either using their column names, or tag
#'   names (or a mixture)
#'
#' @param warn a `logical` indicating if a warning should be issued if some
#'   tagged variables have been lost by the `select` operation; defaults to
#'   `TRUE`
#'
#' @exportS3Method dplyr::select
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` with selected columns.
#'
#' @details The function relies on a concatenation of two data.frames, the first
#'   one containing the regular variables, and the second one containing tagged
#'   variables. This approach is safe as long as regular variables and tagged
#'   variables are referred to by their names, which is the recommended
#'   approach. Other approaches using `integer` or `logical` may yield more
#'   confusing outputs, e.g. selecting `all` variables using `TRUE` will return
#'   the two data.frames concatenated.
#' 

select.linelist <- function(.data, ..., warn = TRUE) {
  # Strategy
  # --------
  # We want to be able to select variables by their original names or
  # using tags, with minimal overhead for the user. Current strategy is to add
  # columns for the tagged variables and then dispatch to the next select method
  # after removing the linelist class from the object. Tags are re-added to the
  # object. And tag whose variable has been removed is removed too.
  x <- .data
  tags <- unlist(tags(x, TRUE))
  tags_df <- x[tags]
  names(tags_df) <- names(tags)
  full_df <- drop_linelist(cbind(x, tags_df))

  out <- select(full_df, ...)
  class(out) <- c("linelist", class(out))
  out <- prune_tags(out, warn = warn)
  out
}
