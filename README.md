
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/linelist/workflows/R-CMD-check/badge.svg)](https://github.com/epiverse-trace/linelist/actions)
[![codecov](https://codecov.io/gh/epiverse-trace/linelist/branch/main/graph/badge.svg?token=JGTCEY0W02)](https://codecov.io/gh/epiverse-trace/linelist)
[![lifecycle-experimental](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-experimental.svg)](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-experimental.svg)
<!-- badges: end -->

# Welcome to linelist\!

<br> **<span style="color: red;">NOTE</span>**

This package is a reboot of the RECON package
[linelist](https://github.com/reconhub/linelist). Unliked its
predecessor, the new package focuses on the implementation of a linelist
class. It will also eventually implement data cleaning tools,
replicating functionalities of the older package. However, the new
package should be seen as a separate one, and will not aim to be
backward compatible due to its change in scope.

The development version of *linelist* can be installed from
[GitHub](https://github.com/) with:

``` r
if (!require(remotes)) {
  install.packages("remotes")
}
remotes::install_github("epiverse-trace/linelist", build_vignettes = TRUE)
```

## linelist in a nutshell

*linelist* is an R package which implements basic data representation
for case line lists, alongside accessors and basic methods. It relies on
the idea that key fields of the linelist such as dates of events
(e.g. reporting, symptom onset), age, gender, symptoms, outcome, or
location, should be explicitely identified to facilitate data cleaning,
validation, and downstream analyses.

A `linelist` object is an instance of a `data.frame` or a `tibble` in
which key epidemiological variables have been *tagged*. The main
functions of the package include:

  - `make_linelist()`: to create a `linelist` object by tagging key epi
    variables in a `data.frame` or a `tibble`

  - `tags()`: to list variables which have been tagged in a `linelist`

  - `tags_names()`: to list all recognized tag names

  - `set_tags():` to modify tags in a `linelist`

  - `select_tags():` to select columns of a `linelist` based on tags
    using *dplyr* compatible syntax

  - `tags_df()`: to obtain a `data.frame` of all the tagged variables in
    a `linelist`

  - `select()`: adapted from `dplyr::select`, for subsetting regular and
    tagged variables

## Worked example

In this example, we use the case line list of the Hagelloch 1861 measles
outbreak.

``` r

# load libraries
library(outbreaks)
library(tibble)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(magrittr)
library(linelist)

# overview of the data
measles_hagelloch_1861 %>%
  head()
#>   case_ID infector date_of_prodrome date_of_rash date_of_death age gender
#> 1       1       45       1861-11-21   1861-11-25          <NA>   7      f
#> 2       2       45       1861-11-23   1861-11-27          <NA>   6      f
#> 3       3      172       1861-11-28   1861-12-02          <NA>   4      f
#> 4       4      180       1861-11-27   1861-11-28          <NA>  13      m
#> 5       5       45       1861-11-22   1861-11-27          <NA>   8      f
#> 6       6      180       1861-11-26   1861-11-29          <NA>  12      m
#>   family_ID class complications x_loc y_loc
#> 1        41     1           yes 142.5 100.0
#> 2        41     1           yes 142.5 100.0
#> 3        41     0           yes 142.5 100.0
#> 4        61     2           yes 165.0 102.5
#> 5        42     1           yes 145.0 120.0
#> 6        42     2           yes 145.0 120.0
```

Let us assume we want to tag the following variables to facilitate
downstream analyses, after having checked their tag name in
`?make_linelist`:

  - the date of symptom onset, here called `prodrome` (tag:
    `date_onset`)
  - the date of death (tag: `date_death`)
  - the age of the patient (tag: `age`)
  - the gender of the patient (tag: `gender`)

We create a `linelist` with the above information:

``` r

x <- measles_hagelloch_1861 %>%
  tibble() %>%
  make_linelist(date_onset = "date_of_prodrome",
                date_death = "date_of_death",
                age = "age",
                gender = "gender")
x
#> 
#> // linelist object
#> # A tibble: 188 × 12
#>    case_ID infector date_of_prodrome date_of_rash date_of_death   age gender
#>      <int>    <int> <date>           <date>       <date>        <dbl> <fct> 
#>  1       1       45 1861-11-21       1861-11-25   NA                7 f     
#>  2       2       45 1861-11-23       1861-11-27   NA                6 f     
#>  3       3      172 1861-11-28       1861-12-02   NA                4 f     
#>  4       4      180 1861-11-27       1861-11-28   NA               13 m     
#>  5       5       45 1861-11-22       1861-11-27   NA                8 f     
#>  6       6      180 1861-11-26       1861-11-29   NA               12 m     
#>  7       7       42 1861-11-24       1861-11-28   NA                6 m     
#>  8       8       45 1861-11-21       1861-11-26   NA               10 m     
#>  9       9      182 1861-11-26       1861-11-30   NA               13 m     
#> 10      10       45 1861-11-21       1861-11-25   NA                7 f     
#> # … with 178 more rows, and 5 more variables: family_ID <int>, class <fct>,
#> #   complications <fct>, x_loc <dbl>, y_loc <dbl>
#> 
#> // tags: date_onset:date_of_prodrome, date_death:date_of_death, gender:gender, age:age
```

The printing of the object confirms that the tags have been added. If we
want to double-check which variables have been tagged:

``` r

tags(x)
#> $date_onset
#> [1] "date_of_prodrome"
#> 
#> $date_death
#> [1] "date_of_death"
#> 
#> $gender
#> [1] "gender"
#> 
#> $age
#> [1] "age"
```

Let us now assume we also want to record the outcome: it is currently
missing, but can be built from dates of deaths (missing date =
survived). This can be done by using `mutate` on `x` to create the new
variable (remember `x` is not only a `linelist`, but also a regular
`tibble` and this compatible with `dplyr` verbs), and setting up a new
tag using `set_tags`:

``` r

x <- x %>%
  mutate(inferred_outcome = if_else(is.na(date_of_death), "survided", "died")) %>%
  set_tags(outcome = "inferred_outcome")
x
#> 
#> // linelist object
#> # A tibble: 188 × 13
#>    case_ID infector date_of_prodrome date_of_rash date_of_death   age gender
#>      <int>    <int> <date>           <date>       <date>        <dbl> <fct> 
#>  1       1       45 1861-11-21       1861-11-25   NA                7 f     
#>  2       2       45 1861-11-23       1861-11-27   NA                6 f     
#>  3       3      172 1861-11-28       1861-12-02   NA                4 f     
#>  4       4      180 1861-11-27       1861-11-28   NA               13 m     
#>  5       5       45 1861-11-22       1861-11-27   NA                8 f     
#>  6       6      180 1861-11-26       1861-11-29   NA               12 m     
#>  7       7       42 1861-11-24       1861-11-28   NA                6 m     
#>  8       8       45 1861-11-21       1861-11-26   NA               10 m     
#>  9       9      182 1861-11-26       1861-11-30   NA               13 m     
#> 10      10       45 1861-11-21       1861-11-25   NA                7 f     
#> # … with 178 more rows, and 6 more variables: family_ID <int>, class <fct>,
#> #   complications <fct>, x_loc <dbl>, y_loc <dbl>, inferred_outcome <chr>
#> 
#> // tags: date_onset:date_of_prodrome, date_death:date_of_death, gender:gender, age:age, outcome:inferred_outcome
```

Now that key variables have been tagged in `x`, we can used these
pre-defined fields in downstream analyses, without having to worry about
variable names and types. We could access tagged variables using any of
the following means:

``` r

# select tagged variables only
x %>%
  select_tags(date_onset, date_death)
#> # A tibble: 188 × 2
#>    date_onset date_death
#>    <date>     <date>    
#>  1 1861-11-21 NA        
#>  2 1861-11-23 NA        
#>  3 1861-11-28 NA        
#>  4 1861-11-27 NA        
#>  5 1861-11-22 NA        
#>  6 1861-11-26 NA        
#>  7 1861-11-24 NA        
#>  8 1861-11-21 NA        
#>  9 1861-11-26 NA        
#> 10 1861-11-21 NA        
#> # … with 178 more rows

# select tagged variables only with renaming on the fly
x %>%
  select_tags(onset = date_onset, date_death)
#> # A tibble: 188 × 2
#>    onset      date_death
#>    <date>     <date>    
#>  1 1861-11-21 NA        
#>  2 1861-11-23 NA        
#>  3 1861-11-28 NA        
#>  4 1861-11-27 NA        
#>  5 1861-11-22 NA        
#>  6 1861-11-26 NA        
#>  7 1861-11-24 NA        
#>  8 1861-11-21 NA        
#>  9 1861-11-26 NA        
#> 10 1861-11-21 NA        
#> # … with 178 more rows

# get all tagged variables in a data.frame
x %>%
  tags_df()
#> # A tibble: 188 × 5
#>    date_onset date_death gender   age outcome 
#>    <date>     <date>     <fct>  <dbl> <chr>   
#>  1 1861-11-21 NA         f          7 survided
#>  2 1861-11-23 NA         f          6 survided
#>  3 1861-11-28 NA         f          4 survided
#>  4 1861-11-27 NA         m         13 survided
#>  5 1861-11-22 NA         f          8 survided
#>  6 1861-11-26 NA         m         12 survided
#>  7 1861-11-24 NA         m          6 survided
#>  8 1861-11-21 NA         m         10 survided
#>  9 1861-11-26 NA         m         13 survided
#> 10 1861-11-21 NA         f          7 survided
#> # … with 178 more rows

# hybrid selection
x %>%
  select(1:2, tags = "gender")
#> Warning in prune_tags(out, lost_action): The following tags have lost their variable:
#>  date_onset:date_of_prodrome, date_death:date_of_death, age:age, outcome:inferred_outcome
#> 
#> // linelist object
#> # A tibble: 188 × 3
#>    case_ID infector gender
#>      <int>    <int> <fct> 
#>  1       1       45 f     
#>  2       2       45 f     
#>  3       3      172 f     
#>  4       4      180 m     
#>  5       5       45 f     
#>  6       6      180 m     
#>  7       7       42 m     
#>  8       8       45 m     
#>  9       9      182 m     
#> 10      10       45 f     
#> # … with 178 more rows
#> 
#> // tags: gender:gender
```

Note especially the meaningful warning in the last example, in which
`select` removes some of the variables that were tagged. This behaviour
can be silenced if needed, or could be changed to issue an error (for
stronger pipelines for instance):

``` r

# hybrid selection - no warning
x %>%
  select(1:2, tags = "gender", lost_action = "none")
#> 
#> // linelist object
#> # A tibble: 188 × 3
#>    case_ID infector gender
#>      <int>    <int> <fct> 
#>  1       1       45 f     
#>  2       2       45 f     
#>  3       3      172 f     
#>  4       4      180 m     
#>  5       5       45 f     
#>  6       6      180 m     
#>  7       7       42 m     
#>  8       8       45 m     
#>  9       9      182 m     
#> 10      10       45 f     
#> # … with 178 more rows
#> 
#> // tags: gender:gender

# hybrid selection - error due to lost tags
x %>%
  select(1:2, tags = "gender", lost_action = "error")
#> Error in prune_tags(out, lost_action): The following tags have lost their variable:
#>  date_onset:date_of_prodrome, date_death:date_of_death, age:age, outcome:inferred_outcome
```

## Contributing guidelines

Contributions are welcome via **pull requests**.

### Code of Conduct

Please note that the linelist project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
