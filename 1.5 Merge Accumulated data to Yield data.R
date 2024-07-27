# Load necessary libraries
library(dplyr)
library(tidyr)

# Load the datasets with headers correctly identified
final_data_with_station_IDs <- read.csv("final_data_with_station_IDs.csv")
all_rain_results <- read.csv("all_rain_results.csv", header = TRUE, check.names = FALSE)
all_temp_results <- read.csv("all_temp_results.csv", header = TRUE, check.names = FALSE)

# Reshape the all_rain_results to have station IDs as a column
all_rain_results_melted <- all_rain_results %>%
  gather(key = "stations_id", value = "IR", -year, -period) %>%
  mutate(stations_id = as.numeric(as.character(stations_id)))

# Check unique values and types for debugging
str(final_data_with_station_IDs)
str(all_rain_results_melted)

# Merge final_data_with_station_IDs with all_rain_results_melted
merged_data <- final_data_with_station_IDs %>%
  left_join(all_rain_results_melted, by = c("year", "stations_id"))

# Check the result of the first merge
str(merged_data)

# Reshape the all_temp_results to have station IDs as a column
all_temp_results_melted <- all_temp_results %>%
  gather(key = "stations_id", value = "IT", -year, -period) %>%
  mutate(stations_id = as.numeric(as.character(stations_id)))

# Check unique values and types for debugging
str(all_temp_results_melted)

# Merge the previously merged data with all_temp_results_melted
final_merged_data <- merged_data %>%
  left_join(all_temp_results_melted, by = c("year", "stations_id", "period"))

# Check the result of the second merge
str(final_merged_data)

# Select relevant columns and rename them to match the example provided
final_merged_data <- final_merged_data %>%
  select(district_no, year, stations_id, value, period, IR, IT) %>%
  rename(Yield = value, Correlation = period)

# View the final merged data
print(head(final_merged_data))

# Save the final merged data to a CSV file
write.csv(final_merged_data, "final_merged_data.csv", row.names = FALSE)
