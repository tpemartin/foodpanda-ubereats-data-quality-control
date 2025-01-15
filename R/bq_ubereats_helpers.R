library(tidyverse)
library(dplyr)
library(bigrquery)
library(DBI)
project_id = "food-delivery-432217"

create_connection <- function(dataset_id = "ubereats_menu") {
  # create a connection
  con <- dbConnect(
    bigrquery::bigquery(),
    project = project_id,
    dataset = dataset_id
  )
  return(con)
}
