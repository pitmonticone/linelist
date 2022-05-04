#' Check tagged variables are the right class
#'
#' This function checks the class of each tagged variable in a `linelist`
#' against pre-defined accepted classes in [`tags_types()`](tags_types).
#'
#' @export
#'
#' @param x a `linelist` object
#'
#' @param ref_types a `list` providing allowed types for all tags, as returned
#'   by [`tags_types`](tags_types)
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return A named `list`.
#'
#' @seealso [`tags_types`](tags_types) to check or change acceptable data
#'   classes for specific tags; [`validate_type`](validate_type) to apply
#'   validation to a single variable (non exported)
#' 
#' @examples
#' if (require(outbreaks) && require(dplyr) && require(magrittr)) {
#'
#'   ## create an invalid linelist - gender is a numeric
#'   x <- measles_hagelloch_1861 %>%
#'     tibble() %>% 
#'     make_linelist(id = "case_ID",
#'                   gender = "infector")
#'   x
#'
#'   ## the below would issue an error
#'   # validate_types(x)
#'
#'   ## to allow other types, e.g. gender to be integer, character or factor
#'   validate_types(x, tags_types(gender = c("integer", "character", "factor")))
#' }

validate_types <- function(x, ref_types = tags_types()) {

  checkmate::assert_class(x, "linelist")

  df_to_check <- tags_df(x)

  for (i in seq_len(ncol(df_to_check))) {
    res <- validate_type(df_to_check[[i]],
                         names(df_to_check)[i],
                         ref_types
                         )
    if (is.character(res)) {
      msg <- sprintf(
        "Issue when checking class of tag `%s`:\n%s",
        names(df_to_check)[i],
        res)
      stop(msg)
    }
  }
  
  x
}
