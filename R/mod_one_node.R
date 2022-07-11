#' one_node UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_one_node_ui <- function(id){
  ns <- NS(id)
  tagList(

    fluidRow(column(12, dateRangeInput(inputId = ns("date_range"),
                            label = "Date range", start = "2022-01-01",
                            end = "2022-12-31"
                            ))),

    fluidRow(
      column(3, numericInput(ns("wait_list_current"),
                             "Current waiting list", value = 100)),
      column(3, numericInput(ns("rate_in"), "Rate in to the service",
                                value = 3)),
      column(3, numericInput(ns("rate_out"), "Rate out from the service",
                                value = 4))

    ),
    plotOutput(ns("time_graph"))
  )
}

#' one_node Server Functions
#'
#' @noRd
mod_one_node_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$time_graph <- renderPlot({

      daily_data <- simple_input(wait_list = input$wait_list_current,
                                 rate_in = input$rate_in,
                                 rate_out = input$rate_out,
                                 start_date = input$date_range[1],
                                 end_date = input$date_range[2],
                                 date_unit = "day",
                                 historical = FALSE)

      wait_plot(daily_data)
    })
  })
}
