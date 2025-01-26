
filter_extra_anchors <- function(shop_list2, sufficient_anchors,tablename2) {
  
  shop_list2 |>
    tidy_shop_list_and_create_anchor_power(tablename2) |>
    filter_uncovered_shops(sufficient_anchors) -> results2
  
  results2 |>
    obtain_extra_sufficient_anchors() -> extra_sufficient_anchors
}

getShopList_sufficient_anchors <- function(shop_list_summary, shop_list_withPower) {
    sufficient_anchors <- character(0)
    maxIterations <- 600
    it <- 1
    nrow0 <- nrow(shop_list_summary)+1
    while(
      nrow0 > 0
      && it < maxIterations 
      # && nrow(shop_list_summary) < nrow0
    ){
     
      shop_list_summary$shopCode[1] -> shopCode_X
      
      shop_list_withPower |>
        dplyr::filter(
          shopCode == shopCode_X
        ) -> shop_list_withPower_y
      # if(nrow(shop_list_withPower_y) == 0){
      #   break
      # }
      anchorX <- shop_list_withPower_y$anchor[[1]]
      
      sufficient_anchors <- c(sufficient_anchors, anchorX)
      
      # obtain all the shopCode that has been covered by the anchor point anchorX in shop_list_withPower
      
      shop_list_withPower$shopCode[
        shop_list_withPower$anchor %in% anchorX
      ] -> shopCodes_covered
      
      shop_list_summary |>
        dplyr::filter(
          !(shopCode %in% shopCodes_covered)
        ) -> shop_list_summary
      
      shop_list_withPower |>
        dplyr::filter(
          !(shopCode %in% shopCodes_covered)
        ) -> shop_list_withPower
      
      cat(
        "anchors: ", it, " uncovered shops: ", nrow(shop_list_summary), "\n"
      )
      nrow0 <- nrow(shop_list_summary)
      it <- it+1
    }
    sufficient_anchors
  }


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
      n_request = n(),
    ) |>
    ungroup() -> shop_list_summary
  shop_list_summary$fileDate = tablename
  shop_list_summary |>
    arrange(
      n_request
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
filter_uncovered_shops <- function(results2,  sufficient_anchors) {
  results2$shop_list |>
    dplyr::filter(
      !(anchor %in% sufficient_anchors)
    ) -> shop_list2_sufficient
  
  results2$shop_list_summary |> 
    dplyr::filter(
      shopCode %in% shop_list2_sufficient$shopCode
    ) -> shop_list_summary2_sufficient
  return(
    list(
      shop_list2_sufficient=shop_list2_sufficient,
      shop_list_summary2_sufficient=shop_list_summary2_sufficient
    )
  )
}

obtain_extra_sufficient_anchors <- function(results2){
  getShopList_sufficient_anchors(
    results2$shop_list_summary2_sufficient,
    results2$shop_list2_sufficient
  ) -> extra_sufficient_anchors
  extra_sufficient_anchors
}
findMore_sufficient_anchors <- function(shop_list2, shops_covered, anchors, tablename2) {
  shop_list2 |>
    tidy_shopList() -> shop_list2_tidy
  
  shop_list2_tidy |>
    dplyr::filter(
      !(shopCode %in% shops_covered), !(anchor %in% anchors)
    ) |>
    rename(
      "storeUuid"="shopCode")-> shop_list2_uncovered
  
  extra_sufficient_anchors <- 
    filter_extra_anchors(
      shop_list2_uncovered, anchors, tablename2
    )
  extra_sufficient_anchors
}
safely_findMore_sufficient_anchors <- function(shop_list2, shops_covered, anchors, tablename2) {
  extra_sufficient_anchors <- 
    tryCatch(
      {
        findMore_sufficient_anchors(
          shop_list2, 
          shops_covered, 
          anchors, tablename2
        )
      },
      error = function(e){
        anchors
      })
  extra_sufficient_anchors
}
Shops_anchors_coverage_extra <- function(shop_list2, shops_covered, extra_sufficient_anchors) {
  shop_list2 |>
    dplyr::filter(
      !(storeUuid %in% shops_covered)
    ) -> shop_list2_uncovered
  
  shop_list2_uncovered |>
    tidy_shopList() -> shop_list2_uncovered_tidy
  
  shops_anchors_coverage_extra <- 
    shop_list2_uncovered_tidy |>
    group_by(
      shopCode
    ) |>
    dplyr::filter(
      anchor %in% extra_sufficient_anchors
    ) |>
    slice(1) |>
    select(
      shopCode, anchor
    ) 
}

create_shops_anchors_coverage <- function(shop_list0, sufficient_anchors) {
  shop_list0|>
    tidy_shopList() -> shop_list0_tidy
  shop_list0_tidy |>
    dplyr::filter(
      anchor %in% sufficient_anchors
    ) |>
    dplyr::mutate(
      location = paste0(latitude, ",", longitude)
    ) |>
    dplyr::group_by(
      shopCode
    ) |>
    dplyr::slice(1) |>
    select(
      shopCode, anchor, location
    ) -> shops_anchors_coverage
}
