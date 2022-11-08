library(httr)

orgid <- swecris_organisations() %>% filter(grepl("^KTH", organisationNameSv)) %>% pull(organisationId) %>% pluck(1)
swecris_persons(orgid)

# oops - compacted firstName, lastName, fullName string values
GET("https://swecris-api.vr.se/v1/persons/organisations/202100-3054",
    add_headers(Authorization = paste("Bearer", swecris_token()))) |>
  content(as = "raw") |> rawToChar() |> jsonlite::prettify()

# {
#     "personId": 37091,
#     "firstName": "MarilineEricKarin",
#     "lastName": "SilvaKnaussSunde Persson",
#     "fullName": "MarilineEricKarin SilvaKnaussSunde Persson",
#     "organisations": null,
#     "relatedProjectIds": "2012-04304_Vinnova;2013-00888_Vinnova;2022-01624_Vinnova",
#     "orcId": null
# }

# curl "https://swecris-api.vr.se/v1/persons/organisations/202100-3054"
#    -H "Accept: application/json"
#    -H "Authorization: Bearer {token}"
