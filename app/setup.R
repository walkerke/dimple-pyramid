# Set up the app - create a function that fetches Census data

library(dplyr)
library(tidyr)
library(rvest)
library(rcdimple)

df <- read.csv('codes.csv')

country_list <- setNames(as.list(df$FIPS), df$Country)

# Function to fetch the data from the US Census Bureau website

get_data <- function(country, year) {
  
  c1 <- "http://www.census.gov/population/international/data/idb/region.php?N=%20Results%20&T=10&A=separate&RT=0&Y="
  
  c2 <- "&R=-1&C="
  
  yrs <- gsub(" ", "", toString(year))
  
  url <- paste0(c1, yrs, c2, country)
  
  df <- url %>%
    html() %>%
    html_nodes("table") %>%
    html_table() %>%
    data.frame()
  
  names(df) <- c("Year", "Age", "total", "Male", "Female", "percent", "pctMale", "pctFemale", "sexratio") 
  
  cols <- c(1, 3:9)
  
  df[,cols] <- apply(df[,cols], 2, function(x) as.numeric(as.character(gsub(",", "", x))))
  
  # Format the table with dplyr and tidyr
  
  df1 <- df %>%
    mutate(Order = 1:nrow(df), 
           Male = -1 * Male) %>%
    filter(Age != "Total") %>%
    select(Year, Age, Male, Female, Order) %>%
    gather(Gender, Population, -Age, -Order, -Year)
  
  df1
}

# Function to build the pyramid

build_pyramid <- function(data) {
  
  max_x <- plyr::round_any(max(data$Population), 10000, f = ceiling)
  min_x <- plyr::round_any(min(data$Population), 10000, f = floor)
  
  format_absolute <- function(viz) {
    
    if (max_x >= 10000000) {
      tack(viz, options = list(
        chart = htmlwidgets::JS("
                                function(){
                                var self = this;
                                // x axis should be first or [0] but filter to make sure
                                self.axes.filter(function(ax){
                                return ax.position == 'x'
                                })[0] // now we have our x axis set _getFormat as before
                                ._getFormat = function () {
                                return function(d) {
                                return d3.format('.0f')(Math.abs(d) / 1000000) + 'm';
                                };
                                };
                                // return self to return our chart
                                return self;
                                }
                                ")))
      
      
    }
    
    else if (max_x >= 1000000 & max_x < 10000000) {
      tack(viz, options = list(
        chart = htmlwidgets::JS("
                                function(){
                                var self = this;
                                // x axis should be first or [0] but filter to make sure
                                self.axes.filter(function(ax){
                                return ax.position == 'x'
                                })[0] // now we have our x axis set _getFormat as before
                                ._getFormat = function () {
                                return function(d) {
                                return d3.format('.1f')(Math.abs(d) / 1000000) + 'm';
                                };
                                };
                                // return self to return our chart
                                return self;
                                }
                                ")))
    } else {
      tack(viz, options = list(
        chart = htmlwidgets::JS("
                                function(){
                                var self = this;
                                // x axis should be first or [0] but filter to make sure
                                self.axes.filter(function(ax){
                                return ax.position == 'x'
                                })[0] // now we have our x axis set _getFormat as before
                                ._getFormat = function () {
                                return function(d) {
                                return d3.format(',.0f')(Math.abs(d) / 1000) + 'k';
                                };
                                };
                                // return self to return our chart
                                return self;
                                }
                                ")))
      
      
      
    }
    
  }
  
  
  d1 <- data %>%
     dimple(x = "Population", y = "Age", group = "Gender", type = 'bar', width = 600, height = 600 ) %>%
        yAxis(type = "addCategoryAxis", orderRule = "Order") %>%
        xAxis(type = "addMeasureAxis", overrideMax = max_x, overrideMin = min_x) %>%
        add_legend() 
  
  d1 %>% format_absolute()
    

  
  
  
}
