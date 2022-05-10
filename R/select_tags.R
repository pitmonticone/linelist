#' Extract tagged variables of a linelist object
#'
#' This function is used to create a `data.frame` of tagged variables from a
#' `linelist` object, and runs [dplyr::select] on the output. It is equivalent
#' to running successively [tags_df()] and [dplyr::select()] on a
#' `linelist` object. Note that the output no longer is a `linelist` object, but
#' a regular `data.frame` (or `tibble`).
#'
#' @param x a `linelist` object
#'
#' @param ... the tagged variables to select, using [dplyr::select()] compatible
#'   terminology; see [tags_names()] for default values
#'
#' @author Thibaut Jombart \email{thibaut@@data.org}
#'
#' @return A `data.frame` of tagged variables.
#'
#' @export
#'
#' @seealso
#' * [tags()] for existing tags in a `linelist`
#' * [tags_df()] to get a `data.frame` of all tags
#' 
#' @examples
#' if (require(outbreaks)) {
#'
#'   ## dataset we'll create a linelist from
#'   measles_hagelloch_1861
#'
#'   ## create linelist
#'   x <- make_linelist(measles_hagelloch_1861,
#'                      id = "case_ID",
#'                      date_onset = "date_of_prodrome",
#'                      age = "age",
#'                      gender = "gender")
#'   head(x)
#' 
#'   ## check tagged variables
#'   tags(x)
#' 
#'   ## extract tagged variables
#'   select_tags(x, "gender", "age")
#' }

select_tags <- function(x, ...) {
  df <- tags_df(x)
  dplyr::select(df, ...)
}



## #' @export
## #' @rdname select_tags
## #' @param x a `linelist` object
## select_id <- function(x) {
##   select_tags(x, "id")
## }

## #' @export
## #' @rdname select_tags
## select_date_onset <- function(x) {
##   select_tags(x, "date_onset")
## }

## #' @export
## #' @rdname select_tags
## select_date_reporting <- function(x) {
##   select_tags(x, "date_reporting")
## }

## #' @export
## #' @rdname select_tags
## select_date_admission <- function(x) {
##   select_tags(x, "date_admission")
## }

## #' @export
## #' @rdname select_tags
## select_date_discharge <- function(x) {
##   select_tags(x, "date_discharge")
## }

## #' @export
## #' @rdname select_tags
## select_date_outcome <- function(x) {
##   select_tags(x, "date_outcome")
## }

## #' @export
## #' @rdname select_tags
## select_date_death <- function(x) {
##   select_tags(x, "date_death")
## }

## #' @export
## #' @rdname select_tags
## select_gender <- function(x) {
##   select_tags(x, "gender")
## }

## #' @export
## #' @rdname select_tags
## select_age <- function(x) {
##   select_tags(x, "age")
## }

## #' @export
## #' @rdname select_tags
## select_location <- function(x) {
##   select_tags(x, "location")
## }

## #' @export
## #' @rdname select_tags
## select_occupation <- function(x) {
##   select_tags(x, "occupation")
## }

## #' @export
## #' @rdname select_tags
## select_hcw <- function(x) {
##   select_tags(x, "hcw")
## }

## #' @export
## #' @rdname select_tags
## select_outcome <- function(x) {
##   select_tags(x, "outcome")
## }


