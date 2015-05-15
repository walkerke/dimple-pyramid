library(shiny)
library(rcdimple)
source('setup.R')


shinyServer(function(input, output, session) {
  
  # Fetch the data
  pyramid_data <- reactive({
    get_data(input$country, input$year)
  })
  

  output$pyramid <- renderDimple({
    
    max_x <- plyr::round_any(max(pyramid_data()$Population), 10000, f = ceiling)
    min_x <- plyr::round_any(min(pyramid_data()$Population), 10000, f = floor)
    
    pyramid_data() %>%
      dimple(x = "Population", y = "Age", group = "Gender", type = 'bar') %>%
      yAxis(type = "addCategoryAxis", orderRule = "Order") %>%
      xAxis(type = "addMeasureAxis", overrideMax = max_x, overrideMin = min_x) %>%
      add_legend() %>%
      # Here, I'll pass in some JS code to make all the values on the X-axis and in the tooltip absolute values
      tack(., options = list(
        chart = htmlwidgets::JS("
                                function(){
                                var self = this;
                                // x axis should be first or [0] but filter to make sure
                                self.axes.filter(function(ax){
                                return ax.position == 'x'
                                })[0] // now we have our x axis set _getFormat as before
                                ._getFormat = function () {
                                return function(d) {
                                return d3.format(',.0f')(Math.abs(d) / 1000000) + 'm';
                                };
                                };
                                // return self to return our chart
                                return self;
                                }
                                "))
        )
  })
  
})