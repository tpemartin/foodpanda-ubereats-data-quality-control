# Reference week -----
library(tidyverse)

# date folder


foodpanda <- read_csv("data/foodpanda/2024-09-30/all_most_2024-09-30.csv")

# for each storeUuid, retain only the first one so that no duplicate storeUuid
# foodpanda <- foodpanda |>
#     group_by(shopCode) |>
#     slice(1) |>
#     ungroup()
#

foodpanda |>
    rename(lat = "latitude", lon = "longitude") |>
    econDV2::augment_county_township_using_lon_lat() -> foodpanda

foodpanda <- foodpanda |>
    mutate(
        county = factor(county),
    )

# create a function that take folder as input and return the cleaned data
clean_foodpanda <- function(date_file) {
    foodpanda <- read_csv(date_file)


    foodpanda |>
        rename(lat = "latitude", lon = "longitude") |>
        econDV2::augment_county_township_using_lon_lat() -> foodpanda

    return(foodpanda)
}
# create 2024-09-24 to 2024-09-30
dates <- paste0("2024-09-", 24:30)
date_files <- glue::glue("data/foodpanda/{dates}/all_most_{dates}.csv") 

# clean all the folders and bind them together
foodpanda <- date_files |>
    map_dfr(clean_foodpanda)


# create a weekday column that shows mon to sun from date column
foodpanda <- foodpanda |>
    mutate(
        # get ymd from updateDate
        updateDate=ymd_hms(updateDate),
        date = date(updateDate),
        weekday = lubridate::wday(date, label = TRUE, abbr = TRUE)
    )

# get yyyy-mm-dd from updateDate


glimpse(foodpanda)

# drop anchor_latitude, anchor_longitude
foodpanda <- foodpanda |>
    select(-c(anchor_latitude, anchor_longitude))

glimpse(foodpanda)

# Population statistics
## For each weekday, what's the distribution of the number of stores
foodpanda |>
    group_by(weekday) |>
    summarise(
        n = n()
    ) -> foodpanda_weekday

foodpanda_weekday |>
    ggplot(aes(x = weekday, y = n)) +
    geom_line(group = 1) +
    labs(
        title = "Number of stores on each weekday",
        x = "Weekday",
        y = "Number of stores"
    )

foodpanda_weekday |>
    write_sheet(
        "https://docs.google.com/spreadsheets/d/1IeuC0bjr6GG9J3i6ekZUPY0gBvO0gDWpzZBcbjOc268/edit?gid=0#gid=0",
                sheet = "weekday count"
    )



## For each weekday, what's the distribution of the number of stores in each county
### fill by county's level sequence should be based on the number of stores
foodpanda |>
    group_by(weekday, county) |>
    summarise(
        n = n()
    ) -> foodpanda_weekday_county



# compute the total number of stores in each county and sort them in descending order
# use that order to sort the county factor
foodpanda_weekday_county |>
    group_by(county) |>
    summarise(
        n = mean(n)
    ) |>
    arrange(desc(n)) |>
    pull(county) -> county_order

foodpanda <- mutate(
    foodpanda,
    county = factor(county, levels = county_order)
)

foodpanda_weekday_county |>
    mutate(
        county = factor(county, levels = rev(county_order))
    ) -> foodpanda_weekday_county

foodpanda_weekday_county |>
    ggplot(aes(x = weekday, y = n, fill = county)) +
    geom_col(position = "dodge") +
    labs(
        title = "Number of stores on each weekday in each county",
        x = "Weekday",
        y = "Number of stores"
    )+
    coord_flip()

# fluctuation of the number of stores in each county relative to its weekday average
foodpanda_weekday_county |>
    filter(county != "") |>
    group_by(county) |>
    mutate(
        n = n/mean(n)
    ) |>
    ggplot(aes(x = weekday, y = n, color = county, group=county)) +
    geom_line() +
    labs(
        title = "Fluctuation of the number of stores in each county relative to its weekday average",
        x = "Weekday",
        y = "Number of stores"
    )

foodpanda_weekday_county |>
    ggplot(aes(x = weekday, y = n, color = county, group=county)) +
    geom_line() +
    labs(
        title = "Number of stores on each weekday in each county",
        x = "Weekday",
        y = "Number of stores"
    )

# pivot wider to have each weekday as a column
foodpanda_weekday_county |>
    pivot_wider(names_from = weekday, values_from = n) -> foodpanda_weekday_county_wide

foodpanda_weekday_county_wide |>
    write_sheet(
"https://docs.google.com/spreadsheets/d/1IeuC0bjr6GG9J3i6ekZUPY0gBvO0gDWpzZBcbjOc268/edit?gid=0#gid=0",
        sheet = "weekday_county count"
    )

# filter county is ""
foodpanda |>
    dplyr::filter(county == "") |>
    select(storeUuid, name, lat, lon, county)
