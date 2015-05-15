library(shiny)
library(rcdimple)

source('setup.R')

shinyUI(pageWithSidebar(
  headerPanel('Interactive population pyramid'),
  sidebarPanel(
    selectInput('country', 'Select a country', country_list),
    numericInput('year', 'Year', 2015,
                 min = 1990, max = 2050), 
    textInput("color1", "Color (male)", value = "red"), 
    textInput("color2", "Color (female)", value = "blue")
  ),
  mainPanel(
    dimpleOutput('pyramid', width = "100%")
  )
))