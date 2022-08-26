test_that("Simple dataframe calculation", {

  daily_data <- simple_input(wait_list = 30,
                             rate_in = 4,
                             rate_out = 6,
                             start_date = as.Date("2022-01-01"),
                             date_unit = "day",
                             end_date = as.Date("2022-02-01"),
                             historical = FALSE)

  hx_data <- simple_input(wait_list = 30,
                          rate_in = 4,
                          rate_out = 6,
                          start_date = as.Date("2021-12-01"),
                          date_unit = "day",
                          end_date = as.Date("2021-12-31"),
                          historical = TRUE)

  expect_equal(tail(daily_data[, 2], 1), 0)

  expect_equal(nrow(daily_data), 32)

  combine <- rbind(hx_data, daily_data) |>
    tidyr::pivot_longer(type)

  # write test here

})
