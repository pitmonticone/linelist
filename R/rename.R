#' Rename columns of a linelist object
#'
#' This function works similarly to `dplyr::rename` and can be used to rename
#' the columns of a `linelist`. Tagged variables are updated as needed to match
#' new column names.
#'
#' @rdname rename.linelist
#' 
#' @param .data a `linelist` object
#'
#' @param ... the variables to rename, using `dplyr` compatible syntax
#'
#' @exportS3Method dplyr::rename
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` with renameed columns.
#'
#' @seealso
#' * [`select.linelist`](select.linelist) for selecting variables and tags
#' * [`tags_df`](tags_df) to return a `data.frame` of all tagged variables
#' * [`select_tags`](select_tags) to rename tags only
#' * [`tags_df`](tags_df) to return a `data.frame` of all tagged variables
#' 

rename.linelist <- function(.data, ...) {
  # Strategy: we use `dplyr::rename` to handle the renaming of columns, then
  # extract these names and use them to rename the linelist using
  # `names<-.linelist`
  out <- .data
  new_names <- names(dplyr::rename(drop_linelist(out), ...))
  names(out) <- new_names
  out
}
