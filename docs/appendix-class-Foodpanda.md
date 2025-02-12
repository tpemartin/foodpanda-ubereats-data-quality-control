# Class Foodpanda

`Foodpanda` inherits from `DataImport` and is used to import Foodpanda data. It has the following methods:  

  - `load_data(relative_path: str)`: Load data from a CSV file in the given relative path.
  - `load_data_from_folder(relative_path: str, prefix: str)`: Load data from all CSV files in the given relative path with the given prefix.
  - `tidy_for_anchor(df_uncovered: pd.DataFrame)`: From `foodpanda.data`, apply `augment_anchor` from `helpers` module and select `shopCode` and `anchor` from the returned data frame. It also add `.anchor_data` property to the instance.

`FoodpandaShoplist` is a class that inherits from `DataImport` and is used to import Foodpanda shoplist data. 