
library(tidyverse)
library(igraph)
library(sf)

temp_nodelist1 <- readr::read_csv(
  here::here("data/migration_decision_making_syria.csv")) %>%
  mutate(
    group    = str_extract(`Civilian Group`,
                           "^(.*?)(?=\\sof)"),
    mood     = as.numeric(str_extract(`Mood at Week 1 (October 1, 2019)`, 
                           "(?<=:\\s)(.*?)$")),
    security = as.numeric(str_extract(`Security at Week 1 (October 1, 2019)`,
                           "(?<=:\\s)(.*?)$"))) %>%
  tidyr::drop_na() %>%
  dplyr::select(-c(`Civilian Group`,
                  `Mood at Week 1 (October 1, 2019)`,
                  `Security at Week 1 (October 1, 2019)`)) %>%
  dplyr::rename(neighborhood_id       = `Neighborhood of Syria`) %>%
  # dplyr::select(neighborhood_id, group, mood, security, 
  #               dplyr::everything()) %>%
  # tidyr::gather(key, value, -neighborhood_id) %>%
  # pivot_wider(id_cols = neighborhood_id, 
  #             names_from = key, 
  #             values_from = value)
  dplyr::select(neighborhood_id, Population) %>%
  dplyr::group_by(neighborhood_id) %>%
  dplyr::summarise(total_population = sum(Population))

nodelist <- readRDS(here::here("data/syria_merged.rds")) %>%
  migratr:::add_centroid() %>%
  rename(lon = centroid_longitude, lat = centroid_latitude) %>%
  dplyr::left_join(temp_nodelist1, by = "neighborhood_id")

usethis::use_data(nodelist, overwrite = TRUE)  
