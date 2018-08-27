# https://dreamrs.github.io/shinyWidgets/articles/palette_picker.html

library("shiny")
library("shinyWidgets")
library("RColorBrewer")

# First get all palettes available by category
# List of palettes
colors_pal <- lapply(
  X = split(
    x = brewer.pal.info,
    f = factor(brewer.pal.info$category, labels = c("Diverging", "Qualitative", "Sequential"))
  ),
  FUN = rownames
)

# Then get all colors in each palette
# Get all colors given a palette name(s)
get_brewer_name <- function(name) {
  pals <- brewer.pal.info[rownames(brewer.pal.info) %in% name, ]
  res <- lapply(
    X = seq_len(nrow(pals)),
    FUN = function(i) {
      brewer.pal(n = pals$maxcolors[i], name = rownames(pals)[i])
    }
  )
  unlist(res)
}

# With a pal, construct a linear gradient (in CSS, explanation here -> https://www.w3schools.com/css/css3_gradients.asp)
# Calc linear gradient for CSS
linear_gradient <- function(cols) {
  x <- round(seq(from = 0, to = 100, length.out = length(cols)+1))
  ind <- c(1, rep(seq_along(x)[-c(1, length(x))], each = 2), length(x))
  m <- matrix(data = paste0(x[ind], "%"), ncol = 2, byrow = TRUE)
  res <- lapply(
    X = seq_len(nrow(m)),
    FUN = function(i) {
      paste(paste(cols[i], m[i, 1]), paste(cols[i], m[i, 2]), sep = ", ")
    }
  )
  res <- unlist(res)
  res <- paste(res, collapse = ", ")
  paste0("linear-gradient(to right, ", res, ");")
}

background_pals <- sapply(unlist(colors_pal, use.names = FALSE), get_brewer_name)
background_pals <- unlist(lapply(X = background_pals, FUN = linear_gradient))

# Set the text color (white for Diverging pals, black overwise)
colortext_pals <- rep(c("white", "black", "black"), times = sapply(colors_pal, length))

ui <- fluidPage(
  tags$h1("Palette Picker"),
  
  br(),
  
  pickerInput(
    inputId = "col_palette", label = "Choose a palette :",
    choices = colors_pal, selected = "Paired", width = "60%",
    choicesOpt = list(
      content = sprintf(
        "<div style='width:100%%;padding:5px;border-radius:4px;background:%s;color:%s'>%s</div>",
        unname(background_pals), colortext_pals, names(background_pals)
      )
    )
  ),
  verbatimTextOutput(outputId = "res")
  
)

server <- function(input, output, session) {
  
  output$res <- renderPrint(input$col_palette)
  
}

shinyApp(ui, server)