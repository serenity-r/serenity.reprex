# Passing data within Shiny Modules from Module 1 to Module 2
#   https://stackoverflow.com/questions/46555355/passing-data-within-shiny-modules-from-module-1-to-module-2/46555851#46555851
library(shiny)

# Inner module
mySliderInput <- function(id) {
  ns <- NS(id)
  wellPanel(h3("My Slider"),
            sliderInput(ns("slider"),
                        label = "",
                        min = 0,
                        max = 1,
                        value = 0.5))
}

mySlider <- function(input, output, session) {
  reactive({
    input$slider
  })
}

# outer module
outerModuleUI <- function(id){
  ns <- NS(id)
  wellPanel(h3("Output Module"),
            id = ns("dataset-vars-wrap"),
            mySliderInput(ns("one")),
            mySliderInput(ns("two")),
            verbatimTextOutput(ns("txt"))
  )
}

outerModule <- function(input, output, session) {
  slider_names <- c("one", "two")
  
  # Get list of reactives
  sliders <- sapply(slider_names, function(name) {
    return(callModule(module = mySlider,
                      id = name))
  }, simplify = FALSE, USE.NAMES = TRUE)

  # Evaluate list of reactives
  values <- reactive({
    lapply(sliders, function(slider) {
      return(slider())
    })
  })
  
  output$txt <- renderPrint({
    paste0('(', paste(values(), collapse = ', '), ')')
  })
  
  observeEvent(values(), {
    showNotification(paste0(session$ns(''), '(', paste(values(), collapse = ', '), ')'))
  })
}

ui <- fluidPage(
  titlePanel("Nested Modules"),
  fluidRow(
    column(6,
           outerModuleUI('sliderSet1')       
    ),
    column(6,
           outerModuleUI('sliderSet2')
    )
  )
)   

server <- function(input, output, session) {
  callModule(outerModule, 'sliderSet1')
  callModule(outerModule, 'sliderSet2')
}

shinyApp(ui, server)