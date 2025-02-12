# download from google drive
driveUrl <- "https://drive.google.com/file/d/1KC-TBohnzT3Toq7ZIfSUhaaAhKrfK1wX/view?usp=drive_link"

library(googledrive)
drive_download(as_id(driveUrl), path = "foodpanda_menu.csv")               

library(readr)
library(tidyverse)
library(base64enc)
library(jsonlite)
foodpanda_menu <- read_csv("foodpanda_menu.csv")

# select shopCode, updateDate, catList, menu
foodpanda_menu <- foodpanda_menu %>% select(shopCode, shopName, updateDate, catLst, menu)


# base64 decode catList and menu
foodpanda_menu$catLst <- sapply(foodpanda_menu$catLst, function(x) {
  rawToChar(base64decode(x))
})

# base64 decode menu
foodpanda_menu$menu <- sapply(foodpanda_menu$menu, function(x) {
  rawToChar(base64decode(x))
})


foodpanda_menu$menu[[6]]
# json parse 
foodpanda_menu$menu[[6]] %>% fromJSON() -> menu_json

names(menu_json)

# select  "productCode" "product" "preDiscountPrice" "price" 'tags'
menu_json %>% select(productCode, product, preDiscountPrice, price, tags) |>
  mutate(
    tags=as.character(tags)
    )-> menu_json2

source("R/foodpanda_menu_helpers.R")
menu_json2 |>
  tidy_menu_dataframe() |>
  head()


