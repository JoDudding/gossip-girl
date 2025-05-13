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

