import os
import pandas as pd

class DataImport:
    def __init__(self, root_path: str):
        self.root_path = root_path

    def import_csv_file(self, relative_path: str) -> pd.DataFrame:
        file_path = os.path.join(self.root_path, relative_path)
        return pd.read_csv(file_path)

    def import_csv_folder(self, relative_path: str) -> pd.DataFrame:
        folder_path = os.path.join(self.root_path, relative_path)
        all_files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.endswith('.csv')]
        df_list = [pd.read_csv(file) for file in all_files]
        return pd.concat(df_list, ignore_index=True)
