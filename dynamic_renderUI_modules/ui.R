fluidPage(
  titlePanel("Picking Items"),
  fluidRow(
    column(6,
           h3("Dragzone"),
           dragZone("dragzone",
                    choices = list(one = "One",
                                   two = "Two",
                                   three = "Three",
                                   four = "Four")),
           br(),
           h3("Dropzone"),
           dropZoneInput("dropzone",
                         choices = list(one = "1",
                                        two = "2",
                                        three = "3",
                                        four = "4"),
                         presets = list(values = "one",
                                        selected = "one",
                                        locked = "one",
                                        freeze = "one"),
                         selectable = TRUE,
                         selectOnDrop = TRUE)
    ),
    column(6,
           uiOutput("item")
    )
  ),
  verbatimTextOutput("parsed"),
  verbatimTextOutput("inputs")
)