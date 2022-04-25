#' List acceptable variable types for tags
#'
#' This function returns a named list providing the acceptable data types for
#' the default tags.
#'
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return A named `list`.
#'
#' @seealso [`tags_defaults`](tags_defaults) for the default tags
#' 
#' @examples
#' tags_types()

tags_types <- function() {
  list(
    id = c("numeric", "integer", "character"),
    date_onset = date_types,
    date_reporting = date_types,
    date_admission = date_types,
    date_discharge = date_types,
    date_outcome = date_types,
    date_death = date_types,
    gender = category_types,
    age = numeric_types,
    location = category_types,
    occupation = category_types,
    hcw = binary_types, 
    outcome = category_types
  )
}


#' @noRd
date_types <- c("integer", "numeric", "Date", "POSIXct", "POSIXlt")

#' @noRd
category_types <- c("character", "factor")

#' @noRd
numeric_types <- c("numeric", "integer") 

#' @noRd
binary_types <- c("logical", "integer", "character", "factor")
