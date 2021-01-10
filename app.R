library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(data.table)
library(readr)
library(geosphere)
library(shinycssloaders)
library(tidyr)
library(RSQLite)

ui <- app_ui()

server <- app_server()


 
shinyApp(ui = ui, server = server)
