# Parse "InvolvedPeople" field from a SweCRIS export

InvolvedPeople is a field where strings are provided like
`¤¤¤Peter Hedstroem¤0000-0003-1102-4342¤Principal Investigator¤Projektledare¤Male`

## Usage

``` r
parse_involved_people(x)
```

## Arguments

- x:

  the InvolvedPeople string

## Details

These strings encode a dataset equivalent to what a call using
`swecris_project_people("2021-00157_VR")` would provide.

Instead of making multiple API request calls to resolve, a utility fcn
for parsing is provided.

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 ip <- swecris_kth$InvolvedPeople
 ppl <- purrr::map_dfr(ip, parse_involved_people, .id = "row")
 ppl$ProjectId <- swecris_kth[as.integer(ppl$row),]$ProjectId
 }
} # }
```
