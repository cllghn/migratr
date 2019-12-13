
library(tidyverse)
library(igraph)
library(sf)
shared_kurds_edgelist <- readr::read_csv(
  here::here("data/migration_decision_making_syria.csv")) %>%
  mutate(
    group = str_extract(`Civilian Group`,
                        "^(.*?)(?=\\sof)")) %>%
  filter(group == "Syrian Kurds") %>%
  dplyr::select(`Neighborhood of Syria`, group) %>%
  rename(neighborhood_id       = `Neighborhood of Syria`) %>%
  tidyr::drop_na() %>%
  igraph::graph_from_data_frame() %>%
  igraph::set_vertex_attr(name = "type",
                          value =  igraph::bipartite_mapping(.)$type) %>%
  igraph::bipartite.projection(which = "false") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_type      = "Shared_Kurds") %>%
  dplyr::select(from, to, edge_type)


syrian_polygons                  <- readRDS(here::here("data/syria_merged.rds"))
syrian_polygons_matrix           <- sf::st_intersects(syrian_polygons,
                                                      sparse = FALSE)
rownames(syrian_polygons_matrix) <- syrian_polygons$neighborhood_id
colnames(syrian_polygons_matrix) <- syrian_polygons$neighborhood_id
border_edgelist <- syrian_polygons_matrix %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_type                  = "Border")

kurds_matrix <- get.adjacency(
  graph_from_data_frame(
    shared_kurds_edgelist),
  sparse = FALSE)

bordr_matrix <- get.adjacency(
  graph_from_data_frame(
    border_edgelist),
  sparse = FALSE)

g <- graph_from_data_frame(shared_kurds_edgelist,
                           directed = FALSE) %s%  graph_from_data_frame(border_edgelist,
                                                                        directed = FALSE)

kurds_edgelist <- g %>%
  igraph::get.data.frame(what = "edges") %>%
  select(from, to) %>%
  mutate(edge_type            = "Shared_Kurds")
usethis::use_data(kurds_edgelist, overwrite = TRUE)  


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
  filter(group == "Syrian Kurds") %>%
  dplyr::select(-c(`Civilian Group`,
                   `Mood at Week 1 (October 1, 2019)`,
                   `Security at Week 1 (October 1, 2019)`)) %>%
  dplyr::rename(neighborhood_id       = `Neighborhood of Syria`)

kurds_nodelist <- readRDS(here::here("data/syria_merged.rds")) %>%
  migratr:::add_centroid() %>%
  rename(lon = centroid_longitude, lat = centroid_latitude) %>%
  dplyr::left_join(temp_nodelist1, by = "neighborhood_id")

usethis::use_data(kurds_nodelist, overwrite = TRUE)  
