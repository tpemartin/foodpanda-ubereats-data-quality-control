# Reference week -----
library(tidyverse)

# date folder
foodpanda <- read_csv("data/foodpanda/2024-09-30/all_most_2024-09-30.csv")
glimpse(foodpanda)

foodpanda$platform <- "foodpanda"
# create location as "latitude, longitude"
foodpanda$location <- paste(foodpanda$latitude, foodpanda$longitude, sep = ",")
# create tooltips as "shopName, shopCode, address"
foodpanda$tooltips <- paste(foodpanda$shopName, foodpanda$shopCode, foodpanda$address, sep = ",")

# Reference week -----
library(tidyverse)

# date folder
date_folder <- "data/ubereats/2024-9-30"

# read all csv files in the folder and bind them together
ubereats <- list.files(date_folder, full.names = TRUE) |>
    map_dfr(read_csv)

# create location as "latitude, longitude"
ubereats$location <- paste(ubereats$latitude, ubereats$longitude, sep = ",")

# create tooltips as "name, storeUuid"
ubereats$tooltips <- paste(ubereats$name, ubereats$storeUuid, sep = ",")

ubereats$platform <- "ubereats"

# combine foodpanda and ubereats with only location, tooltips, platform
foodpanda_ubereats <- bind_rows(foodpanda |>
    select(location, tooltips, platform), ubereats |>
    select(location, tooltips, platform)) 

foodpanda_ubereats |>
  googlesheets4::write_sheet("https://docs.google.com/spreadsheets/d/1hOMJ5ioeVZco16lZbNBNXuThf8AR1kppNlf-4I5Auyo/edit?gid=0#gid=0",
  sheet="foodpanda_ubereats")

glimpse(ubereats)
