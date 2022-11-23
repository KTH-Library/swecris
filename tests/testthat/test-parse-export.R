test_that("Parsing InvolvedPeople from SweCRIS export works", {
  skip_on_ci()
  export <- head(swecris_kth, 100)
  ip <- export$InvolvedPeople
  ppl <- purrr::map_dfr(ip, parse_involved_people, .id = "row")
  ppl$ProjectId <- swecris_kth[as.integer(ppl$row),]$ProjectId
  is_valid <- nrow(ppl) > 100 & all(names(ppl) ==
     c("row", "personId", "fullName", "orcId", "roleEn", "roleSv", "gender", "ProjectId"))
  expect_true(is_valid)
})

test_that("Parsing Scbs from SweCRIS export works", {
  skip_on_ci()
  export <- head(swecris_kth, 100)
  ip <- export$Scbs
  scb <- purrr::map_dfr(ip, parse_scb_codes, .id = "row")
  scb$ProjectId <- swecris_kth[as.integer(scb$row),]$ProjectId
  is_valid <- nrow(scb) > 100 & all(names(scb) ==
    c("row", "scb_code", "scb_sv_en", "ProjectId"))
  expect_true(is_valid)
})
