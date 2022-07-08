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
#' @param date_unit string. "day", "week", or "month". Date interval to output
#' the dataframe in (in the same units as rate_*)
#' @param length_output int. Length of output dataframe (i.e. number of rows)
#' @return dataframe with two columns- date and waitlist size
#'
simple_input <- function(wait_list, rate_in, rate_out, start_date, date_unit,
                         length_output){

  make_data <- data.frame("date" = seq(start_date, by = date_unit,
                                       length.out = length_output),
                          "list_size" = seq(from = wait_list,
                                            by = rate_in - rate_out,
                                            length.out = length_output))

  make_data <- make_data |>
    dplyr::mutate(list_size = ifelse(list_size < 0, 0, list_size)
    )

}

