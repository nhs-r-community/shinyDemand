#' no_data_one_node UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_no_data_one_node_ui <- function(id){
  ns <- NS(id)
  tagList(

    conditionalPanel(
      "input.showHistory", ns = ns,

      tagList(

        fluidRow(
          column(12,
                 dateRangeInput(inputId = ns("date_range_hx"),
                                label = "Historical date range",
                                start = "2021-01-01",
                                end = "2021-12-31"
                 ),
          )
        ),

        fluidRow(
          column(4, numericInput(ns("wait_list_hx"),
                                 "Waiting list at start of series",
                                 value = 20)),
          column(4, numericInput(ns("rate_in_hx"),
                                 "Historical rate in to the service",
                                 value = 5)),
          column(4, numericInput(ns("rate_out_hx"),
                                 "Historical rate out from the service",
                                 value = 4))
        ),

      )
    ),
    flowLayout(
      checkboxInput(ns("showHistory"), "Show history")
    ),

    fluidRow(
      column(12,
             dateRangeInput(inputId = ns("date_range"),
                            label = "Date range", start = "2022-01-01",
                            end = "2022-12-31"
             ),
      )
    ),
    fluidRow(
      column(4,
             conditionalPanel("!input.showHistory", ns = ns,
                              numericInput(ns("wait_list_current"),
                                           "Current waiting list", value = 100)
             )
      ),
      column(4, numericInput(ns("rate_in"), "Rate in to the service",
                             value = 3)),
      column(4, numericInput(ns("rate_out"), "Rate out from the service",
                             value = 4))

    ),
    plotOutput(ns("time_graph"))
  )
}

#' no_data_one_node Server Functions
#'
#' @noRd
mod_no_data_one_node_server <- function(id, real_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    historical_data <- reactive({

      if(input$load_data){

        simple_input(wait_list = real_data$current_waiting_list,
                     rate_in = real_data$avg_week_ref,
                     rate_out = real_data$avg_week_treat,
                     start_date = real_data$min_date_referrals,
                     end_date = real_data$max_date_referrals,
                     date_unit = real_data$date_unit,
                     historical = TRUE)

      } else {

        simple_input(wait_list = input$wait_list_hx,
                     rate_in = input$rate_in_hx,
                     rate_out = input$rate_out_hx,
                     start_date = input$date_range_hx[1],
                     end_date = input$date_range_hx[2],
                     date_unit = "day",
                     historical = TRUE)
      }
    })

    daily_data <- reactive({

      wait_list_current <- ifelse(input$showHistory,
                                  tail(historical_data()$n, 1),
                                  input$wait_list_current)

      simple_input(wait_list = wait_list_current,
                   rate_in = input$rate_in,
                   rate_out = input$rate_out,
                   start_date = input$date_range[1],
                   end_date = input$date_range[2],
                   date_unit = "day",
                   historical = FALSE)

    })

    output$time_graph <- renderPlot({

      if(input$showHistory){

        wait_plot(rbind(historical_data(), daily_data()))
      } else {

        wait_plot(daily_data())
      }
    })
  })
}
