library(googledrive)
library(tidyverse)
import_csv <- function(driveFileUrl) {
    # Get the file dribble
    dribbl <- driveFileUrl |>
        as_dribble()

    # download the file
    drive_download(dribbl, path = dribbl$name)

    # read csv from dribb name
    ubereats <- read_csv(dribbl$name)

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

    return(ubereats)
}

list_all_files <- function(driveFolderUrl) {
    # get the dribble of the folder
    dribble <- driveFolderUrl |>
        as_dribble()

    # list all the files in the folder
    dribble |>
        drive_ls() -> files

    return(files[c("name","id")])
}