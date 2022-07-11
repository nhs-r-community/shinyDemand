test_that("Simple dataframe calculation", {

  daily_data <- simple_input(wait_list = 30,
                             rate_in = 4,
                             rate_out = 6,
                             start_date = as.Date("2022-01-01"),
                             date_unit = "day",
                             end_date = as.Date("2022-02-01"),
                             historical = FALSE)

  expect_equal(tail(daily_data[, 2], 1), 0)

  expect_equal(nrow(daily_data), 17)

})
