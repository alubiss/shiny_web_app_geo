
library(shiny)

library(dplyr)
library("ggplot2")
theme_set(theme_bw())
library("sf")
library(shinydashboard)
library(shinyjs)
library(leaflet)

world_spdf <- readOGR( 
    dsn = '/Users/alubis/Desktop/OneDrive/DS sem I/Visualization in R/zaj 7/Data/',
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
                textInput("text", "Enter your address: ")) ),
        
        fluidRow(
        box(width=100,
            tabsetPanel(
                tabPanel("Map", leafletOutput("mapa", width = "100%", height = 500)),
                tabPanel("Informations"))))
        
        
    )
)

server <- function(input, output) { 
    
    output$mapa <- renderLeaflet({
        
        # Final Map
        leaflet(world_spdf) %>% 
            addTiles()  %>% 
            setView(lat=52, lng=19.2 ,zoom=6)
        
    })
    
    
    }

shinyApp(ui, server)