
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyUI(fluidPage(
  
  # Application title
  titlePanel(div("Explore dados sobre a classificação de 600+ séries no IMDB", class="text-center"), windowTitle = "SeriesExplorer"),
  br(),br(),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("seriesNames"),
      sliderInput("sizePoints",
                  "Tamanho dos pontos:",
                  ticks = FALSE,
                  min = 10,
                  max = 1000,
                  value = 40),
      
      tags$script(HTML("
        $(document).ready(function() {setTimeout(function() {
                       supElement = document.getElementById('sizePoints').parentElement;
                       $(supElement).find('span.irs-max, span.irs-min, span.irs-single, span.irs-from, span.irs-to').remove();
                       }, 50);})
                       ")
                ),
      
      plotlyOutput("plotSelected"),
      helpText("Instruções:"),
      helpText("1 - Selecione a série desejada"),
      helpText("2 - Clique em um episodio para obter informaçoes sobre as notas desse episodio"),
      helpText("3 - Selecione alguns pontos no gráfico para compara-los separadamente"),
      helpText("4 - O tamanho dos pontos representa o total de votos recebidos, caso estejam muito grandes você pode diminui-los")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(            
      plotlyOutput("distPlot"),
      br(),
      plotlyOutput("pointInfo")
    )
  )
))
