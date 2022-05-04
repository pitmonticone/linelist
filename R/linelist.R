#' linelist: Base Tools for Storing and Handling Case Line Lists
#'
#' The *linelist* package provides tools to help storing and handling case line
#' list data. The `linelist` class adds a tagging system to classical
#' `data.frame` or `tibble` objects which permits to identify key
#' epidemiological data such as dates of symptom onset, epi case definition,
#' age, gender or disease outcome. Once tagged, these variables can be
#' seamlessly used in downstream analyses, making data pipelines more robust and
#' reliable.
#' 
#' @docType package
#'
#' @aliases linelist
#' 
#' @author Thibaut Jombart [thibaut@data.org](thibaut@data.org)
#'
#' @section Main functions:
#'
#' * [`make_linelist`](make_linelist): to create `linelist` objects from a
#' `data.frame` or a `tibble`, with the possibility to tag key epi variables
#'
#' * [`set_tags`](set_tags): to change or add tagged variables in a `linelist`
#' 
#' * [`tags`](): to get the list of tags of a `linelist`
#' 
#' * [`tags_df`](tags_df): to get a `data.frame` of all tagged variables
#' 
#' * [`select_tags`](select_tags): like `dplyr::select`, but for tagged variables
#' 
#' * [`lost_tags_action`](lost_tags_action): to change the behaviour of actions
#' where tagged variables are lost (e.g. removing columns storing tagged
#' variables) to issue warnings, errors, or do nothing
#' 
#' * [`get_lost_tags_action`](get_lost_tags_action): to check the current
#' behaviour of actions where tagged variables are lost
#'
#' @section Dedicated methods:
#'
#' Specific methods commonly used to handle `data.frame` are provided for
#'   `linelist` objects, typically to help flag or prevent actions which could
#'   alter or lose tagged variables (and may thus break downstream data
#'   pipelines).
#' 
#' * [`names() <-`](names<-.linelist) and [`rename`](rename.linelist): will
#' rename tags as needed
#' 
#' * [`x[...] <-`](sub_linelist) and [`x[[...]] <-`](sub_linelist): will adopt
#' the desire behaviour when tagged variables are lost
#' 
NULL
