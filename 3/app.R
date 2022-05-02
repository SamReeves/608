library(shiny)
library(ggplot2)
library(plotly)

df <- read.csv('cleaned-cdc-mortality-1999-2010-2.csv')

server <- function(input, output, session) {}

ui <- fluidPage(
  headerPanel('Mortality'),
  sidebarPanel(
    selectInput('State', 'State', unique(df$State), selected='CA'),
    selectInput('Unit', 'ICD.Chapter', unique(df$ICD.Chapter),
                selected='Diseases of the genitourinary system')),
  mainPanel(
    plotOutput('plot1'),
    verbatimTextOutput('stats')))

shinyApp(ui, server)