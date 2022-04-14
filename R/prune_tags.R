#' Prune tags after changing columns of a linelist
#'
#' Internal function. Used to remove tags whose variable has been removed after
#' subsetting the columns of a `linelist` object.
#'
#' @param x `linelist` object
#'
#' @param warn a `logical` indicating if a warning should be issued if some tagged
#'   variables have been lost; defaults to `TRUE`
#'
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` object.
#' 

prune_tags <- function(x, warn = TRUE) {
  old_tags <- tags(x, show_null = TRUE)

  has_lost_column <- vapply(old_tags,
                            function(e) !is.null(e) && !e %in% names(x),
                            logical(1))
  
  new_tags <- old_tags[!has_lost_column]
  out <- x
  attr(out, "tags") <- new_tags
  
  if (warn && any(has_lost_column)) {
    lost_tags <- unlist(old_tags[has_lost_column])
    lost_tags_txt <- paste(names(lost_tags),
                           lost_tags,
                           sep = "->",
                           collapse = ", ")
    msg <- paste("The following tags have lost their variable:\n",
                 lost_tags_txt)
    warning(msg)
  }
  
  out
}
