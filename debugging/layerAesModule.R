layerAesUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      h3(id),
      # This HAS to be a uiOutput, as we need to use persistent inputs to seed the values
      tabsetPanel(type = "tabs",
                  tabPanel("Output", verbatimTextOutput(ns("one"))),
                  tabPanel("Slider", uiOutput(ns("trait_ui"))))
    )
  )
}

layerAes <- function(input, output, session, triggerAesUpdate, geom_blank_input) {
  output$trait_ui <- renderUI({
    ns <- session$ns
    triggerAesUpdate()
    
    isolate({
      # https://stackoverflow.com/questions/34801607/shiny-data-persistence-in-renderui
      # There's an extra complication in this example: note that the inputId is ns("trait"),
      #   but the value uses input$trait! This was the second biggest hurdle for me.  The 
      #   biggest hurdle was the StackOverflow issue, i.e. how to have persistent inputs
      #   using renderUI (i.e. implements a dynamic conditionalPanel).  See the persistent_inputs
      #   example, which uses removeUI but not renderUI (i.e. I didn't try and put it back in that
      #   example!)
      sliderInput(inputId = ns("trait"), 
                  label = "",
                  min = 0,
                  max = 1,
                  value = input$trait %||% 0.1234)
    })
  })
  
  output$one <- renderText({
    if (isTruthy(geom_blank_input)) {
      paste("Hair 1:", geom_blank_input[["one-hair-trait"]](), "\n", "Skin 1:", geom_blank_input[["one-skin-trait"]](), "\n\n")
    } else {
      geom_blank_input
    }
  })
  
  # Need to send reactives back
  aesToCode <- reactive({
    input$trait
  })
  
  return(aesToCode)
}
