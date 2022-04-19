#' subset columns of a linelist object
#'
#' This function works similarly to `dplyr::select` but can in addition refer to
#' tagged variables through the `tags` argument. When variables are selected
#' using both procedures, tagged variables are output as the last columns.
#'
#' @rdname select.linelist
#' 
#' @param .data a `linelist` object
#'
#' @param ... the variables to select, either using their column names, or tag
#'   names (or a mixture)
#'
#' @param tags a `character` indicating tagged variables to select using tag
#'   names (see `tags_names()`) for default values
#'
#' @inheritParams prune_tags
#'
#' @exportS3Method dplyr::select
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` with selected columns.
#'
#' @details 
#'
#' @seealso [`make_linelist`](make_linelist) for a list of all tags which can be
#'   used in `select`
#' 

select.linelist <- function(.data, ..., tags = NULL,
                            lost_action = "none") {
  # Strategy
  # --------
  #
  # Variable selection is done in two steps:
  # 1. normal use of `dplyr::select` on the data.frame using `...` arguments
  # 2. selection of tagged variables via the `tags` argument
  #
  # Both outputs are cbinded in the returned object. The following additional
  # checks are done, depending on how variables were selected:
  #
  # 1. we need to check that tagged variables have not been lost, through
  # subsetting or renaming; for this we use `restore_tags()`
  # 2. if tagged variables are added to the output, they need renaming to their
  # canonical tag name

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
  out <- prune_tags(out, lost_action)
  out
}



#' @export
#' @rdname select.linelist
#' @param x a `linelist` object
select_id <- function(x) {
  select(x, "id")
}

#' @export
#' @rdname select.linelist
select_date_onset <- function(x) {
  select(x, "date_onset")
}

#' @export
#' @rdname select.linelist
select_date_reporting <- function(x) {
  select(x, "date_reporting")
}

#' @export
#' @rdname select.linelist
select_date_admission <- function(x) {
  select(x, "date_admission")
}

#' @export
#' @rdname select.linelist
select_date_discharge <- function(x) {
  select(x, "date_discharge")
}

#' @export
#' @rdname select.linelist
select_date_outcome <- function(x) {
  select(x, "date_outcome")
}

#' @export
#' @rdname select.linelist
select_date_death <- function(x) {
  select(x, "date_death")
}

#' @export
#' @rdname select.linelist
select_gender <- function(x) {
  select(x, "gender")
}

#' @export
#' @rdname select.linelist
select_age <- function(x) {
  select(x, "age")
}

#' @export
#' @rdname select.linelist
select_location <- function(x) {
  select(x, "location")
}

#' @export
#' @rdname select.linelist
select_occupation <- function(x) {
  select(x, "occupation")
}

#' @export
#' @rdname select.linelist
select_hcw <- function(x) {
  select(x, "hcw")
}

#' @export
#' @rdname select.linelist
select_outcome <- function(x) {
  select(x, "outcome")
}
