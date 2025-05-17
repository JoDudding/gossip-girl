#-------------------------------------------------------------------------------
#' _setup.r
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' set up stuff like loading libraries, themes and functions shared by multiple
#' scripts
#-------------------------------------------------------------------------------

#--- packages ---

library(tidyverse)
library(glue)
library(scales)
library(cli)
library(rvest)
library(janitor)
#library(tidytuesdayR)
library(tidytext)
library(textdata)
library(systemfonts)

#--- options ---

options(
  dplyr.width = Inf,
  papersize = "a4",
  tab.width = 2,
  width = 80,
  max.print = 25,
  stringsAsFactors = FALSE,
  lubridate.week.start = 6,
  tibble.print_max = 25,
  tibble.print_min = 25,
  tibble.width = Inf,
  dplyr.summarise.inform = FALSE,
  tidyverse.quiet = TRUE
)


#--- ggplot theme ---

# colour palette

gg_palette <- list(
  black = "#000000",
  beige = "#B3917D",
  blue = "#22598F",
  red = "#B40411",
  pink = "#FF5F5F",
  grey = "#c0c0c0"
)

scales::show_col(unlist(gg_palette))

#systemfonts::get_from_google_fonts("Roboto")

systemfonts::register_variant(
  name = "Roboto-Thin",
  family = "Roboto ",
  weight = 'light'
)

base_size <- 6

theme_set(
  theme_minimal(base_family = "Roboto-Thin", base_size = base_size) +
    theme(
      plot.title.position = "plot",
      plot.caption.position = "plot",
      panel.grid.major.x = element_line(linewidth = 0.15),
      panel.grid.major.y = element_line(linewidth = 0.15),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank()
    )
)

update_geom_defaults("col", aes(fill = gg_palette$red, colour = NA))
update_geom_defaults("line", aes(colour = gg_palette$blue, linewidth = 1))
update_geom_defaults("segment", aes(colour = gg_palette$blue))
update_geom_defaults("point", aes(colour = gg_palette$blue, size = 2))
update_geom_defaults("text", aes(
  family = "Roboto-Thin", colour = gg_palette$black,
  size = base_size / .pt * 0.8
))

#--- functions ---

# log size of object

log_obj <- function(object_name) {
  cli::cli_alert_info(c(
    "{.strong {object_name}} has {comma(nrow(get(object_name)))} rows and ",
    "{comma(ncol(get(object_name)))} columns"
  ))
}

save_rds_csv <- function(object_name, save_name = NULL) {
  if (is.null(save_name)) {
    save_name <- str_replace_all(object_name, "_", "-")
  }

  save_name_rds <- glue::glue("data/{save_name}.rds")
  save_name_csv <- glue::glue("data/{save_name}.csv")

  get(object_name) |>
    saveRDS(save_name_rds)

  get(object_name) |>
    write_csv(save_name_csv)

  cli::cli_alert_info("{.file {save_name_rds}} created")
  cli::cli_alert_info("{.file {save_name_csv}} created")
}

# save ggplot objects

gg_save <- function(pic_name, plot = last_plot(), width = 3, height = width / 1.618, ...) {
  pic_name_path <- glue::glue("charts/{pic_name}.png")

  ggsave(
    filename = pic_name_path,
    plot = plot,
    width = width,
    height = height,
    ...
  )

  cli::cli_alert_info("{.file {pic_name_path}} created")
}
