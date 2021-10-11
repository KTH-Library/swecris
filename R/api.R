#' Search the SweCRIS  API for funding data
#'
#' Performs a search for funding and exports
#' results as an R object
#'
#' @param searchstring string to search for, Default is the search string for KTH
#' @param token token to be used for authentication
#' @return an R object with the search result
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom readr read_delim
#' @importFrom utils URLencode
#' @importFrom httr GET content
#' @export
swecris_funding <- function(searchstring = "KTH, Kungliga Tekniska H\u00f6gskolan",
                            token) {

  if (missing(token))
    token <- "RWNDZ3FDRVVSMmNUNlZkMkN3"

  httr::GET("https://swecris-api.vr.se/v1/scp/export", query = list(
    `organizationType[]`= "Universitet",
    sortOrder = "desc",
    sortColumn = "FundingStartDate",
    searchText = URLencode(searchstring),
    token = token)
  ) %>%
    httr::content(as = "text") %>%
    readr::read_delim(delim = ";", quote = '"')
}

swecris_get <- function(route, token = swecris_token()) {
  res <- httr::GET(route, add_headers(Authorization = paste("Bearer", token)))
  stop_for_status(res)
  httr::content(res)
}

swecris_token <- function()
  "u5pau934k45SJ8a497a6325j"

#' Funders
#'
#' Funders in as a tibble
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_funders <- function() {

  data <-
    swecris_get("https://swecris-api.vr.se/v1/scp/funders")

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))
}

#' SCB lookup table
#'
#' SCB 5-letter codes lookup table
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_scb <- function() {

  data <-
    swecris_get("https://swecris-api.vr.se/v1/scp/scbs")
  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))
}

#' SCB lookup table
#'
#' SCB 5-letter codes lookup table
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_orgtypes <- function() {
  data <-
    swecris_get("https://swecris-api.vr.se/v1/scp/organisationtypes")
  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))

}

simple_rapply <- function(x, fn) {
  if (is.list(x))
    lapply(x, simple_rapply, fn)
  else
    fn(x)
}

replace_nulls <- function(l)
  simple_rapply(l, function(x) if (is.null(x)) NA else x)

remove_slot <- function(l, slot)
  simple_rapply(l, function(x) if (is.list(x) && names(x) == slot) {x <- NULL} else x)

#remove_slot(data, "scbs")

#' Organizations
#'
#' Organizations in SweCRIS
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_organisations <- function() {

  data <-
    swecris_get("https://swecris-api.vr.se/v1/organisations") %>%
    replace_nulls()

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))

}

#' Fundings
#'
#' Fundings in SweCRIS, more than 190k records of fundings for projects
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_fundings <- function() {

  data <-
    swecris_get("https://swecris-api.vr.se/v1/fundings") %>%
    replace_nulls()

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))

}


stripname <- function(x, name) {
  thisdepth <- depth(x)
  if (thisdepth == 0) {
    return (x)
  } else if (length(nameIndex <- which(names(x) == name))) {
    x <- x[-nameIndex]
  }
  return(lapply(x, stripname, name))
}

depth <- function(this, thisdepth = 0) {
  if (!is.list(this)) {
    return (thisdepth)
  } else {
    return (max(unlist(lapply(this, depth, thisdepth = thisdepth + 1))))
  }
}

#' Projects
#'
#' Projects in SweCRIS
#'
#'L
#' @param orgid orgid to filter for
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom tidyr unnest_wider tibble
#' @export
swecris_projects <- function(orgid) {

  route <- sprintf(
    "https://swecris-api.vr.se/v1/projects/organisations/%s",
    orgid
  )

  data <-
    swecris_get(route) %>%
    replace_nulls()

  tidyr::tibble(data)  %>%
    tidyr::unnest_wider(data)
}

#' Persons
#'
#' Persons in SweCRIS
#'
#' @param orgid orgid to filter for
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom tidyr tibble unnest_wider
#' @export
swecris_persons <- function(orgid) {

  route <- sprintf(
    "https://swecris-api.vr.se/v1/persons/organisations/%s",
    orgid
  )

  data <-
    swecris_get(route) %>%
    replace_nulls()


  tidyr::tibble(data)  %>%
    tidyr::unnest_wider(data)

}

#' Swedish List
#'
#' Swedish List of publications.
#'
#' @return a tibble
#' @details see [details about available data](https://www.vr.se/uppdrag/oppen-vetenskap/svenska-listan---sakkunniggranskade-kanaler-i-swepub.html)
#' @importFrom readr read_delim locale
#' @export
swecris_swedish_list <- function() {
  "https://www.vr.se/download/18.6675b4ac1787151b2105c0/1618484217763/Svenska_listan_2021_godk%C3%A4nt.csv" %>%
    readr::read_delim(local = locale(encoding = "latin1"))
}
