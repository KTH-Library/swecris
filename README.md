
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

# either fetch the data from the API
#kth_projects <- swecris_funding()

# or use the bundled data
kthf <- swecris_kth

# top ten largest fundings containing abstracts with the word "data"
library(dplyr)

fundings <- 
  kthf %>%
  mutate(total_funding = as.numeric(FundingsSek)) %>%
  arrange(desc(total_funding)) %>%
  filter(grepl("data", ProjectAbstractEn)) %>%
  slice(10)

# display an example record
fundings %>%
  glimpse()
#> Rows: 1
#> Columns: 27
#> $ ProjectId                                    <chr> "2009-04126_Vinnova"
#> $ ProjectTitleSv                               <chr> "ProNova VINN Excellence …
#> $ ProjectTitleEn                               <chr> "ProNova VINN Excellence …
#> $ ProjectAbstractSv                            <chr> "Syfte och mål:\r\n<p><st…
#> $ ProjectAbstractEn                            <chr> "Purpose and goal:\r\n<p>…
#> $ ProjectStartDate                             <date> 2009-04-01
#> $ ProjectEndDate                               <date> 2012-03-31
#> $ CoordinatingOrganisationId                   <chr> "202100-3054"
#> $ CoordinatingOrganisationNameSv               <chr> "KTH, Kungliga tekniska h…
#> $ CoordinatingOrganisationNameEn               <chr> "KTH, Royal Institute of…
#> $ CoordinatingOrganisationTypeOfOrganisationSv <chr> "Universitet"
#> $ CoordinatingOrganisationTypeOfOrganisationEn <chr> "University"
#> $ FundingOrganisationId                        <chr> "202100-5216"
#> $ FundingOrganisationNameSv                    <chr> "Vinnova"
#> $ FundingOrganisationNameEn                    <chr> "Vinnova"
#> $ FundingOrganisationTypeOfOrganisationSv      <chr> "Stat, regioner, kommune…
#> $ FundingOrganisationTypeOfOrganisationEn      <chr> "Governmental"
#> $ FundingsSek                                  <dbl> 2.1e+07
#> $ FundingYear                                  <dbl> 2009
#> $ FundingStartDate                             <date> 2009-04-01
#> $ FundingEndDate                               <date> 2012-03-31
#> $ TypeOfAwardId                                <dbl> 1
#> $ TypeOfAwardDescrSv                           <chr> "Projektbidrag"
#> $ TypeOfAwardDescrEn                           <chr> "Project grant"
#> $ InvolvedPeople                               <chr> "¤¤¤10306¤Amelie Eriksson…
#> $ Scbs                                         <chr> NA
#> $ total_funding                                <dbl> 2.1e+07
```

Given an organisation, get information about projects:

``` r
orgid <- 
  swecris_organisations() %>%
  filter(grepl("^KTH, ", organisationNameSv)) %>%
  dplyr::pull(organisationId)

kthp <- swecris_projects(orgid)

# ten upcoming projects
projects <- 
  kthp %>% arrange(desc(lubridate::ymd(fundingStartDate))) %>% 
  select(-starts_with("projectAbstract")) %>%
  select(
    projectId, 
    projectTitleEn, 
    projectStartDate, 
    projectEndDate, 
    fundingOrganisationNameEn, 
    fundingsSek, 
    fundingYear
  ) %>%
  head(10)

knitr::kable(projects)
```

| projectId           | projectTitleEn                                                                                                      | projectStartDate | projectEndDate | fundingOrganisationNameEn | fundingsSek | fundingYear |
|:--------------------|:--------------------------------------------------------------------------------------------------------------------|:-----------------|:---------------|:--------------------------|------------:|:------------|
| 2021-02081\_Vinnova | Characterisation and effects of micro and nanoscale components and their impact on efficiency of chemical additives | 2021-12-01       | 2025-11-30     | Vinnova                   |     2600000 | 2021        |
| 2021-03620\_Vinnova | Zero-emission contractors - a feasibility study for solutions in the road construction industry                     | 2021-10-01       | 2022-10-01     | Vinnova                   |      450000 | 2021        |
| 2021-03462\_Vinnova | International Activities for InfraSweden2030                                                                        | 2021-09-15       | 2022-09-15     | Vinnova                   |      800000 | 2021        |
| 2021-03464\_Vinnova | InfraAwards 2022                                                                                                    | 2021-09-15       | 2022-12-30     | Vinnova                   |     1150000 | 2021        |
| 2021-03465\_Vinnova | Communication to support implementation                                                                             | 2021-09-10       | 2022-07-31     | Vinnova                   |      450000 | 2021        |
| 2021-03466\_Vinnova | Client network for a climate-neutral construction sector                                                            | 2021-09-10       | 2023-05-26     | Vinnova                   |      800000 | 2021        |
| 2021-03467\_Vinnova | Innovation partnership - Connected road condition monitoring                                                        | 2021-09-10       | 2024-03-31     | Vinnova                   |     1500000 | 2021        |
| 2021-02048\_Vinnova | Supersonic spraying of graphene/MXene-based conductive wear-resistant coatings for electrification                  | 2021-08-31       | 2022-05-31     | Vinnova                   |      300000 | 2021        |
| 2021-01922\_Vinnova | Digitalisation of atomisation of metal powders                                                                      | 2021-08-16       | 2022-03-11     | Vinnova                   |      510217 | 2021        |
| 2021-03272\_Vinnova | Climate Smart Cities Challenge - competition and system demonstration                                               | 2021-08-16       | 2023-12-31     | Vinnova                   |     5200000 | 2021        |

Swedish list for 2021 (the first few records):

``` r
sl <- 
  swecris_swedish_list()
#> Rows: 34882 Columns: 11
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ";"
#> chr (2): ISSN, Titel
#> dbl (9): 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

glimpse(sl %>% head() %>% collect())
#> Rows: 6
#> Columns: 11
#> $ ISSN   <chr> "0001-0782", "0001-1452", "0001-1541", "0001-2092", "0001-2343"…
#> $ Titel  <chr> "Communications of the ACM", "AIAA Journal", "AIChE Journal", "…
#> $ `2012` <dbl> NA, 1, NA, NA, NA, NA
#> $ `2013` <dbl> 1, 1, 1, NA, 1, NA
#> $ `2014` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2015` <dbl> 1, 1, 1, 1, NA, NA
#> $ `2016` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2017` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2018` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2019` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2020` <dbl> 1, 1, 1, 1, NA, 1

knitr::kable(sl %>% head() %>% collect())
```

| ISSN      | Titel                                          | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 |
|:----------|:-----------------------------------------------|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
| 0001-0782 | Communications of the ACM                      |   NA |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |
| 0001-1452 | AIAA Journal                                   |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |
| 0001-1541 | AIChE Journal                                  |   NA |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |
| 0001-2092 | AORN Journal                                   |   NA |   NA |   NA |    1 |   NA |   NA |   NA |   NA |    1 |
| 0001-2343 | ARSP. Archiv für Rechts- und Socialphilosophie |   NA |    1 |   NA |   NA |   NA |   NA |   NA |   NA |   NA |
| 0001-2351 | Transactions of the ASAE                       |   NA |   NA |   NA |   NA |   NA |   NA |   NA |   NA |    1 |
