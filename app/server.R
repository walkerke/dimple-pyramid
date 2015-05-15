library(shiny)
library(rcdimple)

source('setup.R')


shinyServer(function(input, output, session) {
  
  # Fetch the data
  pyramid_data <- reactive({
    get_data(input$country, input$year)
  })
  

  output$pyramid <- renderDimple({
    
    pyramid_data() %>%
      build_pyramid() %>%
      default_colors(input$color1, input$color2)
        
  })
  
})