itemInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3(id),
    itemOptionInput(ns("hair")),
    itemOptionInput(ns("skin"))
  )
}

itemMod <- function(input, output, session) {
  slider_names <- c("hair", "skin")
  
  slider_modules <- unlist(map(slider_names, ~ callModule(module = itemOptionMod, id = .)))
  
  summary <- reactive({
    paste(map(slider_modules, ~ .()), collapse = " | ")
  })
  
  return(summary)
}
