km6_chart <- function(dat, .serie) {
  title <- km6_title(.serie)

  if (.serie == "pct") {
    dat |>
      group_by(kvart) |>
      e_chart(year) |>
      e_line(pct) |>
      e_y_axis(
        formatter = e_axis_formatter("percent", digits = 0)
      ) |>
      e_tooltip(
        trigger = "axis",
        valueFormatter = htmlwidgets::JS("function(value) {
                                            simpleFormat = new Intl.NumberFormat('de-DE', {
                                              style: 'percent',
                                              maximumFractionDigits: 1
                                            });

                                          return simpleFormat.format(value);
                                         }")
      )
  } else {
    dat |>
      group_by(kvart) |>
      e_chart(year) |>
      e_area(num, stack = "kvart") |>
      e_tooltip("axis")
  }
}

km6_title <- function(x) {
  switch(x,
    num = "Versicherte",
    pct = "Marktanteil"
  )
}
