#' Checks the tags of a linelist object
#'
#' This function evalutes the validity of the tags of a `linelist` object by
#' checking that: i) tags are present ii) tags is a `list` of `character` iii)
#' that all default tags are present and iv) that no extra tag exists (is
#' `allow_extra` is `FALSE`).
#'
#' @export
#'
#' @param x a `linelist` object
#'
#' @inheritParams set_tags allow_extra
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return If checks pass, a `linelist` object; otherwise issues an error.
#'
#' @seealso [`validate_types`](validate_types) to check if tagged variables have
#'   the right classes

validate_tags <- function(x, allow_extra = TRUE) {
  checkmate::assert_class(x, "linelist")
  x_tags <- tags(x, show_null = TRUE)

  if (is.null(x_tags)) {
    msg <- "`x` has no tags attribute"
    stop(msg)
  }
  
  # check that x is a list, and each tag is a `character`
  checkmate::assert_list(x_tags, types = c("character", "null"), null.ok = FALSE)

  # check that defaults are present
  default_present <- tags_names() %in% names(x_tags)
  if (!all(default_present)) {
    missing_tags <- tags_names()[!default_present]
    msg <- sprintf(
      "The following default tags are missing:\n%s",
      paste(missing_tags, collapse = ", "))
  }

  
  # check there is no extra value
  x
}
