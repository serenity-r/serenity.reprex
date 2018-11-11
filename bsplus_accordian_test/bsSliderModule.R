library(bsplus)

bsSliderInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      h3(id),
      sliderInput(ns("filter"), id, 
                  min = 0,
                  max = 1,
                  value = c(0, 1)),
      verbatimTextOutput(ns("placeholder"))
    )
  )
}

bsSlider <- function(input, output, session) {
  output$placeholder <- renderPrint({
    input$filter
  })
}
