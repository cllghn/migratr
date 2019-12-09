#' Generate S3 proto_net generic function
#' @param x An R object
#' @export
proto_graph <- function(x) {
  UseMethod("proto_graph")
}

#' Is this object a \code{proto_graph}?
#' 
#' @description Logical test for proto_graph objects.
#' 
#' @param x An R object.
#' @export
is_proto_graph <- function (x) {
  inherits(x, "proto_graph")
}