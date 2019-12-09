#' \code{proto_graph} Print Method
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param x A class \code{proto_graph} object 
#' @param ... Extra arguments to pass to \code{print()}.
#' @export 
print.proto_graph <- function(x, ...) {
  .print_header(x)
}

#' @keywords internal
#' 
#' @title Print header line for \code{proto_graph} object
#' 
#' @param x A class \code{proto_graph} object 
#' @param ... Extra arguments to pass to \code{print()}.
#' 
#' @importFrom igraph ecount vcount
#' 
.print_header <- function(x, ...) {
  if (!is_proto_graph(x)) {
    stop("Not a proto_graph object.",
         call. = FALSE)
  }
  title <- paste(sep = "",
                 "PROTO_GRAPH ",
                 "\n",
                 " Nodes: ",
                 igraph::vcount(x[["graph"]]),
                 "\n",
                 " Edges: ",
                 igraph::ecount(x[["graph"]]),
                 "\n")
  cat(title)
}
