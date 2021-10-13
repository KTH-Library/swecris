library(readr)

## code to prepare `swecris_kth` dataset goes here

swecris_kth <- swecris_funding()
usethis::use_data(swecris_kth, overwrite = TRUE)

# document in R/data.R, using this roxygen
cat(sprintf("#'   \\item{%s}{}\n", names(sf)))

#swecris_kth %>% View()

## code to prepare `swecris_list_norway` goes here

cm_nor <- readr::read_delim(
  delim = ",", show_col_types = FALSE,
  "col_from,col_to
NSD tidsskrift_id,id_nsd
Original tittel,title
Internasjonal tittel,title_en
Open Access,oa
Print ISSN,issn_print
Online ISSN,issn_online
NPI Fagområde,group_area
NPI Fagfelt,group_field
NSD forlag_id,nsd_publisher_id
Forlag,publisher_company
Utgiver,publisher
Utgiverland,publisher_country
Språk,language
Konferanserapport,conference_report
Etablert,established
Nedlagt,discontinued
URL,url
")

swecris_list_norwegian <- function(f) {
  nor <- readr::read_delim(
    file = f,
    delim = ";",
    show_col_types = FALSE, trim_ws = TRUE
  ) %>%
    rename_cols(cm_nor$col_from, cm_nor$col_to)

  nor %>%
    rename_cols_re("Nivå (\\d{4})", "level_\\1") %>%
    rename_cols_re("[\\.]{3}(*)", "col_\\1")

}

slnj <- swecris_list_norwegian(f = "data-raw/norway_journals.csv")
slnp <- swecris_list_norwegian(f = "data-raw/norway_publishers.csv")

slnj$set <- "journals"
slnp$set <- "publishers"

sln <- bind_rows(slnj, slnp)
names(sln)
View(sln)

swecris_list_norwegian <- sln
usethis::use_data(swecris_list_norwegian, overwrite = TRUE)

# document "swecris_list_norwegian" in dataset in R/data.R
cat(sprintf("#'   \\item{%s}{}\n", names(sln)))


