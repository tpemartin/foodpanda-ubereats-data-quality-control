library(tidyverse)
summarise_folder_csv_files <- function(folder, lat_lon_index=c(2,1)) {
   
    csvFiles <- list.files(folder, pattern = "shopLst.*\\.csv", full.names = TRUE)

    files_location_modified_time <- csvFiles |>
        map_dfr(
            ~ {
                tibble(
                    file = .x,
                    location = get_location(.x, lat_lon_index),
                    modified_time = file.info(.x)$mtime
                )
            }
        )

    files_lines <- files_location_modified_time$file |>
        map_int(
            count_lines
        )

    files_location_modified_time$obs <- files_lines - 1

    return(files_location_modified_time)
}

# helper functions

count_lines <- function(file) {
    #file = "data/foodpanda/2024-09-27/shopLst_121.640614712_24.5436774830001_2024-09-27.csv"
    file |> 
        readLines() |>
        length()
}
get_location <- function(file, lat_lon_index) {
    file |>
        str_extract_all("[0-9]+\\.[0-9]+") |>
        unlist() -> gps
    gps[lat_lon_index] |>
        paste0(collapse = ",")
}