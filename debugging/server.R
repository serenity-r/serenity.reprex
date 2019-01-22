server <- function(input, output, session) {
  # This stores returned reactives from modules (only want to call once)
  item_modules <- reactiveValues()
  
  # Update layer module output reactives - create only once!
  observeEvent(input$dropzone, {
    # Adding new item
    purrr::map(setdiff(input$dropzone, names(item_modules)), ~ { item_modules[[.]] <- callModule(module = layerMod, id = .,
                                                                                                 reactive({input$dropzone_selected}),
                                                                                                 one_inputs_to_reactives())})
    
    # Remove old item
    purrr::map(setdiff(names(item_modules), input$dropzone), ~ { item_modules[[.]] <- NULL })
  })

  # Preps geom_blank dropzone inputs for layer modules
  one_inputs_to_reactives <- function() {
    one_inputs <- as.list(c('one-hair-trait', 'one-skin-trait'))
    names(one_inputs) <- c('one-hair-trait', 'one-skin-trait')
    if (any(names(one_inputs) %in% names(input))) {
      return(one_inputs %>%
             purrr::map(~ reactive({ input[[.]] })))
    } else {
      return(NULL)
    }
  }
  
  # Parse the output from each item module together into one
  #   Subset by dropzone input to get correct ordering
  output$parsed <- renderPrint({
    paste(map(reactiveValuesToList(item_modules)[input$dropzone], ~ .()), collapse = " + ")
  })

  # Render item sliders depending on selected value
  output$aesthetics <- renderUI({
    req(input$dropzone_selected)
    layerUI(id = input$dropzone_selected)
  })
  
  output$inputs <- renderPrint({
    reactiveValuesToList(input)
  })
}