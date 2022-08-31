#' plots
#'
#' @description Plot the waiting list over time, optionally varying
#' the input/ output rate at a "specific" break point in the data
#' @param wait_frame dataframe. You probably made this with a function like
#' \code{\link{simple_input}}
#'
#' @return A plot showing the size of the wait list over time
#'
wait_plot <- function(wait_frame){

  wait_frame |>
    tidyr::pivot_longer(type) |>
    ggplot2::ggplot(ggplot2::aes(x = date, y = n,
                                 group = value, colour = value)) +
    ggplot2::geom_line()
}
