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
    dplyr::pull(organisationId)

  kthp <- swecris_persons(kthid)
  is_valid <- nrow(kthp) > 1000
  expect_true(is_valid)

})

test_that("Swedish list can be retrieved", {
  sl <- swecris_list_swedish()
  expect_true(nrow(sl) > 30000)
})

test_that("Fundings for KTH project works", {
  kthf <- swecris_funding()
  is_valid <- nrow(kthf) > 2600
  expect_true(is_valid)
})
