#' Subsetting of linelist objets
#'
#' The `[]` operator for `linelist` objects behaves like for regular
#' `data.frame` or `tibble`, but checks that tagged variables are not lost, and
#' takes the appropriate action (warning, error, or ignore, depending on the
#' value of `lost_action`) if this is the case.
#'
#' @param x a `linelist` object
#'
#' @param i a vector of `integer` or `logical` to subset the rows of the
#'   `linelist`
#' 
#' @param j a vector of `character`, `integer`, or `logical` to subset the
#'   columns of the `linelist`
#'
#' @param drop a `logical` indicating if, when a single column is selected, the
#'   `data.frame` class should be dropped to return a simple vector, in which
#'   case the `linelist` class is lost as well; defaults to `FALSE`
#'
#' @param lost_action a `character` indicating the behaviour to adopt when some
#'   of the tagged variables are dropped through the subsetting process; can be
#'   "warning" (default), "error", or "none".
#'
#' @return If no drop is happening, a `linelist`. Otherwise an atomic vector.
#' 
#' @export
#'
#' @rdname sub_linelist
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)

`[.linelist` <- function(x, i, j, drop = FALSE, lost_action = "warning") {
  # Strategy for subsetting
  #
  # Subsetting is done using the next method in line, for which we drop the
  # linelist class (we cannot use NextMethod because of the extra argument
  # `lost_action`). Then we need to check two things:
  #
  # 1. that the subsetted object is still a `data.frame` or a `tibble`; if not,
  # we automatically drop the `linelist` class and tags
  # 2. if the output is going to be a `linelist` we need to restore previous
  # tags with the appropriate behaviour in case of missing tagged variables

  # Case 1
  out <- drop_linelist(x)[i, j, drop = drop]
  if (is.null(ncol(out))) {
    return(out)
  }

  # Case 2
  old_tags <- tags(x, TRUE)
  out <- restore_tags(out, old_tags, lost_action)

  out
}



#' @export
#'
#' @rdname sub_linelist
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)

`[<-.linelist` <- function(x, i, j, value, lost_action = "warning") {

  # Note: explicitely calling the `data.frame` method seems like a necessary
  # workaround, as `NextMethod` does not seem to like the extra arguments for
  # `[<-`, even when passing the arguments through.

  # See this conversation: https://stackoverflow.com/questions/21859777/can-i-prevent-arguments-from-being-passed-via-nextmethod-in-r

  out <- drop_linelist(x)
  out[i, j] <- value

  old_tags <- tags(x, TRUE)
  out <- restore_tags(out, old_tags, lost_action)
  out
  
}
