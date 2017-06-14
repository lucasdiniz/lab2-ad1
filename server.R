
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
library(plotly)


options(shiny.error = function() {
  stop()
})


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
    
    
   plot_ly(
            dadosFiltrados %>% mutate(season = paste("Temporada", season)),
            x = ~season_ep,
            y = ~UserRating,
            color = ~as.character(season),
            type = "scatter",
            mode = "lines+markers",
            colors = "Set1",
            marker = list(size = ~UserVotes * input$sizePoints/50000),
            text = ~paste("<b>Episodio",season_ep, "</b><br>" , Episode, "<br>Nota: ", UserRating, "<br>Total de votos:", UserVotes,"<br><b>Clique para ver mais!</b>"),
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
            plot_ly(teste %>% mutate(season = paste("Temporada", season)),
                    x = ~season_ep,
                    y = ~UserRating,
                    type = "bar",
                    color = ~season,
                    colors = "Set2",
                    text = ~paste("<b>Episodio",season_ep, "</b><br>" , Episode, "<br>Nota: ", UserRating, "<br>Total de votos:", UserVotes),
                    hoverinfo = "text") %>% 
              layout(
                title = "Comparando separadamente",
                xaxis = list(title = "Episódio da temporada"),
                yaxis = list(title = "Rating dos Usuários")
              )
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
      xvalues <- c(1,2,3,4,5,6,7,8,9,10)
      yvalues <- c(teste$r1*100,teste$r2*100,teste$r3*100,teste$r4*100,teste$r5*100,teste$r6*100,teste$r7*100,teste$r8*100,teste$r9*100,teste$r10*100)
      
      
      plot_ly(teste, x = ~xvalues,
              y = ~yvalues,
              type = "bar", text = ~paste0("<b>", format(yvalues, digits = 2),"%</b> de Notas entre ",xvalues-1," e ",xvalues),
              hoverinfo = "text") %>% 
        layout(title = ~paste("Temporada", season, "Episodio", season_ep),
              yaxis = list(title = "Porcentagem do total de notas"), 
               xaxis = list(title = "Nota"))
    }
    
  })
    
})

