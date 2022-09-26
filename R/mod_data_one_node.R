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
    ),

    fluidRow(
      column(4, uiOutput(ns("end_dateUI"))

      ),
      column(4, numericInput(ns("rate_in"), "Rate in to the service",
                             value = 4)),
      column(4, numericInput(ns("rate_out"), "Rate out from the service",
                             value = 4))

    ),
    plotOutput(ns("time_graph"))
  )
}

#' data_one_node Server Functions
#'
#' @noRd
mod_data_one_node_server <- function(id, real_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$end_dateUI <- renderUI({

      dateInput(inputId = ns("end_date"),
                label = "End date", value = max(historical_data()$date + 366)
      )
    })

    output$hx_info <- renderText({

      # glue together date range, waiting list, rate in and out

      glue::glue("First date in series: {real_data$min_date_referrals}<br>",
                 "Last date in series: {real_data$max_date_referrals}<br>",
                 # "Waiting list at start of intervention:
                 #   {tail(historical_data()$n, 1)}<br>",
                 "Average weekly referrals in:
                   {round(real_data$avg_week_ref, 1)}<br>",
                 "Average weekly referrals assessed:
                   {round(real_data$avg_week_ax, 1)}<br>",
                 "Average weekly referrals discharged:
                   {round(real_data$avg_week_ref *
                   (1 - real_data$ref_to_ax), 1)}")
    })

    historical_data <- reactive({

      simple_input(wait_list = 0, # THIS IS WRONG
                   rate_in = real_data$avg_week_ref * real_data$ref_to_ax,
                   rate_out = real_data$avg_week_ax,
                   start_date = real_data$min_date_referrals,
                   end_date = real_data$max_date_referrals,
                   date_unit = "week",
                   historical = TRUE)
    })

    daily_data <- reactive({

      simple_input(#wait_list = real_data$current_waiting_list,
                   wait_list = tail(historical_data()$n, 1),
                   rate_in = input$rate_in,
                   rate_out = input$rate_out,
                   start_date = max(historical_data()$date + 1),
                   end_date = input$end_date,
                   date_unit = "week",
                   historical = FALSE)
    })

    output$time_graph <- renderPlot({

      plot_data <- rbind(historical_data(), daily_data())

      wait_plot(plot_data)
    })
  })
}
