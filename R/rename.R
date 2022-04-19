#' Rename columns of a linelist object
#'
#' This function works similarly to `dplyr::rename` but adds a specific
#' behaviour when some of the tagged variable are lost via renaming.
#'
#' @rdname rename.linelist
#' 
#' @param .data a `linelist` object
#'
#' @param ... the variables to rename, using `dplyr` compatible syntax
#'
#' @param lost_action a `character` indicating the behaviour to adopt when some
#'   of the tagged variables are dropped through the `rename` process; can be
#'   "warning" (default), "error", or "none".
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

rename.linelist <- function(.data, ...,
                            lost_action = "warning") {

  x <- .data

  out <- dplyr::rename(drop_linelist(x), ...)
  old_tags <- tags(x, TRUE)
  restore_tags(out, old_tags, lost_action)
  
}
