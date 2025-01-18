library(dplyr)
library(bigrquery)
library(DBI)
dataset_id = "ubereats_shoplist_stacked"


project_id = "food-delivery-432217"

# create a connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = project_id,
  dataset = dataset_id
)

# random sample 10% of table "2024-9"

query <- "SELECT * FROM `food-delivery-432217.ubereats_shoplist_stacked.2024-9` TABLESAMPLE SYSTEM (10 PERCENT)"

smpl_data <- dbGetQuery(con, query) 

