library(rvest)
library(httr)
library(dplyr)

src_formas <-
  "http://proj.formas.se/default.asp?funk=as&forvaltare_s=KTH" %>%
  read_html()

cases <-
  src_formas %>%
  html_nodes("table.tabelltext") %>%
  html_nodes(css = "tr td a[href*=visaarende]") %>%
  html_attr("href") %>%
  grep(x = ., pattern = "\\d+", value = TRUE) %>%
  gsub("javascript:visaarende.(\\d+).", "\\1", .) %>%
  as.numeric()

txt <-
  "http://proj.formas.se/detail.asp?arendeid=10777" %>%
  read_html() %>%
  html_text()

parse_formas <- function(id) {

  txt <-
    sprintf("http://proj.formas.se/detail.asp?arendeid=%s", id) %>%
    read_html() %>%
    html_text()

positions <- readLines(con = textConnection(
"Ämnesområde:
Beslutsdat:
Namn:
Titel:
Kön:
E-post:
Univ./Institution:
Projekttitel (sv):
Projekttitel (eng):
Värdhögskola:
SCB-klassificering:
Beviljat (SEK):
Beskrivning:"
))

  re_escape <- function(x)
    x %>%
    gsub("(", "[(]", x = ., fixed = TRUE) %>%
    gsub(")", "[)]", x = ., fixed = TRUE) %>%
    gsub(".", "\\.", x = ., fixed = TRUE)

  re_snips <- re_escape(positions)


  res <-
    tibble(from = re_snips, to = c(re_snips[-1], "$")) %>%
    mutate(re = sprintf("%s\\s*(.*?)\\s*%s", from, to)) %>%
    pull(re)

  parse_formas_details <- function(txt, re)
    txt %>% gsub("\r\n", "", .) %>% stringr::str_match(re) %>% .[ ,2]

  entry <-
    purrr::map(res, function(x) parse_formas_details(txt, x)) %>%
    setNames(., positions) %>%
    as_tibble()

  entry$title <-
    txt %>% stringr::str_extract("Formas projektdatabas - (.*)")

  entry$dnr <-
    txt %>% stringr::str_extract("Detaljerad information för (.*)")

  fieldnames <- c(
    "topic", "decision_date", "applicant_name", "applicant_title",
    "applicant_gender", "applicant_email", "applicant_institution",
    "project_title_sv", "project_title_en", "host_org", "scb_code",
    "granted_sum", "description", "title", "dnr")

  entry %>% setNames(., fieldnames)

}

# takes about half a minute
tictoc::tic()
kth_grants <-
  cases %>% purrr::map_df(parse_formas)
tictoc::toc()

out <-
  kth_grants %>%
  mutate(case_id = cases) %>%
  arrange(desc(decision_date))

# upload to minio
readr::write_csv(out, "/tmp/formas_kth.csv")
system("mc cp /tmp/formas_kth.csv kthb/bibliometrics")
#unlink("/tmp/formas_kth.csv")
