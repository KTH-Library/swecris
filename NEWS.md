# swecris 0.1.9

* Allow to fetch all projects and people easier (wo requiring orgid)

# swecris 0.1.8

* Fix to improve parsing of date formats
* Refresh of embedded swecris_kth data
* Deprecation of older fcns for Finnish and Norwegian lists
* New fcns for retrieving Norwegian lists for publishers and journals


# swecris 0.1.7

* Fix to improve parsing of varying date formats
* Use |> instead of %>%
* Updated field names for embedded swecris_kth data
* Embedded data is now compressed with .xz

# swecris 0.1.6

* Added support for new fields (updatedDate, loadedDate) returned for projects
* Updated norwegian list (Nov 27, 2023) and embedded data for norwegian list
* Updated swedish list url and embedded data for swecris_kth fundings

# swecris 0.1.5

* Updated norwegian list (Aug 7, 2023)

# swecris 0.1.4

* Added functions for parsing SweCRIS export fields for InvolvedPeople and Scbs
* Added updated swecris_kth data which corrects some earlier outdated fields

# swecris 0.1.3

* Added functions for searching, getting data for specific project and related persons and SCB codes
* Refactored functions that used the older "betasearch" API to use new API routes
* Updated Finnish list to work better when used on Windows OS
* Added function for getting projects data given an ORCiD

# swecris 0.1.2

* Removed Danish list (no longer updated at source)
* Updated Swedish and Norwegian list source
* Updated embedded data for projects at KTH

# swecris 0.1.1

* Added support for Swedish, Norwegian, Finnish and Danish lists with authoritative publication sources


# swecris 0.1

* Added basic support for some routes in the API described at https://swecris-api.vr.se/index.html

# swecris 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
