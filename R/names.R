#' Rename columns of a linelist
#'
#' This function can be used to rename the columns a `linelist`, adjusting tags
#' as needed.
#'
#' @param x a `linelist` object
#'
#' @param value a `character` vector to set the new names of the columns of `x`
#'
#' @return a `linelist` with new column names
#'
#' @seealso [`rename.linelist`](rename.linelist) for `dplyr`-style renaming of
#'   columns
#' 
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)

`names<-.linelist` <- function(x, value) {
  # Strategy for renaming

  # Since renaming cannot drop columns, we can update tags to match new variable
  # names. We do this by:

  # 1. Storing old names and new names to have define replacement rules
  # 2. Replace all tagged variables using the replacement rules 
  
  out <- drop_linelist(x, remove_tags = TRUE)
  names(out) <- value

  # Step 1
  old_names <- names(x)
  new_names <- names(out)
  if (any(is.na(new_names))) {
    msg <- paste(
      "Suggested naming would result in `NA` for some column names.",
      "Did you provide less names than columns targetted for renaming?",
      sep = "\n")
    stop(msg)
  }

  # Step 2
  out_tags <- tags(x, TRUE)
  for (i in seq_along(out_tags)) {
    if (!is.null(out_tags[[i]])) {
      idx <- match(out_tags[[i]], old_names)
      out_tags[[i]] <- new_names[idx]
    }
  }
  
  attr(out, "tags") <- out_tags
  class(out) <- class(x)
  out
}
