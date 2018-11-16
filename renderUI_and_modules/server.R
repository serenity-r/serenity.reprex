server <- function(input, output, session) {
  # Load server for each loverboy
  map(hunks, ~ callModule(module = loverboyMod, id = .))

  output$loverboy <- renderUI({
    loverboyInput(id = input$lovemore)
  })
}