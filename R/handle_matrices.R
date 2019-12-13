#' Subsetting Mismatching Matrices
#' 
#' @param subsetting_matrix a matrix-like object
#' @param subsettor_matrix a matrix-like object
#' 
#' @example 
#' mat1 <- matrix(data = c(1, 1, 0, 0,
#'                         1, 0, 0, 0,
#'                         0, 0, 0, 0,
#'                         0, 0, 0, 0),
#'                ncol = 4,
#'                nrow = 4,
#'                dimnames = list(c("p1", "p2", "p3", "p4"),
#'                                c("p1", "p2", "p3", "p4"))
#' )
#' mat2 <- matrix(data = c(0, 1, 1,
#'                         1, 0, 0,
#'                         1, 0, 0),
#'                ncol = 3,
#'                nrow = 3,
#'                dimnames = list(c("p1", "p2", "p4"),
#'                                c("p1", "p2", "p4"))
#' )
#' sub_mmatrix(mat1, mat2)
#' 
sub_mmatrix <- function(subsetting_matrix, subsettor_matrix) {
  if (!is.matrix(subsetting_matrix)) {
    stop("The subsetting_matrix argument is not a class matrix object.",
         call. = FALSE)
  }
  if (!is.matrix(subsettor_matrix)) {
    stop("The subsettor_matrix argument is not a class matrix object.",
         call. = FALSE)
  }
  if (!all(dim(subsetting_matrix) >= dim(subsettor_matrix))) {
    stop("The subsetting_matrix must be larger than the subsettor_matrix.",
         call. = FALSE)
  }
  
  row_matches <- match(rownames(subsettor_matrix),
                       rownames(subsetting_matrix))
  col_matches <- match(colnames(subsettor_matrix),
                       colnames(subsetting_matrix))
  subset_matrix <-  subsetting_matrix[row_matches, col_matches]
  subset_matrix
  }

#' Add Mismatching Matrices
#'  
#' @param x a matrix-like object
#' @param y a matrix-like object
#' 
#' @description Add matrices of different sizes.
#' 
#' @example 
#' mat1 <- matrix(data = c(1, 1, 0, 0,
#'                         1, 0, 0, 0,
#'                         0, 0, 0, 0,
#'                         0, 0, 0, 0),
#'                ncol = 4,
#'                nrow = 4,
#'                dimnames = list(c("p1", "p2", "p3", "p4"),
#'                                c("p1", "p2", "p3", "p4"))
#' )
#' mat2 <- matrix(data = c(0, 1, 1,
#'                         1, 0, 0,
#'                         1, 0, 0),
#'                ncol = 3,
#'                nrow = 3,
#'                dimnames = list(c("p1", "p2", "p4"),
#'                                c("p1", "p2", "p4"))
#' )
#' add_mmatrix(mat1, mat2)
#'  
#' @export
add_mmatrix <- function(x, y) {
  if (!is.matrix(x) || !is.matrix(y)) {
    stop("Both x and y must by matrix-like objects.",
         call. = FALSE)
  }
  larger_matrix <- if (NROW(x)*NCOL(x) >= NROW(y)*NCOL(y)) {
    x
  } else {
    y
  }
  smaller_matrix <- if (NROW(x)*NCOL(x) < NROW(y)*NCOL(y)) {
    x
  } else {
    y
  }
  
  sub_matrix(larger_matrix, smaller_matrix) + smaller_matrix
}

#' Intersect Mismatching Matrices
#'  
#' @param x a matrix-like object
#' @param y a matrix-like object
#' 
#' @description Intersect matrices of different sizes.
#' 
#' @example 
#' mat1 <- matrix(data = c(1, 1, 0, 0,
#'                         1, 0, 0, 0,
#'                         0, 0, 0, 0,
#'                         0, 0, 0, 0),
#'                ncol = 4,
#'                nrow = 4,
#'                dimnames = list(c("p1", "p2", "p3", "p4"),
#'                                c("p1", "p2", "p3", "p4"))
#' )
#' mat2 <- matrix(data = c(0, 1, 1,
#'                         1, 0, 0,
#'                         1, 0, 0),
#'                ncol = 3,
#'                nrow = 3,
#'                dimnames = list(c("p1", "p2", "p4"),
#'                                c("p1", "p2", "p4"))
#' )
#' intersect_mmatrix(mat1, mat2)
#'  
#' @export
intersect_mmatrix <- function(x, y) {
  if (!is.matrix(x) || !is.matrix(y)) {
    stop("Both x and y must by matrix-like objects.",
         call. = FALSE)
  }
  larger_matrix <- if (NROW(x)*NCOL(x) >= NROW(y)*NCOL(y)) {
    x
  } else {
    y
  }
  smaller_matrix <- if (NROW(x)*NCOL(x) < NROW(y)*NCOL(y)) {
    x
  } else {
    y
  }
  
  sub_matrix(larger_matrix, smaller_matrix) * t(smaller_matrix)
}

