
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swecris

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/KTH-Library/swecris/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KTH-Library/swecris/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of the `swecris` R package is to provide access to data from
SweCRIS, a national database that allows you to see how participating
research funding bodies has distributed their money to Swedish
recipients.

SweCRIS is managed by the Swedish Research Council on behalf of the
Government. This R package uses the [API at
SweCRIS](https://swecris-api.vr.se/index.html) to make data available
for use from R.

## Installation

You can install the development version of `swecris` from
[GitHub](https://github.com/KTH-Library/swecris) with:

``` r
library(devtools)
install_github("swecris", dependencies = TRUE)
```

## Examples

### Projects for an organization

**Goal**: Using bundled data for KTH. This is a basic example which
shows you how to get bundled data about projects at KTH Royal Institute
of Technology:

``` r
library(swecris)
suppressPackageStartupMessages(library(dplyr))

# either fetch data live from the API
#kth_projects <- swecris_funding()

# or use the bundled data
kthf <- swecris_kth

# top three largest fundings containing abstracts with the word "data"
library(dplyr)

fundings <- 
  kthf %>%
  mutate(total_funding = as.numeric(FundingsSek)) %>%
  arrange(desc(total_funding)) %>%
  filter(grepl("data", ProjectAbstractEn)) %>%
  slice(3)

# display an example record
fundings %>%
  glimpse()
#> Rows: 1
#> Columns: 27
#> $ ProjectId                                    <chr> "2017-00630_VR"
#> $ ProjectTitleSv                               <chr> "Nationell Infrastruktur …
#> $ ProjectTitleEn                               <chr> "National Genomics Infras…
#> $ ProjectAbstractSv                            <chr> NA
#> $ ProjectAbstractEn                            <chr> "The National Genomics In…
#> $ ProjectStartDate                             <dttm> 2018-01-01
#> $ ProjectEndDate                               <dttm> 2020-12-31
#> $ CoordinatingOrganisationId                   <chr> "202100-3054"
#> $ CoordinatingOrganisationNameSv               <chr> "KTH, Kungliga tekniska h…
#> $ CoordinatingOrganisationNameEn               <chr> "KTH, Royal Institute of …
#> $ CoordinatingOrganisationTypeOfOrganisationSv <chr> "Universitet"
#> $ CoordinatingOrganisationTypeOfOrganisationEn <chr> "University"
#> $ FundingOrganisationId                        <chr> "202100-5208"
#> $ FundingOrganisationNameSv                    <chr> "Vetenskapsrådet"
#> $ FundingOrganisationNameEn                    <chr> "Swedish Research Council"
#> $ FundingOrganisationTypeOfOrganisationSv      <chr> "Stat, regioner, kommune…
#> $ FundingOrganisationTypeOfOrganisationEn      <chr> "Governmental"
#> $ FundingsSek                                  <dbl> 49450000
#> $ FundingYear                                  <dbl> 2018
#> $ FundingStartDate                             <date> 2018-01-01
#> $ FundingEndDate                               <date> 2020-12-31
#> $ TypeOfAwardId                                <dbl> 5
#> $ TypeOfAwardDescrSv                           <chr> "Forskningsinfrastruktur"
#> $ TypeOfAwardDescrEn                           <chr> "Research infrastructure"
#> $ InvolvedPeople                               <chr> "¤¤¤69418¤Joakim Lundebe…
#> $ Scbs                                         <chr> "¤¤¤ 1: Naturvetenskap, N…
#> $ total_funding                                <dbl> 49450000
```

**Goal**: Given an organisation, get its id and then get information
about three associated projects whose funding start date soon will be
here:

``` r

orgid <- 
  swecris_organisations() %>%
  filter(grepl("^KTH, ", organisationNameSv)) %>%
  dplyr::pull(organisationId) %>%
  purrr::pluck(1)

kthp <- swecris_projects(orgid)

# three upcoming projects
projects <- 
  kthp %>% 
  mutate(fsd = lubridate::ymd(fundingStartDate)) %>%
  filter(fsd > lubridate::now()) %>%
  arrange(desc(fsd)) %>% 
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
  head(3)

knitr::kable(projects)
```

| projectId     | projectTitleEn                                                                                                                   | projectStartDate    | projectEndDate      | fundingOrganisationNameEn | fundingsSek | fundingYear |
|:--------------|:---------------------------------------------------------------------------------------------------------------------------------|:--------------------|:--------------------|:--------------------------|------------:|:------------|
| 2021-00157_VR | Petra III Swedish Node                                                                                                           | 2023-01-01 00:00:00 | 2026-12-31 00:00:00 | Swedish Research Council  |    25636000 | 2023        |
| 2022-00901_VR | How estrogen receptors of the colon create a microenvironment that suppress carcinogenesis - for cancer prevention and treatment | 2023-01-01 00:00:00 | 2026-12-31 00:00:00 | Swedish Research Council  |     6000000 | 2023        |
| 2022-01079_VR | Characterization and quantification of synaptic populations                                                                      | 2023-01-01 00:00:00 | 2025-12-31 00:00:00 | Swedish Research Council  |     2400000 | 2023        |

### Project details

**Goal**: Given a projects id, get more information about the project
and associated people and SCB classification codes:

``` r

# some details for a specific project
"2021-00157_VR" %>% swecris_project() %>% select(-c("projectAbstractEn")) %>% t()
#>                                              [,1]                                    
#> projectId                                    "2021-00157_VR"                         
#> projectTitleSv                               "Petra III svensk nod"                  
#> projectTitleEn                               "Petra III Swedish Node"                
#> projectAbstractSv                            ""                                      
#> projectStartDate                             "2023-01-01 00:00:00"                   
#> projectEndDate                               "2026-12-31 00:00:00"                   
#> coordinatingOrganisationId                   "202100-3054"                           
#> coordinatingOrganisationNameSv               "KTH, Kungliga tekniska högskolan"      
#> coordinatingOrganisationNameEn               "KTH, Royal Institute of Technology"    
#> coordinatingOrganisationTypeOfOrganisationSv "Universitet"                           
#> coordinatingOrganisationTypeOfOrganisationEn "University"                            
#> fundingOrganisationId                        "202100-5208"                           
#> fundingOrganisationNameSv                    "Vetenskapsrådet"                       
#> fundingOrganisationNameEn                    "Swedish Research Council"              
#> fundingOrganisationTypeOfOrganisationSv      "Stat, regioner, kommuner, församlingar"
#> fundingOrganisationTypeOfOrganisationEn      "Governmental"                          
#> fundingsSek                                  "25636000"                              
#> fundingYear                                  "2023"                                  
#> fundingStartDate                             "2023-01-01"                            
#> fundingEndDate                               "2026-12-31"                            
#> typeOfAwardId                                "5"                                     
#> typeOfAwardDescrSv                           "Forskningsinfrastruktur"               
#> typeOfAwardDescrEn                           "Research infrastructure"

# some people involved in this project
"2021-00157_VR" %>% swecris_project_people()
#> # A tibble: 1 × 7
#>   project_id    personId fullName       orcId               roleEn roleSv gender
#>   <chr>         <chr>    <chr>          <chr>               <chr>  <chr>  <chr> 
#> 1 2021-00157_VR 52223    Peter Hedström 0000-0003-1102-4342 Princ… Proje… Male

# SCB classification codes for this project
"2021-00157_VR" %>% swecris_project_scbs()
#> # A tibble: 2 × 10
#>   project…¹ scb5Id scb5N…² scb5N…³ scb3Id scb3N…⁴ scb3N…⁵ scb1Id scb1N…⁶ scb1N…⁷
#>   <chr>     <chr>  <chr>   <chr>   <chr>  <chr>   <chr>   <chr>  <chr>   <chr>  
#> 1 2021-001… 10399  Annan … Other … 103    Fysik   Physic… 1      Naturv… Natura…
#> 2 2021-001… 20599  Annan … Other … 205    Materi… Materi… 2      Teknik  Engine…
#> # … with abbreviated variable names ¹​project_id, ²​scb5NameSv, ³​scb5NameEn,
#> #   ⁴​scb3NameSv, ⁵​scb3NameEn, ⁶​scb1NameSv, ⁷​scb1NameEn
```

## Swedish, Danish, Finnish and Norwegian lists

**Goal**: Not part of the SweCRIS API, but mentioned on SweCRIS website.
Get data for some Nordic “lists”.

Swedish list (the first few records):

``` r
sl <- 
  swecris_list_swedish()
#> Rows: 36614 Columns: 12
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ";"
#> chr  (2): ISSN, Titel
#> dbl (10): 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

glimpse(sl %>% head(3) %>% collect())
#> Rows: 3
#> Columns: 12
#> $ ISSN   <chr> "8756-9728", "8756-7938", "8756-758X"
#> $ Titel  <chr> "Project Management Journal", "Biotechnology progress (Print)",…
#> $ `2012` <dbl> 1, NA, 1
#> $ `2013` <dbl> NA, 1, 1
#> $ `2014` <dbl> 1, 1, 1
#> $ `2015` <dbl> 1, NA, 1
#> $ `2016` <dbl> 1, 1, 1
#> $ `2017` <dbl> 1, 1, NA
#> $ `2018` <dbl> 1, NA, 1
#> $ `2019` <dbl> 1, 1, NA
#> $ `2020` <dbl> 1, 1, 1
#> $ `2021` <dbl> 1, 1, 1

knitr::kable(sl %>% head(3) %>% collect())
```

| ISSN      | Titel                                                            | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 |
|:----------|:-----------------------------------------------------------------|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
| 8756-9728 | Project Management Journal                                       |    1 |   NA |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |
| 8756-7938 | Biotechnology progress (Print)                                   |   NA |    1 |    1 |   NA |    1 |    1 |   NA |    1 |    1 |    1 |
| 8756-758X | Fatigue & Fracture of Engineering Materials & Structures (FFEMS) |    1 |    1 |    1 |    1 |    1 |   NA |    1 |   NA |    1 |    1 |

Some other Nordic list referenced at SweCRIS are also provided:

``` r
f <- swecris_list_finnish()
n <- swecris_list_norwegian

glimpze <- function(df) {
  df %>% slice(1:3) %>% knitr::kable()
}

glimpze(f)
```

| id_jufo | level | title                             | type            | issn_isbn      | issn | abbr | country            | DOAJ | sherpa_romeo | active   | level_2012 | level_2013 | level_2014 | level_2015 | level_2016 | level_2017 | level_2018 | level_2019 | level_2020 |
|--------:|------:|:----------------------------------|:----------------|:---------------|:-----|:-----|:-------------------|-----:|:-------------|:---------|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|
|   65510 |     1 | PROCEEDINGS OF THE PMR CONFERENCE | Lehti/sarja     | 0272-8710      | NA   | NA   | UNITED STATES      |   NA | NA           | Inactive |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |
|    8856 |     0 | ADVANCED BUILDING SKINS           | Kirjakustantaja | 978-3-9812053; | NA   | NA   | GERMANY            |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |          0 |          0 |          0 |          0 |
|   88598 |     0 | AESTHETICA UNIVERSALIS            | Lehti/sarja     | 2686-6943      | NA   | NA   | RUSSIAN FEDERATION |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |

``` r
glimpze(n)
```

| tidsskrift_id | title             | title_en          | issn_print | issn_online | Åpen tilgang | Publiseringsavtale | NPI fagområde | NPI fagfelt             | level_2023 | level_2022 | level_2021 | level_2020 | level_2019 | level_2018 | level_2017 | level_2016 | level_2015 | level_2014 | level_2013 | level_2012 | level_2011 | level_2010 | level_2009 | level_2008 | level_2007 | level_2006 | level_2005 | level_2004 | forlag_id | publisher_company | publisher                                                                      | publisher_country | language     | conference_report | Serie | established | discontinued | url                                                                      | Sist oppdatert      | set      | ISBN-prefiks | Land |
|--------------:|:------------------|:------------------|:-----------|:------------|:-------------|-------------------:|:--------------|:------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|----------:|:------------------|:-------------------------------------------------------------------------------|:------------------|:-------------|------------------:|------:|------------:|-------------:|:-------------------------------------------------------------------------|:--------------------|:---------|:-------------|:-----|
|        480486 | \# ISOJ Journal   | \# ISOJ Journal   | 2328-0700  | 2328-0662   | NA           |                  0 | Humaniora     | Medier og kommunikasjon |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | University of Texas at Austin, UT College of Commu                             | USA               | Engelsk      |                 0 |     0 |        2013 |           NA | <https://online.journalism.utexas.edu/ebook.php>                         | 2022-08-10 12:17:54 | journals | NA           | NA   |
|        469872 | (Pré)publications | (Pré)publications | NA         | 1604-5394   | NA           |                  0 | Humaniora     | Historie og Idéhistorie |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |        NA | NA                | Afdeling for Fransk Institut for Sprog Litteratur og Kultur Aarhus Universitet | Danmark           | Flerspråklig |                 0 |     0 |        2005 |           NA | <https://cc.au.dk/forskning/tidsskrifter/prepublications/>               | 2022-08-04 14:46:30 | journals | NA           | NA   |
|        485792 | @nalyses          | @nalyses          | NA         | 1715-9261   | NA           |                  0 | Humaniora     | Romansk                 |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | Université d’Ottawa. Département de français                                   | Canada            | Fransk       |                 0 |     0 |        2006 |           NA | <https://uottawa.scholarsportal.info/ojs/index.php/revue-analyses/index> | 2022-08-04 14:46:30 | journals | NA           | NA   |
