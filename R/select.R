#' Subset columns of a linelist object
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
#' @param lost_action a `character` indicating the behaviour to adopt when some
#'   of the tagged variables are dropped through the `select` process; can be
#'   "warning" (default), "error", or "none".
#'
#' @exportS3Method dplyr::select
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` with selected columns.
#'
#' @seealso
#' * [`select_tags`](select_tags) to select tags only
#' * [`tags_df`](tags_df) to return a `data.frame` of all tagged variables
#' 

select.linelist <- function(.data, ..., tags = NULL,
                            lost_action = "warning") {

  checkmate::assertCharacter(tags, null.ok = TRUE)
  x <- .data
  
  # Strategy
  # --------
  #
  # Variable selection is done in two steps:
  # 
  # 1. normal use of `dplyr::select` on the data.frame using `...` arguments
  # 2. selection of tagged variables via the `tags` argument
  #
  # Both outputs are cbinded in the returned object. The following additional
  # checks are done:
  #
  # if tagged variables are added to the output, they need renaming to their
  # canonical tag name
  #
  # we need to check that tagged variables have not been lost, through
  # subsetting or renaming; for this we use `restore_tags()`
  # 

  # step 1
  df_base <- dplyr::select(drop_linelist(x), ...)

  # step 2
  # Note that tags could be renamed e.g. tags = c(onset = "date_onset"); we need
  # to ensure that the tags of the output will be renamed accordingly. It is not
  # entirely trivial as some of the tags may be named / renamed, some not,
  # e.g. tags = c(age, onset = "date_onset")); as a workaround we impose names
  # on all tags, then we rename tags as needed.
  df_tags <- select_tags(x, tags)

  ## keep old tags
  old_tags <- tags(x, TRUE)

 # browser()
  ## force naming of all new tags
  tag_names <- names(tags)
  ###  special case of a single unnamed tag
  if (is.null(tag_names)) {
    tag_names <- tags
  } else {
    missing_names <- tag_names == ""
    tag_names[missing_names] <- tags[missing_names]
  }  

  ## create new_tags where tags are renamed as needed 
  new_tags <- as.list(tag_names)  
  names(new_tags) <- tags
  out_tags <- modify_defaults(old_tags, new_tags)
  
  
  # finalize output
  out <- cbind(df_base, df_tags)
  out <- restore_tags(out, out_tags, lost_action)
  out
}



#' @export
#' @rdname select.linelist
#' @param x a `linelist` object
select_id <- function(x) {
  select_tags(x, "id")
}

#' @export
#' @rdname select.linelist
select_date_onset <- function(x) {
  select_tags(x, "date_onset")
}

#' @export
#' @rdname select.linelist
select_date_reporting <- function(x) {
  select_tags(x, "date_reporting")
}

#' @export
#' @rdname select.linelist
select_date_admission <- function(x) {
  select_tags(x, "date_admission")
}

#' @export
#' @rdname select.linelist
select_date_discharge <- function(x) {
  select_tags(x, "date_discharge")
}

#' @export
#' @rdname select.linelist
select_date_outcome <- function(x) {
  select_tags(x, "date_outcome")
}

#' @export
#' @rdname select.linelist
select_date_death <- function(x) {
  select_tags(x, "date_death")
}

#' @export
#' @rdname select.linelist
select_gender <- function(x) {
  select_tags(x, "gender")
}

#' @export
#' @rdname select.linelist
select_age <- function(x) {
  select_tags(x, "age")
}

#' @export
#' @rdname select.linelist
select_location <- function(x) {
  select_tags(x, "location")
}

#' @export
#' @rdname select.linelist
select_occupation <- function(x) {
  select_tags(x, "occupation")
}

#' @export
#' @rdname select.linelist
select_hcw <- function(x) {
  select_tags(x, "hcw")
}

#' @export
#' @rdname select.linelist
select_outcome <- function(x) {
  select_tags(x, "outcome")
}
