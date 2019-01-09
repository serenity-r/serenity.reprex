itemOptionInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      h3(id),
      # This HAS to be a uiOutput, as we need to use persistent inputs to seed the values
      uiOutput(ns("trait")),
      verbatimTextOutput(ns("one"))
    )
  )
}

itemOptionMod <- function(input, output, session, item_change, one_values) {
  output$trait <- renderUI({
    ns <- session$ns
    item_change()
    
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
                value = isolate(input$trait) %||% 1)
  })
  
  output$one <- renderText({
    if (isTruthy(one_values)) {
      paste("Hair 1:", one_values[["one-hair-trait"]](), "\n", "Skin 1:", one_values[["one-skin-trait"]](), "\n\n")
    } else {
      one_values
    }
  })
  
  # Need to send reactives back
  valToCode <- reactive({
    input$trait
  })
  
  return(valToCode)
}
