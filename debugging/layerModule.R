layerUI <- function(id) {
  ns <- NS(id)
  
  div(
    id = ns("layer-aes-wrap"),
    class = "layer-aes",
    uiOutput(ns("layer_aes"), inline = FALSE)
  )
}

layerMod <- function(input, output, session, layers_selected, geom_blank_input) {
  ns <- session$ns
  
  layer_id <- gsub("-$", "", ns(''))

  aesthetics <- c("hair", "skin")
  
  # Create trigger for this layers update
  triggerAesUpdate <- makeReactiveTrigger()
  observeEvent(layers_selected(), {
    if (layers_selected() == layer_id) {
      triggerAesUpdate$trigger()
    }
  })
  
  output$layer_aes <- renderUI({
    triggerAesUpdate$depend()
    
    tagList(
      layerAesUI(id = session$ns("hair")),
      layerAesUI(id = session$ns("skin"))
    )
  })
  
  layer_args <- map(aesthetics, ~ callModule(module = layerAes, id = .,
                                             reactive({ triggerAesUpdate$depend() }),
                                             geom_blank_input))
  
  layer_code <- reactive({
    args <- map(layer_args, ~ .())
    
    input$hair
    input$skin
    
    paste(args, collapse = " | ")
  })
  
  return(layer_code)
}
