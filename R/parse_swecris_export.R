#' Parse "InvolvedPeople" field from a SweCRIS export
#'
#' InvolvedPeople is a field where strings are provided like \code{¤¤¤Peter Hedstroem¤0000-0003-1102-4342¤Principal Investigator¤Projektledare¤Male}
#'
#' These strings encode a dataset equivalent to what a call using \code{swecris_project_people("2021-00157_VR")}
#' would provide.
#'
#' Instead of making multiple API request calls to resolve, a utility fcn for parsing is provided.
#' @param x the InvolvedPeople string
#' @importFrom readr read_delim problems
#' @export
#' @encoding UTF-8
#' @examples
#' \dontrun{
#' if(interactive()){
#'  ip <- swecris_kth$InvolvedPeople
#'  ppl <- purrr::map_dfr(ip, parse_involved_people, .id = "row")
#'  ppl$ProjectId <- swecris_kth[as.integer(ppl$row),]$ProjectId
#'  }
#' }
parse_involved_people <- function(x) {

  if (is.na(x)) return(data.frame())

  fields <- c("personId", "fullName", "orcId", "roleEn", "roleSv", "gender")
  suns <- "\u00a4\u00a4\u00a4"  # from stringi::stri_escape_unicode() %>% cat()
  sun <- "\u00a4"
  tbl <-
    strsplit(x, suns) %>% unlist() %>% trimws() %>%
    paste0(collapse = "\n") %>%  paste0("\n") %>%
    readr::read_delim(
      show_col_types = F,
      delim = sun,
      col_names = fields
    )

  if (!all(names(tbl) == fields)) {
    warning("Issues parsing data in string: ", x)
    return (data.frame())
  }

  return (tbl)
}

#' Parse "Scbs" field from a SweCRIS export
#'
#' Scbs is a field where strings are provided like \code{¤¤¤ 1: Naturvetenskap, Natural Sciences, 103: Fysik, Physical Sciences, 10399: Annan fysik, Other Physics Topics ¤¤¤ 2: Teknik, Engineering and Technology, 205: Materialteknik, Materials Engineering, 20599: Annan materialteknik, Other Materials Engineering}
#'
#' These strings encode a dataset roughly equivalent to what a call using \code{swecris_project_scbs("2021-00157_VR")}
#' would provide
#'
#' Instead of making multiple API request calls to resolve, a utility fcn for parsing is provided.
#' @param x the Scbs string
#' @importFrom readr read_delim problems
#' @export
#' @encoding UTF-8
#' @examples
#' \dontrun{
#' if(interactive()){
#'  x <- swecris_kth$Scbs
#'  scb <- purrr::map_dfr(x, parse_scb_codes, .id = "row")
#'  scb$ProjectId <- swecris_kth[as.integer(scb$row),]$ProjectId
#'  }
#' }
parse_scb_codes <- function(x) {

  if (is.na(x)) return(data.frame())

  fields <- c("scb_code", "scb_sv_en")
  suns <- "\u00a4\u00a4\u00a4"  # from stringi::stri_escape_unicode() %>% cat()
  rowbreak <- function(x) gsub(", (\\d+)", "\n\\1", x)

  tbl <-
    strsplit(x, suns) %>% unlist() %>% trimws() %>%
    paste0(collapse = "\n") %>%  paste0("\n") %>% trimws() %>%
    rowbreak() %>%
#    gsub(": ", ", ", .) %>%
    readr::read_delim(
      show_col_types = F,
      delim = ": ",
      col_names = fields,
      trim_ws = T
    )

  if (nrow(readr::problems(tbl)) > 0) {
    warning("Issues parsing data in string: ", x)
    warning(readr::problems(tbl))
    return (data.frame())
  }

  return (tbl)
}
