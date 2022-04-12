#' Create a linelist from a data.frame
#'
#' This function converts a `data.frame` or a `tibble` to a `linelist` object,
#' where different types of epidemiologically relevant data are tagged. This
#' includes dates of different events (e.g. onset of symtpom, case reporting),
#' information on the patient (e.g. age, gender, location) as well as other
#' informations such as the type of case (e.g. confirmed, probable) or the
#' outcome of the disease. The output will seem to be the same `data.frame`, but
#' `linelist`-aware packages will then be able to automatically use tagged
#' fields for further data cleaning and analysis.
#'
#' @param x a `data.frame` or a `tibble` containing case line list data, with
#'   cases in rows and variables in columns
#' 
#' @param date_onset date of symptom onset
#' 
#' @param date_reporting date of case notification
#' 
#' @param date_admission date of hospital admission
#' 
#' @param date_discharge date of hospital discharge
#' 
#' @param date_outcome date of disease outcome
#' 
#' @param date_death date of death
#' 
#' @param gender the gender of the patient
#' 
#' @param age the age of the patient, in years
#' 
#' @param location the location of the patient
#' 
#' @param occupation the professional activity of the patient
#' 
#' @param hcw a logical indicating if the patient is a health care worker
#' 
#' @param outcome 
#'
#' @export
#'
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @return The function returns a `linelist` object.
#'
#' @details Some more information on the function
#'
#' @examples
#' # basic use of the function
#' template(1)
#' 

make_linelist <- function(x) {
  # assert inputs

  # do stuff ...

  # shape output and return object
  class(x) <- c(class(x), "linelist")
  x
}
