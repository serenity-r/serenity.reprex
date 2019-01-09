itemInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3(id),
    itemOptionInput(ns("hair")),
    itemOptionInput(ns("skin"))
  )
}

itemMod <- function(input, output, session, item_change, one_values) {
  slider_names <- c("hair", "skin")
  
  slider_modules <- unlist(map(slider_names, ~ callModule(module = itemOptionMod, 
                                                          id = .,
                                                          item_change = item_change,
                                                          one_values = one_values)))
  
  summary <- reactive({
    paste(map(slider_modules, ~ .()), collapse = " | ")
  })
  
  return(summary)
}
