#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(lubridate)

skiData <- read.csv("ski_resort_stats.csv")
skiData[is.na(skiData)] <- 0
states <- data.frame(st = unique(skiData[,2]))
states <- rbind(data.frame(st = "All"), states)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  # Put today's date in sidepanel 
  output$datePub <- renderText(format(today(), "%d %b %g"))
  
  output$skiMap <- renderLeaflet({
    minV <- input$vertical[1]
    maxV <- input$vertical[2]
    minB <- input$pBlack[1]
    maxB <- input$pBlack[2]
    minA <- input$acreage[1]
    maxA <- input$acreage[2]
    
    skiDataFiltered <- skiData[skiData$vertical >= minV & skiData$vertical <= maxV & skiData$black_percent >= minB & skiData$black_percent <= maxB & skiData$acres >= minA & skiData$acres <= maxA,]
    
    ifelse(input$state == "All",
            skiDataFiltered <- skiData[skiData$vertical >= minV & skiData$vertical <= maxV & skiData$black_percent >= minB & skiData$black_percent <= maxB & skiData$acres >= minA & skiData$acres <= maxA,],
            skiDataFiltered <- skiData[skiData$state == input$state & skiData$vertical >= minV & skiData$vertical <= maxV & skiData$black_percent >= minB & skiData$black_percent <= maxB & skiData$acres >= minA & skiData$acres <= maxA,]
                  )
    
    skiDataFiltered %>% leaflet %>% addTiles() %>% addCircles(weight=2, radius = (skiDataFiltered$acres*3)) %>% addMarkers(popup = skiDataFiltered$resort_name)
    
  })
  
})
