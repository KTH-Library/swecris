#' SweCRIS data for KTH Royal Institute of Technology
#'
#' A static dataset containing the projects in SweCRIS resulting from
#' a swecris_funding() call on 2023-11-27 12:13:16 CET.
#'
#' @format A table with data returned from the API
#' \describe{
#'   \item{ProjectId}{}
#'   \item{ProjectTitleSv}{}
#'   \item{ProjectTitleEn}{}
#'   \item{ProjectAbstractSv}{}
#'   \item{ProjectAbstractEn}{}
#'   \item{ProjectStartDate}{}
#'   \item{ProjectEndDate}{}
#'   \item{CoordinatingOrganisationId}{}
#'   \item{CoordinatingOrganisationNameSv}{}
#'   \item{CoordinatingOrganisationNameEn}{}
#'   \item{CoordinatingOrganisationTypeOfOrganisationSv}{}
#'   \item{CoordinatingOrganisationTypeOfOrganisationEn}{}
#'   \item{FundingOrganisationId}{}
#'   \item{FundingOrganisationNameSv}{}
#'   \item{FundingOrganisationNameEn}{}
#'   \item{FundingOrganisationTypeOfOrganisationSv}{}
#'   \item{FundingOrganisationTypeOfOrganisationEn}{}
#'   \item{FundingsSek}{}
#'   \item{FundingYear}{}
#'   \item{FundingStartDate}{}
#'   \item{FundingEndDate}{}
#'   \item{TypeOfAwardId}{}
#'   \item{TypeOfAwardDescrSv}{}
#'   \item{TypeOfAwardDescrEn}{}
#'   \item{UpdatedDate}{}
#'   \item{LoadedDate}{}
#'   \item{InvolvedPeople}{}
#'   \item{Scbs}{}
#' }
"swecris_kth"

#' Norwegian list
#'
#' A static dataset containing the Norwegian lists fetched 7 Aug 2023.
#'
#' For details see these URLs:
#' - https://dbh.nsd.uib.no/publiseringskanaler/AlltidFerskListeTidsskriftSomCsv
#' - https://dbh.nsd.uib.no/publiseringskanaler/AlltidFerskListeForlagSomCsv
#'
#' @format A table with data returned from the API
#' \describe{
#'   \item{journal_id}{}
#'   \item{title}{}
#'   \item{title_en}{}
#'   \item{issn_print}{}
#'   \item{issn_online}{}
#'   \item{oa}{}
#'   \item{publishing_agreement}{}
#'   \item{group_area}{}
#'   \item{group_field}{}
#'   \item{level_2024}{}
#'   \item{level_2023}{}
#'   \item{level_2022}{}
#'   \item{level_2021}{}
#'   \item{level_2020}{}
#'   \item{level_2019}{}
#'   \item{level_2018}{}
#'   \item{level_2017}{}
#'   \item{level_2016}{}
#'   \item{level_2015}{}
#'   \item{level_2014}{}
#'   \item{level_2013}{}
#'   \item{level_2012}{}
#'   \item{level_2011}{}
#'   \item{level_2010}{}
#'   \item{level_2009}{}
#'   \item{level_2008}{}
#'   \item{level_2007}{}
#'   \item{level_2006}{}
#'   \item{level_2005}{}
#'   \item{level_2004}{}
#'   \item{publisher_id}{}
#'   \item{publisher_company}{}
#'   \item{publisher}{}
#'   \item{publisher_country}{}
#'   \item{language}{}
#'   \item{conference_report}{}
#'   \item{series}{}
#'   \item{established}{}
#'   \item{discontinued}{}
#'   \item{url}{}
#'   \item{last_updated}{}
#'   \item{set}{}
#'   \item{isbn_prefix}{}
#'   \item{country}{}
#' }
"swecris_list_norwegian"
