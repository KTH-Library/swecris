# Parse "Scbs" field from a SweCRIS export

Scbs is a field where strings are provided like
`¤¤¤ 1: Naturvetenskap, Natural Sciences, 103: Fysik, Physical Sciences, 10399: Annan fysik, Other Physics Topics ¤¤¤ 2: Teknik, Engineering and Technology, 205: Materialteknik, Materials Engineering, 20599: Annan materialteknik, Other Materials Engineering`

## Usage

``` r
parse_scb_codes(x)
```

## Arguments

- x:

  the Scbs string

## Details

These strings encode a dataset roughly equivalent to what a call using
`swecris_project_scbs("2021-00157_VR")` would provide

Instead of making multiple API request calls to resolve, a utility fcn
for parsing is provided.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 x <- swecris_kth$Scbs
 scb <- purrr::map_dfr(x, parse_scb_codes, .id = "row")
 scb$ProjectId <- swecris_kth[as.integer(scb$row),]$ProjectId
 }
} # }
```
