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
      plotOutput("histPlot"),
      textOutput("xxx2")
      )
    )
  )

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Sample size based on number of gifts and occasions and value of x
    size <- reactive({
        round(input$gifts/input$occasions + sqrt(input$x)*(input$gifts/(input$occasions/(input$occasions-1))), 0)
    })
    
    # Create a dataframe for members with score reflecting their characteristics
    df <- reactive({
        data.frame(member = rep(1:input$members, size),
                   gift = rep(1:size, each = members),
                   score_member = rep(rnorm(members), size),
                   score_gift = rep(rnorm(size), members)) %>%
            mutate(distance = abs(score_member - score_gift),
                   recommended = (distance < similarity)*1) %>% 
            group_by(member) %>% 
            summarize(gifts_rec = min(gift_rec, sum(recommended)))
    })
    
    # Show the histogram in the output
    output$histPlot <- renderPlot({
        ggplot(df, aes(x=gifts_rec)) +
            geom_histogram()
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
