#' Extract tagged variables of a linelist object
#'
#' This function is used to create a `data.frame` of tagged variables from a
#' `linelist` object, and runs `dplyr::select` on the output. Note that the
#' output no longer is a `linelist` object, but a regular `data.frame`.
#'
#' @param x a `linelist` object
#'
#' @param ... the tagged variables to select, using `dplyr::select` compatible
#'   terminology; see [`tags_names`](tags_names)) for default values
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return A `data.frame` of tagged variables.
#'
#' @seealso [`tags_names`](tags_names)) for the names of tags
#' 

select_tags <- function(x, ...) {
  df <- tags_df(x)
  dplyr::select(df, ...)
}


