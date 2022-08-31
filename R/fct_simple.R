#' simple_input
#'
#' @description A simple function to model input waiting lists (that is,
#' ones with only referrals as inputs). Takes as
#' arguments only initial wait list size and rate of input and output,
#' start date, date increment (day, week, month), and length of output
#' @param wait_list numeric. Size of wait list at initialisation
#' @param rate_in numeric. Rate (expressed in the unit of time selected in
#' date_unit) of referrals in to assessment
#' @param rate_out numeric. Rate (expressed in the unit of time selected in
#' date_unit) of assessments out
#' @param start_date date. Date of initialisation
#' @param end_date int. Length of output dataframe (i.e. number of rows)
#' @param date_unit string. "day", "week", or "month". Date interval to output
#' the dataframe in (in the same units as rate_*)
#' @param historical boolean. Is this historical data or a projection?
#' affects the column name so it appears correctly on the graph
#' @return dataframe with two columns- date and waitlist size
#'
simple_input <- function(wait_list, rate_in, rate_out, start_date,
                         end_date, date_unit, historical){

  var_name <- ifelse(historical, "prev_list", "future_list")

  make_data <- data.frame("date" = seq(start_date, end_date, by = date_unit))

  make_data$n <- seq(from = wait_list,
                     by = rate_in - rate_out,
                     length.out = nrow(make_data)
                     )

  make_data$type <- var_name

  make_data$n[make_data$n < 0] <- 0

  make_data
}


