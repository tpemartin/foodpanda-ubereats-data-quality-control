# create a function that take menu_json and return a tibble as menu_json2 when there is variables missing in menu_json then add those variables with NA
library(tidyverse)
tidy_menu_dataframe <- function(menu_json){
  if(!"productCode" %in% names(menu_json)){
    menu_json$productCode <- NA
  }
  if(!"product" %in% names(menu_json)){
    menu_json$product <- NA
  }
  if(!"preDiscountPrice" %in% names(menu_json)){
    menu_json$preDiscountPrice <- NA
  }
  if(!"price" %in% names(menu_json)){
    menu_json$price <- NA
  }
  if(!"tags" %in% names(menu_json)){
    menu_json$tags <- NA
  }
  menu_json %>% select(productCode, product, preDiscountPrice, price, tags) |>
    mutate(
      tags=as.character(tags)
    )-> menu_json2
  
  return(menu_json2)
}
