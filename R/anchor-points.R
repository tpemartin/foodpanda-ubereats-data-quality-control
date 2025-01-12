# Anchor point data collection examination

## foodpanda folders ----
source("R/anchor-points-helper.R")
date_folders <- paste0("data/foodpanda/2024-09-", 24:30)

folders_csv_summary <-
    date_folders |>
    map_dfr(
        summarise_folder_csv_files,
        .progress = TRUE
    )
# create file_date column
folders_csv_summary$file_date <- str_extract(folders_csv_summary$file, "[0-9]{4}-[0-9]+-[0-9]{2}") |> 
    lubridate::ymd()

folders_csv_summary |>
    glimpse()

## ubereats folders ----
date_folders <- paste0("data/ubereats/2024-9-", 24:30)

folders_csv_summary2 <-
    date_folders |>
    map_dfr(
        summarise_folder_csv_files,
        lat_lon_index = c(1,2),
        .progress = TRUE
    )

# create file_date column
folders_csv_summary2$file_date <- str_extract(folders_csv_summary2$file, "[0-9]{4}-[0-9]+-[0-9]{2}") |> 
    lubridate::ymd()

glimpse(folders_csv_summary2)

# bind foodpanda and ubereats together
folders_csv_summary |>
    bind_rows(folders_csv_summary2) ->
    fp_ub_folders_csv_summary

# create a platform column
fp_ub_folders_csv_summary$platform <- ifelse(
    grepl("foodpanda", fp_ub_folders_csv_summary$file),
    "foodpanda",
    "ubereats"
)


glimpse(fp_ub_folders_csv_summary)

## Valid anchor points count by date -----
# for each platform, for each file_date, count the rows, 
#  and count the rows whose obs is greater than 0
fp_ub_folders_csv_summary |>
    group_by(platform, file_date) |>
    summarise(
        num_anchors = n(),
        num_anchors_gt_0 = sum(obs > 0)
    ) -> fp_ub_folders_csv_summary_tidy

fp_ub_folders_csv_summary |>
    group_by(platform, file_date) |>
    summarise(
        num_anchors = n()
    ) -> fp_ub_folders_csv_summary_tidy
    
fp_ub_folders_csv_summary_tidy

## upload to google sheet
gsUrl <- "https://docs.google.com/spreadsheets/d/1A8r3oNrmG_5wuk3SjKbnHmfGMAAegICHQjiY7IIsndI/edit?gid=0#gid=0"
library(googlesheets4)

fp_ub_folders_csv_summary_tidy |>
    write_sheet(gsUrl, sheet = "anchor points by date")

## Total valid anchor points count
fp_ub_folders_csv_summary |>
    group_by(platform) |>
    summarise(
        num_anchors = n(),
        num_anchors_gt_0 = sum(obs > 0)
    ) -> fp_ub_folders_csv_summary_total

fp_ub_folders_csv_summary_total |>
    write_sheet(gsUrl, sheet = "total anchor points count")

# for each platform, found number of unique locations whose obs is greater than 0
fp_ub_folders_csv_summary |>
    filter(obs > 0) |>
    group_by(platform) |>
    summarise(
        num_unique_locations = n_distinct(location)
    ) -> fp_ub_folders_csv_summary_unique_locations

# upload to google sheet
fp_ub_folders_csv_summary_unique_locations |>
    write_sheet(gsUrl, sheet = "valid locations count")

## anchor point efficiency -----

# for each platform, for each location, summarise its obs
fp_ub_folders_csv_summary |>
    filter(obs > 0) |>
    group_by(platform, location) |>
    summarise(
        max_obs = max(obs),
        min_obs = min(obs),
        mean_obs = mean(obs),
        range_obs = max_obs - min_obs
    ) -> fp_ub_folders_csv_summary_efficiency

# upload to google sheet
head(fp_ub_folders_csv_summary_efficiency)

fp_ub_folders_csv_summary_efficiency |>
    write_sheet(gsUrl, sheet = "anchor point efficiency")

## quantile of range_obs
fp_ub_folders_csv_summary_efficiency |>
    group_by(platform) |>
    summarise(
        q0 = quantile(range_obs, 0),
        q1 = quantile(range_obs, 0.25),
        q2 = quantile(range_obs, 0.5),
        q3 = quantile(range_obs, 0.75),
        q4 = quantile(range_obs, 1)
    ) -> fp_ub_folders_csv_summary_efficiency_quantile

# create range_level column which depends on range_obs
# if range_obs is less than q1 in its platform, then range_level is "low"
# if range_obs is greater than q3 in its platform, then range_level is "high"
# otherwise, range_level is "medium"
fp_ub_folders_csv_summary_efficiency_quantile |>
  filter(platform == "foodpanda") -> fp_range_qt
fp_ub_folders_csv_summary_efficiency |>
    filter(platform == "foodpanda") |>
    mutate(
        range_level = case_when(
            range_obs < fp_range_qt$q1 ~ "low",
            range_obs > fp_range_qt$q3 ~ "high",
            TRUE ~ "medium"
        )
    ) -> fp_folders_csv_summary_efficiency_quantile
# same for ubereats
fp_ub_folders_csv_summary_efficiency_quantile |>
  filter(platform == "ubereats") -> ub_range_qt

fp_ub_folders_csv_summary_efficiency |>
    filter(platform == "ubereats") |>
    mutate(
        range_level = case_when(
            range_obs < ub_range_qt$q1 ~ "low",
            range_obs > ub_range_qt$q3 ~ "high",
            TRUE ~ "medium"
        )
    ) -> ub_folders_csv_summary_efficiency_quantile

## upload to google sheet
fp_ub_folders_csv_summary_efficiency_quantile |>
    write_sheet(gsUrl, sheet = "anchor point efficiency quantile")

## upload to google sheet
fp_folders_csv_summary_efficiency_quantile |>
    write_sheet(gsUrl, sheet = "fp obs range")

ub_folders_csv_summary_efficiency_quantile |>
    write_sheet(gsUrl, sheet = "ub obs range")

# same for mean_obs to see its mean_obs_level
fp_ub_folders_csv_summary_efficiency |>
    group_by(platform) |>
    summarise(
        q0 = quantile(mean_obs, 0),
        q1 = quantile(mean_obs, 0.25),
        q2 = quantile(mean_obs, 0.5),
        q3 = quantile(mean_obs, 0.75),
        q4 = quantile(mean_obs, 1)
    ) -> fp_ub_folders_csv_summary_efficiency_quantile_mean_obs

# create mean_obs_level column which depends on mean_obs
# if mean_obs is less than q1 in its platform, then mean_obs_level is "low"
# if mean_obs is greater than q3 in its platform, then mean_obs_level is "high"
# otherwise, mean_obs_level is "medium"
fp_ub_folders_csv_summary_efficiency_quantile_mean_obs |>
  filter(platform == "foodpanda") -> fp_mean_qt
fp_ub_folders_csv_summary_efficiency |>
    filter(platform == "foodpanda") |>
    mutate(
        mean_obs_level = case_when(
            mean_obs < fp_mean_qt$q1 ~ "low",
            mean_obs > fp_mean_qt$q3 ~ "high",
            TRUE ~ "medium"
        )
    ) -> fp_folders_csv_summary_efficiency_quantile_mean_obs

# same for ubereats
fp_ub_folders_csv_summary_efficiency_quantile_mean_obs |>
  filter(platform == "ubereats") -> ub_mean_qt

fp_ub_folders_csv_summary_efficiency |>
    filter(platform == "ubereats") |>
    mutate(
        mean_obs_level = case_when(
            mean_obs < ub_mean_qt$q1 ~ "low",
            mean_obs > ub_mean_qt$q3 ~ "high",
            TRUE ~ "medium"
        )
    ) -> ub_folders_csv_summary_efficiency_quantile_mean_obs

## upload to google sheet
fp_folders_csv_summary_efficiency_quantile_mean_obs |>
    write_sheet(gsUrl, sheet = "fp mean obs levels")

ub_folders_csv_summary_efficiency_quantile_mean_obs |>
    write_sheet(gsUrl, sheet = "ub mean obs levels")

## upload to google sheet
fp_ub_folders_csv_summary_efficiency_quantile_mean_obs |>
    write_sheet(gsUrl, sheet = "anchor point efficiency quantile mean obs")
