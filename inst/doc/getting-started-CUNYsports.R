## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## ----setup--------------------------------------------------------------------
library(CUNYsports)
library(dplyr)
library(ggplot2)

## ----table-names--------------------------------------------------------------
cuny_table_names()

## ----find-player-tables-------------------------------------------------------
cuny_find_tables("player")

## ----find-tables--------------------------------------------------------------
cuny_find_tables("scoring")
cuny_find_tables("game")

## ----table-info---------------------------------------------------------------
cuny_table_info(
  "basketball_all_seasons_player_overall_final"
)

## ----column-info--------------------------------------------------------------
cuny_columns_info(
  "basketball_all_seasons_player_overall_final"
)

## ----pull-player-data---------------------------------------------------------
player_stats <- cuny_pull_table(
  "basketball_all_seasons_player_overall_final"
)

player_stats |>
  slice_head(n = 6)

## ----womens-basketball--------------------------------------------------------
womens_player_stats <- player_stats |>
  filter(gender == "W")

womens_player_stats |>
  slice_head(n = 6)

## ----mens-basketball----------------------------------------------------------
mens_player_stats <- player_stats |>
  filter(gender == "M")

mens_player_stats |>
  slice_head(n = 6)

## ----complete-workflow--------------------------------------------------------
# Discover
cuny_find_tables("player")

# Understand
cuny_table_info(
  "basketball_all_seasons_player_overall_final"
)

cuny_columns_info(
  "basketball_all_seasons_player_overall_final"
)

# Retrieve
players <- cuny_pull_table(
  "basketball_all_seasons_player_overall_final"
)

## ----scoring-search-----------------------------------------------------------
cuny_find_tables("scoring")

## ----scoring-info-------------------------------------------------------------
cuny_table_info(
  "basketball_all_seasons_player_scoring_final"
)

## ----scoring-columns----------------------------------------------------------
cuny_columns_info(
  "basketball_all_seasons_player_scoring_final"
)

## ----scoring-data-------------------------------------------------------------
scoring <- cuny_pull_table(
  "basketball_all_seasons_player_scoring_final"
)

scoring |>
  slice_head(n = 6)

## ----scoring-summary----------------------------------------------------------
scoring |>
  filter(!is.na(points_per_game)) |>
  summarize(
    players = n(),
    average_ppg = mean(points_per_game),
    median_ppg = median(points_per_game),
    maximum_ppg = max(points_per_game)
  )

## ----scoring-gender-summary---------------------------------------------------
scoring |>
  filter(!is.na(points_per_game)) |>
  group_by(gender) |>
  summarize(
    players = n(),
    average_ppg = mean(points_per_game),
    median_ppg = median(points_per_game),
    maximum_ppg = max(points_per_game),
    .groups = "drop"
  )

## ----scoring-graph, fig.alt="Histogram showing the distribution of player points per game in CUNY basketball, separated into men's and women's basketball.", fig.cap="Distribution of player points per game in CUNY basketball.", fig.height=5, fig.width=7----
scoring |>
  filter(!is.na(points_per_game)) |>
  ggplot(aes(x = points_per_game)) +
  geom_histogram(bins = 30) +
  facet_wrap(~ gender) +
  theme_minimal() +
  labs(
    title = "Player Scoring Across CUNY Basketball",
    subtitle = "Men's and Women's Basketball",
    x = "Points Per Game",
    y = "Number of Player-Seasons"
  )

## ----database-connection------------------------------------------------------
con <- cuny_db()

DBI::dbListTables(con)

DBI::dbDisconnect(con)

## ----database-query-----------------------------------------------------------
con <- cuny_db()

player_db <- dplyr::tbl(
  con,
  "basketball_all_seasons_player_overall_final"
)

player_db |>
  filter(gender == "W") |>
  select(player_name, season_label, school_id, points_per_game) |>
  head()

DBI::dbDisconnect(con)

