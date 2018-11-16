loverboyInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3(id),
    loverboyTraitInput(ns("hair")),
    loverboyTraitInput(ns("skin")),
    verbatimTextOutput(ns("summary"))
  )
}

loverboyMod <- function(input, output, session) {
  slider_names <- c("hair", "skin")
  
  slider_modules <- unlist(map(slider_names, ~ callModule(module = loverboyTraitMod, id = .)))
  
  output$summary <- renderPrint({
    paste(map(slider_modules, ~ .()), collapse = " | ")
  })
}
