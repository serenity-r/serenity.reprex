fluidPage(
  titlePanel("Twilight Tinder"),
  selectInput("lovemore", "Choose your loverboy", hunks, selected = "Edward", multiple = FALSE),
  uiOutput("loverboy")
)