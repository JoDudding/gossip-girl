#-------------------------------------------------------------------------------
#' viewership.r
cli::cli_h1("viewership.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' look at veiwership trends
#-------------------------------------------------------------------------------

source("scripts/_setup.r")  

gg_caption <- "Source: Wikipedia"

#--- season palette ---

season_pal <- c(gg_palette)

names(season_pal) <- 1:6

#--- viewership data ---

episodes <- readRDS("data/gg-episodes.rds") |> 
  select(season, no_overall, episode, us_viewers_millions) |> 
  mutate(season = factor(season)) |> 
  group_by(season) |>
  mutate(
    episode_type = case_when(
      episode == min(episode) ~ "Premiere",
      episode == max(episode) ~ "Finale",
      TRUE ~ "Middle"
    ),
    episode_first_last = case_when(
      episode == min(episode) | episode == max(episode) ~ season
    ),
    episode_first_last_y = case_when(
      episode == min(episode) | episode == max(episode) ~ us_viewers_millions
    ),
    premier = case_when(episode == min(episode) ~ us_viewers_millions),
    finale = case_when(episode == max(episode) ~ us_viewers_millions),
    season_label = case_when(episode == floor(mean(episode)) ~ season),
    season_y = case_when(
      episode == floor(mean(episode)) ~
        coalesce(us_viewers_millions, mean(us_viewers_millions, na.rm = TRUE))
    ),
    colour = season_pal[season][[1]]
  ) |>
  ungroup()

log_obj("episodes")

#--- bar chart ---

episodes |>
  ggplot(aes(no_overall , us_viewers_millions, fill = colour)) +
  geom_col(colour = "white", linewidth = 0.01) +
  geom_text(aes(y = season_y, label = season_label), nudge_y = 0.5) +
  scale_y_continuous(label = comma_format(1), expand = c(0, 0.5)) +
  scale_fill_identity() +
  labs(
    x = NULL, y = "Total US viewers (m)",
    fill = "Season", colour = "Season",
    title = "Viewership was highest in season 2",
    subtitle = "Total US viewers (m) by season and episode",
    caption = gg_caption
  ) +
  guides(x = "none", fill = "none")

gg_save("viewership-bar")

#--- line chart ---

episodes |>
  ggplot(aes(episode , us_viewers_millions, colour = colour)) +
  geom_line(linewidth = 0.5) +
  geom_point(aes(y = episode_first_last_y), size = 2) +
  geom_text(aes(label = episode_first_last), colour = "white") +
  scale_y_continuous(label = comma_format(1), expand = c(0, 0.5)) +
  scale_colour_identity() +
  labs(
    x = "Episode", y = "Total US viewers (m)",
    fill = "Season", colour = "Season",
    title = "Viewership trended down within seasons",
    subtitle = "Total US viewers (m) by season and episode",
    caption = gg_caption
  ) +
  guides(colour = "none")

gg_save("viewership-line")


episodes |>
  filter(episode_type != "Middle") |> 
  ggplot(aes(as.integer(season), us_viewers_millions, colour = episode_type)) +
  geom_line() +
  geom_point() +
  scale_colour_manual(values = c(gg_palette$pink, gg_palette$beige)) +
  scale_y_continuous(label = comma_format(1), expand = c(0, 0.5)) +
  labs(
    x = "Season", y = "Total US viewers (m)",
    colour = "Episode type",
    title = "Similar viewership for the first and last episodes in a season",
    subtitle = "Total US viewers (m) by season for first and last episodes",
    caption = gg_caption
  )

gg_save("viewership-first-last")
