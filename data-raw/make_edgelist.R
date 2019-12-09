
library(tidyverse)
library(igraph)
library(sf)
temp_edgelist1 <- readr::read_csv(
  here::here("data/migration_decision_making_syria.csv")) %>%
  mutate(
    group = str_extract(`Civilian Group`,
                        "^(.*?)(?=\\sof)")) %>%
  dplyr::select(`Neighborhood of Syria`, group) %>%
  rename(neighborhood_id       = `Neighborhood of Syria`) %>%
  tidyr::drop_na() %>%
  igraph::graph_from_data_frame() %>%
  igraph::set_vertex_attr(name = "type",
                         value =  igraph::bipartite_mapping(.)$type) %>%
  igraph::bipartite.projection(which = "false") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_type      = "Population") %>%
  dplyr::select(from, to, edge_type)

syrian_polygons                  <- readRDS(here::here("data/syria_merged.rds"))
syrian_polygons_matrix           <- sf::st_intersects(syrian_polygons,
                                                      sparse = FALSE)
rownames(syrian_polygons_matrix) <- syrian_polygons$neighborhood_id
colnames(syrian_polygons_matrix) <- syrian_polygons$neighborhood_id
temp_edgelist2 <- syrian_polygons_matrix %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_type                  = "Adjacency")

temp_edgelist3 <- readRDS(here::here("data/sum_matrix.rds")) %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_type                = "Adjacency/Population")

edgelist <- rbind(temp_edgelist1, temp_edgelist2, temp_edgelist3)

usethis::use_data(edgelist, overwrite = TRUE)  
