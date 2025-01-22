source("R/bq_ubereats_helpers.R")

connections <- ubereats_connections()

# download smpl-2024-10-13 table from the current connection
df <- list()
popular_items <- tbl(
  connections$ubereats_popular_items, "2024-09-04"
)

popular_items |>
  collect() -> df$popular_items

# shop menus ----
# list all tables from connection$ubereats_menu
list_tables <- dbListTables(connections$ubereats_menu)
list_tables

# collect one table
shop_menus <- list()

shop_menus[[list_tables[[1]]]] <- tbl(
  connections$ubereats_menu, list_tables[[1]]
) |> collect()

## anchor point efficiency ----
source("R/bq_ubereats_helpers.R")

list_tables[-1] |>
  purrr::walk(
    ~ {
      .GlobalEnv$shop_menus[[.x]] <- tbl(
        connections$ubereats_menu, .x
      ) |> collect()
    }
  )

seq_along(shop_menus) |>
  purrr::map_dfr(~ {
    cat(names(shop_menus)[.x], " ")

    create_menu_summary(shop_menus[[.x]]) -> dfx
    dfx$fileDate <- names(shop_menus)[.x]
    dfx
  }) -> df_shop_menus_summary

# upload to google sheets
{
  gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"

  df_shop_menus_summary |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "爬點效率：全部日期"
    )
}


## total unique shops ----

shop_menuX <- shop_menus[[1]]
{
  shop_menuX$shopCode |> unique()

  shop_menuX |>
    summarise(
      n_shop = n_distinct(shopCode),
      fileDate = min(updateDate)
    )
}

seq_along(shop_menus) |>
  purrr::map_dfr(
    ~ {
      .dfx <- shop_menus[[.x]]
      .fileDatex <- names(shop_menus)[.x]
      .dfx |>
        summarise(
          n_shop = n_distinct(shopCode),
          fileDate = .fileDatex
        )
    }
  ) |>
  mutate(
    fileDate = lubridate::ymd(fileDate),
    wday = lubridate::wday(fileDate, label = T)
  ) |>
  arrange(
    fileDate
  ) -> df_unique_shops_eachDate

# upload to google sheets
{
  gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"

  df_unique_shops_eachDate |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "有效店家數：全部日期"
    )
}

# popular items----
connections$ubereats_popular_items |>
  dbListTables()

df_popular_items <- tbl(
  connections$ubereats_popular_items, "2024-09-05"
) |> collect()

df_popular_items |> distinct(uuid)

df_popular_items |> glimpse()

shop_menus$`2024-10-13` |> View()

## tidy popular items----
source("R/bq_ubereats_helpers.R")
{
  df_popular_items |>
    dplyr::select(uuid, popular_uuid) |>
    dplyr::filter(
      popular_uuid != "[]"
    ) |>
    dplyr::distinct() ->
    df_popular_items_distinct

  df_popular_items_distinct |>
    group_by(uuid) |>
    summarise(
      n_popular = n(),
      popular_uuid = steady_popular_items(popular_uuid)
    ) |>
    ungroup() |>
    arrange(
      desc(n_popular)
    ) -> df_popular_items_summary
  
  df_popular_items_summary |> 
    dplyr::filter(
      popular_uuid != "[]"
    ) |>
    select(uuid, popular_uuid) -> 
    df_popular_items_summary2
}
# upload to bigquery
source("R/bigQuery-helpers.R")
{
  df_popular_items_summary2 |>
    stacked_data_upload_bigquery(
      "tidy-2024-09-05",
      dataset_id = "ubereats_popular_items",
      project_id = "food-delivery-432217"
    )
  
}

## compute popular items price
shop_menus$`2024-10-13` -> shop_menuX
### join shop_menuX with df_popular_items_summary2
# 每間店被request的次數----
## from different anchor points
source("R/bq_ubereats_helpers.R")
{
  shop_menus |>
    purrr::map2_dfr(
      names(shop_menus),
      summarise_repeatRequest_per_shop) -> 
    shop_menus_repeatRequest_summary
  
  shop_menus_repeatRequest_summary |>
    mutate(
      fileDate=lubridate::ymd(fileDate),
    ) |>
    dplyr::filter(
      !is.na(shopCode)
    ) -> 
    shop_menus_repeatRequest_summary
  
  shop_menus_repeatRequest_summary$anchor |>
    unique() -> anchor_points
  
  shop_menus_repeatRequest_summary |>
    mutate(
      location = glue::glue("{shopLat},{shopLng}"),
      type="shop"
    ) -> shop_menus_repeatRequest_summary
  
  shop_menus_repeatRequest_summary |>
    select(
      shopName,
      shopCode, location, n_item, fileDate
    ) -> shop_menus_repeatRequest_summary2

  anchor_points_df <-
    tibble(
      # remove "[" and "]" from localtion
      location = stringr::str_remove_all(anchor_points, "\\[|\\]")
    )
  
  bind_rows(
    shop_menus_repeatRequest_summary2,
    anchor_points_df
  ) -> shop_menus_repeatRequest_summary2
  
  shop_menus_repeatRequest_summary2 |>
    dplyr::filter(
      is.na(n_item)
    )
}
# upload to google sheets
{
  gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"

  shop_menus_repeatRequest_summary2 |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "每間店被request的次數：全部日期"
    )
}
## upload to bigquery ----
source("R/bigQuery-helpers.R")
{
  shop_menus_repeatRequest_summary2 |>
    stacked_data_upload_bigquery(
      "menus_repeatRequest_summary",
      dataset_id = "ubereats_anchor",
      project_id = "food-delivery-432217"
    )
}
# sufficient anchors-----
source("R/bq_ubereats_helpers.R")
target_date = "2024-10-13"
sufficient_anchors <- obtain_sufficient_anchors(target_date)

all_dates <- shop_menus |> names()

list_anchors <- purrr::map(
  all_dates,
  obtain_sufficient_anchors
)

complete_sufficient_anchors <- list_anchors |>
  unlist() |> unique()

length(complete_sufficient_anchors)

glimpse(df_shop_menus_summary)

## summarise difference 
{
  gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"
  
  df_shop_menus_summary <-
    googlesheets4::read_sheet(
      gsUrl,
      sheet = "爬點效率：全部日期"
    )
}
# rename localtion to anchor
df_shop_menus_summary <- df_shop_menus_summary |>
  rename(
    anchor = localtion
  )

# for each anchor compute average n_menu
df_shop_menus_summary |>
  group_by(anchor) |>
  summarise(
    n_menu = mean(n_menu, na.rm = T)
  ) |>
  arrange(
    desc(n_menu)
  ) -> df_shop_menus_summary_anchor

# create a logical isSufficient which is true if anchor is in complete_sufficient_anchors
df_shop_menus_summary_anchor$isSufficient <- (df_shop_menus_summary_anchor$anchor %in% complete_sufficient_anchors)*1

# upload to google sheets
{
  gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"

  df_shop_menus_summary_anchor |>
    googlesheets4::write_sheet(
      gsUrl,
      sheet = "sufficient anchors"
    )
}
# examine na
df_shop_menus_summary_anchor |>
  dplyr::filter(
    is.na(isSufficient)
  )

