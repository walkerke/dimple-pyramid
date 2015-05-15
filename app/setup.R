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
  
  
  
  
  
}
