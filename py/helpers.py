# %%
# filepath: /Users/martin/Documents/GitHub/foodpy/foodpy/helpers.py
import os
import pickle
import gspread
import pandas as pd
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pkg_resources

# %% Helper function
def find_minimal_anchors(df_uncovered):
    # Step 1: Augment with anchor_coverage_count
    anchor_coverage_count = df_uncovered['anchor'].value_counts().reset_index()
    anchor_coverage_count.columns = ['anchor', 'anchor_coverage_count']
    df_uncovered = df_uncovered.merge(anchor_coverage_count, on='anchor', how='left')

    # Step 2: Augment with shop_coverage_count
    shop_coverage_count = df_uncovered['shopCode'].value_counts().reset_index()
    shop_coverage_count.columns = ['shopCode', 'shop_coverage_count']
    df_uncovered = df_uncovered.merge(shop_coverage_count, on='shopCode', how='left')

    # Step 3: Sort the data frame
    df_uncovered = df_uncovered.sort_values(by=['shop_coverage_count', 'anchor_coverage_count'], ascending=[True, False])

    # Step 4: Iteratively select anchors
    selected_anchors = set()
    covered_shops = set()

    while len(covered_shops) < len(df_uncovered['shopCode'].unique()):
        # Select the first uncovered shop
        for index, row in df_uncovered.iterrows():
            if row['shopCode'] not in covered_shops:
                selected_anchor = row['anchor']
                break
        

        # Add the selected anchor to the set of selected anchors
        selected_anchors.add(selected_anchor)
        
        # Add all shops covered by the selected anchor to the set of covered shops
        covered_shops.update(df_uncovered[df_uncovered['anchor'] == selected_anchor]['shopCode'])

    # Convert the set of selected anchors to a DataFrame
    df_selected_anchors = pd.DataFrame(list(selected_anchors), columns=['anchor'])
    return df_selected_anchors


# %% Function to update the anchors sheet
def update_anchors(df_anchors, df_uncovered):
    # # Step 1: Download the anchors sheet
    # df_anchors = read_google_sheet(sheet_url, sheet_name)

    # Step 2: Find uncovered shops
    df_uncovered = find_uncovered_shops(df_anchors, df_uncovered)

    # Step 3: Find minimal sufficient anchor set
    new_anchors = find_minimal_anchors(df_uncovered)

    # Step 4: Update the anchors sheet
    df_new_anchors = pd.DataFrame(list(new_anchors), columns=['anchor'])
    df_anchors = pd.concat([df_anchors, df_new_anchors]).drop_duplicates().reset_index(drop=True)
    return df_anchors

    # Save the updated anchors sheet back to Google Sheets
    # helpers.update_google_sheet(sheet_url, sheet_name, df_anchors)


def find_uncovered_shops(df_anchors, df_uncovered):
    if df_anchors is None:
        return df_uncovered

    covered_shops = df_anchors['anchor'].unique()
    df_uncovered = df_uncovered[~df_uncovered['shopCode'].isin(df_uncovered[df_uncovered['anchor'].isin(covered_shops)]['shopCode'])]
    return df_uncovered

def read_google_sheet(sheet_url, sheet_name):
    # Define the scope
    SCOPES = [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/drive"
    ]
    # Get the path to the credentials file
    current_dir = os.path.dirname(__file__) # current file directory
    credentials_path = load_credential_path()
    
    token_path = os.path.join(os.getcwd(), 'token.pickle')

    print(os.getcwd())
    creds = None
    # Load the token if it exists
    if os.path.exists(token_path):
        with open(token_path, 'rb') as token_file:
            creds = pickle.load(token_file)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(credentials_path, SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(token_path, 'wb') as token_file:
            pickle.dump(creds, token_file)

    # Authorize the client
    client = gspread.authorize(creds)

    # Get the sheet
    sheet = client.open_by_url(sheet_url).worksheet(sheet_name)

    # Get all records of the data
    data = sheet.get_all_records()

    # Convert the json to dataframe
    df = pd.DataFrame.from_records(data)

    return df

def update_google_sheet(sheet_url, sheet_name, df):
    # Define the scope
    SCOPES = [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/drive"
    ]
    # Get the path to the credentials file
    credentials_path = load_credential_path()
    token_path = os.path.join(os.getcwd(), 'token.pickle')


    creds = None
    # Load the token if it exists
    if os.path.exists(token_path):
        with open(token_path, 'rb') as token_file:
            creds = pickle.load(token_file)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(credentials_path, SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(token_path, 'wb') as token_file:
            pickle.dump(creds, token_file)

    # Authorize the client
    client = gspread.authorize(creds)

    # Get the sheet
    sheet = client.open_by_url(sheet_url).worksheet(sheet_name)

    # Clear the existing data
    sheet.clear()

    # Update the sheet with new data
    sheet.update([df.columns.values.tolist()] + df.values.tolist())

def load_credential_path():
    resource_path = 'client_secret_198363307721-ohqg3ov57v2et82u7e1a1cl1hm0vlbi5.apps.googleusercontent.com.json'
    # Get the directory of the current module file
    module_dir = os.path.dirname(__file__)
    # Construct the full path to the resource file
    credentials_path = os.path.join(module_dir, resource_path)
    return credentials_path


# %% Helper function
def augment_anchor(df):
    # Round anchor_latitude and anchor_longitude to 5 decimal places without padding zeros
    df['anchor_latitude'] = df['anchor_latitude'].apply(lambda x: f"{x:.5f}".rstrip('0').rstrip('.'))
    df['anchor_longitude'] = df['anchor_longitude'].apply(lambda x: f"{x:.5f}".rstrip('0').rstrip('.'))
    
    # Create the new field 'anchor' by concatenating latitude and longitude with a comma separator
    df['anchor'] = df['anchor_latitude'] + ',' + df['anchor_longitude']
    
    return df

# %% Example usage
if __name__ == "__main__":
    data = {
        'anchor_latitude': [12.3456789, 23.4567890, 34.5678901],
        'anchor_longitude': [98.7654021, 87.6543210, 76.5432109]
    }
    df = pd.DataFrame(data)
    df = augment_anchor(df)
    print(df)

    # %% Example usage
    sheet_url = "https://docs.google.com/spreadsheets/d/1F49Du731-I9WZRhHPXX8C7eyCnZAYhEtRZnvZWJDp3E/edit?gid=370707926#gid=370707926"
    sheet_name = "anchors"
    anchors = read_google_sheet(sheet_url, sheet_name)
    print(anchors)
    update_google_sheet(sheet_url, "anchors-test", anchors)
    print(df)


# %%
