library(shiny)

ui <- fluidPage(
  actionButton("constant", "Button (no change)"),
  actionButton("changes", "Button (change)")
)

server <- function(input, output, session) {
  # This is using a closure because
  #  (1) This function is returning a function, and
  #  (2) The returning function is accessing a reactive variable created in the scope of the dedupe function
  dedupe <- function(r) {
    makeReactiveBinding("val")
    observe(val <<- r(), priority = 10)
    reactive(val)
  }
  
  # This reactive will be used as an event trigger
  # - Reactive that ALWAYS returns 5
  # - input$constant will invalidate, but return value is constant 5
  # - This WILL trigger the event following this reactive
  num5 <- reactive({
    input$constant
    5
  })

  observeEvent(num5(), {
    req(input$constant)
    cat("No change in event trigger value, but I've been duped!\n")
  })
  
  # Same reactive as above, but deduped
  # - Reactive that ALWAYS returns 5
  # - input$constant will invalidate, but return value is constant 5
  # - This WILL NOT trigger the event following this reactive
  num5v2 <- dedupe(reactive({
    input$constant
    5
  }))
  
  observeEvent(num5v2(), {
    req(input$constant)
    cat("YOU SHOULDN'T SEE ME!!!!\n")
  })
  
  # This reactive shows that the deduped reactive will trigger the event when there is a change
  # - Reactive returns the value of the changes button
  # - This WILL trigger the event following this reactive
  ch_ch_ch_changes <- dedupe(reactive({
    input$changes
  }))
  
  observeEvent(ch_ch_ch_changes(), {
    cat(paste0("Deduped (change in event trigger; ", input$changes, ")\n"))
  })
}

shinyApp(ui = ui, server = server)