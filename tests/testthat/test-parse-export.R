test_that("Parsing InvolvedPeople from SweCRIS export works", {
  skip_on_ci()
  export <- head(swecris_kth, 100)
  ip <- export$involvedPeople
  ppl <- purrr::map_dfr(ip, parse_involved_people, .id = "row")
  ppl$projectId <- swecris_kth[as.integer(ppl$row),]$projectId
  is_valid <- nrow(ppl) > 100 & all(names(ppl) ==
     c("row", "personId", "fullName", "orcId", "roleEn", "roleSv", "gender", "projectId"))
  expect_true(is_valid)
})

test_that("Parsing Scbs from SweCRIS export works", {
  skip_on_ci()
  export <- head(swecris_kth, 100)
  ip <- export$scbs
  scb <- purrr::map_dfr(ip, parse_scb_codes, .id = "row")
  scb$projectId <- swecris_kth[as.integer(scb$row),]$projectId
  is_valid <- nrow(scb) > 100 & all(names(scb) ==
    c("row", "scb_code", "scb_sv_en", "projectId"))
  expect_true(is_valid)
})
