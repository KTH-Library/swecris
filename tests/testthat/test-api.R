test_that("swecris orgs for KTH works", {

 so <- swecris_organisations()

 kthid <-
   so %>%
   filter(grepl("^KTH, ", organisationNameSv)) %>%
   dplyr::pull(organisationId)

  sp <- swecris_projects(orgid = kthid)

  is_valid <-
    nrow(sp) > 2500

  expect_true(is_valid)

})

test_that("retrieving projects data for KTH works", {

  so <- swecris_organisations()

  kthid <-
    so %>%
    filter(grepl("^KTH, ", organisationNameSv)) %>%
    dplyr::pull(organisationId)

  p1 <- swecris_projects(kthid)

  is_valid <- nrow(p1) > 2600

  expect_true(is_valid)
})

test_that("retrieving persons for KTH projects works", {

  so <- swecris_organisations()

  kthid <-
    so %>%
    filter(grepl("^KTH, ", organisationNameSv)) %>%
    dplyr::pull(organisationId) %>%
    purrr::pluck(1)

  kthp <- swecris_persons(kthid)
  is_valid <- nrow(kthp) > 500
  expect_true(is_valid)

})

test_that("Swedish list can be retrieved", {
  sl <- swecris_list_swedish()
  expect_true(nrow(sl) > 30000)
})

test_that("Danish list function is defunct (no longer provided)", {
  is_defunct <- tryCatch(swecris_list_danish(), error = function(e) e$old == "swecris_list_danish")
  expect_true(is_defunct)
})

test_that("Finnish list can be retrieved", {
  #skip_on_ci()
  fl <- swecris_list_finnish()
  is_valid <- nrow(fl) > 1e4
  expect_true(is_valid)
})

test_that("Norwegian list can be retrieved", {
  nl <- swecris_list_norwegian
  is_valid <- nrow(nl) > 1e4
  expect_true(is_valid)
})

test_that("Fundings for KTH project works", {
  kthf <- swecris_funding()
  is_valid <- nrow(kthf) > 2600
  expect_true(is_valid)
})

test_that("Projects data can be retrieved from an ORCiD", {
  o <- "0000-0003-1102-4342" |> swecris_projects_from_orcid()
  is_valid <- nrow(o$projects) > 10 & nrow(o$peopleList) > 100 & nrow(o$scbs) > 10
  expect_true(is_valid)
})

