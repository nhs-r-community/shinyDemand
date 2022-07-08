test_that("Simple dataframe calculation", {

  daily_data <- simple_input(10, 4, 6, as.Date("2022-01-01"), "day", 17)

  daily_data |>
    ggplot2::ggplot(ggplot2::aes(x = date, y = list_size)) +
    ggplot2::geom_line()
})
