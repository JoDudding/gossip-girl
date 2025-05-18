#-------------------------------------------------------------------------------
#' create-table-metadata.r
cli::cli_h1("create-table-metadata.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' create a table of the metadata
#-------------------------------------------------------------------------------

source("scripts/_setup.r")

#--- get a list of the tables ---

gg_tables <- fs::dir_ls("data", glob = "*.rds")

#--- function to read the names and classes ---

get_metadata <- function(path) {
  x <- readRDS(path)

  tibble::tibble(
    table = str_remove_all(path, "data/|\\.rds"),
    variable = names(x)
  ) |>
    dplyr::mutate(
      class = purrr::map(x, \(var) vctrs::vec_ptype_full(var))[[1]],
      description = "TODO"
    )
}

#--- run for each table ---

gg_metadata <- map_dfr(gg_tables, get_metadata) |>
  mutate(
    description = case_when(
      variable == "season" ~ "Season number",
      variable == "episode" ~ "Episode number",
      variable == "no_overall" ~ "Episode number counting over all seasons",
      variable == "cast_type" ~ "Character is main, recurring, etc",
      variable == "character" ~ "Character name",
      variable == "actor" ~ "Actor name",
      variable == "character_full" ~ "Full name of character",
      variable == "average_viewership_in_millions" ~ "Average US viewership (millions)",
      variable == "directed_by" ~ "Director name",
      variable == "us_viewers_millions" ~ "US viewership (millions)",
      variable == "title" ~ "Episode title",
      variable == "relationship_id" ~ "Unique ID for the relationship",
      variable == "line_no" ~ "Line number in pilot transcript",
      variable == "line" ~ "Text of line in pilot transcript",
      variable == "line_type" ~ "Line was spoken, voice over or direction",
      variable == "location" ~ "Location line was spoken in the pilot transcript",
      variable == "episodes" ~ "Number of episodes in series",
      variable == "word" ~ "Word spoken in the pilot transcript",
      variable == "main_character" ~ "Person speaking is a main character",
      variable == "main_character_word" ~ "Word is a main character name",
      variable == "written_by" ~ "Writer of episode",
      variable == "original_release_date" ~ "Original release date of episode",
      variable == "first_released" ~ "Date season first released",
      variable == "last_released" ~ "Date season last released",
      variable == "direction" ~ "Direction for actors in pilot transcript",
      variable == "table" ~ "Name of table",
      variable == "variable" ~ "Name of variable",
      variable == "class" ~ "Class of variable",
      variable == "description" ~ "Description of variable",
      TRUE ~ description
    )
  )

#--- check ---

gg_metadata |>
  select(-class) |>
  print(n = 50)

#--- save ---

save_rds_csv("gg_metadata")

