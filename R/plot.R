#' \code{proto_graph} Plot Method
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param x A class \code{proto_graph} object 
#' @param ... Extra arguments to pass to \code{print()}.
#' 
#' @importFrom ggplot2 aes ggplot geom_curve geom_point geom_sf theme_minimal scale_color_manual xlab ylab
#' @importFrom RColorBrewer brewer.pal
#' @importFrom sf st_geometry
#' 
#' @export 
plot.proto_graph <- function(x, .xlab = "", .ylab = "", ...) {
  #TODO fix this ramp to something more nimble.
  mycolors = c(RColorBrewer::brewer.pal(name="Dark2",
                                        n = 8),
               RColorBrewer::brewer.pal(name="Paired",
                                        n = 6)
               )
  
  ggplot() +
    theme_minimal() +
    geom_sf(data = x[['geo_nodes']],
            show.legend = FALSE,
            aes(fill = x[['geo_nodes']][[1]])
            ) +
    geom_curve(data = x[['geo_edges']],
               aes(x = x[['geo_edges']][['longitude_start']],
                   y = x[['geo_edges']][['latitude_start']],
                   xend = x[['geo_edges']][['longitude_end']],
                   yend = x[['geo_edges']][['latitude_end']]),
               curvature = 0) +
    geom_point(aes(x = x[['geo_nodes']][['centroid_longitude']],
                   y = x[['geo_nodes']][['centroid_latitude']]),
               size = 1.4,
               colour = "white",
               data = x[['geo_nodes']]) +
    geom_point(aes(x = x[['geo_nodes']][['centroid_longitude']],
                   y = x[['geo_nodes']][['centroid_latitude']]),
               size = 1,
               colour = "black",
               data = x[['geo_nodes']],
               show.legend = FALSE) +
    scale_color_manual(values = mycolors) +
    xlab(.xlab) +
    ylab(.ylab)
}
