#' Generate S3 proto_net generic function
#' @param x An R object
#' @export
proto_graph <- function(x) {
  UseMethod("proto_graph")
}

#' Is this object a proto_net?
#' 
#' @description Logical test for proto_net objects.
#' 
#' @param pn An R object.
#' @export
is_proto_graph <- function (x) {
  inherits(x, "proto_graph")
}