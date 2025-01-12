# Reference week -----
library(tidyverse)

# date folder
date_folder <- "data/ubereats/2024-9-27"

# read all csv files in the folder and bind them together
ubereats <- list.files(date_folder, full.names = TRUE) |>
    map_dfr(read_csv)

glimpse(ubereats)

# for each storeUuid, retain only the first one so that no duplicate storeUuid
ubereats <- ubereats |>
    group_by(storeUuid) |>
    slice(1) |>
    ungroup()

glimpse(ubereats)

ubereats |>
    rename(lat = "latitude", lon = "longitude") |>
    econDV2::augment_county_township_using_lon_lat() -> ubereats

# save as csv 
write_csv(ubereats, "data/ubereats/2024-9-27/ubereats-2024-9-27.csv")

ubereats <- ubereats |>
    mutate(
        county = factor(county),
    )

# create a function that take folder as input and return the cleaned data
clean_ubereats <- function(date_folder){
    date_folder = date_folders[[1]]
    date_folder
    # read all csv files in the folder and bind them together
    ubereats <- list.files(date_folder, full.names = T) |>
        map_dfr(read_csv)

    # for each storeUuid, retain only the first one so that no duplicate storeUuid
    ubereats <- ubereats |>
        group_by(storeUuid) |>
        slice(1) |>
        ungroup()

    ubereats |>
        rename(lat = "latitude", lon = "longitude") |>
        econDV2::augment_county_township_using_lon_lat() -> ubereats

    ubereats <- ubereats |>
        mutate(
            county = factor(county),
        )
    
    return(ubereats)
}

# create a vector of folder paths from 2024-9-24 to 2024-9-30 , month is in m format not mm

date_folders <- paste0("data/ubereats/2024-9-", 24:30)

# clean all the folders and bind them together
ubereats <- date_folders |>
    map_dfr(clean_ubereats)

# create a weekday column that shows mon to sun from date column
ubereats <- ubereats |>
    mutate(
        weekday = lubridate::wday(date, label = TRUE, abbr = TRUE)
    )

glimpse(ubereats)

# import augment_eyeball_request_count from urbereats_shopList.R
augment_eyeball_request_count <- function(ubereats){
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
    return(ubereats)
}

ubereats <- augment_eyeball_request_count(ubereats)

# drop anchor_latitude, anchor_longitude
ubereats <- ubereats |>
    select(-c(anchor_latitude, anchor_longitude))

glimpse(ubereats)

# Population statistics
## For each weekday, what's the distribution of the number of stores
ubereats |>
    group_by(weekday) |>
    summarise(
        n = n()
    ) -> ubereats_weekday

ubereats_weekday |>
    ggplot(aes(x = weekday, y = n)) +
    geom_line(group=1) +
    labs(
        title = "Number of stores on each weekday",
        x = "Weekday",
        y = "Number of stores"
    )

ubereats_weekday |>
  write_sheet(
    "https://docs.google.com/spreadsheets/d/1RUy5KjrZDR73dPe0rh4gi4eRdvh54N9csZuAefFYUjI/edit?gid=0#gid=0",
    sheet="weekday count"
  )



## For each weekday, what's the distribution of the number of stores in each county
### fill by county's level sequence should be based on the number of stores
ubereats |>
    group_by(weekday, county) |>
    summarise(
        n = n()
    ) -> ubereats_weekday_county



# compute the total number of stores in each county and sort them in descending order
# use that order to sort the county factor
ubereats_weekday_county |>
    group_by(county) |>
    summarise(
        n = mean(n)
    ) |> 
    arrange(desc(n)) |>
    pull(county) -> county_order

ubereats <- mutate(
    ubereats,
    county= factor(county, levels = county_order)
)

ubereats_weekday_county    |>
    mutate(
        county = factor(county, levels = rev(county_order))
    ) -> ubereats_weekday_county

ubereats_weekday_county  |>
    ggplot(aes(x = weekday, y = n, fill = county)) +
    geom_col(position = "dodge") +
    labs(
        title = "Number of stores on each weekday in each county",
        x = "Weekday",
        y = "Number of stores"
    ) +
    coord_flip()

# pivot wider to have each weekday as a column
ubereats_weekday_county |>
    pivot_wider(names_from = weekday, values_from = n) -> ubereats_weekday_county_wide

ubereats_weekday_county_wide |>
    write_sheet(
        "https://docs.google.com/spreadsheets/d/1RUy5KjrZDR73dPe0rh4gi4eRdvh54N9csZuAefFYUjI/edit?gid=0#gid=0",
        sheet = "weekday_county count"
    )

ubereats_weekday_county |>
    write_sheet(
        "https://docs.google.com/spreadsheets/d/1RUy5KjrZDR73dPe0rh4gi4eRdvh54N9csZuAefFYUjI/edit?gid=0#gid=0",
        sheet = "ubereats_weekday_county"
    )

# filter county is ""
ubereats |>
    dplyr::filter(county=="") |>
    select(storeUuid, name, lat, lon, county)
