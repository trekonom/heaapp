library(shiny)
library(bslib)
library(reactable)
library(dplyr)
library(echarts4r)

source("km6-chart.R")

# read in data
km6 <- readRDS("data/km6.rds")

# ui
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
    "Table",
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        selectInput("kvbezirk", "Bezirk", choices = unique(km6$kvbezirk)),
        selectInput("kvart", "Art", choices = unique(km6$kvart))
      ),
      mainPanel = mainPanel(
        reactable::reactableOutput("km6_table")
      )
    )
  ),
  tabPanel(
    "Marktanteil",
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        selectInput("kvbezirk1", "Bezirk", choices = unique(km6$kvbezirk))
      ),
      mainPanel = mainPanel(
        echarts4r::echarts4rOutput("km6_chart")
      )
    )
  )
)

# build server
server <- function(input, output) {
  output$km6_table <- reactable::renderReactable({
    table_df <- km6 |>
      filter(kvbezirk %in% input$kvbezirk,
             kvart %in% input$kvart)
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

  output$km6_chart <- echarts4r::renderEcharts4r({
    dat <- km6 |>
      filter(kvbezirk %in% input$kvbezirk1)

    km6_chart(dat, "pct")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
