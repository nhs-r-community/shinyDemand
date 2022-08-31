# shinyDemand

Show, tune, explore, and download simple and complex demand and capacity analyses, of the kind that might be used in UK health and social care settings.

This is a Shiny package built in [{golem}](https://thinkr-open.github.io/golem/). Early development will focus on adding a very simple model which merely models a simple referral -> assessment -> discharge pathway, but the hope is that the Shiny controls and outputs can be used with more complex models, of the type which might be used in, e.g., [{simmer}](https://r-simmer.org/).

Note that this repo includes a dependency on a private package called nottshcData and a code file called data_functions.R which will not run outside of Nottinghamshire Healthcare NHS Trust. Remove the dependency and the file to use it in your own context (you may wish to replace the file with code that will load data in your own case). This is a rather unpleasant hack that is being done temporarily during development, over time hopefully the code will mature and others will become involved and then this material will be improved. 

Install and run easily:

    remotes::install_github("https://github.com/nhs-r-community/shinyDemand")
    shinyDemand::run_app()
