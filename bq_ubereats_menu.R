source("R/bq_ubereats_helpers.R")

connections <- list()
dataset_id = "ubereats_popular_items"
connections[["ubereats_popular_items"]] <- create_connection(dataset_id = dataset_id)
connections[["ubereats_menu"]] <- 
  create_connection(dataset_id = "ubereats_menu")
connections[["ubereats_shoplist"]] <-
  create_connection("ubereats_shoplist")
connections[["ubereats_shoplist_stacked"]] <-
  create_connection("ubereats_shoplist_stacked")

# download smpl-2024-10-13 table from the current connection
df <- list()
popular_items <- tbl(
  connections$ubereats_popular_items, "2024-09-04")

popular_items |>
  collect() -> df$popular_items

# list all tables from connection$ubereats_menu
list_tables <- dbListTables(connections$ubereats_menu)
list_tables

# collect one table
shop_menus <- list()
shop_menus[[list_tables[[1]]]] <- tbl(
  connections$ubereats_menu, list_tables[[1]]
) |> collect()

shop_menus$`2024-10-13` |> glimpse()

# explore one menu df
df_menu <- shop_menus$`2024-10-13`
{
  df_menu$shopCode[[1]]
  
  glimpse(df_menu)
  
  # parse updateDate using lubridate
  df_menu$updateDate <- lubridate::mdy(df_menu$updateDate)
  # check range
  range(df_menu$updateDate)
  
  df_menu |>
    dplyr::filter(shopCode=="0d42ca6a-81fc-5903-a704-f5476db5fbbd") |> View()
  # There are duplicate for same date. Need to remove duplicates 
  
  df_menu |>
    dplyr::group_by(
      localtion
    ) |>
    summarise(
      updateDate = updateDate[[1]],
      wday = lubridate::wday(updateDate[[1]], label=T),
      n_menu=n()
    ) |>
    arrange(
      desc(n_menu)
    ) -> df_menu_summary
  
  # remove "[" and "]" from localtion
  df_menu_summary$localtion <- stringr::str_remove_all(df_menu_summary$localtion, "\\[|\\]")
  
  glimpse(df_menu_summary)
  # upload to google sheets
  {
    gsUrl <- "https://docs.google.com/spreadsheets/d/1x695FH6WWwXJrgp_od4ZDmXAYw_avO1lS9bcsWJ7Hmo/edit?gid=1530785463#gid=1530785463"
    
    df_menu_summary |>
      googlesheets4::write_sheet(
        gsUrl,
        sheet = "anchor point efficiency"
      )
  }
  
  # plot updateDate vs n_menu
  df_menu_summary |>
    ggplot(aes(updateDate, n_menu)) +
    geom_point() +
    labs(
      title = "Number of menu items by date",
      x = "Date",
      y = "Number of menu items"
    )
  
  # change x labels to wday
  df_menu_summary |>
    ggplot(aes(wday, n_menu)) +
    geom_point() +
    labs(
      title = "Number of menu items by day of week",
      x = "Day of week",
      y = "Number of menu items"
    )
  
  # Keep x be updateDate but change x labels to wday
  df_menu_summary |>
    ggplot(aes(updateDate, n_menu)) +
    geom_point() +
    scale_x_date(date_labels = "%a") +
    labs(
      title = "Number of menu items by day of week",
      x = "Day of week",
      y = "Number of menu items"
    ) 
  
  # label minor breaks as well
  df_menu_summary |>
    ggplot(aes(updateDate, n_menu)) +
    geom_point() +
    scale_x_date(date_labels = "%a", date_breaks = "1 day") +
    labs(
      title = "Number of menu items by day of week",
      x = "Day of week",
      y = "Number of menu items"
    )
  
  df_menu |>
    dplyr::filter(
      localtion == "[21.9814483630001,120.720446352]"
    ) |> View()
}
