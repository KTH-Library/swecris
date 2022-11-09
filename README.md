
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
#> $ InvolvedPeople                               <chr> "¤¤¤32027¤Joakim Lundebe…
#> $ Scbs                                         <chr> "¤¤¤ 1: Naturvetenskap, N…
#> $ total_funding                                <dbl> 49450000
```

Given an organisation, get information about projects:

``` r

orgid <- 
  swecris_organisations() %>%
  filter(grepl("^KTH, ", organisationNameSv)) %>%
  dplyr::pull(organisationId) %>%
  purrr::pluck(1)

kthp <- swecris_projects(orgid)

# three upcoming projects
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
  head(3)

knitr::kable(projects)
```

| projectId          | projectTitleEn                                                                                             | projectStartDate    | projectEndDate      | fundingOrganisationNameEn | fundingsSek | fundingYear |
|:-------------------|:-----------------------------------------------------------------------------------------------------------|:--------------------|:--------------------|:--------------------------|------------:|:------------|
| 2021-00157_VR      | Petra III Swedish Node                                                                                     | 2023-01-01 00:00:00 | 2026-12-31 00:00:00 | Swedish Research Council  |    25636000 | 2023        |
| 2022-01624_Vinnova | Nanoscale organization and dynamics of ER-mitochondria contact sites upon induction of synaptic plasticity | 2023-02-01 00:00:00 | 2025-01-31 00:00:00 | Vinnova                   |     2068800 | 2023        |
| 2022-02413_Vinnova | Eureka SMART Dynamic SALSA                                                                                 | 2023-04-01 00:00:00 | 2026-03-31 00:00:00 | Vinnova                   |     4100000 | 2023        |

Given a project, get more information:

``` r

# some details for a specific project
swecris_project("2021-00157_VR") |> select(-c("projectAbstractEn")) |> t()
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
swecris_project_people("2021-00157_VR")
#> # A tibble: 4 × 7
#>   project_id    personId fullName       orcId               roleEn roleSv gender
#>   <chr>         <chr>    <chr>          <chr>               <chr>  <chr>  <chr> 
#> 1 2021-00157_VR 11820    Peter Hedström ""                  Princ… Proje… Male  
#> 2 2021-00157_VR 21322    Peter Hedström "0000-0003-1102-43… Princ… Proje… Male  
#> 3 2021-00157_VR 13505    Peter Hedström ""                  Princ… Proje… Female
#> 4 2021-00157_VR 12329    Peter Hedström ""                  Princ… Proje… Male

# SCB classification codes for this project
swecris_project_scbs("2021-00157_VR")
#> # A tibble: 2 × 10
#>   project…¹ scb5Id scb5N…² scb5N…³ scb3Id scb3N…⁴ scb3N…⁵ scb1Id scb1N…⁶ scb1N…⁷
#>   <chr>     <chr>  <chr>   <chr>   <chr>  <chr>   <chr>   <chr>  <chr>   <chr>  
#> 1 2021-001… 10399  Annan … Other … 103    Fysik   Physic… 1      Naturv… Natura…
#> 2 2021-001… 20599  Annan … Other … 205    Materi… Materi… 2      Teknik  Engine…
#> # … with abbreviated variable names ¹​project_id, ²​scb5NameSv, ³​scb5NameEn,
#> #   ⁴​scb3NameSv, ⁵​scb3NameEn, ⁶​scb1NameSv, ⁷​scb1NameEn
```

## Swedish, Danish, Finnish and Norwegian lists

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

glimpse(sl %>% head() %>% collect())
#> Rows: 6
#> Columns: 12
#> $ ISSN   <chr> "8756-9728", "8756-7938", "8756-758X", "8756-6583", "8756-6575"…
#> $ Titel  <chr> "Project Management Journal", "Biotechnology progress (Print)",…
#> $ `2012` <dbl> 1, NA, 1, 1, 1, 1
#> $ `2013` <dbl> NA, 1, 1, 1, NA, NA
#> $ `2014` <dbl> 1, 1, 1, 1, NA, NA
#> $ `2015` <dbl> 1, NA, 1, 1, NA, NA
#> $ `2016` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2017` <dbl> 1, 1, NA, 1, 1, NA
#> $ `2018` <dbl> 1, NA, 1, NA, NA, NA
#> $ `2019` <dbl> 1, 1, NA, NA, 1, 1
#> $ `2020` <dbl> 1, 1, 1, NA, NA, NA
#> $ `2021` <dbl> 1, 1, 1, NA, NA, NA

knitr::kable(sl %>% head() %>% collect())
```

| ISSN      | Titel                                                            | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 |
|:----------|:-----------------------------------------------------------------|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
| 8756-9728 | Project Management Journal                                       |    1 |   NA |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |
| 8756-7938 | Biotechnology progress (Print)                                   |   NA |    1 |    1 |   NA |    1 |    1 |   NA |    1 |    1 |    1 |
| 8756-758X | Fatigue & Fracture of Engineering Materials & Structures (FFEMS) |    1 |    1 |    1 |    1 |    1 |   NA |    1 |   NA |    1 |    1 |
| 8756-6583 | Holocaust and Genocide Studies                                   |    1 |    1 |    1 |    1 |   NA |    1 |   NA |   NA |   NA |   NA |
| 8756-6575 | PHILOSOPHY OF EDUCATION                                          |    1 |   NA |   NA |   NA |   NA |    1 |   NA |    1 |   NA |   NA |
| 8756-6222 | Journal of Law, Economics & Organization                         |    1 |   NA |   NA |   NA |   NA |   NA |   NA |    1 |   NA |   NA |

Some other Nordic list referenced at SweCRIS are also provided:

``` r
f <- swecris_list_finnish()
n <- swecris_list_norwegian

glimpze <- function(df) {
  df %>% head() %>% knitr::kable()
}

glimpze(f)
```

| id_jufo | level | title                             | type            | issn_isbn      | issn      | abbr | country            | DOAJ | sherpa_romeo | active   | level_2012 | level_2013 | level_2014 | level_2015 | level_2016 | level_2017 | level_2018 | level_2019 | level_2020 |
|:--------|:------|:----------------------------------|:----------------|:---------------|:----------|:-----|:-------------------|:-----|:-------------|:---------|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|
| 65510   | 1     | PROCEEDINGS OF THE PMR CONFERENCE | Lehti/sarja     | 0272-8710      | NA        | NA   | UNITED STATES      | NA   | NA           | Inactive |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |
| 8856    | 0     | ADVANCED BUILDING SKINS           | Kirjakustantaja | 978-3-9812053; | NA        | NA   | GERMANY            | NA   | NA           | Active   |         NA |         NA |         NA |         NA |         NA |          0 |          0 |          0 |          0 |
| 88598   | 0     | AESTHETICA UNIVERSALIS            | Lehti/sarja     | 2686-6943      | NA        | NA   | RUSSIAN FEDERATION | NA   | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
| 89424   | 0     | ANNALS OF DISASTER RISK SCIENCES  | Lehti/sarja     | 2584-4873      | 2623-8934 | NA   | CROATIA            | NA   | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
| 89386   | 1     | COMPOSITES PART C : OPEN ACCESS   | Lehti/sarja     | NA             | 2666-6820 | NA   | NETHERLANDS        | 1    | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
| 87002   | 1     | ESTUDOS LINGUISTICOS              | Lehti/sarja     | 1413-0939      | NA        | NA   | BRAZIL             | 1    | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |          1 |          1 |

``` r
glimpze(n)
```

| tidsskrift_id | title             | title_en          | issn_print | issn_online | Åpen tilgang | Publiseringsavtale | NPI fagområde     | NPI fagfelt             | level_2023 | level_2022 | level_2021 | level_2020 | level_2019 | level_2018 | level_2017 | level_2016 | level_2015 | level_2014 | level_2013 | level_2012 | level_2011 | level_2010 | level_2009 | level_2008 | level_2007 | level_2006 | level_2005 | level_2004 | forlag_id | publisher_company | publisher                                                                      | publisher_country | language       | conference_report | Serie | established | discontinued | url                                                                                | Sist oppdatert      | set      | ISBN-prefiks | Land |
|--------------:|:------------------|:------------------|:-----------|:------------|:-------------|-------------------:|:------------------|:------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|----------:|:------------------|:-------------------------------------------------------------------------------|:------------------|:---------------|------------------:|------:|------------:|-------------:|:-----------------------------------------------------------------------------------|:--------------------|:---------|:-------------|:-----|
|        480486 | \# ISOJ Journal   | \# ISOJ Journal   | 2328-0700  | 2328-0662   | NA           |                  0 | Humaniora         | Medier og kommunikasjon |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | University of Texas at Austin, UT College of Commu                             | USA               | Engelsk        |                 0 |     0 |        2013 |           NA | <https://online.journalism.utexas.edu/ebook.php>                                   | 2022-08-10 12:17:54 | journals | NA           | NA   |
|        469872 | (Pré)publications | (Pré)publications | NA         | 1604-5394   | NA           |                  0 | Humaniora         | Historie og Idéhistorie |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |        NA | NA                | Afdeling for Fransk Institut for Sprog Litteratur og Kultur Aarhus Universitet | Danmark           | Flerspråklig   |                 0 |     0 |        2005 |           NA | <https://cc.au.dk/forskning/tidsskrifter/prepublications/>                         | 2022-08-04 14:46:30 | journals | NA           | NA   |
|        485792 | @nalyses          | @nalyses          | NA         | 1715-9261   | NA           |                  0 | Humaniora         | Romansk                 |         NA |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | Université d’Ottawa. Département de français                                   | Canada            | Fransk         |                 0 |     0 |        2006 |           NA | <https://uottawa.scholarsportal.info/ojs/index.php/revue-analyses/index>           | 2022-08-04 14:46:30 | journals | NA           | NA   |
|        492970 | @ulaMEdieval      | @ulaMEdieval      | NA         | 2340-3748   | NA           |                  0 | Humaniora         | Litteraturvitenskap     |         NA |          0 |          0 |          0 |          0 |          0 |          0 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | University of Valencia, Spain (Parnaseo Project)                               | Spania            | Spansk         |                 0 |     0 |        2013 |           NA | <http://parnaseo2.uv.es/AulaMedieval/AulaMedieval.php?valor=monografias&lengua=es> | 2022-08-04 14:46:30 | journals | NA           | NA   |
|        499037 | \[in\]Transition  | \[in\]Transition  | NA         | 2469-4312   | NA           |                  0 | Humaniora         | Medier og kommunikasjon |         NA |          1 |          1 |          1 |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |        NA | NA                | MediaCommons                                                                   | USA               | Engelsk        |                 0 |     0 |        2014 |           NA | <http://mediacommons.org/intransition/>                                            | 2022-08-10 12:46:11 | journals | NA           | NA   |
|        475372 | \[tilt\]          | \[tilt\]          | 1502-2471  | 1892-3100   | NA           |                  0 | Samfunnsvitenskap | Pedagogikk og utdanning |         NA |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |          0 |         NA |         NA |         NA |         NA |         NA |        NA | NA                | Landslaget for Medieundervisning                                               | Norge             | Norsk (bokmål) |                 0 |     0 |        1986 |           NA | <http://www.lmu.no/default.asp?uid=65&CID=65>                                      | 2022-08-04 14:46:30 | journals | NA           | NA   |
