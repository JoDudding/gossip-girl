# gossip-girl


![](https://img.shields.io/badge/XOXO-done-B40411?style=for-the-badge&labelColor=black.png)

![](assets/Gossip_Girl_season_3_DVD.png)
![](assets/Gossip_Girl_season_4_DVD.png)

Data on the Gossip Girl TV series

Sourced from [Wikipedia](https://en.wikipedia.org/wiki/Gossip_Girl) and
[gossipgirl.fandom.com](https://gossipgirl.fandom.com/wiki/Gossip_Girl_Wiki)

The purpose of this exercise is to provide some fun data for my niece to
use when learning Excel. [Click here to see a google sheets
view](https://docs.google.com/spreadsheets/d/1wDTANHdBV6wMknnWzSC2ajtxuNmZuUhHrziACAEBTDQ/edit?usp=sharing)

If I can source some relationship information I can play with some
network analysis, and some transcript information for text analysis
using [{tidytext}](https://juliasilge.github.io/tidytext/).

# Tables

## gg_cast_main

Main characters in Gossip Girl and the actors that play them (Source:
Wikipedia)

| variable       | description                       | class     |
|:---------------|:----------------------------------|:----------|
| actor          | Actor name                        | character |
| character      | Character name                    | character |
| season         | Season number                     | character |
| cast_type      | Character is main, recurring, etc | character |
| character_full | Full name of character            | character |

## gg_cast_recurring

Recurring characters in Gossip Girl and the actors that play them
(Source: Wikipedia)

| variable       | description                       | class     |
|:---------------|:----------------------------------|:----------|
| actor          | Actor name                        | character |
| character      | Character name                    | character |
| season         | Season number                     | character |
| cast_type      | Character is main, recurring, etc | character |
| character_full | Full name of character            | character |

## gg_episodes

Episode names, directors, writers and viewership for Gossip Girl
(Source: Wikipedia)

| variable              | description                              | class   |
|:----------------------|:-----------------------------------------|:--------|
| season                | Season number                            | integer |
| no_overall            | Episode number counting over all seasons | integer |
| episode               | Episode number                           | integer |
| title                 | Episode title                            | integer |
| directed_by           | Director name                            | integer |
| written_by            | Writer of episode                        | integer |
| original_release_date | Original release date of episode         | integer |
| us_viewers_millions   | US viewership (millions)                 | integer |

## gg_metadata

Summary metadata for each Gossip Girl table saved

| variable          | description                            | class     |
|:------------------|:---------------------------------------|:----------|
| table             | Name of table                          | character |
| table_description | Description of what the table contains | character |
| variable          | Name of variable                       | character |
| description       | Description of variable                | character |
| class             | Class of variable                      | character |

## gg_pilot_token

Gossip Girl pilot transcript tokenised to word level (Source:
gossipgirl.fandom.com)

| variable            | description                              | class   |
|:--------------------|:-----------------------------------------|:--------|
| main_character      | Person speaking is a main character      | logical |
| character           | Character name                           | logical |
| line_no             | Line number in pilot transcript          | logical |
| line_type           | Line was spoken, voice over or direction | logical |
| word                | Word spoken in the pilot transcript      | logical |
| main_character_word | Word is a main character name            | logical |

## gg_pilot

Text from the Gossip Girl pilot transcript with the characters speaking
each line (Source: gossipgirl.fandom.com)

| variable       | description                                      | class     |
|:---------------|:-------------------------------------------------|:----------|
| line           | Text of line in pilot transcript                 | character |
| season         | Season number                                    | character |
| episode        | Episode number                                   | character |
| line_no        | Line number in pilot transcript                  | character |
| line_type      | Line was spoken, voice over or direction         | character |
| character      | Character name                                   | character |
| direction      | Direction for actors in pilot transcript         | character |
| location       | Location line was spoken in the pilot transcript | character |
| main_character | Person speaking is a main character              | character |

## gg_relationships

Relationships betwen Gossip Girl characters (Source:
gossipgirl.fandom.com, seems to be missing some relationships)

| variable        | description                    | class     |
|:----------------|:-------------------------------|:----------|
| character       | Character name                 | character |
| relationship_id | Unique ID for the relationship | character |

## gg_season_summary

Statistics on each Gossip Girl season (Source: Wikipedia)

| variable                       | description                      | class   |
|:-------------------------------|:---------------------------------|:--------|
| season                         | Season number                    | integer |
| episodes                       | Number of episodes in series     | integer |
| first_released                 | Date season first released       | integer |
| last_released                  | Date season last released        | integer |
| average_viewership_in_millions | Average US viewership (millions) | integer |

XOXO

# Viewership

![](charts/viewership-bar.png)

![](charts/viewership-line.png)

# Analysis of pilot transcript

![](charts/gg-pilot-speaking-about.png)

![](charts/gg-pilot-sentiment.png)
