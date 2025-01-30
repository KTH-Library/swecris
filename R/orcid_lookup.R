orcid_lookup_one <- function(orcid) {

  query <- list(
    q = paste0("orcid:", orcid), 
    start = 0, 
    rows = 50
  )

  resp <- 
    "https://pub.orcid.org/v3.0/expanded-search/" |> 
    httr2::request() |> 
    httr2::req_url_query(!!!query) |> 
    httr2::req_headers("Accept" = "application/json") |> 
    httr2::req_perform()

  resp |> httr2::resp_body_json() |> parse_orcid()
}

parse_orcid <- function(o) {

  person <- 
    try(
      o$`expanded-result` |> tibble::enframe() |> 
      tidyr::unnest_wider(col = 2) |> 
      rename(
        orcId = "orcid-id", 
        firstName = "given-names", 
        lastName = "family-names",
        creditName = "credit-name", 
        otherName = "other-name", 
        institution = "institution-name",
        result = "name"
      )
    )
  
  if (inherits(person, "try-error")) {
    warning(paste0(o, "  - lookup failed"))
    return (list(person = data.frame(0), institutions = data.frame(0)))
  }
  
  institutions <- 
    person |> 
    tidyr::unnest_longer(col = any_of(c("institution")))

  list(
    person = person |> select(-any_of(c("institution", "result"))), 
    institutions = institutions |> select(any_of(c("orcId", "institution")))
  )
}

#' Lookup ORCiD
#' 
#' @param orcid the orcid identifier as a string
#' @returns a list of tibbles with information from the lookup
#' @export

orcid_lookup <- function(orcid) {

  ole <- purrr::possibly(orcid_lookup_one, quiet = FALSE)

  orcids <- unique(orcid)

  res <- orcids |> purrr::map(ole, .progress = TRUE) 

  out <- list(
    person = res |> purrr::map_dfr("person", c),
    institutions = res |> purrr::map_dfr("institutions", c)
  )

  aliases <- out$person |> 
    tidyr::unnest_longer(col = any_of("otherName")) |> 
    select(-any_of(c("email")))

  emails <- out$person |> 
    tidyr::unnest_longer(col = any_of("email")) |> 
    select(-any_of(c("otherName")))

  out$emails <- emails 
  out$aliases <- aliases 
  out$person <- out$person |> select(-any_of(c("otherName", "email")))

  return(out)

}

#' Lookup orcid(s)
#' @param orcid character vector of orcid
#' @return list of two tibbles with names and associated institutions

lookup_orcid <- function(orcid) {
  orcid_lookup(na.omit(orcid))
}

