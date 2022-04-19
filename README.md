
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/linelist/workflows/R-CMD-check/badge.svg)](https://github.com/epiverse-trace/linelist/actions)
[![codecov](https://codecov.io/gh/epiverse-trace/linelist/branch/main/graph/badge.svg?token=JGTCEY0W02)](https://codecov.io/gh/epiverse-trace/linelist)
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
downstream analyses:

  - dates of onset, here called `prodrome`
  - date of death
  - age
  - gender

Here, we will first create the outcome variable, then create a
`linelist` with the above information:

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
missing but can be built from dates of deaths (missing date = survived).
This can be done by using `mutate` to create the new variable, and
setting up a new tag using `set_tags`:

``` r

x <- x %>%
  mutate(inferred_outcome = if_else(is.na(date_of_death), "survided", "died")) %>%
  set_tags(outcome = "inferred_outcome")
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
#>     case_ID infector gender
#> 1         1       45      f
#> 2         2       45      f
#> 3         3      172      f
#> 4         4      180      m
#> 5         5       45      f
#> 6         6      180      m
#> 7         7       42      m
#> 8         8       45      m
#> 9         9      182      m
#> 10       10       45      f
#> 11       11      182      f
#> 12       12       45      f
#> 13       13       12      m
#> 14       14      181      f
#> 15       15       45      m
#> 16       16      181      f
#> 17       17      181      f
#> 18       18      175      f
#> 19       19      181      m
#> 20       20      181      m
#> 21       21      181      f
#> 22       22       45      f
#> 23       23       45      f
#> 24       24       22      m
#> 25       25       22      f
#> 26       26       45      m
#> 27       27       10      m
#> 28       28      180      f
#> 29       29       31      m
#> 30       30       45      f
#> 31       31       45      f
#> 32       32       45      m
#> 33       33       45      f
#> 34       34      181      m
#> 35       35      182      f
#> 36       36       34      m
#> 37       37      182      m
#> 38       38       17   <NA>
#> 39       39       45      m
#> 40       40       93      m
#> 41       41      180      m
#> 42       42      178      f
#> 43       43       42      m
#> 44       44       45      m
#> 45       45      184      m
#> 46       46       45      m
#> 47       47       45      f
#> 48       48       10      f
#> 49       49       17      m
#> 50       50        8      f
#> 51       51       31      m
#> 52       52       17      m
#> 53       53       17      m
#> 54       54       17      m
#> 55       55       17      f
#> 56       56       45      m
#> 57       57       56      m
#> 58       58       45      m
#> 59       59       58      f
#> 60       60       58      m
#> 61       61      186      f
#> 62       62       11      m
#> 63       63       19      m
#> 64       64       45      m
#> 65       65       64      m
#> 66       66       64      f
#> 67       67       11      f
#> 68       68      179      f
#> 69       69       54      m
#> 70       70      180      m
#> 71       71       10      f
#> 72       72       12      f
#> 73       73      180      f
#> 74       74       45      f
#> 75       75       74      m
#> 76       76        5      m
#> 77       77      180      f
#> 78       78      181      f
#> 79       79      179      f
#> 80       80       78      m
#> 81       81       39      m
#> 82       82       45      m
#> 83       83       82      f
#> 84       84       82      m
#> 85       85       44      f
#> 86       86        1      f
#> 87       87       47      f
#> 88       88       47      f
#> 89       89       12      f
#> 90       90       93      m
#> 91       91       93      f
#> 92       92       93      f
#> 93       93       45      m
#> 94       94      183      f
#> 95       95       10      m
#> 96       96       97      m
#> 97       97       45      m
#> 98       98       64      m
#> 99       99       11      m
#> 100     100       47      m
#> 101     101        7      f
#> 102     102       21      m
#> 103     103       37   <NA>
#> 104     104       58      m
#> 105     105       74      m
#> 106     106       42      m
#> 107     107       19      f
#> 108     108      106      m
#> 109     109       12      f
#> 110     110       18      m
#> 111     111       34      m
#> 112     112       21      m
#> 113     113       31      f
#> 114     114       78   <NA>
#> 115     115       16      f
#> 116     116       45      m
#> 117     117      116      m
#> 118     118      116      f
#> 119     119      116      f
#> 120     120        7      m
#> 121     121       11      m
#> 122     122      188      f
#> 123     123        7      f
#> 124     124        7      m
#> 125     125        7      f
#> 126     126       37   <NA>
#> 127     127      106      m
#> 128     128        7      m
#> 129     129        7      f
#> 130     130       56      f
#> 131     131       56      m
#> 132     132       14      m
#> 133     133       18      f
#> 134     134       78      m
#> 135     135       79      m
#> 136     136       17      f
#> 137     137       16      f
#> 138     138       34   <NA>
#> 139     139        4   <NA>
#> 140     140        6   <NA>
#> 141     141       NA      f
#> 142     142      145      m
#> 143     143      145      f
#> 144     144      145      m
#> 145     145       45      f
#> 146     146      172      f
#> 147     147       18      f
#> 148     148       14      f
#> 149     149       39      m
#> 150     150      148      m
#> 151     151      153      f
#> 152     152      153      f
#> 153     153       45      f
#> 154     154      153      f
#> 155     155       73      m
#> 156     156       45      m
#> 157     157      156      f
#> 158     158      156      f
#> 159     159       37      f
#> 160     160       68      f
#> 161     161      148      f
#> 162     162      123      f
#> 163     163      123      f
#> 164     164      102      m
#> 165     165      102      m
#> 166     166      153      m
#> 167     167      110      m
#> 168     168       98      m
#> 169     169      153      m
#> 170     170      153      m
#> 171     171      169      m
#> 172     172      174      f
#> 173     173       NA      m
#> 174     174       NA      f
#> 175     175      173      m
#> 176     176      146   <NA>
#> 177     177      184      f
#> 178     178      184      m
#> 179     179      177      f
#> 180     180      177      m
#> 181     181      184      f
#> 182     182      184      m
#> 183     183      184      m
#> 184     184       NA   <NA>
#> 185     185       82      m
#> 186     186       45   <NA>
#> 187     187       82      m
#> 188     188      175   <NA>
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
#>     case_ID infector gender
#> 1         1       45      f
#> 2         2       45      f
#> 3         3      172      f
#> 4         4      180      m
#> 5         5       45      f
#> 6         6      180      m
#> 7         7       42      m
#> 8         8       45      m
#> 9         9      182      m
#> 10       10       45      f
#> 11       11      182      f
#> 12       12       45      f
#> 13       13       12      m
#> 14       14      181      f
#> 15       15       45      m
#> 16       16      181      f
#> 17       17      181      f
#> 18       18      175      f
#> 19       19      181      m
#> 20       20      181      m
#> 21       21      181      f
#> 22       22       45      f
#> 23       23       45      f
#> 24       24       22      m
#> 25       25       22      f
#> 26       26       45      m
#> 27       27       10      m
#> 28       28      180      f
#> 29       29       31      m
#> 30       30       45      f
#> 31       31       45      f
#> 32       32       45      m
#> 33       33       45      f
#> 34       34      181      m
#> 35       35      182      f
#> 36       36       34      m
#> 37       37      182      m
#> 38       38       17   <NA>
#> 39       39       45      m
#> 40       40       93      m
#> 41       41      180      m
#> 42       42      178      f
#> 43       43       42      m
#> 44       44       45      m
#> 45       45      184      m
#> 46       46       45      m
#> 47       47       45      f
#> 48       48       10      f
#> 49       49       17      m
#> 50       50        8      f
#> 51       51       31      m
#> 52       52       17      m
#> 53       53       17      m
#> 54       54       17      m
#> 55       55       17      f
#> 56       56       45      m
#> 57       57       56      m
#> 58       58       45      m
#> 59       59       58      f
#> 60       60       58      m
#> 61       61      186      f
#> 62       62       11      m
#> 63       63       19      m
#> 64       64       45      m
#> 65       65       64      m
#> 66       66       64      f
#> 67       67       11      f
#> 68       68      179      f
#> 69       69       54      m
#> 70       70      180      m
#> 71       71       10      f
#> 72       72       12      f
#> 73       73      180      f
#> 74       74       45      f
#> 75       75       74      m
#> 76       76        5      m
#> 77       77      180      f
#> 78       78      181      f
#> 79       79      179      f
#> 80       80       78      m
#> 81       81       39      m
#> 82       82       45      m
#> 83       83       82      f
#> 84       84       82      m
#> 85       85       44      f
#> 86       86        1      f
#> 87       87       47      f
#> 88       88       47      f
#> 89       89       12      f
#> 90       90       93      m
#> 91       91       93      f
#> 92       92       93      f
#> 93       93       45      m
#> 94       94      183      f
#> 95       95       10      m
#> 96       96       97      m
#> 97       97       45      m
#> 98       98       64      m
#> 99       99       11      m
#> 100     100       47      m
#> 101     101        7      f
#> 102     102       21      m
#> 103     103       37   <NA>
#> 104     104       58      m
#> 105     105       74      m
#> 106     106       42      m
#> 107     107       19      f
#> 108     108      106      m
#> 109     109       12      f
#> 110     110       18      m
#> 111     111       34      m
#> 112     112       21      m
#> 113     113       31      f
#> 114     114       78   <NA>
#> 115     115       16      f
#> 116     116       45      m
#> 117     117      116      m
#> 118     118      116      f
#> 119     119      116      f
#> 120     120        7      m
#> 121     121       11      m
#> 122     122      188      f
#> 123     123        7      f
#> 124     124        7      m
#> 125     125        7      f
#> 126     126       37   <NA>
#> 127     127      106      m
#> 128     128        7      m
#> 129     129        7      f
#> 130     130       56      f
#> 131     131       56      m
#> 132     132       14      m
#> 133     133       18      f
#> 134     134       78      m
#> 135     135       79      m
#> 136     136       17      f
#> 137     137       16      f
#> 138     138       34   <NA>
#> 139     139        4   <NA>
#> 140     140        6   <NA>
#> 141     141       NA      f
#> 142     142      145      m
#> 143     143      145      f
#> 144     144      145      m
#> 145     145       45      f
#> 146     146      172      f
#> 147     147       18      f
#> 148     148       14      f
#> 149     149       39      m
#> 150     150      148      m
#> 151     151      153      f
#> 152     152      153      f
#> 153     153       45      f
#> 154     154      153      f
#> 155     155       73      m
#> 156     156       45      m
#> 157     157      156      f
#> 158     158      156      f
#> 159     159       37      f
#> 160     160       68      f
#> 161     161      148      f
#> 162     162      123      f
#> 163     163      123      f
#> 164     164      102      m
#> 165     165      102      m
#> 166     166      153      m
#> 167     167      110      m
#> 168     168       98      m
#> 169     169      153      m
#> 170     170      153      m
#> 171     171      169      m
#> 172     172      174      f
#> 173     173       NA      m
#> 174     174       NA      f
#> 175     175      173      m
#> 176     176      146   <NA>
#> 177     177      184      f
#> 178     178      184      m
#> 179     179      177      f
#> 180     180      177      m
#> 181     181      184      f
#> 182     182      184      m
#> 183     183      184      m
#> 184     184       NA   <NA>
#> 185     185       82      m
#> 186     186       45   <NA>
#> 187     187       82      m
#> 188     188      175   <NA>
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
