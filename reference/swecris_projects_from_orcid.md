# Projects data from ORCiD

Given an ORCiD, this function retrieves information about related
projects, about subject classification codes (a.k.a scbs) and about
involved people (peopleList)

## Usage

``` r
swecris_projects_from_orcid(orcid)
```

## Arguments

- orcid:

  A character string with a valid ORCiD

## Value

a list with three slots (projects, peopleList, scbs)

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 o <- "0000-0003-1102-4342" |> swecris_projects_from_orcid()
 o$projects
 o |> purrr::pluck("peopleList")
 o$scbs
 }
} # }
```
