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
caze$`Project Number`

caze %>% filter(!is.na(`Project Number`)) %>% select(`Project Number`)

# 1. Can we use ProjectID in Swecris to match? CASE has `Project Number`.

swecris::swecris_kth$ProjectId %>%
  gsub(pattern = ".*?_(.*?)$", replacement = "\\1") %>%
  unique() %>%
  paste(collapse = "|")

# We could strip off the last section of the identifier, one of these
#[1] "VR"      "Vinnova" "Formas"  "Forte"   "RJ"      "Energi"  "SNSB"

swec <-
  swecris::swecris_kth$ProjectId %>%
  gsub(pattern = "(.*?)_(VR|Vinnova|Formas|Forte|RJ|Energi|SNSB)$", replacement = "\\1")

caz <-
  caze$`Project Number` %>%
  grep(pattern = "(\\d{4,}[-|/]\\d{1,})", value = TRUE)

# we can get some exact matches
intersect(swec, caz)

# some partial
Reduce('+', lapply(caz, grepl, x = swec)) %>% sum()
Reduce('+', lapply(swec, grepl, x = caz)) %>% sum()

# 2. can we use Project Title/Name to match?

caz <-
  caze$Name %>%
  tolower() %>% substr(1, 20) %>% unique() %>% janitor::make_clean_names()

# swedish or english titles?
swec <-
  swecris::swecris_kth$ProjectTitleSv %>%
  tolower() %>% substr(1, 20) %>% unique() %>% janitor::make_clean_names()

Reduce('+', lapply(caz, grepl, x = swec)) %>% sum()
Reduce('+', lapply(swec, grepl, x = caz)) %>% sum()

# 3. could we match by ORCiD to catch the "residual"?

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

# if we pick one ORCiD from a CASE-project, what does SweCRIS provide?
caze2$ugOrcid[1] %>%
  swecris_projects_from_orcid()

# Q1. Once matched, can we add/compare Grant Amount from Swecris? Begin/End dates?


