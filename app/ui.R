library(shiny)
library(shinythemes)
library(rcdimple)

source('setup.R')

shinyUI(fluidPage(theme = shinytheme("flatly"),  
  headerPanel('Interactive population pyramid with Dimple.js'),
  sidebarLayout(
  sidebarPanel(  
    selectInput('country', 'Select a country', country_list),
    numericInput('year', 'Year', 2015,
                 min = 1990, max = 2050), 
    textInput("color1", "Color (male)", value = "blue"), 
    textInput("color2", "Color (female)", value = "red"),
    downloadButton('downloadPage', "Download HTML"), 
    p("Data come from the ", 
    a("US Census Bureau's International Database. ", 
      href = "http://www.census.gov/population/international/data/idb/informationGateway.php")), 
    br(), 
    p("App author: ", 
      a("Kyle Walker, Texas Christian University.  ", 
        href = "http://personal.tcu.edu/kylewalker"), 
      a("Code on GitHub.", href = ""))
  ),
  mainPanel(
    dimpleOutput('pyramid', width = "100%")
  )
  )
))