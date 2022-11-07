library(bibliotools)
library(swecris)
library(kthapi)
library(dplyr)

# kthid, unit, username, orcid
ug <- kthapi::ug_orcid_kthid_unit()
lookup <- ug$kthid_with_unit

# CASE data
caze <- bibliotools::case()

# any external identifiers we can use?
caze$`Project ID`
caze %>% filter(!is.na(`Project Number`)) %>% select(`Project Number`)

# 1. can we use ProjectID in swecris to match? CASE har Project Number.
# 2. can we use Name to match? "Projekttitel". Kompletterat med andra fält såsom beg, end?
# 3. could we match by ORCiD to catch the "residual"?

# Q1. går det att "komplettera" med Grant Amount från Swecris? I vilken utsträckning?

# could we use ORCiD? It is used in SweCRIS
caze2 <-
  caze %>%
  left_join(lookup, by = c("username" = "ugUsername")) %>%
  # removes 242 missing - out of 1571
  filter(!is.na(ugOrcid))

# 1300 projects with an associated orcid for primary researcher
caze2

# what do we already have?
swecris::swecris_kth %>% View()

# can we match by ORCiD?
# we need a function to lookup projects from SweCRIS from ORCiD
swecris_projects_from_orcid <- function(orcid) {

  route <-
    sprintf(
      paste0("https://swecris-api.vr.se",
      "/v%s/projects/persons/orcId/%s")
      , 1, URLencode(orcid)
    )

  res <- swecris:::swecris_get(route)

  fields <- c(
    "projectId",
    "projectTitleSv",
    "projectTitleEn",
    "projectAbstractSv",
    "projectAbstractEn",
    "projectStartDate",
    "projectEndDate",
    "coordinatingOrganisationId",
    "coordinatingOrganisationNameSv",
    "coordinatingOrganisationNameEn",
    "coordinatingOrganisationTypeOfOrganisationSv",
    "coordinatingOrganisationTypeOfOrganisationEn",
    "fundingOrganisationId",
    "fundingOrganisationNameSv",
    "fundingOrganisationNameEn",
    "fundingOrganisationTypeOfOrganisationSv",
    "fundingOrganisationTypeOfOrganisationEn",
    "fundingsSek",
    "fundingYear",
    "fundingStartDate",
    "fundingEndDate",
    "typeOfAwardId",
    "typeOfAwardDescrSv",
    "typeOfAwardDescrEn")

  projects <-
    res %>%
    purrr::map_df(.f = function(x) x[fields] %>% as_tibble())

  peopleList <-
    res %>%
    purrr::map_df(.f = purrr::pluck(c("peopleList")))

  scbs <-
    res %>%
    purrr::map_df(.f = purrr::pluck(c("peopleList")))

  list(projects = projects, peopleList = peopleList, scbs = scbs)

}

# if we pick one ORCiD from a CASE-project, what does SweCRIS provide?
caze2$ugOrcid[1] %>%
  swecris_projects_from_orcid()

