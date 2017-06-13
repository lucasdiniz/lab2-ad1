
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(shinysky)
library(tidyverse)
library(plotly)

shinyServer(function(input, output) {
  
  dados <- read_csv(file = "dados/series_from_imdb.csv") %>% select(series_name, series_ep, season, season_ep, Episode, UserRating, UserVotes)
  
  output$distPlot <- renderPlotly({

    # generate bins based on input$bins from ui.R
    dadosFiltrados <- dados %>% filter(series_name == input$seriesNames) %>% mutate(season = paste("Temporada", season))
    #x <- aux$UserRating
    #y <- aux$series_ep
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    
    maxRow = dadosFiltrados[which.max(dadosFiltrados$UserRating),]
    minRow = dadosFiltrados[which.min(dadosFiltrados$UserRating),]
    
    maxAndMin <- rbind(minRow, maxRow)
    
    a = list(
      x = maxAndMin$season_ep,
      y = maxAndMin$UserRating,
      text = c("Pior episodio", "Melhor episodio"),
      xref = "x",
      yref = "y",
      ax = 30,
      showarrow = TRUE,
      arrowhead = 2,
      arrowsize = .5,
      font = list(family = "bank gothic", size = 14),
      xanchor = "left"
    )
    
    l <- list(
      x = 1.05,
      y = 0.1,
      font = list(
        family = "bank gothic",
        size = 10,
        color = "#000"),
      bgcolor = "white",
      bordercolor = "white",
      borderwidth = 1)
    
    
    
    plot_ly(dadosFiltrados,
            x = ~season_ep,
            y = ~UserRating,
            color = ~as.character(season),
            type = "scatter",
            mode = "lines+markers",
            colors = "Set1",
            marker = list(size = ~UserVotes/input$sizePoints),
            text = ~paste("<b>Episodio",season_ep, "</b><br>" , Episode, "<br>Nota: ", UserRating, "<br>Total de votos:", UserVotes),
            hoverinfo = "text",
            source = "subset"
            ) %>%
      layout(
        autosize = TRUE,
        title = ~paste("Evolução do rating de", series_name),
        xaxis = list(title = "Episódio da Temporada"),
        yaxis = list(title = "Rating dos usuários"),
        annotations = a,
        legend = l
      )

  })
  
  output$seriesNames <- renderUI({
    nomes <- as.list(unique(dados %>% arrange(series_name) %>% select(series_name)))

    selectInput("seriesNames", "Escolha uma série", nomes) 
  })
  
  output$plotSelected <- renderPrint({
    event.data <- event_data("plotly_selected", source = "subset")
    if(is.null(event.data) == T) return(NULL)
    else     
      as.list(event.data)
       teste <- subset(plot.df, Class == "malignant")[subset(event.data, curveNumber == 0)$pointNumber + 1,]
 
       #https://plot.ly/r/shiny-coupled-events/
        #    plot_ly(plot.summ, x = ~Class, y = ~Count, type = "bar", source = "select", color = ~Class) %>%
   #   layout(title = "No. of Malignant and Benign cases <br> in Selection",
    #         plot_bgcolor = "6A446F",
     #        yaxis = list(domain = c(0, 0.9)))
  })
    
})

