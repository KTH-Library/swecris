#' Search the SweCRIS  API for an organization
#'
#' Performs a search for organizatinons and exports
#' results as an R object
#'
#' @param orgs string to search for, Default: "KTH, Kungliga Tekniska Högskolan"
#' @return an R object with the search result
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @import httr tidyjson
#' @importFrom utils URLencode
#' @export
swecris_search <- function(orgs = "KTH, Kungliga tekniska h\u00f6gskolan") {

  w1 <-
    sprintf(paste0("https://www.swecris.se/betasearch/search/export",
                   "?q=*&view=rows&coordinating_organizations_sv=%s&lang=sv"), URLencode(orgs))

  cw1 <-
    content(httr::GET(w1))
  #jsonlite::fromJSON(w1, simplifyDataFrame = TRUE, flatten = TRUE)

  #a <- map(cw1$documentList$documents, function(x) enframe(unlist(x))) %>% map(pivot_wider)
  #cw1$documentList$documents %>% dplyr::as_tibble()

  j <- cw1$documentList$documents

  res <-
    j %>% spread_all(sep = "_") %>% as_tibble()

  # tags is an array here
  #j %>% gather_object %>% json_types %>% count(name, type)
  #j %>% enter_object(organizations) -> boho

  tags <-
    j %>%
    enter_object(tags) %>%
    gather_array %>%
    spread_all %>%
    as_tibble()

  list(
    hits = res,
    tags = tags
  )

  # could funding and coordinating orgs be retrieved like so?
  #boho$..JSON %>% map(function(x) unnest(unnest(as_tibble(x)))) %>% map_df(bind_rows)
  #str(boho)

}


#' Retrieve details about a project
#'
#' Given the project identifier, retrieve details about a project.
#'
#' @param project_id string identifier for the project
#' @return R object with results
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @export
swecris_project <- function(project_id) {

  url <-
    sprintf(paste0("https://www.swecris.se/betasearch/search/export",
                   "?q=identifier_clean:(%s)"), URLencode(project_id))

  jsonlite::fromJSON(url)

}

#' Retrieve project leader data
#'
#' Given the project identifier, retrieve details about a project leaders
#' for a project.
#'
#' @param project_id string identifier for project
#' @return R object with results
#' @importFrom dplyr as_tibble
#' @importFrom purrr pluck
#' @export
swecris_project_leaders <- function(project_id) {

  project <- swecris_project(project_id)

  project$documentList$documents %>%
    pluck("people", "project_leaders", 1) %>%
    as_tibble()

}
