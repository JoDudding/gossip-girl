#-------------------------------------------------------------------------------
#' data-engineering.r
cli::cli_h1("data-engineering.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' extract gossip girl data from wikipedia
#-------------------------------------------------------------------------------

source("scripts/_setup.r")

#--- read wikipedia pages ---

gg_main_url <- "https://en.wikipedia.org/wiki/Gossip_Girl"

gg_main_wiki <- read_html(gg_main_url)

gg_episodes_url <- "https://en.wikipedia.org/wiki/List_of_Gossip_Girl_episodes"

gg_episodes_wiki <- read_html(gg_episodes_url)

gg_cast_url <- "https://en.wikipedia.org/wiki/List_of_Gossip_Girl_characters"

gg_cast_wiki <- read_html(gg_cast_url)

#--- cast ---

# get the tables from the cast page

gg_cast_tables <- html_nodes(gg_cast_wiki, ".wikitable")

log_obj("gg_cast_tables")

# main characters

gg_cast_main_raw <- gg_cast_tables |>
  pluck(1) |>
  html_table(fill = TRUE) |>
  glimpse()

log_obj("gg_cast_main_raw")

gg_cast_main <- gg_cast_main_raw |>
  set_names(
    c(
      "actor", "character", "orig_1", "orig_2", "orig_3", "orig_4", "orig_5",
      "orig_6", "new_1", "new_2"
    )
  ) |>
  filter(row_number() > 2) |>
  gather(-1, -2, key = "season", value = "cast_type") |>
  clean_names() |>
  mutate(
    cast_actortype = str_remove_all(actor, "\\[.*\\]"),
    character = str_remove_all(character, "\\[.*\\]"),
    cast_type = str_remove_all(cast_type, "\\[.*\\]"),
    character_nickname = case_when(
      str_detect(character, '\\"') ~ str_extract(character, '(?<=\\").*(?=\\")'),
      TRUE ~ str_extract(character, "^\\w*(?=\\s)")
    ) |>
      str_replace("Gossip", "Gossip Girl")
  ) |>
  filter(!is.na(cast_type), cast_type != "Does not appear") |>
  print()

log_obj("gg_cast_main")

gg_cast_main |>
  count(season)

gg_cast_main |>
  count(cast_type)

save_rds_csv("gg_cast_main")

# recurring characters

gg_cast_recurring_raw <- gg_cast_tables |>
  pluck(2) |>
  html_table(fill = TRUE) |>
  glimpse()

log_obj("gg_cast_recurring_raw")

gg_cast_recurring <- gg_cast_recurring_raw |>
  set_names(
    c(
      "actor", "character", "orig_1", "orig_2", "orig_3", "orig_4", "orig_5",
      "orig_6", "new_1", "new_2"
    )
  ) |>
  filter(row_number() > 2) |>
  gather(-1, -2, key = "season", value = "cast_type") |>
  clean_names() |>
  mutate(
    cast_actortype = str_remove_all(actor, "\\[.*\\]"),
    character = str_remove_all(character, "\\[.*\\]"),
    cast_type = str_remove_all(cast_type, "\\[.*\\]"),
    character_nickname = case_when(
      str_detect(character, '\\"') ~ str_extract(character, '(?<=\\").*(?=\\")'),
      TRUE ~ str_extract(character, "^\\w*(?=\\s)")
    )
  ) |>
  filter(!is.na(cast_type), cast_type != "Does not appear") |>
  print()

log_obj("gg_cast_recurring")

gg_cast_recurring |>
  count(season)

gg_cast_recurring |>
  count(cast_type)

save_rds_csv("gg_cast_recurring")
