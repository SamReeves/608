library(shiny)
library(dplyr)
library(globe4r)
library(DT)

options(shiny.port = 1337)

usage <- read.csv('https://raw.githubusercontent.com/SamReeves/608/main/final/usage.csv')
points <- read.csv('https://raw.githubusercontent.com/SamReeves/608/main/final/points.csv')

server <- shinyServer(function(input, output, session) {
  
  output$table1 <- renderDataTable({
    filter(points, type == input$p) %>%
      select(c('name', 'val', 'qual')) %>%
      arrange(desc(val))
    })
  
  output$table2 <- renderDataTable({
    filter(usage, year == input$y) %>%
      select(c('country', input$u,
               'population', 'gdp',
               'per_capita_electricity')) %>%
      arrange(desc(population))
  })
  output$globe <- render_globe({
    dat1 <- filter(usage, year == input$y)
    dat1$country <- as.character(dat1$a2)
    dat1$val <- as.numeric(dat1[,input$u])
    
    dat2 <- filter(points, type == input$p) %>%
      arrange(desc(val)) %>%
      slice(1:input$n)
    
    create_globe() %>%
      globe_img_url() %>%
      globe_choropleth(
        data = dat1,
        coords(
          country = country,
          altitude = val,
          cap_color = val,
          side_color = val)) %>%
      scale_choropleth_altitude() %>%
      scale_choropleth_cap_color() %>%
      scale_choropleth_side_color() %>%
    globe_bars(
      data = dat2,
      coords(lat = lat,
             lon = lng,
             altitude = val)) %>%
      scale_bars_altitude()
  })
})

ui <- shinyUI(fluidPage(
  theme = bslib::bs_theme(bootswatch = 'cyborg'),
  headerPanel('Country-level Energy Statistics'),
  sidebarLayout(
    sidebarPanel(
  
      selectInput('u',
                  label = 'Historical Data:',
                  choices = names(usage)[4:122],
                  selected = 'nuclear_share_energy',
                  multiple = FALSE),
  
      sliderInput('y',
                  label = 'Year:',
                  min = 1900,
                  max = 2019,
                  value = 2016),
  
      selectInput('p',
                  label = 'Data Point Type:',
                  c('Cities' = 'city',
                    'Power Plants' = 'plant'),
                  selected = 'Power Plants',
                  multiple = FALSE),
      sliderInput('n', label = 'Number of data points: ',
                  min = 1,
                  max = 10000,
                  value = 100),
      dataTableOutput('table1')),
    
    mainPanel(globeOutput('globe'),
              dataTableOutput('table2')))))



shinyApp(ui, server)
