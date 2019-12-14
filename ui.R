library(jsonlite)
library(geojsonio)
library(dplyr) 
library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(DT)

#analyticsData<-read.csv("LifeExpectancyData.csv")


vars <- names(dataAnalytics)
vars <-vars[-1:-3]

years<-c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012", "2013","2014","2015")

# Define UI for application that draws a histogram
navbarPage("Life expectancy", id="nav",
           
           tabPanel("Interactive Map",
                    
                    div(class="outer",
                        
                          tags$head
                          (
                          # Include our custom CSS
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                           ),
                        
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        
                        leafletOutput("map", width="80%", height="100%"),
                        
                        
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = FALSE, top = 55, left = "auto", right = 10, bottom = "auto",
                                      width = 400, height = "100%",
                                      
                                      h2("Life expectancy in different countries"),
                                      selectInput("typeofyear", "Select years", years),
                                      
                                      selectInput("typeofvariable", "Select variables", vars),
                                      
                                      tableOutput("data")
                                    )
                        )
                    ), 
           
           tabPanel(textOutput('plottitle'),
                    plotOutput("hist1"))
           
          
)