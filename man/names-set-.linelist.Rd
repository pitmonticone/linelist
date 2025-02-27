% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/names.R
\name{names<-.linelist}
\alias{names<-.linelist}
\title{Rename columns of a linelist}
\usage{
\method{names}{linelist}(x) <- value
}
\arguments{
\item{x}{a \code{linelist} object}

\item{value}{a \code{character} vector to set the new names of the columns of \code{x}}
}
\value{
a \code{linelist} with new column names
}
\description{
This function can be used to rename the columns a \code{linelist}, adjusting tags
as needed.
}
\examples{
if (require(outbreaks)) {

  ## dataset to create a linelist from
  measles_hagelloch_1861

  ## create linelist
  x <- make_linelist(measles_hagelloch_1861,
                     id = "case_ID",
                     date_onset = "date_of_prodrome",
                     age = "age",
                     gender = "gender")
  head(x)

  ## change names
  names(x)[1] <- "case_label"

  ## see results: tags have been updated
  head(x)
  tags(x)
}
}
\seealso{
\code{\link[=rename.linelist]{rename.linelist()}} for renaming columns as with \code{\link[dplyr:rename]{dplyr::rename()}}
}
\author{
Thibaut Jombart \email{thibaut@data.org}
}
