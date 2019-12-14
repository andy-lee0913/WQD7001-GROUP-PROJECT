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
  
  
############################ liyuanze 
output$plottitle <- renderPrint({
  cat("Life.expectancy ~ GDP",target_year())
})

output$hist1 <- renderPlot({
  life2015 <- filter(dataAnalytics, Year == target_year())
  plottitle <- paste("Life.expectancy ~ GDP",target_year())
  ggplot(life2015, aes(GDP, Life.expectancy)) + 
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

}
