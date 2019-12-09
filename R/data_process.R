#' @title \code{get_proto_graph}
#'
#' @description Produce a \code{proto_graph} object that can be laid as a network, map, or geocoded network on a map.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param edges A \code{data.frame} containing a symbolic edge list in the first two columns. Additional columns are considered as edge attributes.
#' @param nodes A \code{data.frame} and object of class \code{sf} containing the node metadata. See details below.
#' @param directed Logical, whether or not to create a directed graph.
#' @param centroid Logical, whether or not to calculate the centroid for each geometry in the \code{nodes}. See details below.
#' 
#' @importFrom igraph graph_from_data_frame
#' 
#' @details 
#' \code{nodes} must be a \code{data.frame} with vertex metadata. The first column of the table is assume to contain the symbolic vertex names, this will be added to the graphs as the 'name' vertex attribute. Additionally, as an object of class \code{sf} it must include the intended geometry for each vertex.
#' 
#' \code{centroid} is used to calculate the geographic position of each node when the network is represented on a map. As a default, the argument is set to \code{TRUE} and will calculate the centroid for the provided geometry. If \code{FALSE} the user will have to provide a node latitude and longitude for graphing.
#' 
#' @export
get_proto_graph <- function(edges, nodes, directed = FALSE, centroid = TRUE) {
  
  if (!is.data.frame(nodes)) {
    stop("nodes not a data.frame.",
         call. = FALSE)
  }
  if (!inherits(nodes, "sf")) {
   stop("nodes are not sf class.") 
  }
  if (!is.data.frame(edges)) {
    stop("edges not a data.frame.",
         call. = FALSE)
  }
  if (!is.logical(directed)) {
    stop("directed is not a logical scalar.",
         call. = FALSE)
  }
  if (!is.logical(centroid)) {
    stop("centroid is not a logical scalar.",
         call. = FALSE)
  }
  
  out <- list("graph"  = igraph::graph_from_data_frame(edges,
                                                       directed = directed,
                                                       vertices = nodes),
              "geo_nodes" = if (centroid == TRUE) {
                add_centroid(nodes)
              } else {nodes},
              "geo_edges" = if (centroid == TRUE) {
                get_geo_edges(edges = edges,
                              nodes = add_centroid(nodes),
                              .centroid_latitude  = 'centroid_latitude',
                              .centroid_longitude = 'centroid_longitude')
              } else {
                if (
                  any(
                    !c("centroid_latitude",
                       "centroid_longitude") %in% names(nodes))
                  ) {
                  stop("Centroid latidude and longitude must be recorded as centroid_latitude and centroid_latitude on the nodelist; othersise, use TRUE on the centroid argument.",
                       call. = FALSE) 
                  }
                get_geo_edges(edges = edges,
                              nodes = add_centroid(nodes),
                              .centroid_latitude  = 'centroid_latitude',
                              .centroid_longitude = 'centroid_longitude')
                }
              )
  
  class(out) <- "proto_graph"
  out
}

#' @title \code{add_centroid}
#'
#' @description Geometric operation on simple feature geometry to add coordinates for feature centroid.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom sf st_centroid st_geometry
#' @importFrom stats setNames
#'
#' @param df an object of class \code{sf}
#' 
add_centroid <- function(df) {
  
  if (!is.data.frame(df)) {
    stop("df not a data.frame.",
         call. = FALSE)
  }
  if (!inherits(df, "sf")) {
    stop("df not sf class.") 
  }
  
  coords <- setNames(
      data.frame(
        do.call(
          rbind,
          sf::st_geometry(sf::st_centroid(df))
          )
        ),
      c("lon", "lat"))
  
  df['centroid_longitude'] <- coords$lon
  df['centroid_latitude']  <- coords$lat
  
  df
}

#' @title \code{get_geo_edges}
#'
#' @description Geometric operation on simple feature geometry to add coordinates for start and end point coordinates for each edge.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom dplyr left_join select rename
#' @importFrom sf st_geometry
#' @importFrom magrittr %>%
#' @importFrom rlang !!! syms set_names
#'
#' @param edges ...
#' @param nodes ...
#' @param .centroid_latitude ...
#' @param .centroid_longitude ...
#' 
get_geo_edges <- function(edges, nodes, .centroid_latitude, .centroid_longitude) {
  
  sf::st_geometry(nodes) <- NULL
  id <- names(nodes[1])
  out_cols <- syms(c(id, .centroid_latitude, .centroid_longitude))
  
  nodes_temp <- nodes %>%
    select(!!!out_cols) %>%
    set_names( c("id", "latitude", "longitude") )
  #print(nodes_temp)
  
  edges_temp <- edges[1:2]
  colnames(edges_temp) <- c("from", "to")
  
  from <- names(edges_temp[1])
  to   <- names(edges_temp[2])
  
  geo_edges <- edges_temp %>%
    left_join(nodes_temp, by = c(from = 'id'), suffix = c("_start", "_end")) %>%
    left_join(nodes_temp, by = c(to = 'id'), suffix = c("_start", "_end"))
  
  geo_edges
}
