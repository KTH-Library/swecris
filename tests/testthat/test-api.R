test_that("swecris orgs for KTH works", {

 so <- swecris_organisations()

 kthid <-
   so  |>
   filter(grepl("^KTH, ", organisationNameSv)) |>
   dplyr::pull(organisationId)

  sp <- swecris_projects(orgid = kthid)

  is_valid <-
    nrow(sp) > 2500

  expect_true(is_valid)

})

test_that("retrieving projects data for KTH works", {

  so <- swecris_organisations()

  kthid <-
    so |>
    filter(grepl("^KTH, ", organisationNameSv)) |>
    dplyr::pull(organisationId)

  p1 <- swecris_projects(kthid)

  is_valid <- nrow(p1) > 2600

  expect_true(is_valid)
})

test_that("retrieving persons for KTH projects works", {

  so <- swecris_organisations()

  kthid <-
    so |>
    filter(grepl("^KTH, ", organisationNameSv)) |>
    dplyr::pull(organisationId) |>
    purrr::pluck(1)

  kthp <- swecris_persons(kthid)
  is_valid <- nrow(kthp) > 300
  expect_true(is_valid)

})


test_that("Fundings for KTH project works", {
  kthf <- swecris_funding()
  is_valid <- nrow(kthf) > 800
  expect_true(is_valid)
})

test_that("Projects data can be retrieved from an ORCiD", {
  o <- "0000-0003-1102-4342" |> swecris_projects_from_orcid()
  is_valid <- nrow(o$projects) > 10 & nrow(o$peopleList) > 40 & nrow(o$scbs) > 10
  expect_true(is_valid)
})

test_that("A single project can be retrieved from a project identifier", {
  res <- "2021-00157_VR" |> swecris_project()
  is_valid <- ncol(res) == 26
  expect_true(is_valid)
})

test_that("A single project can be retrieved from a project identifier containing a slash", {
  id <- "107/08_SNSB"
  res <- swecris_project(id)
  is_valid <- ncol(res) == 26
  expect_true(is_valid)
})

test_that("Two date fields (loadedDate and updatedDate) are included", {
  id <- "107/08_SNSB"
  res <- swecris_project(id)
  has_fields <- all(c("loadedDate", "updatedDate") %in% names(res))
  is_valid <- ncol(res) == 26 && has_fields
  expect_true(is_valid)
})

test_that("A single project's associated people can be retrieved from a project identifier", {
  res <- "2021-00157_VR" |> swecris_project_people()
  is_valid <- ncol(res) > 4 & nrow(res) >= 1
  expect_true(is_valid)
})

test_that("A single project's associated SCB codes can be retrieved from a project identifier", {
  res <- "2021-00157_VR" |> swecris_project_scbs()
  is_valid <- ncol(res) > 2 & nrow(res) > 1
  expect_true(is_valid)
})

test_that("Another single project can be retrieved from a project identifier", {
  res <- "2024-04925_VR" |> swecris_project()
  is_valid <- ncol(res) == 26
  expect_true(is_valid)
})

# test_that("Coordinating Organisation Name Multiplettes by orgids", {
#
#   scf <- swecris_fundings()
#
#   multiplettes <-
#     scf |> group_by(coordinatingOrganisationNameEn) |>
#     summarize(n = n_distinct(coordinatingOrganisationId)) |>
#     arrange(desc(n)) |>
#     filter(n > 1, !is.na(coordinatingOrganisationNameEn)) |>
#     ungroup() |>
#     inner_join(scf, by = "coordinatingOrganisationNameEn") |>
#     group_by(coordinatingOrganisationId) |>
#     distinct(coordinatingOrganisationId, n, coordinatingOrganisationNameEn, coordinatingOrganisationNameSv)
#
#   is_valid <- nrow(multiplettes) < 1
#   expect_true(is_valid)
# })

