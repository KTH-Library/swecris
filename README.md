
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swecris

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/KTH-Library/swecris/workflows/R-CMD-check/badge.svg)](https://github.com/KTH-Library/swecris/actions)
<!-- badges: end -->

The goal of the `swecris` R package is to provide access to data from
SweCRIS, a national database that allows you to see how participating
research funding bodies has distributed their money to Swedish
recipients. SweCRIS is managed by the Swedish Research Council on behalf
of the Government. This R package uses the open API at SweCRIS to make
data available for use from R.

## Installation

You can install the development version of `swecris` from
[GitHub](https://github.com/KTH-Library/swecris) with:

``` r
library(devtools)
install_github("swecris", dependencies = TRUE)
```

## Example

This is a basic example which shows you how to get data about projects
at KTH Royal Institute of Technology:

``` r
library(swecris)
suppressPackageStartupMessages(library(dplyr))

kth_projects <- 
  swecris_search()

# display one of the search hits

project <- 
  kth_projects$hits %>%
  mutate(total_funding = as.numeric(total_funding)) %>%
  arrange(desc(total_funding)) %>%
  filter(grepl("data", abstract_en)) %>%
  slice(2)

project %>%
  glimpse()
#> Rows: 1
#> Columns: 13
#> $ document.id       <int> 2860
#> $ `_id`             <chr> "2019-00222_VR"
#> $ `_type`           <chr> "project"
#> $ identifier_short  <chr> "2019-00222"
#> $ total_funding     <dbl> 8e+07
#> $ abstract_sv       <chr> "NGI"
#> $ abstract_en       <chr> "The National Genomics Infrastructure (NGI) is an i…
#> $ dates_start_date  <chr> "2021-01-01"
#> $ dates_end_date    <chr> "2024-12-31"
#> $ title_sv          <chr> "National Genomics Infrastructure"
#> $ title_en          <chr> "National Genomics Infrastructure"
#> $ type_of_awards_sv <chr> "Forskningsinfrastruktur"
#> $ type_of_awards_en <chr> "Research infrastructure"
```

Given a project identifier, one can retrieve information about a
specific project:

``` r
p1 <- swecris_project("2019-05221_Vinnova")

# its funding organization
p1$documentList$documents$organizations$funding[[1]]$en
#> [1] "Vinnova"

# and various other details
p1$documentList$documents$dates
#>   start_date   end_date
#> 1 2019-11-01 2022-08-31

# such as its project leader
swecris_project_leaders("2019-05221_Vinnova")
#> # A tibble: 1 x 3
#>   id    name            orcid
#>   <chr> <chr>           <chr>
#> 1 28330 Tobias Jeppsson null
```
