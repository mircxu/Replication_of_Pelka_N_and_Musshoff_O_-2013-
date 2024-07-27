# Load necessary libraries
library(dplyr)

# Load the CSV files
stations_df <- read.csv('filtered_stations_df_all.csv')
data_df <- read.csv('filtered_data.csv')

# For each district, select the nearest station
nearest_stations_df <- stations_df %>%
  group_by(kreis_code_in) %>%
  slice_min(order_by = dist, n = 1) %>%
  ungroup()

# Merge the datasets on 'kreis_code_in' and 'district_no'
merged_df <- data_df %>%
  left_join(nearest_stations_df %>% select(kreis_code_in, stations_id, geobreite, geolaenge), 
            by = c("district_no" = "kreis_code_in"))

# Remove 'outlier' column if all values are 0
if(all(merged_df$outlier == 0)) {
  merged_df <- merged_df %>% select(-outlier)
}

# Convert 'stations_id' to integer to remove the '.0'
merged_df$stations_id <- as.integer(merged_df$stations_id)

# Save the updated dataframe to a new CSV file
write.csv(merged_df, 'final_data_with_station_IDs.csv', row.names = FALSE)

# Display the merged dataframe to the user (optional, for your reference)
print(head(merged_df))
