
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
library(plotly)

shinyServer(function(input, output) {
  
  dados <- read_csv(file = "dados/series_from_imdb.csv") %>% select(series_name, series_ep, season, season_ep, Episode, UserRating, UserVotes)
  
  output$distPlot <- renderPlotly({

    # generate bins based on input$bins from ui.R
    aux <- dados %>% filter(series_name == input$seriesNames) %>% group_by(season)
    #x <- aux$UserRating
    #y <- aux$series_ep
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    plotly(aux, x = ~UserRating, y = ~season_ep)

  })
  
  nomes <- unique(dados %>% select(series_name))
  
  output$seriesNames <- renderUI({
    selectInput("seriesNames", "Escolha uma série", as.list(nomes)) 
  })

})
