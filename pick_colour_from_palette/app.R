# https://rdrr.io/cran/shinyWidgets/man/spectrumInput.html
# Based on jQuery library: https://bgrins.github.io/spectrum/#options

library(shiny)
library(shinyWidgets)
library(colourpicker)
library(RColorBrewer)
library(magrittr)

# Grab R colour names with rgb, hex and hsv values
crgb <- col2rgb(cc <- colors())
chsv <- rgb2hsv(crgb)
chsv <- dplyr::tbl_df(t(chsv)) %>% dplyr::mutate(name = cc)
colours_tbl <- dplyr::tbl_df(t(crgb)) %>%
  dplyr::mutate(name = cc,
                hex = rgb(red, green, blue, maxColorValue = 255)) %>%
  dplyr::select(name, hex, red, green, blue) %>%
  dplyr::left_join(chsv, by = "name") %>%
  dplyr::arrange(h, s, v) # Sort by hue, then saturation, then value

ui <- fluidPage(
  tags$h1("Spectrum color picker"),
  
  br(),
  
  # list(unique(colours_tbl$hex)), # grab only unique hex values
  spectrumInput(
    inputId = "myColor",
    label = "Pick a color:",
    choices = list(unique(colours_tbl$hex)),
    options = list(`toggle-palette-more-text` = "Show more",
                   `show-input` = TRUE,
                   `preferred-format` = "name")
  ),
  verbatimTextOutput(outputId = "res"),
  colourInput(
    inputId = "myColour",
    label = "Pick a color:",
    palette = "limited",
    allowedCols = unique(colours_tbl$hex),
    returnName = TRUE
  ),
  verbatimTextOutput(outputId = "res2"),
  actionButton(inputId = "steve", label = "Picker")
)

server <- function(input, output, session) {
  
  # Output the R colour names - can be multiples!  
  output$res <- renderPrint(dplyr::filter(colours_tbl, hex == toupper(input$myColor))$name)
  
  output$res2 <- renderPrint(input$myColour)
  
  observeEvent(input$steve, {
    command <- "colourPicker()"
    rstudioapi::sendToConsole(command)
    stopApp()
  })
}

shinyApp(ui, server)