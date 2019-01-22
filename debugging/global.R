library(shiny)
library(purrr)
library(dragulaSelectR)

`%||%` <- function(x, y) if (is.null(x)) y else x

makeReactiveTrigger <- function(init_val = NULL) {
  rv <- reactiveValues(a = 0)
  val <- init_val
  list(
    get = function() {
      val
    },
    set = function(new_val) {
      val <<- new_val
    },
    depend = function() {
      rv$a
      invisible()
    },
    trigger = function() {
      rv$a <- isolate(rv$a + 1)
    }
  )
}


source("layerModule.R")
source("layerAesModule.R")