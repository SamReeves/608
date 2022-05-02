library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

df <- read.csv('cleaned-cdc-mortality-1999-2010-2.csv')

shinyApp(ui = ui, server = server)