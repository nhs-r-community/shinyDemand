#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  if(exists("return_data")){

    real_data <- return_data("tm378")
  }

  mod_one_node_server("one_node_1", real_data = real_data)
}
