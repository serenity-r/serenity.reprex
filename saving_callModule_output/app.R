library(shiny)

`%||%` <- function(x, y) if (is.null(x)) y else x

# outer module
moduleUI <- function(id) {
  ns <- NS(id)
  wellPanel(h4(paste("Module", id)), uiOutput(ns("slider")))
}

moduleCode <- function(input, output, session, trigger) {
  state <- reactiveValues(value = 0)
  
  output$slider <- renderUI({
    trigger()
    
    isolate({
      sliderInput(session$ns('slider'), 
                  "Slider", 
                  min = 0, 
                  max = 1, 
                  value = input$slider %||% 0.5, 
                  step = 0.1)
    })
  })
  
  observeEvent(input$slider, {
    state$value <<- state$value + input$slider
  })
  
  return(
    reactive({
      list(
        input = input$slider,
        state = state$value
      )
    })
  )
}

ui <- fluidPage(
  titlePanel("Module Picker"),
  h3(
    tagList(
      span("Module #1 server code is only called once."),
      br(),
      span("Module #2 server code is rerun every time.")
    )
  ),
  selectInput('module', label = "Choose module", choices = c("one", "two"), selected = "one"),
  h3("Module UI:"),
  uiOutput('modules'),
  verbatimTextOutput('module_output'),
  h4(
    tagList(
      span("Result: While both modules will \"remember\" their inputs, only Module #1 will remember the state."),
      br(),
      br(),
      span("The state for each module accumulates the values from the slider.  In Module #2, the state gets reset when reloaded.")
    )
  )
)   

server <- function(input, output, session) {
  module_output <- list()
  
  output$modules <- renderUI({
    moduleUI(input$module)
  })
  
  module_output$one <- callModule(moduleCode, 'one', reactive({ input$module }))
  
  observeEvent(input$module, {
    if (input$module == "two") {
      module_output$two <<- callModule(moduleCode, 'two', reactive({ input$module }))
    }
  })
  
  output$module_output <- renderPrint({
    cat(paste0("Input: ", module_output[[input$module]]()$input, "\n",
          "State: ", module_output[[input$module]]()$state))
  })
}

shinyApp(ui, server)