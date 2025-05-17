#-------------------------------------------------------------------------------
#' pilot-transcipt-analysis.r
cli::cli_h1("pilot-transcipt-analysis.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' do some analysis on the pilot transcript
#' pilot transcript sourced from https://gossipgirl.fandom.com/wiki/Pilot/Transcript
#' with some manual cleaning
#-------------------------------------------------------------------------------

source("scripts/_setup.r")

pilot_caption <- "Source: gossipgirl.fandom.com"

#--- get the main characters in season 1 ---

character_list <- readRDS("data/gg-cast-main.rds") |>
  filter(season == "orig_1") |>
  pull(character_nickname)

#--- read token file ---

gg_pilot_token <- readRDS("data/gg-pilot-token.rds") |>
  mutate(
    main_character = character %in% character_list,
    word = if_else(
      word == "gossip" & lead(word) == "girl" & line_no == lead(line_no),
      "gossip girl",
      word
    ),
    main_character_word = word %in% str_to_lower(character_list)
  ) |>
  filter(
    !(lag(word) == "gossip girl" & word == "girl" & line_no == lag(line_no))
  )

log_obj("gg_pilot_token")

#--- most common words ---

gg_pilot_token |>
  filter(!main_character_word) |>
  count(word, sort = TRUE) |>
  slice(1:25) |>
  mutate(word = fct_rev(fct_inorder(word))) |>
  ggplot(aes(n, word)) +
  geom_col() +
  labs(
    x = NULL, y = NULL,
    title = "Top 25 words in Gossip Girl pilot transcript",
    subtitle = "Excluding main character names",
    caption = pilot_caption
  )

gg_save("gg-most-common-words")

#--- who talks the most ---

gg_pilot_token |>
  filter(main_character) |>
  filter(!main_character_word) |>
  group_by(character) |>
  count(word, sort = TRUE) |>
  summarise(
    n_words = sum(n),
    n_unique_words = n(),
    top_word = first(word),
    n_top_word = first(n)
  ) |>
  ungroup() |>
  arrange(-n_words)

#--- who are they talking about ---

gg_pilot_token |>
  filter(main_character) |>
  filter(main_character_word) |>
  count(character, word) |>
  mutate(
    word = str_to_title(word) |>
      fct_inorder() |>
      fct_relevel("Gossip Girl"),
    character = fct_inorder(character) |>
      fct_relevel("Gossip Girl") |>
      fct_rev()
  ) |>
  ggplot(aes(word, character, fill = n, label = n)) +
  geom_tile() +
  geom_text(colour = "white") +
  scale_x_discrete(position = "top", label = label_wrap(8)) +
  scale_y_discrete(label = label_wrap(8)) +
  scale_fill_gradient(low = gg_palette$grey, high = gg_palette$red) +
  labs(
    x = "Spoken about",
    y = "Speaking",
    fill = NULL,
    title = "Who is speaking about who in the pilot?",
    caption = pilot_caption
  ) +
  guides(fill = "none")

gg_save("gg-pilot-speaking-about")

#--- sentiment analysis ---

gg_pilot_token |>
  count(character, word) |>
  group_by(character) |>
  filter(sum(n) >= 20) |>
  ungroup() |>
  inner_join(
    get_sentiments("nrc") |>
      filter(sentiment %in% c("positive", "negative")),
    by = "word",
    relationship = "many-to-many"
  ) |>
  count(character, sentiment, sort = TRUE) |>
  spread(key = sentiment, value = n, fill = 0) |>
  filter(positive + negative >= 5) |>
  mutate(
    net_sentiment_pct = (positive - negative) / (positive + negative)
  ) |>
  arrange(net_sentiment_pct) |>
  mutate(
    sentiment_group = if_else(net_sentiment_pct > 0, "Positive", "Negative"),
    sentiment_colour = if_else(net_sentiment_pct > 0, gg_palette$blue, gg_palette$red),
    character = fct_inorder(character)
  ) |>
  group_by(sentiment_group) |>
  arrange(abs(net_sentiment_pct)) |>
  mutate(
    sentiment_text = case_when(row_number() == n() ~ sentiment_group),
    sentiment_x = 0,
    sentiment_hjust = case_when(
      row_number() == n() & sentiment_group == "Positive" ~ 1.1,
      row_number() == n() & sentiment_group == "Negative" ~ -0.1,
    )
  ) |>
  ggplot(aes(net_sentiment_pct, character, fill = sentiment_colour, )) +
  geom_col() +
  geom_text(aes(
    label = sentiment_text, colour = sentiment_colour, x = sentiment_x,
    hjust = sentiment_hjust
  ), show.legend = FALSE) +
  scale_x_continuous(label = percent) +
  scale_fill_identity() +
  scale_colour_identity() +
  labs(
    x = "Net sentiment percent",
    y = NULL,
    title = "Net sentiment by character in pilot",
    caption = pilot_caption
  )

gg_save("gg-pilot-sentiment")
