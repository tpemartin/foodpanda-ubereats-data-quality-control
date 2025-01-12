# Load necessary packages
library(jsonlite)
library(base64enc)
library(readr)
library(dplyr)
library(purrr)
library(bigrquery)

stacked_data_upload_bigquery <- function(
    stacked_data, table_name,
    dataset_id = "ubereats_shoplist",
    project_id = "food-delivery-432217") {
    fields <- stacked_data |>
        as_bq_fields()

    # get data set
    ds <- bq_dataset(project_id, dataset_id)


    ## 5. upload the data to big query in a specific table with the fields
    bq_table_upload(
        x = bq_table(ds, table_name),
        values = stacked_data,
        fields = fields,
        create_disposition = "CREATE_IF_NEEDED"
    )
}
stacked_data_create_count_columns <- function(stacked_data) {
    stacked_data <- stacked_data |>
        dplyr::mutate(
            eyeball_count = purrr::map_dbl(score_breakdown, ~ .x$t120d_eyeball_count %||% NA),
            request_count = purrr::map_dbl(score_breakdown, ~ .x$t120d_request_count %||% NA)
        ) |>
        select(-score_breakdown)
    return(stacked_data)
}

folder_create_stacked_data <- function(folder_path) {
    # List all files in the specified folder
    files <- list.files(folder_path, full.names = TRUE)

    # Read and stack the data from all files in the folder
    stacked_data <- files |>
        purrr::map_dfr(read_shopdata)

    return(stacked_data)
}

# Define the read_shopdata function
read_shopdata <- function(file_path) {
    # Read the CSV file into a data frame
    shop_data <- suppressMessages(readr::read_csv(file_path))

    # Decode the score_breakdown column from Base64 and convert it to a list
    shop_data <- shop_data |>
        dplyr::mutate(score_breakdown = purrr::map(score_breakdown, ~ fromJSON(rawToChar(base64enc::base64decode(as.character(.))))))

    return(shop_data)
}

# # Example usage
# file_path <- "data/ubereats/2024-9-24/shopLst_21.9414135330001_120.720446352_2024-9-24.csv"
# shop_data <- read_shopdata(file_path)

# # Display the first few rows of the score_breakdown column
# glimpse(shop_data$score_breakdown)

read_ubereats_menu <- function(file_path) {
    # Read the CSV file into a data frame
    menu_data <- suppressMessages(readr::read_csv(file_path))

    menu_data |>
        dplyr::mutate(
            deliverFee = as.numeric(deliverFee),
            rateCt = as.numeric(rateCt),
            postalCode = as.character(postalCode),
        ) |>
        dplyr::mutate(
            catLst = purrr::map_chr(catLst, ~ {
                decoded <- safe_base64_decode(as.character(.))
                if (length(decoded) == 0) {
                    NA
                } else {
                    tryCatch({
                        (rawToChar(decoded))
                    }, error = function(e) {
                        NA
                    })
                }
            }),
            chain = purrr::map_chr(chain, ~ {
                decoded <- safe_base64_decode(as.character(.))
                if (length(decoded) == 0) {
                    NA
                } else {
                    tryCatch({
                        (rawToChar(decoded))
                    }, error = function(e) {
                        NA
                    })
                }
            }),
            menu = purrr::map_chr(menu, ~ {
                decoded <- safe_base64_decode(as.character(.))
                if (length(decoded) == 0) {
                    NA
                } else {
                    tryCatch({
                        (rawToChar(decoded))
                    }, error = function(e) {
                        NA
                    })
                }
            })
        ) -> menu_data

    return(menu_data)
}

safe_base64_decode <- function(encoded_string) {
  tryCatch({
    base64enc::base64decode(as.character(encoded_string))
  }, error = function(e) {
    raw(0)  # Return an empty raw vector on error
  })
}
ensure_menu_data_types <- function(menu_data) {
    menu_data <- menu_data |>
        dplyr::mutate(
            shopCode = as.character(shopCode),
            location = as.character(location),
            updateDate = as.character(updateDate),
            shopName = as.character(shopName),
            address = as.character(address),
            postalCode = as.numeric(postalCode),
            shopLat = as.numeric(shopLat),
            shopLng = as.numeric(shopLng),
            city = as.logical(city),
            pickupTime = as.character(pickupTime),
            deliverFee = as.numeric(deliverFee),
            rate = as.numeric(rate),
            rateCt = as.numeric(rateCt),
            storeAvailabilityStatus = as.numeric(storeAvailabilityStatus)
        )
    return(menu_data)
}
