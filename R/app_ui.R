#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    dashboardPage(
      dashboardHeader(title = "Demand and capacity"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("One node", tabName = "one_node", icon = icon("dashboard")),
          # menuItem("Two nodes", tabName = "two_nodes", icon = icon("th")),
          checkboxInput("load_data", "Load data?", value = TRUE),
          uiOutput("team_selectUI")

        )
      ),
      dashboardBody(
        tabItems(
          tabItem(tabName = "one_node",
                  h1("One node"),
                  conditionalPanel("!input.load_data",
                                   mod_no_data_one_node_ui("no_data_one_node_1")

                  ),
                  conditionalPanel("input.load_data",
                                   mod_data_one_node_ui("data_one_node_1")
                  )

          ),

          # Second tab content
          tabItem(tabName = "two_nodes",
                  h2("Widgets tab content")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "demandAndCapacity"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
