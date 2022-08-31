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

    "Hello!"

  )
}

#' data_one_node Server Functions
#'
#' @noRd
mod_data_one_node_server <- function(id, real_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}
