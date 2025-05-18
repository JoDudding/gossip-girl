#-------------------------------------------------------------------------------
#' pilot-transcript-engineering.r
cli::cli_h1("pilot-transcript-engineering.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' read in the pilot transcript, clean it up and tokenise
#' pilot transcript sourced from https://gossipgirl.fandom.com/wiki/Pilot/Transcript
#' with some manual cleaning
#-------------------------------------------------------------------------------

source("scripts/_setup.r")

#--- get the main characters in season 1 ---

character_list <- readRDS("data/gg-cast-main.rds") |>
  filter(season == 1) |>
  pull(character)

#--- read in the raw file ---

gg_pilot_raw <- tibble(
  line = readLines("data/pilot-transcript.txt")
) |>
  filter(line != "") |>
  mutate(
    season = 1,
    episode = 1,
    line_no = row_number(),
    line_type = case_when(
      str_sub(line, 1, 1) == "[" ~ "directions",
      str_sub(line, 1, 6) == "Gossip" ~ "voice over",
      TRUE ~ "lines"
    )
  )

log_obj("gg_pilot_raw")

#--- tidy the voice over lines ---

tidy_voice_over <- gg_pilot_raw |>
  filter(line_type == "voice over") |>
  mutate(
    character = "Gossip Girl",
    line = str_sub(line, 26) |>
      str_trim()
  )

log_obj("tidy_voice_over")

#--- tidy the spoken lines ---

tidy_spoken <- gg_pilot_raw |>
  filter(line_type == "lines") |>
  mutate(
    character = str_split(line, ": ", simplify = TRUE)[, 1],
    line = str_remove(line, paste0("^", character, ": ")) |>
      str_trim()
  )

log_obj("tidy_spoken")

# tidy_spoken |>
#  count(character, sort = TRUE)

#--- tidy the directions ---

tidy_directions_location <- gg_pilot_raw |>
  filter(
    line_type == "directions",
    str_detect(line, "^\\[(INT|EXT)")
  ) |>
  mutate(
    location = str_sub(str_split(line, " - ", simplify = TRUE)[, 1], 2) |>
      str_trim() |>
      str_remove("\\]$") |>
      str_trim(),
    direction = str_sub(line, str_length(location) + 5) |>
      str_trim() |>
      str_remove("\\]$") |>
      str_trim()
  ) |>
  select(-line)

log_obj("tidy_directions_location")

# tidy_directions_location |>
#  glimpse()

# tidy_directions_location |>
#  select(direction) |>
#  print(n = 50)

# gg_pilot_tokentidy_directions_location |>
# gg_pilot_token  count(location) |>
# gg_pilot_token  print(n = 50)

tidy_directions_rest <- gg_pilot_raw |>
  filter(
    line_type == "directions",
    !str_detect(line, "^\\[(INT|EXT)")
  ) |>
  mutate(
    direction = str_remove(line, "^\\[") |>
      str_trim() |>
      str_remove("\\]$") |>
      str_trim()
  ) |>
  select(-line)

log_obj("tidy_directions_rest")

#--- join ---

gg_pilot <- bind_rows(
  tidy_voice_over,
  tidy_spoken,
  tidy_directions_rest,
  tidy_directions_location
) |>
  # flag if the line is for a main character
  mutate(
  main_character = character %in% character_list
  ) |> 
  arrange(line_no) |>
  fill(location)

log_obj("gg_pilot")

gg_pilot |> 
  filter(main_character) |> 
  count(character)

#--- save ---

save_rds_csv("gg_pilot")

#--- tokenise words ---

data(stop_words)

gg_pilot_token <- gg_pilot |>
  filter(!is.na(line)) |>
  # gossip girl uses initials when referring to people - replace with their names
  mutate(
    line = str_replace_all(line, "\\sB(?=(\\s|'|\\.|\\?))", " Blair") |> 
      str_replace_all("\\sS(?=(\\s|'|\\.|\\?))", " Serena") |> 
      str_replace_all("\\sJ(en)?(?=(\\s|'|\\.|\\?))", " Jenny") |> 
      str_replace_all("\\sN(?=(\\s|'|\\.|\\?))", " Nate") |> 
      str_replace_all("\\sC(?=(\\s|'|\\.|\\?))", " Chuck") |> 
      str_replace_all("\\sD(?=(\\s|'|\\.|\\?))", " Dan") |> 
      str_replace_all("\\sR(?=(\\s|'|\\.|\\?))", " Rufus") |> 
      str_replace_all("\\sL(?=(\\s|'|\\.|\\?))", " Lily")
  ) |> 
  select(main_character, character, contains("line")) |>
  unnest_tokens(word, line) |>
  mutate(
    word = if_else(
      word == "gossip" & lead(word) == "girl" & line_no == lead(line_no),
      "gossip girl",
      word
    ) |> 
      str_remove_all("'s"),
    main_character_word = word %in% str_to_lower(character_list)
  ) |>
  filter(
    !(lag(word) == "gossip girl" & word == "girl" & line_no == lag(line_no))
  ) |> 
  anti_join(stop_words, by = "word")

log_obj("gg_pilot_token")

gg_pilot_token |> 
  filter(main_character_word) |> 
  count(word) |> 
  mutate(tot_n = sum(n), pct = n / sum(n))

#--- save ---

save_rds_csv("gg_pilot_token")
