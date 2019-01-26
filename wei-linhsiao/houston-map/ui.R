library(shiny)
library(leaflet)
library(tidyverse)
library(rsconnect)

#UI
shinyUI(
  bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:150%}"),
    leafletOutput("houstonMap", width = "100%", height = "100%")
  )
)
