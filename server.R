library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(rlang)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(DT)
library(plotly)
library(hrbrthemes)
#analyticsData<-read.csv("LifeExpectancyData.csv")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  target_year = reactive({
    
    input$typeofyear
    
  })

  
  
  
  target_quo = reactive ({
    
    parse_quosure(input$typeofvariable)
  })
  
  #analytics$Country[analytics$Year==2013]
  #target_year() target_quo()
  
  
  
  
  dftable<-reactive({
   
    #analytics[which(analytics$Year==target_year(),]
    
    #analyticsData%>% arrange(desc(!!target_quo()))
    
    #analyticsData[which(analyticsData$Year== target_year()), ]
    
    analytics=filter(dataAnalytics,Year== target_year())
    
    arrange(analytics,desc(!!target_quo()))
    
    
   # analytics$Country[analytics$Year%in%target_year()]
                        
  })
  
  
  
# dftable<-  reactive ({
   
 #  analyticsData%>%
#      arrange(desc(!!target_quo()))
 # }
 
 
 
 dfmap<-reactive ({
   
   analytics2<-filter(dataAnalytics,Year==target_year())
   CountryData_<-left_join(Df1,analytics2,by="Country")
   CountryData_%>%select(input$typeofvariable)
   
   #dataAnalytics
   
   #dat<-dataAnalytics %>%filter(Year==target_year())%>%group_by(Country)
   #CountryData2<-left_join(Df1,dat,by="Country")
   #CountryData2%>%select(input$typeofvariable)
   
   #d1%>%select(input$typeofvariable)
   
   
   #analytics=filter(dataAnalytics,Year==target_year())
   #arrange(analytics,Country)
   #analytics%>%select(input$typeofvariable)
   
   })
  
  
  
  ## Interactive Map  liuhongyang###########################################
  
  # Create the map
 
 
 
  output$map <- renderLeaflet({
    leaflet(geojson) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                  attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>')%>%
      addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5,
                  label = paste(CountryData$Country, ":", dfmap()[,1]),
                  color = pal(rescale(dfmap()[,1],na.rm=TRUE))
                 
                  
      )%>%
      setView(lng = 0, lat = 40, zoom = 2) %>%
      addLegend("bottomleft",pal = pal, 
              
                 values =c(0:1), opacity = 0.7)
  })
  
output$data <- renderTable({
  
  head((dftable()[, c("Country", input$typeofvariable), drop = FALSE]) ,10)
  
}, rownames = TRUE)
############################
  
#############################
# tab GDP #
#############################
output$plottitle <- renderPrint({
  cat("Lifespan ~ GDP,mortality,diseases in ",input$slider1)
})

output$hist1 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ GDP in", input$slider1)
  ggplot(life2015, aes(GDP, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_economist() +
    labs(title = plottitle)
})

output$hist2 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ infant deaths in", input$slider1)
  ggplot(life2015, aes(infant.deaths, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_solarized() +
    labs(title = plottitle)
})

output$hist3 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ adult mortality in", input$slider1)
  ggplot(life2015, aes(Adult.Mortality, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_economist() +
    labs(title = plottitle)
})

output$hist4 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ HIV.AIDS in", input$slider1)
  ggplot(life2015, aes(HIV.AIDS, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_solarized() +
    labs(title = plottitle)
})

output$hist5 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ Diphtheria in", input$slider1)
  ggplot(life2015, aes(Diphtheria, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_economist() +
    labs(title = plottitle)
})

output$hist6 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ Measles in", input$slider1)
  ggplot(life2015, aes(Measles, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_solarized() +
    labs(title = plottitle)
})

output$hist7 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == input$slider1)
  plottitle <- paste("Life.expectancy ~ Hepatitis.B in", input$slider1)
  ggplot(life2015, aes(Hepatitis.B, Life.expectancy)) + 
    geom_point(aes(color = Status)) +
    geom_smooth() +
    theme_economist() +
    labs(title = plottitle)
})
############################

############################ liuhongyang
output$table <- DT::renderDataTable({
  DT::datatable(dataAnalytics)
})
############################

############################
#  tab 'Health Expenditure'#
############################
defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
series <- structure(
  lapply(defaultColors, function(color) { list(color=color) }),
  names = levels(dataAnalytics$Status)
)

yearData <- reactive({
  # Filter to the desired year, and put the columns
  # in the order that Google's Bubble Chart expects
  # them (name, x, y, color, size). Also sort by region
  # so that Google Charts orders and colors the regions
  # consistently.
  df_expenditure <- dataAnalytics %>%
    filter(Year == input$year) %>%
    select(Country, Total.expenditure, Life.expectancy, Status,Population)
  
})

output$chart <- reactive({
  # Return the data and options
  list(
    data = googleDataTable(yearData()),
    options = list(
      title = sprintf(
        "Life Expectancy against Health Expenditure by Country, %s",
        input$year),
      series = series
    )
  )
})
########################################
# life expectancy changes with time
########################################
output$plot1 <- renderPlotly({
  # Usual area chart
  p <- data %>%
    select(Country, Year, Life.expectancy ) %>%
    filter(Country == input$typeOfCountry) %>%
    ggplot( aes(x= Year, y=Life.expectancy)) +
    geom_area(fill="#69b3a2", alpha=0.5) +
    geom_line(color="#69b3a2") +
    ylab("life expectancy")+ 
    ggtitle("Life expectancy changes with time") 
  theme_ipsum()
  print(
    ggplotly(p))
  
})

}
