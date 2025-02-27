% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rename.R
\name{rename.linelist}
\alias{rename.linelist}
\title{Rename columns of a linelist object}
\usage{
\method{rename}{linelist}(.data, ...)
}
\arguments{
\item{.data}{a \code{linelist} object}

\item{...}{the variables to rename, using \code{dplyr} compatible syntax}
}
\value{
The function returns a \code{linelist} with renameed columns.
}
\description{
This function works similarly to \code{dplyr::rename} and can be used to rename
the columns of a \code{linelist}. Tagged variables are updated as needed to match
new column names.
}
\examples{
if (require(outbreaks) && require(dplyr) && require(magrittr)) {

  ## dataset to create a linelist from
  head(measles_hagelloch_1861)

  ## create linelist
  x <- measles_hagelloch_1861 \%>\%
    tibble() \%>\% 
    make_linelist(id = "case_ID",
                  date_onset = "date_of_prodrome",
                  age = "age",
                  gender = "gender")
  x

  ## change names
  x <- x \%>\%
    rename(sex = gender, case = case_ID)

  ## see results: tags have been updated
  x
  tags(x)
}
}
\seealso{
\itemize{
\item \code{\link[=select.linelist]{select.linelist()}} for selecting variables and tags
\item \code{\link[=select_tags]{select_tags()}} for selecting tags
\item \code{\link[=tags_df]{tags_df()}} to return a \code{data.frame} or a \code{tibble} of all agged variables
}
}
\author{
Thibaut Jombart \email{thibaut@data.org}
}
