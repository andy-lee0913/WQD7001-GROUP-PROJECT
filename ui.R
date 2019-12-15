library(jsonlite)
library(geojsonio)
library(dplyr) 
library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(DT)
library(googleCharts)
<<<<<<< HEAD
library(ggplot2)
library(ggthemes)
library(plotly)
library(hrbrthemes)
=======
library(plotly)
>>>>>>> add new tabs

analyticsData<-read.csv("LifeExpectancyData.csv")


vars <- names(dataAnalytics)
vars <-vars[-1:-3]

years<-c("2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012", "2013","2014","2015")

xlim <- list(
  min = 0,
  max = 15
)

ylim <- list(
  min = 40,
  max = 100
)

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
                                      
                                      h2("worldwide data related to Life expectancy"),
                                      selectInput("typeofyear", "Select years", years),
                                      
                                      selectInput("typeofvariable", "Select variables", vars),
                                      
                                      tableOutput("data")
                                    )
                        )
                    ), 
           
           #############################
           # tab GDP disease mortality #
           #############################
           tabPanel("Lifespan ~ GDP",
                    sliderInput('slider1','choose the year you want to check',
                                           2000, 2015, 2003),
                        plotOutput("hist1")
                      ),

          tabPanel("Lifespan ~ mortality",
                   sliderInput('slider2','choose the year you want to check',
                               2000, 2015, 2003),
                   plotOutput("hist2"),
                   plotOutput("hist3")
                   ),
          
          tabPanel("Lifespan ~ diseases",
                   sliderInput('slider3','choose the year you want to check',
                               2000, 2015, 2003),
                   plotOutput("hist4"),
                   plotOutput("hist5"),
                   plotOutput("hist6"),
                   plotOutput("hist7")
                   ),
           ###########################
           
            # tab 'DataSearch'
            tabPanel("DataSearch",DTOutput(outputId = "table")),
           
           ###########################
           # tab 'Health Expenditure #
           ###########################
           tabPanel(title = "Health Expenditure",
                    googleChartsInit(),
                    
                    # use google webfront source sans pro
                    tags$link(
                      href=paste0("http://fonts.googleapis.com/css?",
                                  "family=Source+Sans+Pro:300,600,300italic"),
                      rel="stylesheet", type="text/css"),
                    
                    tags$style(type="text/css",
                               "body {font-family: 'Source Sans Pro'}"
                    ),
                    
                    googleBubbleChart("chart",
                                      width = "100%", height = "500px",
                                      options = list(
                                        fontName = "sans-serif",
                                        fontSize = 13, 
                                        # axis labels and ranges
                                        hAxis = list(
                                          title = "Health expenditure (%)",
                                          viewWindow = xlim
                                        ),
                                        vAxis = list(
                                          title = "Life expectancy (years)",
                                          viewWindow = ylim
                                        ),
                                        chartArea = list(
                                          top = 50, left = 75,
                                          height = "75%", width = "75%"
                                        ),
                                        # to allow zoom in/out
                                        explorer = list(),
                                        bubble = list(
                                          opacity = 0.30,
                                          stroke = "none",
                                          textStyle = list(
                                            fontSize = 8
                                          )
                                        ),
                                        
                                        #set fonts
                                        titleTextStyle = list(
                                          fontSize =16
                                        ),
                                        tooltip = list(
                                          textStyle = list(
                                            fontSize = 12
                                          )
                                        ),
                                        colorAxis = list(
                                          colors = list(
                                            'yellow', 'red', 'blue', 'green', 'orange', 'pink', 'grey', 'purple', 'magenta', 'cyan', 'beige', 'lavender', 'gold'
                                          )
                                        ),
                                        sizeAxis = list(
                                          minSize = 5, 
                                          maxSize = 20,
                                          minValue = min(dataAnalytics$Population),
                                          maxValue = max(dataAnalytics$Population)
                                        ),
                                        animation = list(
                                          'duration'=1000,
                                          'easing' = 'inAndOut'
                                        )
                                      )
                    ),
                    fluidRow(
                      shiny::column(10,
                                    sliderInput("year", "Select the year",
                                                min = min(dataAnalytics$Year), max = max(dataAnalytics$Year),
                                                value = min(dataAnalytics$Year), step = 1, animate = TRUE)
                      )
                      
                    )
           ),
           #############################
           # tab Life.expectancy ~ Year #
           #############################
           tabPanel(  title = "Life expectancy changes with time",
                      
                      sidebarLayout(
                        sidebarPanel(
                        selectInput("typeOfCountry", h4("Select countries"), choices = levels(analyticsData$Country),selected=levels(analyticsData$Country)[35]),
                        ),
                        mainPanel(
                        plotlyOutput("plot1"),),
                        position = c("left", "right")
                        )
           )
          
)
