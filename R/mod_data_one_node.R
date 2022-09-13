#' data_one_node UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_one_node_ui <- function(id){
  ns <- NS(id)
  tagList(

    fluidRow(

      column(12, htmlOutput(ns("hx_info")))
    )
  )
}

#' data_one_node Server Functions
#'
#' @noRd
mod_data_one_node_server <- function(id, real_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$hx_info <- renderText({

      # glue together date range, waiting list, rate in and out

      glue::glue("First date in series: {real_data$min_date_referrals}<br>",
                 "Last date in series: {real_data$min_date_referrals}<br>",
                 "Waiting list at start of intervention:
                 {real_data$current_waiting_list}<br>",
                 "Average weekly referrals in: {real_data$avg_week_ax}<br>",
                 "Average weekly referrals out: {real_data$avg_week_ref}<br>")

    })

  })
}
