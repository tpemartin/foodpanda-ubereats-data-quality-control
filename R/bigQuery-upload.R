library(tidyverse)
source("R/bigQuery-helpers.R")

# Ubereats ----
## shoplist -----
folder <- "data/ubereats/2024-9-30"

folder |>
    folder_create_stacked_data() -> stacked_data
stacked_data |>
    stacked_data_create_count_columns() -> stacked_data

glimpse(stacked_data)

# BigQuery
table_name <- folder |> basename()

stacked_data |>
    stacked_data_upload_bigquery(table_name,
    dataset_id = "ubereats_shoplist",
    project_id = "food-delivery-432217")

## menu ----
source("R/bigQuery-helpers.R")

folder <- "data/ubereats-menu/2024-9-27"

### list files
files <- list.files(folder, full.names = TRUE)

fileX <- files[[1]]

menu_data <- read_ubereats_menu(fileX)

files |>
    purrr::map_dfr(
        read_ubereats_menu
    ) -> stacked_data


fields <- stacked_data |>
    as_bq_fields()
table_name <- folder |> basename()

stacked_data_upload_bigquery(
    stacked_data, table_name,
    dataset_id = "ubereats_menu",
    project_id = "food-delivery-432217"
)
