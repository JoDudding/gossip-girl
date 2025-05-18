#-------------------------------------------------------------------------------
#' _run_all.r
cli::cli_h1("_run_all.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' run all the scripts in order
#-------------------------------------------------------------------------------

source("scripts/data-engineering.r")

#--- viewership ---

source("scripts/viewership.r")

#--- pilot transcript ---

source("scripts/pilot-transcript-engineering.r")

source("scripts/pilot-transcript-analysis.r")

#--- relationships ---

source("scripts/relationships-analysis.r")

#--- create table metadata ---

source("scripts/create-table-metadata.r")

#--- write to google sheets ---

source("scripts/write-to-google-sheets.r")