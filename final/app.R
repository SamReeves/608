library(shiny)
library(dplyr)
library(globe4r)

options(shiny.port = 1337)

plants <- read.csv('power.csv')
p2 <- plants %>%
  mutate(cap = Capacity..MW. / max(Capacity..MW.))
cities <- read.csv('worldcities.csv')
usage <- read.csv('consumption.csv')

server <- shinyServer(function(input, output, session) {
})

ui <- fluidPage(create_globe(height = '100vh') %>%
                  globe_bars(
                    coords(Latitude, 
                           Longitude, 
                           altitude = cap,
                           color = cap),
                    data = p2) %>%
                  scale_bars_color() %>%
                  globe_title("Power Plants by Output Capacity"))

shinyApp(ui, server)