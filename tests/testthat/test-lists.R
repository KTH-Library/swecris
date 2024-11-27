test_that("Swedish list can be retrieved", {
  sl <- swecris_list_swedish()
  expect_true(nrow(sl) > 30000)
})

test_that("Danish list function is defunct (no longer provided)", {
  is_defunct <- tryCatch(swecris_list_danish(), error = function(e) e$old == "swecris_list_danish")
  expect_true(is_defunct)
})

test_that("(Original) Finnish list is defunct (no longer provided)", {
  skip_on_ci()
  is_defunct <- tryCatch(swecris_list_finnish(), error = function(e) e$old == "swecris_list_finnish")
  expect_true(is_defunct)
})

test_that("Embedded Norwegian list can be retrieved", {
  nl <- swecris_list_norwegian
  is_valid <- nrow(nl) > 1e4
  expect_true(is_valid)
})

test_that("Norwegian list of publishers can be retrieved from API", {
  skip_on_ci()
  norp <- nor_publishers()
  is_valid <- nrow(norp) > 3000
  expect_true(is_valid)
})

test_that("Norwegian list of journals can be retrieved from API", {
  skip_on_ci()
  norj <- nor_journals()
  is_valid <- nrow(norj) > 30000
  expect_true(is_valid)
})
