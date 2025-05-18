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

#--- season summary ---

gg_season_summary <- html_nodes(gg_main_wiki, ".wikitable") |> 
  pluck(1) |>
  html_table(fill = TRUE) |> 
  clean_names() |> 
  select(-episodes_2) |> 
  filter(season != 'Season') |> 
  rename(
    first_released = originally_released,
    last_released = originally_released_2
  ) |> 
  mutate(
    season = as.integer(season),
    episodes = as.integer(episodes),
    average_viewership_in_millions  = str_remove_all(
      average_viewership_in_millions , 
      "\\[.*\\]"
    ) |> 
      as.numeric(),
    first_released = ymd(str_sub(first_released, -11, -2)),
    last_released = ymd(str_sub(last_released, -11, -2))
  ) 

log_obj("gg_season_summary")

gg_season_summary |> 
  print()

save_rds_csv("gg_season_summary")

#--- episodes ---

gg_episodes_tables <- html_nodes(gg_episodes_wiki, ".wikitable")
 
gg_episodes <- map_dfr(
  1:6,
  ~gg_episodes_tables |> 
    pluck(1 + .x) |>
    html_table(fill = TRUE) |> 
    clean_names() |> 
    mutate(
      season = as.integer(.x),
      no_inseason = as.integer(no_inseason),
      across(where(is.character), ~str_remove_all(.x , "\\[.*\\]")),
      title = str_remove_all(title, '"'),
      original_release_date = ymd(str_sub(original_release_date, -11, -2)),
      u_s_viewers_millions  = as.numeric(u_s_viewers_millions )
    ) |> 
    select(season, everything()) 
) |> 
  select(-prod_code) |> 
  rename(
    us_viewers_millions = u_s_viewers_millions,
    episode = no_inseason 
  ) 

log_obj("gg_episodes")

gg_episodes |> 
  group_by(season) |> 
  summarise(
    n_episodes = n(),
    avg_us_viewers_millions = mean(us_viewers_millions)
  ) |> 
  print()

save_rds_csv("gg_episodes")

#--- cast ---

# get the tables from the cast page

gg_cast_tables <- html_nodes(gg_cast_wiki, ".wikitable")

log_obj("gg_cast_tables")

# main characters

gg_cast_main_raw <- gg_cast_tables |>
  pluck(1) |>
  html_table(fill = TRUE)

log_obj("gg_cast_main_raw")

gg_cast_main <- gg_cast_main_raw |>
  set_names(
    c(
      "actor", "character", "1", "2", "3", "4", "5",
      "6", "drop_1", "drop_2"
    )
  ) |>
  filter(row_number() > 2) |>
  select(-drop_1, -drop_2) |> 
  gather(-1, -2, key = "season", value = "cast_type") |>
  clean_names() |>
  mutate(
    season = as.integer(season),
    actor = str_remove_all(actor, "\\[.*\\]"),
    character = str_remove_all(character, "\\[.*\\]"),
    character_full = character,
    cast_type = str_remove_all(cast_type, "\\[.*\\]"),
    character = case_when(
      str_detect(character, '\\"') ~ str_extract(character, '(?<=\\").*(?=\\")'),
      TRUE ~ str_extract(character, "^\\w*(?=\\s)")
    ) |>
      str_replace("Gossip", "Gossip Girl") |> 
      coalesce(character_full)
  ) |>
  filter(!is.na(cast_type), cast_type != "Does not appear")

log_obj("gg_cast_main")

gg_cast_main |>
  count(season) |> 
  print()

gg_cast_main |>
  count(cast_type) |> 
  print()

gg_cast_main |>
  count(character, character_full) |> 
  print(n = 50)

save_rds_csv("gg_cast_main")

# recurring characters

gg_cast_recurring_raw <- gg_cast_tables |>
  pluck(2) |>
  html_table(fill = TRUE)

log_obj("gg_cast_recurring_raw")

gg_cast_recurring <- gg_cast_recurring_raw |>
  set_names(
    c(
      "actor", "character", "1", "2", "3", "4", "5",
      "6", "drop_1", "drop_2"
    )
  ) |>
  filter(row_number() > 2) |>
  select(-drop_1, -drop_2) |> 
  gather(-1, -2, key = "season", value = "cast_type") |>
  clean_names() |>
  mutate(
    season = as.integer(season),
    actor = str_remove_all(actor, "\\[.*\\]"),
    character = str_remove_all(character, "\\[.*\\]"),
    character_full = character,
    cast_type = str_remove_all(cast_type, "\\[.*\\]"),
    character = case_when(
      str_detect(character, '\\"') ~ str_extract(character, '(?<=\\").*(?=\\")'),
      TRUE ~ str_extract(character, "^\\w*(?=\\s)")
    ) |> 
      coalesce(character_full)
  ) |>
  filter(!is.na(cast_type), cast_type != "Does not appear")

log_obj("gg_cast_recurring")

gg_cast_recurring |>
  count(season) |> 
  print()

gg_cast_recurring |>
  count(cast_type) |> 
  print()

gg_cast_recurring |>
  count(character, character_full) |> 
  print(n = 50)

save_rds_csv("gg_cast_recurring")
