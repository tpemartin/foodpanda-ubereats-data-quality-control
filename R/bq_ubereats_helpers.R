library(tidyverse)
library(dplyr)
library(bigrquery)
library(DBI)
project_id = "food-delivery-432217"

ubereats_connections <- function(){
  # connections ----
  connections <- list()
  dataset_id <- "ubereats_popular_items"
  connections[["ubereats_popular_items"]] <- create_connection(dataset_id = dataset_id)
  connections[["ubereats_menu"]] <-
    create_connection(dataset_id = "ubereats_menu")
  connections[["ubereats_shoplist"]] <-
    create_connection("ubereats_shoplist")
  connections[["ubereats_shoplist_stacked"]] <-
    create_connection("ubereats_shoplist_stacked")
  
  connections[["ubereats_shoplist_stacked"]] <- 
    create_connection("ubereats_shoplist_stacked")
  connections
}
create_connection <- function(dataset_id = "ubereats_menu") {
  # create a connection
  con <- dbConnect(
    bigrquery::bigquery(),
    project = project_id,
    dataset = dataset_id
  )
  return(con)
}

create_menu_summary <- function(df_menu){
  # df_menu = shop_menus[[1]]
  # glimpse(df_menu)
  df_menu |>
    dplyr::mutate(
      updateDate = lubridate::mdy(updateDate)
    ) |>
    dplyr::group_by(
      localtion
    ) |>
    summarise(
      updateDate = updateDate[[1]],
      wday = lubridate::wday(updateDate[[1]], label=T),
      n_menu=n()
    ) |>
    ungroup() |>
    arrange(
      desc(n_menu)
    ) -> df_menu_summary
  
  # remove "[" and "]" from localtion
  df_menu_summary$localtion <- stringr::str_remove_all(df_menu_summary$localtion, "\\[|\\]")
  df_menu_summary
}
steady_popular_items <- function(popUuid){
  popUuid |>
    purrr::reduce(
      function(out,inp){
        inp |>
          stringr::str_replace_all("'",'"') |>
          jsonlite::fromJSON() |>
          setdiff(out)
      }) |>
    jsonlite::toJSON(auto_unbox=T) 
}
summarise_repeatRequest_per_shop <- function(shop_menuX, tablename=""){
  shop_menuX |>
    group_by(shopCode) |>
    summarise(
      shopName = first(shopName),
      shopLat = first(shopLat),
      shopLng = first(shopLng),
      anchor = first(localtion),
      n_item = n(),
    ) |>
    ungroup()-> shop_menuX_summary
  shop_menuX_summary$fileDate = tablename
  shop_menuX_summary
}
obtain_sufficient_anchors <- function(target_date) {
  shop_menus_repeatRequest_summary2 |>
    dplyr::filter(
      fileDate == target_date
    ) -> shop_menus_repeatRequest_summary2_X
  # sort shop_menus_repeatRequest_summary2_X its n_item from small to the largest
  
  shop_menus_repeatRequest_summary2_X |>
    dplyr::arrange(n_item) -> shop_menus_repeatRequest_summary2_X
  
  
  # shop_menus_repeatRequest_summary2 |> View()
  
  # obtain the df under the key fileDate of shop_menus
  
  shop_menus[[target_date]] -> shop_menuX
  
  cat("initial anchor number: ", 
      length(unique(shop_menus[[target_date]]$localtion)), "\n")
  
  # View(shop_menuX)
  
  # remove "[" and "]" from localtion
  shop_menuX$localtion <- stringr::str_remove_all(shop_menuX$localtion, "\\[|\\]")
  # rename localtion to location
  shop_menuX |>
    rename(
      "anchor"="localtion"
    ) -> shop_menuX
  
  # View(shop_menuX)
  
  # Used anchors
  shop_menuX$anchor |>
    unique() |> length()
  
  
  sufficient_anchors <- character(0)
  maxIterations <- 600
  it <- 1
  nrow0 <- nrow(shop_menus_repeatRequest_summary2_X)+1
  while(
    nrow0 > 0
    && it < maxIterations 
    && nrow(shop_menus_repeatRequest_summary2_X) < nrow0
  ){
    nrow0 <- nrow(shop_menus_repeatRequest_summary2_X)
    shop_menus_repeatRequest_summary2_X$shopCode[1] -> shopCode_X
    
    shop_menuX |>
      dplyr::filter(
        shopCode == shopCode_X
      ) -> shop_menuX_y
    
    anchorX <- shop_menuX_y$anchor
    
    sufficient_anchors <- c(sufficient_anchors, anchorX)
    
    # obtain all the shopCode that has been covered by the anchor point anchorX in shop_menuX
    
    shop_menuX$shopCode[
      shop_menuX$anchor %in% anchorX
    ] -> shopCodes_covered
    
    shop_menus_repeatRequest_summary2_X |>
      dplyr::filter(
        !(shopCode %in% shopCodes_covered)
      ) -> shop_menus_repeatRequest_summary2_X
    
    shop_menuX |>
      dplyr::filter(
        !(shopCode %in% shopCodes_covered)
      ) -> shop_menuX
    
    cat(
      "i: ", it, " nrow: ", nrow(shop_menus_repeatRequest_summary2_X), "\n"
    )
    
    it <- it+1
  }
  return(sufficient_anchors)
}

