library(bsplus)

bsAccordianInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    bsplus::bs_accordion(id = ns("bs_acc")) %>%
      bsplus::bs_set_opts(panel_type = "success", 
                          use_heading_link = TRUE) %>% 
      bsplus::bs_append(bsa, 
                        title = "Steve", 
                        content = bsSliderInput(ns("steve"))) %>%
      bsplus::bs_append(bsa,
                        title = "Fred",
                        content = bsSliderInput(ns("fred"))),
    verbatimTextOutput(ns("summary"))
  )
}

bsAccordian <- function(input, output, session) {
  slider_names <- c("steve", "fred")
  
  slider_modules <- sapply(slider_names, function(slider) {
    return(callModule(module = bsSlider,
                      id = slider))
  }, simplify = FALSE, USE.NAMES = TRUE)
  
  output$summary <- renderPrint({
    paste(c(slider_modules$steve(), slider_modules$fred()), collapse = " | ")
  })
}
