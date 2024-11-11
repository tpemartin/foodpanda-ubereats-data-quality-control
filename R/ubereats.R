library(googledrive)
library(tidyverse)

# Explore 2024-09-01 folder ----

## Explore one file----
driveFileUrl <- "https://drive.google.com/file/d/1c73oL3RT5uJSdFmAjIeagcrqJazzXi4b/view?usp=drive_link"

# Get the file dribble
dribbl <- driveFileUrl |>
    as_dribble()

# download the file
drive_download(dribbl, path = dribbl$name)

# read csv from dribb name
ubereats <- read_csv(dribbl$name)

names(ubereats)
glimpse(ubereats)

# decode base64 from $score_breakdown
ubereats$score_breakdown |>
    map_dfr(~ {
        .x |>
            base64enc::base64decode() |>
            rawToChar() |>
            jsonlite::fromJSON() -> score_breakdown
        tibble(
            t120d_eyeball_count = score_breakdown$t120d_eyeball_count,
            t120d_request_count = score_breakdown$t120d_request_count
        )
    }) -> df_score_breakdown

# bind score_breakdown to ubereats
ubereats <- bind_cols(ubereats, df_score_breakdown)

# remove score_breakdown
ubereats <- select(ubereats, -score_breakdown)

glimpse(ubereats)

## Explore all files ----

driveFolderUrl <- "https://drive.google.com/drive/folders/1fGuCYiAnf9tjWvhRhwekHdqc0lhlzXDA"

# get the dribble of the folder
dribble <- driveFolderUrl |>
    as_dribble()

# list all the files in the folder
dribble |>
    drive_ls() -> files

# flattened csv files under extracted_csv_2024_09_05/

fileLink <- "https://drive.google.com/file/d/1fNN7A7ira_dxFXbmSQZzvJLB0jZkFKcT/view?usp=drive_link"

# Get the file dribble
dribbl <- fileLink |>
    as_dribble()

# download the file
drive_download(dribbl, path = dribbl$name)

# read csv from dribb name
dribbl$name
ubereats_flattened <- read_csv(dribbl$name)

glimpse(ubereats_flattened)

# menu csv -----
# if less and equal to 264 bytes, then it is an empty file

fileLink <- "https://drive.google.com/file/d/12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F/view?usp=drive_link"

# Get the file dribble
dribbl <- fileLink |>
    as_dribble()

# download the file
drive_download(dribbl, path = dribbl$name)

# read csv from dribb name
dribbl$name
ubereats_menu <- read_csv(dribbl$name)

glimpse(ubereats_menu)

# base64 decode menu column into list of data frames
ubereats_menu$menu |>
    map(~ {
        .x |>
            base64enc::base64decode() |>
            rawToChar() |>
            jsonlite::fromJSON() -> .menu
        as.data.frame(.menu)
    }) -> list_df_menu


glimpse(list_df_menu[[1]])

# for the data frame list_df_menu[1], break the data frame into two data frames
#  both have uuid. One has product, price, preDiscountPrice. The other has the remaining columns

df_menu <- list_df_menu[[1]]
df_menu |> glimpse()

df_menu |>
    select(uuid, product, price, preDiscountPirce) |>
    rename(preDiscountPrice = preDiscountPirce) -> menu1
df_menu |> select(-product, -price, -preDiscountPirce) -> menu2

# decompose_df_menu function from df_menu
decompose_df_menu <- function(df_menu) {
    df_menu |>
        select(uuid, product, price, preDiscountPirce) |>
        rename(preDiscountPrice = preDiscountPirce) -> menu1
    df_menu |> select(-product, -price, -preDiscountPirce) -> menu2
    return(list(menu1, menu2))
}

ubereats_menu |> glimpse()

list_df_menu[[1]] |>
    decompose_df_menu() -> menu_12

# turn each element of menu_12 into a json string
library(jsonlite)
menu_12 |>
    map(~ {
        .x |> toJSON() -> .json
        .json
    }) -> menu_12_json

tibble(
    menu1 = menu_12_json[[1]],
    menu2 = menu_12_json[[2]]
)

# decompose_menu_list_into_tibble function from one_list_df_menu

one_list_df_menu <- list_df_menu[[1]]
one_list_df_menu |> glimpse()

decompose_menu_list_into_tibble <- function(one_list_df_menu) {
    one_list_df_menu |> decompose_df_menu() -> menu_12
    menu_12 |>
        map(~ {
            .x |> toJSON() -> .json
            .json
        }) -> menu_12_json
    return(tibble(
        menu1 = as.character(menu_12_json[[1]]),
        menu2 = as.character(menu_12_json[[2]])
    ))
}

ubereats_menu$menu |>
    map(~ {
        .x |>
            base64enc::base64decode() |>
            rawToChar() |>
            jsonlite::fromJSON() -> .menu
        as.data.frame(.menu)
    }) -> list_df_menu

list_df_menu[[1]] |> decompose_menu_list_into_tibble() -> df_menu12

list_df_menu |>
    map_dfr(~ {
        .x |> decompose_menu_list_into_tibble()
    }) -> df_menu12

# bind df_menu12 to ubereats_menu and remove menu column
ubereats_menu <- bind_cols(ubereats_menu, df_menu12)
ubereats_menu <- select(ubereats_menu, -menu)

prepare_menu_sheetData <- function(ubereats_menu) {
    ubereats_menu$menu |>
        map(~ {
            .x |>
                base64enc::base64decode() |>
                rawToChar() |>
                jsonlite::fromJSON() -> .menu
            as.data.frame(.menu)
        }) -> list_df_menu

    list_df_menu[[1]] |> decompose_menu_list_into_tibble() -> df_menu12

    list_df_menu |>
        map_dfr(~ {
            .x |> decompose_menu_list_into_tibble()
        }) -> df_menu12

    # bind df_menu12 to ubereats_menu and remove menu column
    ubereats_menu <- bind_cols(ubereats_menu, df_menu12)
    ubereats_menu <- select(ubereats_menu, -menu)
}
