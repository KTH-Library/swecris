## code to prepare `swecris_kth` dataset goes here

swecris_kth <- swecris_funding()
usethis::use_data(swecris_kth, overwrite = TRUE)

# document in R/data.R, using this roxygen
cat(sprintf("#'   \\item{%s}{}\n", names(sf)))

#swecris_kth %>% View()
