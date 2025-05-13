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
library(tidytuesdayR)
library(showtext)

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

showtext_opts(dpi = 300)
showtext_auto()

#--- ggplot theme ---

# colour palette

gg_palette <- c(
  black = "#000000",
  beige = "#B3917D",
  blue = "#22598F",
  red = "#B40411",
  pink = "#FF5F5F",
  grey = "#c0c0c0"
)

scales::show_col(gg_palette)