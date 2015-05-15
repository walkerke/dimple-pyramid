library(shiny)
library(shinythemes)
library(rcdimple)

source('setup.R')

shinyUI(fluidPage( 
  headerPanel('Interactive population pyramid'),
  sidebarLayout(
  sidebarPanel(  
    selectInput('country', 'Select a country', country_list),
    numericInput('year', 'Year', 2015,
                 min = 1990, max = 2050), 
    textInput("color1", "Color (male)", value = "blue"), 
    textInput("color2", "Color (female)", value = "red"), 
    p("Data come from the ", 
    a("US Census Bureau's International Database. ", 
      href = "http://www.census.gov/population/international/data/idb/informationGateway.php")), 
    br(), 
    p("App author: Kyle Walker, Texas Christian University.  Code on GitHub.")
  ),
  mainPanel(
    dimpleOutput('pyramid', width = "100%")
  )
  )
))