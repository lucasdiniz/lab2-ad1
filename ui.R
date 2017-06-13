
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
require(shinysky)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("seriesNames"),
      sliderInput("sizePoints",
                  "Tamanho dos pontos:",
                  ticks = FALSE,
                  min = 10,
                  max = 1000,
                  value = 300),
      
      tags$script(HTML("
        $(document).ready(function() {setTimeout(function() {
                       supElement = document.getElementById('sizePoints').parentElement;
                       $(supElement).find('span.irs-max, span.irs-min, span.irs-single, span.irs-from, span.irs-to').remove();
                       }, 50);})
                       ")
                ),
      
      verbatimTextOutput("plotSelected")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(            
      plotlyOutput("distPlot")
    )
  )
))
