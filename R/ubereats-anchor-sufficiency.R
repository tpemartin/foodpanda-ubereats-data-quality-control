source("R/bq_ubereats_helpers.R")
source("R/ubereats-anchor-sufficiency-helpers.R")

connections <- ubereats_connections()

# list tables
tables <- dbListTables(connections$ubereats_shoplist)

# shoplist----
tablename <- "2024-9-1"
tb <- tbl(
  connections$ubereats_shoplist, tablename
)

shop_list <- tb |> collect() 

shop_list |>
  tidy_shop_list_and_create_anchor_power(tablename) -> results

shop_list_withPower <- results$shop_list
shop_list_summary <- results$shop_list_summary

## sufficient anchors----
# obtain_sufficient_anchors <- function(target_date) 
target_date = tablename
{
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
}

