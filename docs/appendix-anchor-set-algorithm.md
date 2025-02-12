
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

## (optional) Update anchors

The algorithm above is used to find a minimal sufficient anchor set, which is stored in Google sheets:

  - sheet_url = "https://docs.google.com/spreadsheets/d/1F49Du731-I9WZRhHPXX8C7eyCnZAYhEtRZnvZWJDp3E/edit?gid=370707926#gid=370707926"  
  - sheet_name = "anchors"

The sheet contains only the column of `anchor`.

To update the `anchors` sheet with given data frame `df_uncovered`, the algorithm is as follows:

1. Download the `anchors` sheet from the `sheet_url` and `sheet_name`.  
2. Find out from `df_uncovered` which shops are not covered by the anchors in the `anchors` sheet. Update `df_uncovered` with the uncovered shops.  
3. Run the algorithm above to find a minimal sufficient anchor set.   
4. Update the `anchors` sheet with the new minimal sufficient anchor set.

## Tidy up for `df_uncovered`

The source of `df_uncovered` comes from CSV files of shop lists. 

For Foodpanda shoplists, the relevant fields are: 

1. shopCode  
  - Description: A unique code for the shop.
  - Example: a8ql  
2. anchor_latitude
 - Description: The anchor latitude for the shop.
 - Format: Float
 - Example: 24.8239212930001
3. anchor_longitude
 - Description: The anchor longitude for the shop.
 - Format: Float
 - Example: 121.800643992

For UberEats shoplists, the relevant fields are:  

1. **storeUuid**
   - **Type**: String
   - **Meaning**: Unique identifier for the store.
2. **anchor_latitude**
   - **Type**: Numeric
   - **Meaning**: Latitude coordinate of the anchor point for the store.

3. **anchor_longitude**
   - **Type**: Numeric
   - **Meaning**: Longitude coordinate of the anchor point for the store.
  
Create a `augment_anchor` function that takes a data frame and round up `anchor_latitude` and `anchor_longitude` to 5 decimal places, then paste them together to create a new field `anchor` with "," as a separator.

