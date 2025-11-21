# Retrieve project SCB codes data

Given the project identifier, retrieve details about subject matter
codes.

## Usage

``` r
swecris_project_scbs(project_id)
```

## Arguments

- project_id:

  string identifier for project

## Value

R data frame with results

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 "2021-00157_VR" |> swecris_project_scbs()
 }
} # }
```
