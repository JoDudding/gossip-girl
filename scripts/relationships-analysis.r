#-------------------------------------------------------------------------------
#' relationships-analysis.r
cli::cli_h1("relationships-analysis.r")
#-------------------------------------------------------------------------------
#' jo dudding
#' May 2025
#' read in relationship data and analyse
#' sourced from https://gossipgirl.fandom.com/wiki/Category:Relationships
#' looks light compared to this relationship map
#' https://www.reddit.com/r/GossipGirl/comments/bpp9v4/after_my_recent_rewatch_i_created_a_map_to_keep/
#-------------------------------------------------------------------------------

source("scripts/_setup.r")  
  
#--- read in relationship table ---

gg_relationships <- tibble(
  character = readLines("data/gg-relationships.txt")
) |>
  filter(character != "") |> 
  mutate(
    relationship_id = row_number(),
    character = str_split(character, '-|–')
  ) |> 
  unnest_longer(character) |> 
  mutate(character = str_trim(character))

log_obj("gg_relationships")

#--- who had the most relationships? ---

gg_relationships |> 
  count(character, sort = TRUE)