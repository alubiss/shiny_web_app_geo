
library(shiny)

library(dplyr)
library("ggplot2")
theme_set(theme_bw())
library("sf")
library(shinydashboard)
library(shinyjs)
library(leaflet)
library('tidygeocoder')

world_spdf <- readOGR( 
    dsn = '/Users/alubis/shiny_geo_proj/',
    layer ="TM_WORLD_BORDERS_SIMPL-0.3", 
    verbose = FALSE
)



ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "GEO app"),
    dashboardSidebar(sidebarMenu(
        menuItem("Dashboard", tabName = "Dashboard"),
        menuItem("Tables", tabName = "Tables")
    )),
    dashboardBody(
        
        fluidRow( 
            box(width=100,
                title = "Geocoder : ",
                textInput("text", "Enter your address: ", "Puławska 17"),
                textInput("text2", "Longitude: ", "X"),
                textInput("text3", "Latitude: ", "Y")
                #,verbatimTextOutput("value")
                ) ),
        
        fluidRow(
        box(width=100,
            tabsetPanel(
                tabPanel("Map", leafletOutput("mapa", width = "100%", height = 500)),
                tabPanel("Informations"))))
        
        
    )
)

server <- function(input, output, session) { 
    
    ######################################### TEXT #################################################################
    
    #output$value <- renderText({ input$text })
    
    observe({
        
    xy= geo(input$text, method = 'osm')
    updateTextInput(session, "text2", value = paste(xy$long))
    updateTextInput(session, "text3", value = paste(xy$lat))
    
    ######################################### OUTPUT MAPA ##########################################################
        
    output$mapa <- renderLeaflet({
    
        # Final Map
        leaflet(world_spdf) %>%
            addTiles()  %>% 
            setView(lat=xy$lat, lng=xy$long ,zoom=12) %>%
            addCircleMarkers(lng = xy$long, lat = xy$lat)
        })
    
    })  
    
    }

shinyApp(ui, server)

