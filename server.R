
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
  
  dados <- read_csv(file = "dados/series_from_imdb.csv") %>% select(series_name, series_ep, season, season_ep, Episode, UserRating, UserVotes,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10)
  
  output$distPlot <- renderPlotly({

    # generate bins based on input$bins from ui.R
    dadosFiltrados <- dados %>% filter(series_name == input$seriesNames)
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
    
    
    
    plot_ly(dadosFiltrados %>% mutate(season = paste("Temporada", season)),
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
  
  output$plotSelected <- renderPlotly({
    event.data <- event_data("plotly_selected", source = "subset")
    if(is.null(event.data) == T) return(NULL)
    else {    
      dadosFiltrados <- dados %>% filter(series_name == input$seriesNames)
      #as.list(event.data)
      teste <- dadosFiltrados %>% filter((as.integer(substr(season, 0, length(season))) - 1) %in% event.data$curveNumber & 
                                           season_ep %in% event.data$x & 
                                           UserRating %in% event.data$y)
       #teste
       #https://plot.ly/r/shiny-coupled-events/
            plot_ly(teste , x = ~season_ep, y = ~UserRating, type = "bar", color = ~as.character(season), colors = "Set2")
    }
  })
  
  output$pointInfo <- renderPlotly({
    
    event.data <- event_data("plotly_click", source = "subset")
    if(is.null(event.data)) return(NULL)
    else{
      dadosFiltrados <- dados %>% filter(series_name == input$seriesNames)
      #as.list(event.data)
      teste <- dadosFiltrados %>% filter((as.integer(substr(season, 0, length(season))) - 1) %in% event.data$curveNumber & 
                                           season_ep %in% event.data$x & 
                                           UserRating %in% event.data$y)
      
      plot_ly(teste, x = ~c(1,2,3,4,5,6,7,8,9,10), y = ~c(r1*100,r2*100,r3*100,r4*100,r5*100,r6*100,r7*100,r8*100,r9*100,r10*100), type = "bar") %>% layout(yaxis = list(title = "Porcentagem do total de notas"), xaxis = list(title = "Nota"))
    }
    
  })
    
})

