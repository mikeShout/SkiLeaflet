#
# This is a leaflet Shiny web app for the Week 2 assignment  
# in the John Hopkins Coursera course on Data Products

library(shiny)
library(leaflet)

#setwd("C:/Users/Mike/OneDrive/MOOCs/DataProducts/w2 Assignment/SkiLeaflet/SkiLeaflet")
skiData <- read.csv("ski_resort_stats.csv")
skiData[is.na(skiData)] <- 0
states <- data.frame(st = unique(skiData[,2]))
states <- rbind(data.frame(st = "All"), states)

# Application UI includes a sidebar where you can adjust map settings and
# a main panel that displays the leaflet map

shinyUI(fluidPage(
  
  # Application title
  titlePanel("North American Ski Resorts - Leaflet Example"),
  
  h4("Published:"),
  h4(textOutput("datePub")),
  p(),
  
  # Sidebar with slider inputs for map settings 
  sidebarLayout(
    sidebarPanel(

            sliderInput("vertical",
                   "Vertical",
                   min = min(skiData$vertical),
                   max = max(skiData$vertical),
                   value = range(skiData$vertical)),
            
            sliderInput("pBlack",
                        "Percent Black Runs",
                        min = min(skiData$black_percent),
                        max = max(skiData$black_percent),
                        value = range(skiData$black_percent)),
            
            sliderInput("acreage",
                        "Ski Resort Acreage",
                        min = min(skiData$acres),
                        max = max(skiData$acres),
                        value = range(skiData$acres)),
            
            selectInput("state", "State", states, selected = "All", multiple = FALSE, selectize = TRUE),
            h4("Use the sliders and drop-down menu to filter the results")
    ),
    
    # Show the ski map
    mainPanel(
      leafletOutput("skiMap"),
      h4("Click on the marker to see the names of the ski resort"),
      h4("The blue ring under the marker shows the relative size of the ski resort in acres")
    )
  )
))
