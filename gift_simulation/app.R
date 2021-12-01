library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

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
