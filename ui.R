
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
  br(),
  p("O IMDB é uma excelente ferramenta colaborativa onde os seus usuários podem dar notas para os
     episódios de suas séries favoritas (ou odiadas). E com os dados sobre a classificação dos 
     episódios de MAIS DE 600 SÉRIES podemos responder muitas perguntas interessantes. A segunda temporada de Dexter foi
     melhor do que a primeira? Será que House tem mais público do que Supernatural? Qual o pior episódio dos Simpsons?
     Todas essas são perguntas que podemos responder com os dados dos gráficos! Explore a vontade, as instruções de uso estão na barra lateral. Boa diversão :)
     "),
  br(),
  
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
      helpText("2 - Clique em um ponto no gráfico para obter informaçoes sobre as notas desse episodio"),
      helpText("3 - Usando a ferramenta \"Box Select\" ou \"Lasso Select\" no canto superior direito do gráfico selecione alguns pontos para compara-los separadamente"),
      helpText("4 - O tamanho dos pontos representa o total de votos dados pelos usuários para aquele episódio" ,em("(será que a partir daí podemos inferir qual série tem maior público?)"), "caso estejam muito grandes você pode diminui-los"),
      helpText("5 - As legendas dos gráficos são interativas :)")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(            
      plotlyOutput("distPlot"),
      br(),
      plotlyOutput("pointInfo")
    )
  )
))
