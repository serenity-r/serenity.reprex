server <- function(input, output, session) {
  callModule(module = bsAccordian, 
             id = "my_bs_acc")
}