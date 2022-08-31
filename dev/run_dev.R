
# if the data functions exist then load them

if(file.exists("data_functions.R")){

  source("data_functions.R")

  # note this should return a function called "return_data"
  # see Roxygen of data_functions.R for more
}

# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Comment this if you don't want the app to be served on a random port
options(shiny.port = httpuv::randomPort())

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Run the application
run_app()
