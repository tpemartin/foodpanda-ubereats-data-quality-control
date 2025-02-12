import sys
import os

# Add the root directory of the project to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_import.data_import import DataImport

# Create an instance of DataImport
di = DataImport('codebook/demo_data')

# Use the methods of DataImport
df_file = di.import_csv_file('example.csv')
df_folder = di.import_csv_folder('example_folder')

print(df_file.head())
print(df_folder.head())