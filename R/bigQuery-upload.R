library(tidyverse)
source("R/bigQuery-helpers.R")

# Ubereats ----
## shoplist -----
folder <- "data/ubereats/2024-10-31"

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

folder <- "data/ubereats-menu/2024-9-8"

### list files
files <- list.files(folder, full.names = TRUE)

menu_data <- read_ubereats_menu(files[[1]])

files |>
    purrr::map(
        purrr::safely(read_ubereats_menu)
    ) -> stacked_data

whichHasNoError <- purrr::map_lgl(stacked_data, ~ is.null(.x$error)) |> which()

valid_stacked_data <- stacked_data[whichHasNoError]

valid_stacked_data[[1]]$result -> df0
for(.x in 2:length(valid_stacked_data)){
  valid_stacked_data[[.x]]$result -> df1
    df0 <- dplyr::bind_rows(df0, df1)
}

fields <- df0 |>
    as_bq_fields()
table_name <- folder |> basename()

stacked_data_upload_bigquery(
    df0, table_name,
    dataset_id = "ubereats_menu",
    project_id = "food-delivery-432217"
)
