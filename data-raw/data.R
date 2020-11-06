## code to prepare `swecris_kth` dataset goes here

swecris_kth <- swecris_search()
usethis::use_data(swecris_kth, overwrite = TRUE)
