# Load necessary libraries
library(dplyr)
library(readr)

# Define file paths
stations_df_all_path <- 'stations_df_all.csv'
station_summary_path <- 'station_summary.csv'
filtered_stations_output_path <- 'filtered_stations_df_all.csv'

# Read the CSV files
stations_df_all <- read_csv(stations_df_all_path)
station_summary <- read_csv(station_summary_path)

# Convert column names to lower case for consistency
colnames(stations_df_all) <- tolower(colnames(stations_df_all))
colnames(station_summary) <- tolower(colnames(station_summary))

# Filter the data to include only stations present in station_summary
filtered_stations_df_all <- stations_df_all %>%
  filter(stations_id %in% station_summary$station_id)

# Sort the filtered dataframe by 'kreis_code_in' and then by 'dist'
sorted_filtered_stations_df_all <- filtered_stations_df_all %>%
  arrange(kreis_code_in, dist)

# Save the sorted filtered dataframe to a new CSV file
write_csv(sorted_filtered_stations_df_all, filtered_stations_output_path)

cat("Data saved to", filtered_stations_output_path, "\n")
