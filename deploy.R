# Authenticate
rsconnect::setAccountInfo(
  name = Sys.getenv("SHINY_ACC_NAME"),
  token = Sys.getenv("TOKEN"),
  secret = Sys.getenv("SECRET")
)
# Deploy
rsconnect::deployApp(appFiles = c("app.R", "R/km6-chart.R", "data/km6.rds"))
