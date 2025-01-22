source("R/bigQuery-helpers.R")
## import popular items csv files ----
### folder path of csv files
uri4 <- "data/ubereats-menu/popular-items/extracted_csv_2024_09_04"

### list files
files <- list.files(uri4, full.names = TRUE)

files |>
  purrr::map_dfr(read_csv) -> stacked_df

stacked_df |> glimpse()

fields <- stacked_df |>
    as_bq_fields()

table_name <- "2024-09-04"

stacked_data_upload_bigquery(
    stacked_df, table_name,
    dataset_id = "ubereats_popular_items",
    project_id = "food-delivery-432217"
)

### path of csv file
uri5 <- "data/ubereats-menu/popular-items/extracted_result_2024_09_05.csv"

df_popItems <- read_csv(uri5)
df_popItems |>
  distinct() -> df_popItems

stacked_data_upload_bigquery(
  df_popItems, "2024-09-05",
  dataset_id = "ubereats_popular_items",
  project_id = "food-delivery-432217"
)
