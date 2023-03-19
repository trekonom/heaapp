## code to prepare `km6` dataset goes here

library(dplyr)
library(tidyr)

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = Sys.getenv("KM6DB"))

km6time <- tbl(con, "km6") |>
  mutate(kvbezirk = case_match(
    kvbezirk,
    c("Südwürttemberg", "Nordbaden", "Nord-Württemberg", "Südbaden") ~ "Baden-Württemberg",
    c("Pfalz", "Koblenz", "Rheinhessen", "Trier") ~ "Rheinland-Pfalz",
    c("Westfalen-Lippe", "Nordrhein") ~ "Nordrhein-Westfalen",
    .default = kvbezirk
  )) |>
  filter(
    type %in% "Insgesamt", sex %in% "Zusammen",
    status %in% "Mitglieder und Familienangehörige zusammen", age %in% "alle Altersgruppen"
  ) |>
  select(year, kvart, kvbezirk, num) |>
  collect()

DBI::dbDisconnect(con)

km6time <- km6time |>
  mutate(kvart = case_match(
    kvart,
    c("EKANG", "EKARB") ~ "VDEK",
    c("BKNP", "SEEKK") ~ "KBS",
    c("LKK") ~ "SVLFG",
    .default = kvart
  ),
  year = as.Date(paste0(year, "-07-01")),
  kvart = factor(kvart, c("VDEK", "AOK", "BKK", "IKK", "KBS", "SVLFG"))) |>
  summarise(num = sum(num), .by = c(year, kvart, kvbezirk)) |>
  mutate(pct = num / sum(num), .by = year) |>
  complete(year, kvart, kvbezirk)

readr::write_rds(km6time, "data/km6.rds")
