server <- function(input, output, session) {
  # Items are variable in number and unknown, so need to set this
  #   as a reactive depending on dropzone values. This is similar
  #   to slider_modules in itemModule.R, except number of sliders
  #   was fixed and known so didn't need a reactive.
  values <- reactive({
    map(input$dropzone, ~ callModule(module = itemMod, id = .))
  })
  
  # Parse the output from each item module together into one
  output$parsed <- renderPrint({
    paste(map(values(), ~ .()), collapse = " + ")
  })

  # Render item sliders depending on selected value
  output$item <- renderUI({
    itemInput(id = input$dropzone_selected)
  })
}