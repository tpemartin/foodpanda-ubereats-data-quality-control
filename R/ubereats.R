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
  map_dfr(~{
    .x |>
      base64enc::base64decode() |>
      rawToChar() |>
      jsonlite::fromJSON() -> score_breakdown
      tibble(
        t120d_eyeball_count=score_breakdown$t120d_eyeball_count,
        t120d_request_count=score_breakdown$t120d_request_count
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
