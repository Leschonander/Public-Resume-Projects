library(shiny)
library(tidyverse)

theme_my_axios <- function(...) {
  theme_minimal() +
    theme(
      panel.grid.major.x = element_blank() ,
      panel.grid.major.y = element_line(),  # (size=.1, color="grey" )
      plot.title = element_text(color = "#333333"),
      plot.subtitle =  element_text(color = "#737373"),
      plot.caption = element_text(color = "#737373"),
      axis.title.x = element_text(color = "#737373"),
      axis.title.y = element_text(color = "#737373"),
      axis.text = element_text(color = "#737373"),
      legend.position="none")  
}

terror <- read_csv("2018JanT.csv")

terror <- terror %>%
  separate(
    Location,
    into = c("City","Country"),
    sep = ','
  ) %>%
  mutate(
    Country = trimws(Country)
  )

ui <- fluidPage(
  tags$head(HTML('<link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">')),
  tags$head(HTML('<style>* {font-size: 100%; font-family: Roboto Mono;}</style>')),  
  
  titlePanel("January Terrorism"),
  
  sidebarLayout(
    sidebarPanel(
      HTML(paste("<p>From Wikipedia's <a href='https://en.wikipedia.org/wiki/List_of_terrorist_incidents_in_January_2019'>List of terrorist incidents in January 2019</a></p>")),
      
      HTML(paste("<p>Wikipedia publishes datasets on reported terror attacks every month. The trouble with them is they are not",
                 "very sortable. </p>")),
      
      
      sliderInput("Date", "Date", 1, 31, c(1, 31)),
      sliderInput("Dead", "Dead", 0, 103, c(0, 103)),
      textInput("Country", label = h3("Enter Country"), value = "Afghanistan")
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), 
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  filtered <- reactive({
    terror %>%
      filter(Date >= input$Date[1],
             Date <= input$Date[2],
             Dead >= input$Dead[1],
             Dead <= input$Dead[2],
             Country == input$Country
      )
  })
  
  output$coolplot <- renderPlot({
    ggplot(filtered(), aes(Date, Dead)) +
      geom_point() +
      theme_my_axios()
  })
  
  output$results <- renderTable({
    filtered()
  })
}

shinyApp(ui = ui, server = server)