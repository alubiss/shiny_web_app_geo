library(shiny)
library(dplyr)
library("ggplot2")
theme_set(theme_bw())
library("sf")
install.packages('shinydashboard')
library(shinydashboard)
library(shinyjs)
library(leaflet)
library('tidygeocoder')
library(osmdata) 
library(osrm)
library(rgdal)

tryCatch({
    world_spdf <- readOGR(  
        dsn = '/Users/alubis/shiny_geo_proj/maps/',
        layer ="TM_WORLD_BORDERS_SIMPL-0.3", 
        verbose = FALSE)
    source("/Users/alubis/shiny_geo_proj/functions.R")
}, error = function(e){ return(NA) })

tryCatch({
    world_spdf <- readOGR(
        dsn = '/Users/aleksander/Desktop/programowanie/R/kopia_repo/shiny_web_app_geo/maps/',
        layer ="TM_WORLD_BORDERS_SIMPL-0.3", 
        verbose = FALSE)
    source("/Users/aleksander/Desktop/programowanie/R/kopia_repo/shiny_web_app_geo/functions.R")
   }, error = function(e){ return(NA) })

ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "GEO app"),
    dashboardSidebar(sidebarMenu(
        # https://fontawesome.com/icons?d=gallery
        menuItem("Dashboard", tabName = "Dashboard", icon = icon("globe-europe")),
        menuItem("Tables", tabName = "Tables", icon = icon("info-circle")),
        menuItem("Bus stops", tabName = "Bus_stops", icon = icon("bus")),
        menuItem("Restaurants", tabName = "Restaurants", icon = icon("mug-hot")),
        menuItem("Shops", tabName = "Shops", icon = icon("shopping-cart")),
        menuItem("Tourism", tabName = "Tourism", icon = icon("university"))
    )),
    dashboardBody(
     
        shiny::tagList(
        tabItems(
        tabItem(tabName = "Dashboard",   
        fluidRow( 
            box(width=100,
                title = "Geocoder : ",
                textInput("text", "Enter your address: ", "Puławska 17"),
                textInput("city", "City : ", "Warszawa"),
                submitButton("Search", icon("refresh")),
                textInput("text2", "Longitude: ", "X"),
                textInput("text3", "Latitude: ", "Y")
                #,verbatimTextOutput("value")
                ) ),
        
        fluidRow(
        box(width=100,
            tabsetPanel(
                tabPanel("Map", leafletOutput("mapa", width = "100%", height = 500)),
                tabPanel("Informations"))))
        
         ),
        
        tabItem(tabName = "Bus_stops",
          
                fluidRow(
                    box(width=100,
                        tabsetPanel(
                            tabPanel("Map", leafletOutput("mapa_bus", width = "100%", height = 500)),
                            tabPanel("Informations"))))      
                
        ),
        
        tabItem(tabName = "Restaurants",
                
                fluidRow(
                    box(width=100,
                        tabsetPanel(
                            tabPanel("Map", leafletOutput("mapa_res", width = "100%", height = 500)),
                            tabPanel("Informations"))))
        
        )
        
        
    )))
)

server <- function(input, output, session) { 
    
    ######################################### TEXT #################################################################
    
    #output$value <- renderText({ input$text })
    
    observe({
        
    xy= geo(street= input$text, city= input$city, method = 'osm')
    updateTextInput(session, "text2", value = paste(xy$long))
    updateTextInput(session, "text3", value = paste(xy$lat))
    
    ######################################### OUTPUT MAPA ##########################################################
        
    output$mapa <- renderLeaflet({
    
        # Final Map
        leaflet(world_spdf) %>%
            addTiles()  %>% 
            setView(lat=xy$lat, lng=xy$long ,zoom=14) %>%
            addCircleMarkers(lng = xy$long, lat = xy$lat)
        })
    
 
    
    ######################################### OUTPUT MAPA BUS ####################################################
    
    bus_stops = get_osm_data(paste(input$city, "Poland", sep=", "), our_key = "public_transport", our_value = 'stop_position') %>% plot_points(our_adress=xy)
    output$mapa_bus <- renderLeaflet({bus_stops})

    
    ######################################### OUTPUT MAPA Restaurants ####################################################
    
    restaurants = get_osm_data(paste(input$city, "Poland", sep=", "), our_key = "amenity", our_value = 'restaurant') %>% plot_points(our_adress=xy)
    output$mapa_res <- renderLeaflet({restaurants})
    
    }) 
    
    }

shinyApp(ui, server)

