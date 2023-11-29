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

  res <-
    httr::GET("https://swecris-api.vr.se/v1/scp/export", query = list(
      `organizationType[]`= "Universitet",
      sortOrder = "desc",
      sortColumn = "FundingStartDate",
      searchText = URLencode(searchstring, reserved = TRUE),
      token = token)
    ) |>
    httr::content(as = "text", encoding = "UTF-8") |>
    readr::read_delim(delim = ";", quote = '"', show_col_types = FALSE)

  setNames(res, first_to_lower(names(res)))

}

#' @importFrom httr add_headers GET stop_for_status content
swecris_get <- function(route, token = swecris_token()) {
  res <- httr::GET(route, httr::add_headers(Authorization = paste("Bearer", token)))
  httr::stop_for_status(res)
  httr::content(res)
}

swecris_token <- function() #"RWNDZ3FDRVVSMmNUNlZkMkN3"
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
    swecris_get("https://swecris-api.vr.se/v1/organisations") |>
    replace_nulls()

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))

}

swecris_organisations_for_project <- function(project_id) {

  route <- sprintf(
    "https://swecris-api.vr.se/v1/organisations/projects/%s",
    project_id
  )

  data <-
    swecris_get(route) |>
    replace_nulls()

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)
  dplyr::as_tibble(bind_rows(dfs))

}

#' Fundings
#'
#' Fundings in SweCRIS, more than 211k records of fundings for projects
#'
#' @return a tibble
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom dplyr as_tibble bind_rows
#' @export
swecris_fundings <- function() {

  message("Please be patient, this request may take a couple of minutes to process...")

  data <-
    swecris_get("https://swecris-api.vr.se/v1/fundings") |>
    replace_nulls()

  dfs <- lapply(data, data.frame, stringsAsFactors = FALSE)

  dplyr::as_tibble(bind_rows(dfs)) |>
    parse_swecris_dates()

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

first_to_lower <- function(text) {
  sub("(\\w)(\\w*)", "\\L\\1\\E\\2", text, perl=TRUE)
}

#' @importFrom lubridate parse_date_time
#' @noRd
parse_swecris_dates <- function(x) {
  x |>
    mutate(across(
      any_of(c("loadedDate", "updatedDate")),
      \(x) lubridate::parse_date_time(x, "bdY HM")
    )) |>
    mutate(across(
      any_of(c("projectStartDate", "projectEndDate")),
      \(x) lubridate::parse_date_time(x, "Ymd HMS")
    )) |>
    mutate(across(
      any_of(c("fundingStartDate", "fundingEndDate")),
      \(x) lubridate::parse_date_time(x, c("Ymd", "Y"))
    )) |>
    mutate(across(
      any_of(c("fundingYear")),
      \(x) as.integer(x)
    ))
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
    swecris_get(route) |>
    replace_nulls()

  tidyr::tibble(data) |>
    tidyr::unnest_wider(data) |> View()
    parse_swecris_dates()
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
    swecris_get(route) |>
    replace_nulls()

  tidyr::tibble(data)  |>
    tidyr::unnest_wider(data)

}

swecris_person <- function(personid) {

  route <- sprintf(
    "https://swecris-api.vr.se/v1/persons/%s",
    personid
  )

  data <-
    swecris_get(route) |>
    replace_nulls()

  data |> as.data.frame() |> tidyr::as_tibble()

}

#' Projects data from ORCiD
#'
#' Given an ORCiD, this function retrieves information about related projects,
#'   about subject classification codes (a.k.a scbs) and about
#'   involved people (peopleList)
#' @param orcid A character string with a valid ORCiD
#' @return a list with three slots (projects, peopleList, scbs)
#' @examples
#' \dontrun{
#' if(interactive()){
#'  o <- "0000-0003-1102-4342" |> swecris_projects_from_orcid()
#'  o$projects
#'  o |> purrr::pluck("peopleList")
#'  o$scbs
#'  }
#' }
#' @export
#' @importFrom purrr map_df pluck
#' @importFrom tidyr unnest_wider
#' @importFrom dplyr tibble bind_cols distinct
swecris_projects_from_orcid <- function(orcid) {

  route <-
    sprintf(
      paste0("https://swecris-api.vr.se",
      "/v%s/projects/persons/orcId/%s")
      , 1, URLencode(orcid)
    )

  res <- swecris_get(route)

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
    "typeOfAwardDescrEn",
    "loadedDate",
    "updatedDate")

  projects <-
    res |>
    purrr::map_df(.f = function(x) x[fields] |> replace_nulls() |> as_tibble()) |>
    parse_swecris_dates()
#    purrr::map_df(.f = function(x) x[!names(x) %in% c("scbs", "peopleList")] |> as_tibble())

  accessor <- function(x, sibling_node, id_node = "projectId")
    tibble(sibling_node = pluck(x, sibling_node)) |>
    unnest_wider(col = sibling_node) |>
    bind_cols(id = pluck(x, id_node)) |>
    select(id, everything()) |>
    distinct()

  scbs <-
    res |> map_df(function(x) accessor(x, "scbs"))

  peopleList <-
    res |>
    purrr::map_df(function(x) accessor(x, "peopleList"))

  list(projects = projects, peopleList = peopleList, scbs = scbs)

}

#' Search the SweCRIS  API for an organization
#'
#' Performs a search and exports results as an R object
#'
#' @param orgs string to search for, Default: "KTH, Kungliga Tekniska Högskolan"
#' @return an R object with the search result in the form of a data frame
#' @details see [details about available data](https://swecris-api.vr.se/index.html)
#' @importFrom httr stop_for_status GET content
#' @importFrom utils URLencode
#' @importFrom readr read_delim
#' @export
swecris_search <- function(orgs = "KTH, Kungliga tekniska h\u00f6gskolan") {

  w1 <- sprintf(paste0(
    "https://swecris-api.vr.se/v1/scp/export",
    "?sortOrder=desc&sortColumn=FundingStartDate&searchText=%s&token=%s"),
    URLencode(orgs, reserved = TRUE), swecris_token())

  res <- httr::GET(w1)

  httr::stop_for_status(res)

  httr::content(httr::GET(w1), as = "raw") |>
    readr::read_delim(delim = ";", show_col_types = FALSE)
}


#' Retrieve details about a project
#'
#' Given the project identifier, retrieve details about a project.
#'
#' @param project_id string identifier for the project
#' @param format one of "object" or "tbl"
#' @return R object or tbl with results
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @export
swecris_project <- function(project_id, format = c("tbl", "object")) {

  route <- sprintf(
    "https://swecris-api.vr.se/v1/projects/%s",
    URLencode(project_id, reserved = TRUE)
  )

  res <- swecris_get(route)

  if (match.arg(format) == "object") return (res)

  # fields <- c(
  #   "projectId",
  #   "projectTitleSv",
  #   "projectTitleEn",
  #   "projectAbstractSv",
  #   "projectAbstractEn",
  #   "projectStartDate",
  #   "projectEndDate",
  #   "coordinatingOrganisationId",
  #   "coordinatingOrganisationNameSv",
  #   "coordinatingOrganisationNameEn",
  #   "coordinatingOrganisationTypeOfOrganisationSv",
  #   "coordinatingOrganisationTypeOfOrganisationEn",
  #   "fundingOrganisationId",
  #   "fundingOrganisationNameSv",
  #   "fundingOrganisationNameEn",
  #   "fundingOrganisationTypeOfOrganisationSv",
  #   "fundingOrganisationTypeOfOrganisationEn",
  #   "fundingsSek",
  #   "fundingYear",
  #   "fundingStartDate",
  #   "fundingEndDate",
  #   "typeOfAwardId",
  #   "typeOfAwardDescrSv",
  #   "typeOfAwardDescrEn")

  res[!names(res) %in% c("scbs", "peopleList")] |>
    replace_nulls() |> as_tibble() |>
    parse_swecris_dates()

}

#' Retrieve project people data
#'
#' Given the project identifier, retrieve details about a people involved with
#' a project.
#'
#' @param project_id string identifier for project
#' @return R data frame with results
#' @examples
#' \dontrun{
#' if(interactive()){
#'  "2021-00157_VR" |> swecris_project_people()
#'  }
#' }
#' @importFrom dplyr as_tibble bind_cols everything
#' @importFrom purrr pluck
#' @export
swecris_project_people <- function(project_id) {

  project <- swecris_project(project_id, format = "object")

  project |>
    pluck("peopleList") |>
    purrr::map_df(as.data.frame) |>
    dplyr::as_tibble() |>
    bind_cols(project_id = project_id) |>
    select(project_id, everything())

}

#' Retrieve project SCB codes data
#'
#' Given the project identifier, retrieve details about subject matter codes.
#'
#' @param project_id string identifier for project
#' @return R data frame with results
#' @examples
#' \dontrun{
#' if(interactive()){
#'  "2021-00157_VR" |> swecris_project_scbs()
#'  }
#' }
#' @importFrom dplyr as_tibble bind_cols everything
#' @importFrom purrr pluck
#' @export
swecris_project_scbs <- function(project_id) {

  project <- swecris_project(project_id, format = "object")

  project |>
    pluck("scbs") |>
    purrr::map_df(as.data.frame) |>
    dplyr::as_tibble() |>
    bind_cols(project_id = project_id) |>
    select(project_id, everything())

}

