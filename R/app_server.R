#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # if the data functions exist then load them

  if(get_golem_config("location") == "nottshc"){

    source("data_functions.R")

    # note this should return a function called "return_data"
    # see Roxygen of data_functions.R for more
  }

  output$team_selectUI <- renderUI({

    team_ui_function()
  })

  observe(

    if(input$load_data){

      req(input$select_team)

      # real_data <- return_data("tm378")

      real_data <- return_data(input$select_team)

      mod_data_one_node_server("data_one_node_1", real_data = real_data)
    }
  )


  mod_no_data_one_node_server("no_data_one_node_1")

}
