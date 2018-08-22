# M. Drew LaMar, August 2018

library(shiny)

ui <- fluidPage(
  tags$script("
    Shiny.addCustomMessageHandler('nukeSteve', function(who) {
      Shiny.onInputChange(who, null);
    });
  "),
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      actionButton("banish_steve", "Banish Steve"),
      actionButton("nuke_steve", "Nuke Steve"),
      div(id = "banishsteve",
        sliderInput("steve", "Steve", 
                  min = 1,
                  max = 10,
                  value = 1)
      )
    ),
    
    mainPanel(
      verbatimTextOutput("steve")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$banish_steve, {
    removeUI("#banishsteve", immediate = TRUE)
  })
  
  observeEvent(input$nuke_steve, {
    session$sendCustomMessage("nukeSteve", "steve")
    
    updateSliderInput(session, "steve", value = NULL)
  })
  
  output$steve <- renderPrint({
    input$steve
  })
}

shinyApp(ui = ui, server = server)