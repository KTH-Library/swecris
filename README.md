
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
#> $ ProjectId                                    <chr> "2020-05052_VR"
#> $ ProjectTitleSv                               <chr> "Terrorism i svensk polit…
#> $ ProjectTitleEn                               <chr> "Terrorism in Swedish pol…
#> $ ProjectAbstractSv                            <chr> NA
#> $ ProjectAbstractEn                            <chr> "SweTerror makes a signif…
#> $ ProjectStartDate                             <dttm> 2021-01-01
#> $ ProjectEndDate                               <dttm> 2024-12-31
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
#> $ FundingsSek                                  <dbl> 2.2e+07
#> $ FundingYear                                  <dbl> 2021
#> $ FundingStartDate                             <date> 2021-01-01
#> $ FundingEndDate                               <date> 2024-12-31
#> $ TypeOfAwardId                                <dbl> 1
#> $ TypeOfAwardDescrSv                           <chr> "Projektbidrag"
#> $ TypeOfAwardDescrEn                           <chr> "Project grant"
#> $ InvolvedPeople                               <chr> "¤¤¤17617¤Magnus Ängsal¤…
#> $ Scbs                                         <chr> "¤¤¤ 1: Naturvetenskap, N…
#> $ total_funding                                <dbl> 2.2e+07
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

| projectId          | projectTitleEn                                                                                                         | projectStartDate    | projectEndDate      | fundingOrganisationNameEn | fundingsSek | fundingYear |
|:-------------------|:-----------------------------------------------------------------------------------------------------------------------|:--------------------|:--------------------|:--------------------------|------------:|:------------|
| 2021-00157_VR      | Petra III Swedish Node                                                                                                 | 2023-01-01 00:00:00 | 2026-12-31 00:00:00 | Swedish Research Council  |    25636000 | 2023        |
| 2022-01624_Vinnova | Nanoscale organization and dynamics of ER-mitochondria contact sites upon induction of synaptic plasticity             | 2023-02-01 00:00:00 | 2025-01-31 00:00:00 | Vinnova                   |     2068800 | 2023        |
| 2021-00527_Formas  | A bio-based composite material for enhancing the sustainability in road infrastructures                                | 2022-01-01 00:00:00 | 2025-12-31 00:00:00 | Formas                    |     4000000 | 2022        |
| 2021-00678_Formas  | Catalytic Conversion of Waste to Value                                                                                 | 2022-01-01 00:00:00 | 2025-12-31 00:00:00 | Formas                    |     4000000 | 2022        |
| 2021-00728_Formas  | Turning shortcomings of lignin to advantages for green anti-corrosion and anti-wear coatings                           | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Formas                    |     3000000 | 2022        |
| 2021-00730_Formas  | Recyclable cellulose thermosets with sunlight triggered self-destruction in open natural environments                  | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Formas                    |     3000000 | 2022        |
| 2021-01532_Formas  | DATASETS: exploring DynAmic environmental TAxation for a Sustainable, Efficient urban Transport System                 | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Formas                    |     2933001 | 2022        |
| 2021-01561_Formas  | Environmental Impact of underwater noise from leisure boats - quantifying impact and estimating efficiency of measures | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Formas                    |     2997791 | 2022        |
| 2021-01595_VR      | Utopia 2.0: “Nature-Thinking” in the Nordic New Towns of the Past, Present, and Future                                 | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Swedish Research Council  |     4491000 | 2022        |
| 2021-01666_Formas  | Mechanisms controlling the self-assembly of keratin macromolecules and nanofibrils during fibre spinning               | 2022-01-01 00:00:00 | 2024-12-31 00:00:00 | Formas                    |     3000000 | 2022        |

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
|--------:|------:|:----------------------------------|:----------------|:---------------|:----------|:-----|:-------------------|-----:|:-------------|:---------|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|-----------:|
|   65510 |     1 | PROCEEDINGS OF THE PMR CONFERENCE | Lehti/sarja     | 0272-8710      | NA        | NA   | UNITED STATES      |   NA | NA           | Inactive |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |          1 |
|    8856 |     0 | ADVANCED BUILDING SKINS           | Kirjakustantaja | 978-3-9812053; | NA        | NA   | GERMANY            |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |          0 |          0 |          0 |          0 |
|   88598 |     0 | AESTHETICA UNIVERSALIS            | Lehti/sarja     | 2686-6943      | NA        | NA   | RUSSIAN FEDERATION |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
|   89424 |     0 | ANNALS OF DISASTER RISK SCIENCES  | Lehti/sarja     | 2584-4873      | 2623-8934 | NA   | CROATIA            |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
|   89386 |     1 | COMPOSITES PART C : OPEN ACCESS   | Lehti/sarja     | NA             | 2666-6820 | NA   | NETHERLANDS        |   NA | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |         NA |
|   87002 |     1 | ESTUDOS LINGUISTICOS              | Lehti/sarja     | 1413-0939      | NA        | NA   | BRAZIL             |    1 | NA           | Active   |         NA |         NA |         NA |         NA |         NA |         NA |         NA |          1 |          1 |

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
