# Graph2Data
R package that converts pictures of a graphs into data sets.


#' Extracts data points from a graph loaded into the function.
#'
#' @param file The graph we are extracting data values from.
#' @return The data frame containing all x and y values for the major points of our graph.
#' @description Load image of the graph and calibrate x and y axes.
#' @examples
#' ellipse_area(1, 1)
#' ellipse_area(1)
#' @export