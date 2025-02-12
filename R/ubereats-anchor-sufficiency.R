source("R/bq_ubereats_helpers.R")
source("R/ubereats-anchor-sufficiency-helpers.R")

connections <- ubereats_connections()

# list tables
tables <- dbListTables(connections$ubereats_shoplist)

# shoplist----
## 2024-9-1 ----
tablename <- "2024-9-1"
tb <- tbl(
  connections$ubereats_shoplist, tablename
)

shop_list0 <- tb |> collect()

shop_list0 |>
  tidy_shop_list_and_create_anchor_power(tablename) -> results0

shop_list_withPower <- results0$shop_list
shop_list_summary <- results0$shop_list_summary

### sufficient anchors----
# obtain_sufficient_anchors <- function(target_date)
target_date <- tablename

sufficient_anchors <-
  getShopList_sufficient_anchors(
    results0$shop_list_summary,
    results0$shop_list
  )
### upload Gsheets ----
results0$shop_list |>
  dplyr::group_by(anchor) |>
  dplyr::summarise(
    n_shop = n()
  ) |>
  dplyr::mutate(
    isSufficient = (anchor %in% sufficient_anchors) * 1
  ) -> sufficient_anchors_summary
results0$shop_list |>
  mutate(
    location = paste0(latitude, ",", longitude)
  ) |>
  select(shopCode, location) |>
  group_by(shopCode) |>
  slice(1) -> shops_covered

gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"

sufficient_anchors_summary |>
  googlesheets4::write_sheet(
    gsUrl,
    sheet = "sufficient anchors: shoplist"
  )
shops_covered |>
  googlesheets4::write_sheet(
    gsUrl,
    sheet = "shops covered: shoplist"
  )

shop_list0 |>
  create_shops_anchors_coverage(sufficient_anchors) ->
shops_anchors_coverage

shops_anchors_coverage |>
  googlesheets4::write_sheet(
    gsUrl,
    sheet = "shops anchors coverage: shoplist"
  )

# more anchors----
source("R/bq_ubereats_helpers.R")
source("R/ubereats-anchor-sufficiency-helpers.R")
connections <- ubereats_connections()

gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"


## 2024-9-15----
tablename2 <- "2024-9-15"
{
  tb <- tbl(
    connections$ubereats_shoplist, tablename2
  )
  shop_list2 <- tb |> collect()

  shops_covered <-
    shops_anchors_coverage$shopCode
  anchors <- 
    shops_anchors_coverage$anchor |>
    unique()


  extra_sufficient_anchors <-
    safely_findMore_sufficient_anchors(
      shop_list2, shops_covered, anchors, tablename2
    )

  # update GSheets
  shops_anchors_coverage_extra <-
    Shops_anchors_coverage_extra(
      shop_list2, shops_covered,
      extra_sufficient_anchors
    )

  shops_anchors_coverageUpdated <-
    bind_rows(
      shops_anchors_coverage,
      shops_anchors_coverage_extra
    )

  shops_anchors_coverageUpdated |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "shops anchors coverage: shoplist"
    )
  
  shops_anchors_coverage <-
    shops_anchors_coverageUpdated
}
## 2024-9-30----
tablename2 <- "2024-9-30"
{
  tb <- tbl(
    connections$ubereats_shoplist, tablename2
  )
  shop_list2 <- tb |> collect()

  shops_covered <-
    shops_anchors_coverage$shopCode
  anchors <-
    shops_anchors_coverage$anchor |>
    unique()
  extra_sufficient_anchors <-
    safely_findMore_sufficient_anchors(
      shop_list2, shops_covered, anchors,
      tablename2
    )

  # update GSheets
  shops_anchors_coverage_extra <-
    Shops_anchors_coverage_extra(
      shop_list2, shops_covered,
      extra_sufficient_anchors
    )

  shops_anchors_coverageUpdated <-
    bind_rows(
      shops_anchors_coverage,
      shops_anchors_coverage_extra
    )

  shops_anchors_coverageUpdated |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "shops anchors coverage: shoplist"
    )

  shops_anchors_coverage <-
    shops_anchors_coverageUpdated
}

## upload to bigquery ----
source("R/bigQuery-helpers.R")

shops_anchors_coverage |>
  stacked_data_upload_bigquery(
    "sufficient_anchors_coverage",
    dataset_id = "ubereats_anchor",
    project_id = "food-delivery-432217"
  )

shops_anchors_coverage$location |>
  unique() |> length()


# Menu coverage check-----

