library(readr)

## code to prepare `swecris_kth` dataset goes here

## update nov 2022
#‘kth’ vs. ‘swecris_kth’
#2022-11-23 09:28:46
#	Modified	Reordered	Deleted	Added
#Rows	3137 → 3068	2972	1527	69	0
#Columns	26	6	0	0	0

## update dec 2023
# "2023-11-27 12:09:18 CET"
#	Modified	Reordered	Deleted	Added
#Rows 	3204 → 1020 426 1 2655 471
#Columns 	26 → 28 15 0 0 2

swecris_kth <- swecris_funding("KTH")
swecris_kth <- swecris_kth |> replace_nulls() |> as_tibble()
View(swecris_kth)

usethis::use_data(swecris_kth, overwrite = TRUE)

# document in R/data.R, using this roxygen
sinew::makeOxygen(swecris_kth)
#cat(sprintf("#'   \\item{%s}{}\n", names(sf)))

#swecris_kth %>% View()

## code to prepare `swecris_list_norway` goes here

# Note that the Norwegian CSV download is made from 
# https://kanalregister.hkdir.no/informasjonsartikler/last-ned-gjeldande-liste
# and requires a login (using markussk@kth.se account) and files then placed in data-raw

cm_nor <- readr::read_delim(
  delim = ",", show_col_types = FALSE,
  "col_from,col_to
NSD tidsskrift_id,id_nsd
Original Title,title
Original tittel,title
International Title,title_en
Internasjonal tittel,title_en
tidsskrift_id,journal_id
Open Access,oa
Åpen tilgang,oa
Publiseringsavtale,publishing_agreement
Publishing Agreement,publishing_agreement
Print ISSN,issn_print
Online ISSN,issn_online
NPI Academic Discipline,group_area
NPI Fagområde,group_area
NPI fagområde,group_area
NPI Scientific Field,group_field
NPI Fagfelt,group_field
NPI fagfelt,group_field
NSD forlag_id,nsd_publisher_id
Forlag,publisher_company
forlag_id,publisher_id
Publishing Company,publisher_company
Publisher,publisher
Utgiver,publisher
Country of Publication,publisher_country
Utgiverland,publisher_country
Language,language
Språk,language
Conference Proceedings,conference_report
Konferanserapport,conference_report
Series,series
Serie,series
Established,established
Etablert,established
Ceased,discontinued
Nedlagt,discontinued
URL,url
Last Updated,last_updated
ISBN-Prefix,isbn_prefix
ISBN-prefiks,isbn_prefix
Country,country
Land,country
Sist oppdatert,last_updated
")

swecris_list_norwegian <- function(f) {

  ct <- readr::cols()

  nor <- 
    readr::read_delim(
      file = f,
      delim = ";",
      show_col_types = FALSE, trim_ws = TRUE
    ) |>
    rename_cols(cm_nor$col_from, cm_nor$col_to)

  probs <- readr::problems(nor)

  if (nrow(probs) > 0)
    print(probs)

  nor |> 
    rename_cols_re("Nivå (\\d{4})", "level_\\1") |> 
    rename_cols_re("Level (\\d{4})", "level_\\1") |> 
    rename_cols_re("[\\.]{3}(*)", "col_\\1") |> 
    mutate(across(c(
      starts_with("level"), ends_with("_id"), 
      any_of(c("conference_report", "series", "established", "discontinued"))
    ), \(x) as.integer(x)))  
  
}

slnj <- 
  "data-raw/norway_journals_2025.csv" |> swecris_list_norwegian()

#names(slnj)
#problems(slnj) |>  View()
#slnj[problems(slnj)$row,] |> View()

slnp <- 
  "data-raw/norway_publishers_2025.csv" |> 
  swecris_list_norwegian()

  #|>
#    mutate(level_2023 = case_match(level_2023, "X"))

#names(slnp)
#slnp <- swecris_list_norwegian(f = "data-raw/norway_publishers_2023.csv")
glimpse(slnp)
glimpse(slnj)
#slnj$level_2025 <- slnj$level_2025 |> readr::parse_integer(na = c("X"))
slnj$set <- "journals"
slnp$set <- "publishers"

sln <- bind_rows(slnj, slnp)
names(sln)
View(sln)

swecris_list_norwegian <- sln
usethis::use_data(swecris_list_norwegian, overwrite = TRUE)

# document "swecris_list_norwegian" in dataset in R/data.R
cat(sprintf("#'   \\item{%s}{}\n", names(sln)))

tools::resaveRdaFiles("data/swecris_kth.rda", compress="xz")
tools::resaveRdaFiles("data/swecris_list_norwegian.rda", compress="xz")
tools::checkRdaFiles("data/")
