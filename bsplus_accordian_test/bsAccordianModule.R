library(bsplus)

bsAccordianInput <- function(id) {
  ns <- NS(id)
  
  bsplus::bs_accordion(id = ns("bs_acc")) %>%
    bsplus::bs_set_opts(panel_type = "success", 
                        use_heading_link = TRUE) %>% 
    bsplus::bs_append(bsa, 
                      title = "Steve", 
                      content = bsSliderInput(ns("steve"))) %>%
    bsplus::bs_append(bsa,
                      title = "Fred",
                      content = bsSliderInput(ns("fred")))
}

bsAccordian <- function(input, output, session) {
  callModule(module = bsSlider,
             id = "steve")
  callModule(module = bsSlider,
             id = "fred")
}
