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
