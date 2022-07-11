# shinyDemand

Show, tune, explore, and download simple and complex demand and capacity analyses, of the kind that might be used in UK health and social care settings.

This is a Shiny package built in [{golem}](https://thinkr-open.github.io/golem/). Early development will focus on adding a very simple model which merely models a simple referral -> assessment -> discharge pathway, but the hope is that the Shiny controls and outputs can be used with more complex models, of the type which might be used in, e.g., [{simmer}](https://r-simmer.org/).

Install and run easily:

    remotes::install_github("https://github.com/nhs-r-community/shinyDemand")
    shinyDemand::run_app()
