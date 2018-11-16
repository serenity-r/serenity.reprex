library(shiny)
library(purrr)

`%||%` <- function(x, y) if (is.null(x)) y else x

hunks <- c("edward", "jacob")

source("loverboyModule.R")
source("loverboyTraitModule.R")