library(shiny)
library(bslib)
library(reactable)

source("R/km6-chart.R")

# read in data
km6 <- readRDS("data/km6.rds")

ui <- navbarPage(
  title = "{shinygkv}",
  theme = bs_theme(
    version = 4,
    bootswatch = "minty",
    bg = "#fff",
    fg = "#000",
    primary = "#b10f21",
    base_font = c("Lucida Sans Unicode", "Lucida Grande", "Geneva", "Verdana", "sans-serif"),
  ),
  tabPanel(
    "Versicherte",
    reactable::reactableOutput("km6_table")
  )
)

# build server
server <- function(input, output) {
  output$km6_table <- reactable::renderReactable({
    table_df <- km6
    reactable::reactable(table_df,
      columns = list(
        year = colDef(
          name = "Datum",
          align = "center",
          minWidth = 60,
          format = colFormat(date = TRUE, locales = "de-DE")
        ),
        kvart = colDef(
          name = "Art",
          align = "left",
          minWidth = 60
        ),
        kvbezirk = colDef(
          name = "KV-Bezirk",
          align = "left"
        ),
        num = colDef(
          name = "Versicherte",
          align = "right",
          format = colFormat(separators = TRUE, locales = "de-DE")
        ),
        pct = colDef(
          name = "Marktanteil",
          align = "right",
          format = colFormat(percent = TRUE, digits = 1, locales = "de-DE")
        )
      ),
      striped = TRUE,
      defaultPageSize = 8
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
