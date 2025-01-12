
# Example usage
file_path <- "data/ubereats/2024-9-24/shopLst_21.9414135330001_120.720446352_2024-9-24.csv"
shop_data <- read_shopdata(file_path)

# Display the first few rows of the score_breakdown column
glimpse(shop_data$score_breakdown)