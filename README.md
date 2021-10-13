
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
| 2021-02640\_Vinnova | GeneNova                                                                                                            | 2021-10-15       | 2026-10-14     | Vinnova                   |    36600000 | 2021        |
| 2021-03620\_Vinnova | Zero-emission contractors - a feasibility study for solutions in the road construction industry                     | 2021-10-01       | 2022-10-01     | Vinnova                   |      450000 | 2021        |
| 2021-03462\_Vinnova | International Activities for InfraSweden2030                                                                        | 2021-09-15       | 2022-09-15     | Vinnova                   |      800000 | 2021        |
| 2021-03464\_Vinnova | InfraAwards 2022                                                                                                    | 2021-09-15       | 2022-12-30     | Vinnova                   |     1150000 | 2021        |
| 2021-03465\_Vinnova | Communication to support implementation                                                                             | 2021-09-10       | 2022-07-31     | Vinnova                   |      450000 | 2021        |
| 2021-03466\_Vinnova | Client network for a climate-neutral construction sector                                                            | 2021-09-10       | 2023-05-26     | Vinnova                   |      800000 | 2021        |
| 2021-03467\_Vinnova | Innovation partnership - Connected road condition monitoring                                                        | 2021-09-10       | 2024-03-31     | Vinnova                   |     1500000 | 2021        |
| 2021-02048\_Vinnova | Supersonic spraying of graphene/MXene-based conductive wear-resistant coatings for electrification                  | 2021-08-31       | 2022-05-31     | Vinnova                   |      300000 | 2021        |
| 2021-01922\_Vinnova | Digitalisation of atomisation of metal powders                                                                      | 2021-08-16       | 2022-03-11     | Vinnova                   |      510217 | 2021        |

Swedish list for 2021 (the first few records):

``` r
sl <- 
  swecris_list_swedish()
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

Some other Nordic list referenced at SweCRIS are also provided:

``` r
f <- swecris_list_finnish()
#> New names:
#> * `` -> ...21
#> Warning: One or more parsing issues, see `problems()` for details
n <- swecris_list_norwegian
d <- swecris_list_danish()

glimpze <- function(df) {
  df %>% head() %>% knitr::kable()
}

glimpze(f)
```

| id\_jufo | level | title                                | type            | issn\_isbn     | issn      | abbr | country            | DOAJ | sherpa\_romeo | active   | level\_2012 | level\_2013 | level\_2014 | level\_2015 | level\_2016 | level\_2017 | level\_2018 | level\_2019 | level\_2020 | col\_21 |
|---------:|------:|:-------------------------------------|:----------------|:---------------|:----------|:-----|:-------------------|-----:|:--------------|:---------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|:--------|
|    65510 |     1 | PROCEEDINGS OF THE PMR CONFERENCE    | Lehti/sarja     | 0272-8710      | NA        | NA   | UNITED STATES      |   NA | NA            | Inactive |           1 |           1 |           1 |           1 |           1 |           1 |           1 |           1 |           1 | NA      |
|     8856 |     0 | ADVANCED BUILDING SKINS              | Kirjakustantaja | 978-3-9812053; | NA        | NA   | GERMANY            |   NA | NA            | Active   |          NA |          NA |          NA |          NA |          NA |           0 |           0 |           0 |           0 | NA      |
|    88598 |     0 | AESTHETICA UNIVERSALIS               | Lehti/sarja     | 2686-6943      | NA        | NA   | RUSSIAN FEDERATION |   NA | NA            | Active   |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA | NA      |
|    89424 |     0 | ANNALS OF DISASTER RISK SCIENCES     | Lehti/sarja     | 2584-4873      | 2623-8934 | NA   | CROATIA            |   NA | NA            | Active   |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA | NA      |
|    86812 |     1 | BRITISH JOURNAL OF VISUAL IMPAIRMENT | Lehti/sarja     | 0264-6196      | 1744-5809 | NA   | UNITED KINGDOM     |   NA | NA            | Active   |          NA |          NA |          NA |          NA |          NA |          NA |           1 |           1 |           1 | NA      |
|    89386 |     1 | COMPOSITES PART C : OPEN ACCESS      | Lehti/sarja     | NA             | 2666-6820 | NA   | NETHERLANDS        |   NA | NA            | Active   |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA | NA      |

``` r
glimpze(n)
```

| id\_nsd | title                                                                   | title\_en                                                                                                      | issn\_print | issn\_online | oa   | group\_area       | group\_field            | level\_2022 | level\_2021 | level\_2020 | level\_2019 | level\_2018 | level\_2017 | level\_2016 | level\_2015 | level\_2014 | level\_2013 | level\_2012 | level\_2011 | level\_2010 | level\_2009 | level\_2008 | level\_2007 | level\_2006 | level\_2005 | level\_2004 | itar\_id | nsd\_publisher\_id | publisher\_company | publisher                                          | publisher\_country | language       | conference\_report | established | discontinued | url                                                                                | set      | ISBN-Prefix | Land |
|--------:|:------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|:------------|:-------------|:-----|:------------------|:------------------------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|---------:|-------------------:|:-------------------|:---------------------------------------------------|:-------------------|:---------------|-------------------:|------------:|-------------:|:-----------------------------------------------------------------------------------|:---------|:------------|:-----|
|  480486 | \# ISOJ Journal                                                         | \# ISOJ Journal                                                                                                | 2328-0700   | 2328-0662    | NA   | Humaniora         | Medier og kommunikasjon |          NA |           1 |           1 |           1 |           1 |           1 |           1 |           1 |           1 |           1 |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |  1023339 |                 NA | NA                 | University of Texas at Austin, UT College of Commu | USA                | Engelsk        |                  0 |        2013 |           NA | <https://online.journalism.utexas.edu/ebook.php>                                   | journals | NA          | NA   |
|  485792 | @nalyses                                                                | @nalyses                                                                                                       | NA          | 1715-9261    | NA   | Humaniora         | Romansk                 |          NA |           1 |           1 |           1 |           1 |           1 |           1 |           1 |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |  1025308 |                 NA | NA                 | Université d’Ottawa. Département de français       | Canada             | Fransk         |                  0 |        2006 |           NA | <https://uottawa.scholarsportal.info/ojs/index.php/revue-analyses/index>           | journals | NA          | NA   |
|  492970 | @ulaMEdieval                                                            | @ulaMEdieval                                                                                                   | NA          | 2340-3748    | NA   | Humaniora         | Litteraturvitenskap     |          NA |           0 |           0 |           0 |           0 |           0 |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |  1029093 |                 NA | NA                 | University of Valencia, Spain (Parnaseo Project)   | Spania             | Spansk         |                  0 |        2013 |           NA | <http://parnaseo2.uv.es/AulaMedieval/AulaMedieval.php?valor=monografias&lengua=es> | journals | NA          | NA   |
|  499037 | \[in\]Transition                                                        | \[in\]Transition                                                                                               | NA          | 2469-4312    | NA   | Humaniora         | Medier og kommunikasjon |          NA |           1 |           1 |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |  1031783 |                 NA | NA                 | MediaCommons                                       | USA                | Engelsk        |                  0 |        2014 |           NA | <http://mediacommons.org/intransition/>                                            | journals | NA          | NA   |
|  475372 | \[tilt\]                                                                | \[tilt\]                                                                                                       | 1502-2471   | 1892-3100    | NA   | Samfunnsvitenskap | Pedagogikk og utdanning |          NA |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |           0 |          NA |          NA |          NA |          NA |          NA |  1018144 |                 NA | NA                 | Landslaget for Medieundervisning                   | Norge              | Norsk (bokmål) |                  0 |        1986 |           NA | <http://www.lmu.no/default.asp?uid=65&CID=65>                                      | journals | NA          | NA   |
|  487206 | Anuarul Institutului de Cercetări Socio-Umane „C.S. Nicolăescu-Plopșor” | “C.S. Nicolăescu-Plopşor” Institute for Research in Social Studies and Humanities Yearbook (CSNIPSSH Yearbook) | 1841-0898   | 2501-0468    | DOAJ | Humaniora         | Historie                |          NA |           1 |           1 |           1 |           1 |           1 |           0 |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |          NA |  1026615 |                 NA | NA                 | Editura Academiei Române                           | Romania            | Engelsk        |                  0 |        1999 |           NA | <https://npissh.ro/>                                                               | journals | NA          | NA   |

``` r
glimpze(d)
```

| set    | group\_nr | group\_name                              | bfi\_nr | issn      | channel    | title                               | level | isbn | issn\_isbn | group |
|:-------|----------:|:-----------------------------------------|--------:|:----------|:-----------|:------------------------------------|------:|:-----|:-----------|------:|
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |    7659 | 0003-0678 | Tidsskrift | American Quarterly                  |     2 | NA   | NA         |    NA |
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |   82971 | 1433-5239 | Tidsskrift | American Studies Journal            |     2 | NA   | NA         |    NA |
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |    4878 | 1478-8810 | Tidsskrift | Atlantic Studies                    |     2 | NA   | NA         |    NA |
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |    4703 | 0067-2378 | Tidsskrift | Austrian History Yearbook           |     2 | NA   | NA         |    NA |
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |   12997 | 0261-3050 | Tidsskrift | Bulletin of Latin American Research |     2 | NA   | NA         |    NA |
| serier |         1 | Områdestudier: Europa, Amerika, Oceanien |   14142 | 1537-7873 | Tidsskrift | Cultural Analysis                   |     2 | NA   | NA         |    NA |
