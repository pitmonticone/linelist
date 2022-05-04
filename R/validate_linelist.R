#' Checks the content of a linelist object
#'
#' This function evalutes the validity of a `linelist` object by checking the
#' object class, its tags, and the types of the tagged variables. See 'Details'
#' section for more information on the checks performed.
#'
#' @details The following checks are performed:
#'
#' * `x` is a `linelist` object
#' * `x` has a well-formed `tags` attribute
#' * all default tags are present (even if `NULL`)
#' * all tagged variables correspond to existing columns
#' * all tagged variables have an acceptable class
#' * (optional) `x` has no extra tag beyond the default tags
#'
#' @export
#'
#' @param x a `linelist` object
#'
#' @inheritParams validate_types
#'
#' @inheritParams set_tags
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return If checks pass, a `linelist` object; otherwise issues an error.
#'
#' @seealso [`validate_types`](validate_types) to check if tagged variables have
#'   the right classes; [`validate_tags`](validate_tags) to perform a series of
#'   checks on the tags
#'
#' @examples
#' 
#' if (require(outbreaks) && require(dplyr) && require(magrittr)) {
#'
#'   ## create a valid linelist
#'   x <- measles_hagelloch_1861 %>%
#'     tibble() %>% 
#'     make_linelist(id = "case_ID",
#'                   date_onset = "date_of_prodrome",
#'                   age = "age",
#'                   gender = "gender")
#'   x
#'
#'   ## validation
#'   validate_linelist(x)
#'
#'   ## create an invalid linelist - onset date is a factor
#'   x <- measles_hagelloch_1861 %>%
#'     tibble() %>% 
#'     make_linelist(id = "case_ID",
#'                   date_onset = "gender",
#'                   age = "age")
#'   x
#'
#'   ## the below issues an error
#'   # validate_linelist(x)
#' }

validate_linelist <- function(x,
                              allow_extra = FALSE,
                              ref_types = tags_types()) {

  checkmate::assert_class(x, "linelist")
  validate_tags(x, allow_extra)
  validate_types(x, ref_types)
  
  x
}
