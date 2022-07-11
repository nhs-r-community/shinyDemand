test_that("Simple dataframe calculation", {

  daily_data <- simple_input(10, 4, 6, as.Date("2022-01-01"), "day", 17)

  expect_equal(tail(daily_data$list_size, 1), 0)

  expect_equal(nrow(daily_data), 17)

})
