FROM rocker/shiny:4.2.1
RUN install2.r rsconnect tibble dplyr stringr htmltools bslib reactable echarts4r
WORKDIR /home/shinygkv
RUN mkdir -p /data
RUN mkdir -p /R
COPY app.R app.R
COPY data data
COPY deploy.R deploy.R
CMD Rscript deploy.R
