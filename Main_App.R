# IE6600 Final Project 
# Group member: Gen Li, Zhichun Li, Lingyun Ding, Fante Meng
# Due date: 12/11/2022


library(shiny)
library(ggplot2)
library(markdown)
library(leaflet)
library(RColorBrewer)
library(shinythemes)
library(tidyverse)
library(packcircles)
library(viridis)
library(ggiraph)
library(extrafont)
library(dplyr)
library(plotly)
library(gapminder)
library(fmsb)

theme = "styles.css"

source("www/functions/bubble_plot.R")
source("www/functions/web_plot.R")

# clean data
# page1
charger=read.csv("alt_fuel_stations.csv")
charger$Open.Date[charger$Open.Date=='0022-07-22']='2022-07-22'
charger$Open.Date=charger$Open.Date %>% as.Date()

EVPD <- read_csv('Electric_Vehicle_Population_Data.csv', guess_max = 620000)
EVPD=filter(EVPD,State=="WA")
EVPD2 <- EVPD%>%
  group_by(`Postal Code`,`Model Year`, Make) %>%
  summarise(count = n())
usZipGeo <- read.csv("usZipGeo.csv", sep = ";")
usZipGeo$`Postal Code`= usZipGeo$Zip
usZipGeo_1 <- select(usZipGeo, `Postal Code`, Longitude, Latitude)
EVPD3 <- left_join(EVPD2, usZipGeo_1, by = c("Postal Code"))
EVPD3$`Model Year`=as.Date(paste(EVPD3$`Model Year`, 1, 1, sep = "-"))
names(EVPD3)[names(EVPD3) == 'count'] <- 'carcount'
EVPD3

#----------------------------------------------------------------------------------------------------------- 
# page2
evp <- read_csv("Electric_Vehicle_Population_Data.csv")
station <- read_csv("alt_fuel_stations.csv")
head(station)
head(evp)


# vehichles: select columns that we need and store into a new dataframe
new_evp <- evp %>% select(`VIN (1-10)`, County, City, State, `Postal Code`,
                          `Model Year`, Make,
                          Model, `Electric Vehicle Type`,
                          `Electric Range`, `Electric Utility`)
# replace missing values with 0
new_evp$Model[is.na(new_evp$Model)] <- 'None'
new_evp$`Electric Utility`[is.na(new_evp$`Electric Utility`)] <- 'None'
# validate if any columns have missing values
which(colSums(is.na(new_evp)) > 0)
# rename column names
new_evp <- new_evp %>%
  rename(
    VIN = `VIN (1-10)`,
    County = County,
    City = City,
    State = State,
    PostalCode = `Postal Code`,
    ModelYear = `Model Year`,
    Make = Make,
    Model = Model,
    ElectricVehicleType = `Electric Vehicle Type`,
    ElectricRange = `Electric Range`,
    ElectricUtility = `Electric Utility`
  )


# fuel station: select columns that we need and store into a new dataframe
new_station <- station %>%
  select(`Fuel Type Code`, City, State, ZIP, `EV Level1 EVSE Num`,
         `EV Level2 EVSE Num`, `EV DC Fast Count`, `EV Connector Types`,'Open Date')
# replace missing values with 0
new_station[is.na(new_station)] <- 0
# validate if any columns have missing values
which(colSums(is.na(new_station)) > 0)
# rename column names
new_station <- new_station %>%
  rename(
    FuelTypeCode = `Fuel Type Code`,
    City = City,
    State = State,
    PostalCode = ZIP,
    Level1 = `EV Level1 EVSE Num`,
    Level2 = `EV Level2 EVSE Num`,
    Level3 = `EV DC Fast Count`,
    ConnectorTypes = `EV Connector Types`
  )

# webplot: extract make that have at least four models
all_make_names <- unique(as.character(new_evp$Make))
makeList <- list()
i = 1
for (make_name in all_make_names){
  model_names <- new_evp %>% filter(Make == make_name) %>% select(Model) %>% distinct(Model)
  if (nrow(model_names) >= 3) {
    makeList[i] <- make_name
    i=i+1
  }
}

#########################################################################################
# UI
ui <- bootstrapPage(
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             # credit to: https://github.com/eparker12/nCoV_tracker/blob/master/app.R
             HTML('<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#">WA EV Tracker</a>'), id="nav",
             windowTitle = "WA ElectV Tracker",
           
  # First page 
  tabPanel("Map",
           div(class="outer",
               # credit to: https://github.com/eparker12/nCoV_tracker/blob/master/styles.css
               # adjust the map position by styles.css
               tags$head(includeCSS("styles.css")),
               # credit to: https://rstudio.github.io/leaflet/shiny.html
             leafletOutput("map", width = "100%", height = "100%"),
             absolutePanel(id = "control", class = "panel panel-default",
                           top = 75, left = 55, width = 400, fixed=TRUE,
                           draggable = TRUE, height = "auto",align='center',
                           sliderInput("range", "Date", min(charger$Open.Date), max(charger$Open.Date),
                                       value = range(charger$Open.Date), step = 0.1
                           ),
                           checkboxInput("charge", "Show Charging Station", FALSE),
                     
                          
             ))
             ), 
  
  # Second page
  tabPanel("Graphic",
           headerPanel('Apply Filters'),
    sidebarLayout(
      sidebarPanel(
        helpText("The datasets include electric vehicle population from 2000 to 2020 in Washington, United States"),
        
        # Input: Slider for the number of observations to generate ----
        
        sliderInput("range2",
                    "Choose the year range:",
                    value = c(2010, 2020),
                    min = 2010,
                    max = 2022),
        selectInput(
          'Make', 'Choose the vehicle brand to view its model distribution:', c("KIA", makeList)
        ),
        
         #############################################################################################A
        h1(textOutput('TotV'),align='left'),
 
        img(src='logo.png',width = '550',  height = '400',align='bottom')
        ############################################################################################
        ),

      mainPanel(
        tabsetPanel(
          tabPanel("Vehicle Make",
                   fluidPage(
                     h1("Electric Vehicle Market by Makes"),
                     fluidRow(
                       plotOutput(
                         "plotChart",
                         width = "100%",
                         height = "800px"
                         ),
                       textOutput("selected_var"))
                   )),
          tabPanel("Vehicle Model",
                   fluidPage(
                     h1("Electric Vehicle Model Distribution by Makes"),
                     fluidRow(
                       plotOutput(
                         "plotChart2",
                         width = "100%",
                         height = "800px"
                       ))
                   )),
          )
        )
      )
    )      
  )
)

# Server functions
server <- function(input, output, session) {
  # credit to: https://rstudio.github.io/leaflet/shiny.html
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    EVPD3[EVPD3$`Model Year` >= input$range[1] & EVPD3$`Model Year` <= input$range[2],]
  })
  
  
  filteredData2 <- reactive({
    charger[charger$Open.Date >= input$range[1] & charger$Open.Date <= input$range[2],]
  })
  
 
  
  output$map <- renderLeaflet({
 
    leaflet(charger) %>% addTiles() %>%
      fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))
  })
  
  #show car data on the map
  observe({
    pal <- colorNumeric("PuOr", EVPD3$carcount)
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~carcount^0.7*250, weight = 1, color = "#777777",
                 fillColor = ~pal(carcount), fillOpacity = 0.7, popup = ~paste(carcount)
      )
  })
  #show charger data on the map  
  observe({
    leafletProxy("map", data = filteredData2()) %>% 
      clearMarkers()
    if (input$charge==TRUE) {
      leafletProxy("map", data = filteredData2()) %>% 
        addMarkers()} 
  })
  
  
  #show legend
  observe({
    proxy <- leafletProxy("map", data = EVPD3)
    pal <- colorNumeric("PuOr", EVPD3$carcount)
    proxy %>% addLegend(position = "bottomright",
                        pal = pal, values = ~carcount)
  })
  
  
  # bubbleplot
  observe({
    output$plotChart <- renderPlot({
      bubbleplot(new_evp, input$range2[1],input$range2[2], 100)
    })
  })
  
  # webplot
  observe({
    output$plotChart2 <- renderPlot({
      webplot(new_evp, input$range2[1],input$range2[2], input$Make)
    })
  })
  
  output$TotV <- renderText({
    paste('Total Electric Vehicles:',nrow(new_evp %>% filter(ModelYear %in% (input$range2[1]:input$range2[2]))))
  })


}


shinyApp(ui, server)