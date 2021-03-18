
library(shiny)

library(dplyr)
library("ggplot2")
theme_set(theme_bw())
library("sf")
library(shinydashboard)
library(shinyjs)
#dashboardPage(skin = "black")

ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "GEO app"),
    dashboardSidebar(sidebarMenu(
        menuItem("Dashboard", tabName = "Dashboard"),
        menuItem("Tables", tabName = "Tables")
    )),
    dashboardBody(
        
        fluidRow( box(
            title = "Geocoder : ",
            textInput("text", "Enter your address: ")) ),
        
        fluidRow(
        box())
        
        
        
    )
)

server <- function(input, output) { }

shinyApp(ui, server)