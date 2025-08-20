library(dplyr)
library(purrr)

url_den_base <- paste0(
  "https://ufm.dk/forskning-og-innovation/statistik-og-analyser",
  "/den-bibliometriske-forskningsindikator/BFI-lister/"
  )

url_den <- paste0(url_den_base, c(
  "bfi-listen-for-serier-2021.xlsx",
  "bfi-listen-for-forlag-2021.xlsx",
  "fjernede-kanaler-2021.xlsx",
  "tilfojede-kanaler-2021.xlsx"
))

sets <- c(
  "serier",
  "forlag",
  "fjerdene",
  "tilfojede"
)

#' @importFrom readxl read_xlsx
#' @importFrom utils download.file
read_xl <- function(url, set) {
  x <- url
  tf <- tempfile()
  on.exit(unlink(tf))
  y <- download.file(x, tf, quiet = TRUE)
  res <- readxl::read_xlsx(tf)
  res$set <- set
  res
}


cm_den <- readr::read_delim(delim = ",", show_col_types = FALSE,
"col_from,col_to
Faggruppenr.,group_nr
Faggruppenavn,group_name
BFI-nummer,bfi_nr
ISSN,issn
Kanal,channel
Titel,title
Niveau,level
BFI nr.,bfi_nr
ISBN,isbn
ISSN/ISBN,issn_isbn
Faggruppe,group
BFI-nr.,bfi_nr")

#' @importFrom stats na.omit
rename_cols <- function(df, from, to) {
  m <- match(from, names(df))
  names(df)[na.omit(m)] = to[!is.na(m)]
  df
}

rename_cols_re <- function(df, re_from, re_to) {
  if (missing(re_to))
    re_to <- "\\1"
  from <- grep(re_from, names(df), value = TRUE)
  to <- gsub(re_from, re_to, from)
  rename_cols(df, from, to)
}

#' Danish BFI lists
#'
#' @details see [details about available data](https://ufm.dk/forskning-og-innovation/statistik-og-analyser/den-bibliometriske-forskningsindikator/BFI-lister)
#' @return tibble with set column indicating type of list
#' (serier, forlag, fjerdene, tilfojede)
#' @export
#' @importFrom purrr map2 map map_df
#' @import dplyr
swecris_list_danish <- function() {
  .Defunct(msg = "The BFI-list are no longer updated, see https://www.ucnbib.dk/da/page/bfi")
  # purrr::map2(url_den, sets, read_xl)%>%
  #   purrr::map(function(x) rename_cols(x, cm_den$col_from, cm_den$col_to)) %>%
  #   purrr::map_df(function(x) bind_rows(x)) %>%
  #   select("set", everything())
}

cm_fin <- readr::read_delim(
  delim = ",", show_col_types = FALSE,
"col_from,col_to
Jufo_ID,id_jufo
TASO/LEVEL,level
NIMEKE/TITLE,title
TYYPPI/TYPE/,type
ISSN1/ISBN,issn_isbn
ISSN2,issn
Abbreviation,abbr
Country,country
SHERPA/ROMEO,sherpa_romeo
ACTIVE,active
")

#' Swedish List
#'
#' Swedish List of publication sources.
#'
#' @return a tibble
#' @details see [details about available data](https://www.vr.se/uppdrag/oppen-vetenskap/svenska-listan---sakkunniggranskade-kanaler-i-swepub.html)
#' and [web page](https://www.vr.se/english/mandates/open-science/svenska-listan---a-register-of-peer-reviewed-publication-channels-in-swepub.html)
#' @importFrom readr read_delim locale
#' @export
swecris_list_swedish <- function() {

  .Defunct(msg = "The Swedish List is no longer updated, see https://www.vr.se/aktuellt/nyheter/nyhetsarkiv/2025-03-13-svenska-listan-avvecklas.html")

#  "https://www.vr.se/download/18.32d3406a188bdc568be14ff2/1687784311607/svenska-listan-2023.csv" %>%
#    readr::read_delim(local = locale(encoding = "latin1"))

#  "https://www.vr.se/download/18.6675b4ac1787151b2105c0/1618484217763/Svenska_listan_2021_godk%C3%A4nt.csv" %>%
#    readr::read_delim(local = locale(encoding = "latin1"))
}

#' Finnish List
#'
#' Finnish List of publication sources.
#'
#' @return a tibble
#' @details see [details about available data](https://www.tsv.fi/julkaisufoorumi/haku.php?lang=en)
#' @importFrom readr read_delim locale
#' @export
swecris_list_finnish <- function() {

  .Defunct(msg = "The data from https://www.tsv.fi/julkaisufoorumi/haku.php?lang=en is no longer available")

  # if (.Platform$OS.type != "unix") {
  #   # temporarily set Windows curl requests to use "openssl" SSL backend
  #   # to work around issue with curl requests to older web servers
  #   # see https://github.com/KWB-R/kwb.pkgbuild/commit/983c2b02a630e7bd1c0cdf4b13a9880d2fe898ea#diff-1a8ed3fe2070a27e0bc9a1adc04acd1776eb71ea8397bc4cfdaa3faee0a1278e
  #   backend <- Sys.getenv("CURL_SSL_BACKEND")
  #   Sys.setenv(CURL_SSL_BACKEND = "openssl")
  #   on.exit(Sys.setenv(CURL_SSL_BACKEND = backend))
  # }

  # fin <- readr::read_delim(
  #   file = "https://www.tsv.fi/julkaisufoorumi/kokonaisluettelo.php",
  #   delim = ";", col_select = -21,
  #   show_col_types = FALSE, trim_ws = TRUE,
  #   local = locale(encoding = "latin1")
  # ) %>% suppressWarnings() %>%
  #   suppressMessages() %>%
  #   rename_cols(cm_fin$col_from, cm_fin$col_to)

  # fin %>%
  #   rename_cols_re("TASO (\\d{4})/LEVEL.*", "level_\\1") %>%
  #   rename_cols_re("[\\.]{3}(*)", "col_\\1")
}


nor_collections <- function() c("uhr_tidsskrift_cache", "uhr_forlag_cache")

#' @import httr2
#' @importFrom purrr map_dfr possibly
#' @importFrom tibble tibble enframe
#' @importFrom tidyr unnest_wider unnest
nor_kanalregister <- function(collection = nor_collections()) {
  # https://kanalregister.hkdir.no/

  coll <- match.arg(collection, choices = nor_collections(), several.ok = FALSE)

  url_nor_journals <- function(page = 1, cache = coll) {
      source <- match.arg(cache, several.ok = FALSE)
      sprintf(paste0(
        "https://5tv6sfnzrjemi3h2p.a1.typesense.net/collections/", 
        source,
        "/documents/search?q=&query_by=*&prefix=true&per_page=100&page=%s&filter_by="
      ), page)
  }
  
  req_nor_journal <- function(url) {
    url |> 
    request() |> 
    req_headers(`X-TYPESENSE-API-KEY` = "JSXXNWfHEQoEI1i4vhgoS8GPjgCRZ1tv") |> 
    req_perform() |> 
    resp_body_json()
  }
  
  parse_nor_journals <- function(res) {
    res$hits |> tibble::enframe() |> 
      tidyr::unnest_wider("value") |> 
      tidyr::unnest_wider("document")
  }
  
  req_page_one <- req_nor_journal(url_nor_journals())
  page_one <- parse_nor_journals(req_page_one)
  
  n_pages <- ceiling(req_page_one$out_of / req_page_one$request_params$per_page) 
  
  crawl_nor_journals <- function(urls) {
    pn <- possibly(function(url) url |> req_nor_journal() |> parse_nor_journals(), data.frame(0)) 
    urls |> purrr::map_dfr(pn, .progress = TRUE)
  }
  
  page_rest <- data.frame(0)

  if (n_pages > 1) {
    pages <- 2:n_pages
    page_rest <- url_nor_journals(pages) |> crawl_nor_journals()
  }
  
  bind_rows(page_one, page_rest)
  
}

#' Norwegian journals from https://kanalregister.hkdir.no/
#' @export
#' @return tibble with results from web API call
nor_journals <- function() {

  journals <- nor_kanalregister(collection = nor_collections()[1])

  lookup <- c(
    year = "aar", 
    name = "navn_en", 
    name_no = "navn", 
    oa_date_agreement = "oa_avtale_dato", 
    oa_date_doaj = "oa_doaj_dato",
    oa_date_romeo = "oa_romeo_dato",
    lang_id = "spraak_spraak_id",
    publisher_isbn = "forlagISBN",
    issne = "tidsskriftISSNE",
    issnp = "tidsskriftISSNP",
    level_id = "uhrNivaa_id",
    publisher = "utgiver",
    country_id = "land_id",
    oa_agreement = "oa_avtale",
    year_inactive = "nedlagt"
  )

  exclude <- c("name", "text_match_info", "highlight", "highlights", "text_match")

  res <- 
    journals |> 
    dplyr::select(-dplyr::any_of(exclude)) |> 
    dplyr::rename(dplyr::any_of(lookup)) |> 
    readr::type_convert(guess_integer = TRUE) |> 
    suppressMessages()

  res
} 

#' Norwegian publishers from https://kanalregister.hkdir.no/
#' @export
#' @return tibble with results from web API call
nor_publishers <- function() {

  publishers <- nor_kanalregister(collection = nor_collections()[2])

  lookup <- c(
    year = "aar", 
    name = "navn_en", 
    name_no = "navn", 
    isbn = "forlagISBN", 
    level_id = "uhrNivaa_id",
    country_id = "land_id",
    year_inactive = "nedlagt"
  )

  exclude <- c("name", "text_match_info", "highlight", "highlights", "text_match")

  res <- 
    publishers |> 
    dplyr::select(-dplyr::any_of(exclude)) |> 
    dplyr::rename(dplyr::any_of(lookup)) |> 
    readr::type_convert(guess_integer = TRUE) |> 
    suppressMessages()

  res

}

