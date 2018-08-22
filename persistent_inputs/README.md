# Persistent Inputs

This reprex illustrates that when the UI for a Shiny input is removed, the reactive input for the UI remains in the reactive object _and is still reactive_.  

More specifically, we have a slider with value `input$steve` and two buttons: **Banish Steve** which removes just the slider UI, and **Nuke Steve** which sets `input$steve` to NULL (via an R -> JS -> R communication).  Notice that the reactive text output still reacts to setting `input$steve` to NULL, even after the slider was already removed.