# From source

## Class DataImport

Usage:
```python
data_import = DataImport(root_path) 
```

Properties:  
 
- `root_path` : str, the root path of the data source

Methods:

- `import_csv_file(relative_path)` : import a CSV file from the given relative path (relative to the root path) and return a dataframe  
- `import_csv_folder(relative_path)` : import all CSV files from the given relative path (relative to the root path) and union them into a single dataframe


## data_import.py

```python
import fooddelivery.data_import as data_import

# create an instance of the Ubereats class
ubereats = data_import.Ubereats()
# the instance has properties: shoplist_root and menu_root

# import CSV files from the given folder (under relevant root) and union them into a single dataframe
ubereats.import_shoplist_folder(folder_name)
ubereats.import_menu_folder(folder_name)

foodpanda = data_import.Foodpanda()
# the instance has properties: shoplist_root and menu_root

foodpanda.import_shoplist_folder(folder_name)
foodpanda.import_menu_folder(folder_name)
```

The imported and unioned dataframes can be accessed as follows:

```python
ubereats.shoplist
ubereats.menu
foodpanda.shoplist
foodpanda.menu
```




