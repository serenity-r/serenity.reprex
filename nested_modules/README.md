# Nested Modules

This reprex illustrates how to set up nested modules that return a list of reactive expressions. It was necessary for my brain to digest the following statement from the [Shiny Modules](https://shiny.rstudio.com/articles/modules.html) article:

> If a module wants to return reactive expressions to the calling app, then return a list of reactive expressions from the function.

I was specifically interested in how to have an observer depend on ALL of the reactives in the returned list. The solution was to create a reactive evaluator function in the outer module that converted the list of reactives from the inner module into a list of evaluated reactives.