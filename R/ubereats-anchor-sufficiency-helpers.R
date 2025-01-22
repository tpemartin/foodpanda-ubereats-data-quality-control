tidy_shopList <- function(shop_list){
  shop_list |>
    rename(
      "shopCode" = "storeUuid"
    ) -> shop_list 
  shop_list |>
    mutate(
      anchor=paste0(anchor_latitude,",",anchor_longitude) )-> shop_list
  shop_list
}
compute_anchor_shop_efficiency <- function(shop_list, tablename){
  
  shop_list |>
    group_by(shopCode) |>
    summarise(
      shopName = first(name),
      shopLat = first(latitude),
      shopLng = first(longitude),
      n_item = n(),
    ) |>
    ungroup() -> shop_list_summary
  shop_list_summary$fileDate = tablename
  shop_list_summary |>
    arrange(
      n_item
    )-> shop_list_summary
  shop_list_summary
  
  # compute each anchor's power
  shop_list |>
    group_by(anchor) |>
    summarise(
      power = n_distinct(shopCode),
    ) |>
    arrange(
      desc(power)
    ) -> anchor_power
  
  return(
    list(
      anchor_power = anchor_power,
      shop_list_summary = shop_list_summary
    )
  )
}
augment_shop_list_with_power <- function(shop_list, anchor_power){
  shop_list |>
    left_join(
      anchor_power,
      by = "anchor"
    ) -> shop_list
  
  shop_list |>
    arrange(
      desc(power)
    ) -> shop_list_withPower
  shop_list_withPower
}

tidy_shop_list_and_create_anchor_power <- function(shop_list, tablename){
  shop_list |>
    tidy_shopList() -> tidy_shop_list
  tidy_shop_list |>
    compute_anchor_shop_efficiency(tablename) -> 
    anchor_shop_efficiency
  tidy_shop_list |>
    augment_shop_list_with_power(anchor_shop_efficiency$anchor_power) -> tidy_shop_list
  
  shop_list_summary <- anchor_shop_efficiency$shop_list_summary
  return(
    list(
      shop_list = tidy_shop_list,
      shop_list_summary = shop_list_summary
    )
  )
}