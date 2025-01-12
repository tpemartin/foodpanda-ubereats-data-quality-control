library(dplyr)
library(bigrquery)
library(DBI)
dataset_id = "ubereats_shoplist"
project_id = "food-delivery-432217"


# create a connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = project_id,
  dataset = dataset_id
)

# Get all the table names
tables <- dbListTables(con)
tables

# previes combined_results
combined_results <- dbReadTable(con, "combined_results")
head(combined_results)
