test_that("search against betasearch api works", {

  kth_projects <-
    swecris_search()

  is_valid <-
    nrow(kth_projects$hits) > 2500 && nrow(kth_projects$tags) > 3000

  expect_true(is_valid)
  #project_ids <-
  #

})

test_that("retrieving data for a specific project works", {

  # kth_projects$hits %>%
  #   arrange(desc(as.numeric(total_funding))) %>%
  #   filter(grepl("bibliometri", abstract_sv)) %>%
  #   pull(`_id`) %>%
  #   paste(collapse = "\n") %>%
  #   cat

  project_ids <-
    trimws(readLines(con = textConnection(
      "2019-05221_Vinnova
      2014-04173_Vinnova
      2014-06082_Vinnova
      2018-02683_Vinnova
      2015-04315_Vinnova
      2015-06978_Vinnova")))

  p1 <- swecris_project(project_ids[1])

  is_valid <- p1$stats$totalHits >= 1

  expect_true(is_valid)
})

test_that("retrieving project leader data for a specific project works", {

  # kth_projects$hits %>%
  #   arrange(desc(as.numeric(total_funding))) %>%
  #   filter(grepl("bibliometri", abstract_sv)) %>%
  #   pull(`_id`) %>%
  #   paste(collapse = "\n") %>%
  #   cat

  project_ids <-
    trimws(readLines(con = textConnection(
      "2019-05221_Vinnova
      2014-04173_Vinnova
      2014-06082_Vinnova
      2018-02683_Vinnova
      2015-04315_Vinnova
      2015-06978_Vinnova")))

  p1 <- swecris_project_leaders(project_ids[1])

  is_valid <- p1$id == 28330

  expect_true(is_valid)
})
