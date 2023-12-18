#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)

driver_results_df = read.csv("data/driver_data.csv")

# Define UI
ui <- navbarPage(
  title = "F1 Racing Statistics",
  tabPanel(title = "Visualization",
           sidebarLayout(
             sidebarPanel(
               selectInput("racer", "Select Racer:", choices = unique(driver_results_df$driverRef)),
               selectInput("year", "Select Year:", choices = unique(driver_results_df$year)),
               textInput("position", "Enter Position:")
             ),
             mainPanel(
               plotOutput("plot")
             )
           )),
  tabPanel(title = "Table",
           tableOutput("table")),
  tabPanel(title = "About", includeMarkdown("about.Rmd")),

)


server <- function(input, output) {

  filtered_data <- reactive({
    req(input$racer, input$year)
    filter(driver_results_df, driverRef == input$racer, year == input$year, position == input$position)
  })

  output$table <- renderTable({
    selected_cols <- c("driverRef", "year", "position", "name", "points")
    filtered_data() %>% select(all_of(selected_cols))
  })

  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = name, y = points, group = driverRef, color = driverRef)) +
      geom_line() +
      labs(title = "Points Over Races",
           x = "Race",
           y = "Points")
  })
}


# Run the Shiny app
shinyApp(ui, server)
