shinyUI(fluidPage(
  headerPanel('Mortality'),
  sidebarPanel(
    selectInput('State', 'State', unique(df$State), selected='CA'),
    selectInput('Unit', 'ICD.Chapter', unique(df$ICD.Chapter),
                selected='Diseases of the genitourinary system')),
  mainPanel(
    plotOutput('plot1'),
    verbatimTextOutput('stats')
  )
))