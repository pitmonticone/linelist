#' Changes tags of a linelist object
#'
#' This function changes the `tags` of a `linelist` object, using the same
#' syntax as the constructor `make_linelist`. If some of the default tags are
#' missing, they will be added to the final object.
#'
#' @inheritParams make_linelist
#'
#' @seealso [make_linelist](make_linelist) to create a `linelist` object
#'
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` object.
#'
#' @examples
#' # basic use of the function
#' if (require(outbreaks)) {
#' measles_hagelloch_1861
#' x <- make_linelist(measles_hagelloch_1861, date_onset = "date_of_prodrome")
#' tags(x)
#' x <- set_tags(x, age = "age", gender = "gender")
#' tags(x)
#' }
#' 

set_tags <- function(x, ..., allow_extra = FALSE) {

  # assert inputs
  checkmate::assertClass(x, "linelist")
  checkmate::assertLogical(allow_extra)

  old_tags <- attr(x, "tags")
  defaults <- tags_defaults()
  new_tags <- list(...)
  
  final_tags <- modify_defaults(defaults, old_tags, strict = !allow_extra)
  final_tags <- modify_defaults(old_tags, new_tags, strict = !allow_extra)

  out <- x
  for (i in seq_along(final_tags)) {
    out <- tag_variable(out,
                        var_type = names(final_tags)[i],
                        var_name = final_tags[[i]])
  }
 
  out
}
