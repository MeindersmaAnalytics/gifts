library(shiny)
library(tidyverse)
library(glue)

ui <- fluidPage(
  titlePanel("SomeTitle"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("gifts", label = "Number of gifts in the gift pool", min = 0, max = 5000, value = 1000),
      sliderInput("members", label = "Expected number of members that are gifting (or trying to gift)", min = 0, max = 5000, value = 1000),
      sliderInput("occasions", label = "Number of occasions to suggest a gift for", min = 0, max = 20, value = 10),
      sliderInput("x", label = "How well should gifts fit the occasion to be eligible for recommendation?", min = 0, max = 1, value = 0.5),
      sliderInput("similarity", label = "Define the required degree of similarity", min = 0, max = 1, value = 0.2),
      sliderInput("gift_rec", label = "How many gifts do we want to recommend per person?", min = 0, max = 20, value = 8),
      actionButton("calculate", "Calculate")
    ),
    mainPanel(
      h3("UI Main panel"),
      plotOutput("xxx"),
      textOutput("xxx2")

      )
    )
  )

server <- function(input, output, session) {
}

shinyApp(ui, server)