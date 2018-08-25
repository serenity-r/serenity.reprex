# Serenity Reprexes

See the `ShinyReactLogs.key` Keynote file for Shiny execution scheduling templates.  You too can build reactive graphs that look like the "real thing"!

### Persistent Inputs

This reprex illustrates that when the UI for a Shiny input is removed, the reactive input for the UI remains in the reactive object _and is still reactive_.

### Reactive Dedupe (and Higher-Order Reactives)

*This example is modified from the `reactive-dedupe` example from [daattali/advanced-shiny](https://github.com/daattali/advanced-shiny/tree/master/reactive-dedupe).  I have added a shiny script to help my brain.*