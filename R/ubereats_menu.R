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
decompose_df_menu <- function(df_menu) {
    df_menu |>
        select(uuid, product, price, preDiscountPirce) |>
        rename(preDiscountPrice = preDiscountPirce) -> menu1
    df_menu |> select(-product, -price, -preDiscountPirce) -> menu2
    return(list(menu1, menu2))
}
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
test_prepare_menu_sheetData <- function() {
    fileLink <- "https://drive.google.com/file/d/12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F/view?usp=drive_link"

    # Get the file dribble
    dribbl <- fileLink |>
        as_dribble()

    # download the file
    drive_download(dribbl, path = dribbl$name, overwrite = TRUE)

    ubereats_menu <- read_csv(dribbl$name)

    # prepare_menu_sheetData function from ubereats_menu
    ubereats_menu |> prepare_menu_sheetData() -> ubereats_menu
    ubereats_menu |> glimpse()
}
