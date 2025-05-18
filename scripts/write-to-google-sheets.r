#-------------------------------------------------------------------------------
#' write-to-google-sheets.r
cli::cli_h1("write-to-google-sheets.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' export the tables to google sheets
#-------------------------------------------------------------------------------

source("scripts/_setup.r")  
  
#--- read cover sheet ---

cover_sheet <- read_sheet(
  "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ"
)

print(cover_sheet)

#--- add relationships tab ---

readRDS("data/gg-relationships.rds") |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "relationships"
  )

#--- add series summary tab ---

readRDS("data/gg-season-summary.rds") |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "season-summary"
  )

#--- add main cast tab ---

readRDS("data/gg-cast-main.rds") |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "main-cast"
  )

#--- add episode tab ---

readRDS("data/gg-episodes.rds") |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "episodes"
  )

#--- add pilot transcript tokens ---

readRDS("data/gg-pilot-token.rds") |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "pilot-transcript-words"
  )

#--- add table metadata ---

readRDS("data/gg-metadata.rds") |>
  mutate(
    table = case_match(
      table,
      "gg_relationships" ~ "relationships",
      "gg_season_summary" ~ "season-summary",
      "gg_cast_main" ~ "main-cast",
      "gg_episodes" ~ "episodes",
      "gg_pilot_token" ~ "pilot-transcript-words"
    )
  ) |> 
  filter(! is.na(table)) |> 
  sheet_write(
    "1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ",
    sheet = "table-metadata"
  )
