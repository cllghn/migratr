#' @title \code{get_proto_graph}
#'
#' @description 
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
#' \code{nodes} must be a \code{data.frame} with vertex metadata. THe first column of the table is assume to contain the symbolic vertex names, this will be added to the graphs as the 'name' vertex attribute. Additionally, as an object of class \code{sf} it must include the intended geometry for each vertex.
#' 
#' \code{centroid} is used to calculate the geographic position of each node when the network is represented on a map. As a default, the argument is set to \code{TRUE} and will calculate the centroid for the provided geometry. If \code{FALSE} the user will have to provide a node latitude and longitude for graphing.
#' 
#' @export
get_proto_graph <- function(edges, nodes, directed = FALSE, centroid = TRUE) {
  
  if (!is.data.frame(nodes)) {
    stop("nodes not a data.frame.",
         call. = FALSE)
  }
  if (!is(nodes, "sf")) {
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
              "nodes" = ifelse(centroid,
                               add_centroid(nodes),
                               nodes)
              )
  
  class(out) <- "proto_graph"
  out
}

#' @title \code{get_centroid}
#'
#' @description Geometric operation on simple feature geometry to add coordinates for feature centroid.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom sf st_centroid st_geometry
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

# edges_geom <- edges %>%
#   inner_join(coords %>% select(id, lon, lat), by = c('from' = 'id')) %>%
#   rename(x = lon, y = lat) %>%
#   inner_join(coords %>% select(id, lon, lat), by = c('to' = 'id')) %>%
#   rename(xend = lon, yend = lat)


