The resource structure: 

  - Anchors sheets: "https://docs.google.com/spreadsheets/d/1F49Du731-I9WZRhHPXX8C7eyCnZAYhEtRZnvZWJDp3E"  
  There is an "anchors" sheet with the following columns:  "shopCode", "anchor", and "location".   "location" refers to the location of a shop with "shopCode". "anchor" refers to the GPS point of the request that obtained the shop information.  

There are four sources of data that are used to update "anchors" sheet:  

  - Ubereats menu  
  - Ubereats shoplist  
  - Foodpanda menu  
  - Foodpanda shoplist  

For each data source, we will check of the shops' shopCodes are in the "anchors" sheet. Those that are not in the "anchors" sheet will be used to update the "anchors" sheet using the following algorithm.

## Algorithm: Deduct a minimal sufficient anchor set

Let `df_uncovered` be the dataframe of shops that are described by the following columns: "shopCode", "anchor", and "location". 

  - shopCode <STRING>: the unique identifier of a shop.  
  - anchor <STRING>: the GPS point of the request that obtained the shop information.  
  - location <STRING>: the location of a shop with "shopCode".  

First, create a summary data frame, named `df_uncovered_summary` from `df_uncovered` that has "shopCode" and "location", and for each "shopCode" compute how many times it appears in `df_uncovered`, called it "anchor_counts", and arrage its rows by "anchor_counts" in a increasing order.

  - `df_uncovered_summary` has the following columns: "shopCode", "location", "anchor_counts" (arranged in an increasing order of "anchor_counts").
  
Sencondly, compute `summary_anchor_efficiency` which uses `df_uncovered` to summarise the number of rows (name `coverage_count` column) shares the same `anchor` value for each `anchor`. And sort it by `coverage_count` in a decreasing order. 

The algorithm to deduct a minial sufficient anchor set `min_sufficient_anchors`. Starting with `i=0`. Suppose `summary_anchor_efficiency` has `n>0` rows, and `max_i = 600`:

  1. Select an `anchor_i`: Obtain the 1-st row of `summary_anchor_efficiency`'s `anchor`'value, named `anchor_i`.
  2. Update `min_sufficient_anchors`: If `i=0`, then `min_sufficient_anchors` = `anchor_i`. Otherwise, `min_sufficient_anchors` = `min_sufficient_anchors` union `anchor_i`.
  3. Obtain `covered_shopCodes`: Obtain all `shopCode` in `df_uncovered` that has `anchor` equal to `anchor_i`.
  4. Update `df_uncovered`: Remove all rows in `df_uncovered` that has `shopCode` in `covered_shopCodes`.  
  5. Update `i` and `n`: `i = i + 1` and `n` the number of rows in `summary_anchor_efficiency`.
  6. If `n>0` or `i < max_i`, then go to step 1 or . Otherwise, stop.


# Appendix: Minimal sufficient anchor set algorithm

Each time we start with a shop and find the anchor that covers it. Find out which else shops are also covered by the same anchor. Then, we remove all the shops that are covered by the anchor. We repeat this process until all shops are covered.

The data frame `df_uncovered` has two fields: `shopCode` and `anchor`. The algorithm will return a set of anchors that are sufficient to cover all shops in `df_uncovered`. 

The goal is to find a minimal set of anchors that can cover all shops in `df_uncovered`. Therefore, each time for a given shop (i.e, `shopCode`), we look for the anchor that covers the most shops. In order to do that, we need to augment `df_uncovered` with the number of shops that each anchor covers. Name the new field `anchor_coverage_count`, and then sort the data frame by the number of shops that each anchor covers in a decreasing order.  

However each time which shop to start with is important. We need to start with a shop that is covered by the fewest anchors. Those anchors are more likely to be neccessary -- especially when only one anchor covers a shop. To achieve that we augment the data frame further to include the field `shop_coverage_count` which is the number of anchors that each shop belongs to their coverage. Then we sort the data frame by `shop_coverage_count` that each shop covers in an increasing order.

Given the data frame `df_uncovered` that starts with only two fields `shopCode` and `anchor` The algorithm is as follows:  

1. Augment `df_uncovered` with the field `shop_coverage_count` which is the number of anchors that each shop belongs to their coverage.  
2. Sort `df_uncovered` by `shop_coverage_count` in an increasing order.
3. Augment `df_uncovered` with the field `anchor_coverage_count` which is the number of shops that each anchor covers. 
4. Sort `df_uncovered` by `anchor_coverage_count` in a decreasing order.
5. Create an empty set `min_sufficient_anchors` to store the minimal sufficient anchors.
6. For each row in `df_uncovered`:
    - If the anchor of the row is not in `min_sufficient_anchors`, then add it to `min_sufficient_anchors`.
    - Remove all shops that are covered by the anchor of the row.  
    - If all shops are covered, then stop.  
7. Return `min_sufficient_anchors`.
8. Done.

