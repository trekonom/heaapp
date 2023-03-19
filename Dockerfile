FROM rocker/shiny:4.2.1
RUN install2.r rsconnect tibble dplyr stringr htmltools bslib reactable echarts4r
WORKDIR /home/shinygkv
RUN mkdir -p /data
RUN mkdir -p /R
COPY app.R app.R
COPY R/server.R R/server.R
COPY data/km6.rds data/km6.rds
COPY R/deploy.R R/deploy.R
CMD Rscript R/deploy.R
