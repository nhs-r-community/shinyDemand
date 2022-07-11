#' plots
#'
#' @description Plot the waiting list over time, optionally varying
#' the input/ output rate at a "specific" break point in the data
#' @wait_frame dataframe. You probably made this with a function like
#' \code{\link{simple_input}}
#'
#' @return A plot showing the size of the wait list over time
#'
wait_plot <- function(wait_frame){

  wait_frame |>
    tidyr::pivot_longer(-date) |>
    ggplot2::ggplot(ggplot2::aes(x = date, y = value,
                                 group = name, colour = name)) +
    ggplot2::geom_line()
}
