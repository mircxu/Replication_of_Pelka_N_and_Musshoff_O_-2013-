# Load necessary libraries
library(dplyr)
library(lubridate)

# Load the data
temp_data <- read.csv("allstations_temp.csv")
rain_data <- read.csv("allstations_rain.csv")

# Convert the date column to Date type
temp_data$Date <- dmy(temp_data$Stations_id)
rain_data$Date <- dmy(rain_data$Stations_id)

# Define the periods of interest
periods <- list(
  "3:3" = 3:3,
  "3:4" = 3:4,
  "3:5" = 3:5,
  "3:6" = 3:6,
  "3:7" = 3:7,
  "3:8" = 3:8,
  "3:9" = 3:9,
  "3:10" = 3:10
)

# Function to calculate statistics for a given period
calculate_stats <- function(temp_data, rain_data, start_month, end_month) {
  temp_data_filtered <- temp_data %>%
    filter(month(Date) >= start_month & month(Date) <= end_month)
  
  rain_data_filtered <- rain_data %>%
    filter(month(Date) >= start_month & month(Date) <= end_month)
  
  temp_stats <- temp_data_filtered %>%
    group_by(year = year(Date)) %>%
    summarise(across(-c(Stations_id, Date), mean, na.rm = TRUE)) %>%
    mutate(period = paste0(start_month, ":", end_month))
  
  rain_stats <- rain_data_filtered %>%
    group_by(year = year(Date)) %>%
    summarise(across(-c(Stations_id, Date), sum, na.rm = TRUE)) %>%
    mutate(period = paste0(start_month, ":", end_month))
  
  return(list(temp_stats = temp_stats, rain_stats = rain_stats))
}

# Initialize data frames to store all results
all_temp_results <- data.frame()
all_rain_results <- data.frame()

# Calculate statistics for each period and concatenate the results
for (period in names(periods)) {
  months <- periods[[period]]
  start_month <- min(months)
  end_month <- max(months)
  
  stats <- calculate_stats(temp_data, rain_data, start_month, end_month)
  temp_stats <- stats$temp_stats %>% select(year, period, everything())
  rain_stats <- stats$rain_stats %>% select(year, period, everything())
  
  all_temp_results <- bind_rows(all_temp_results, temp_stats)
  all_rain_results <- bind_rows(all_rain_results, rain_stats)
}

# Remove "X_" from column names if present
colnames(all_temp_results) <- gsub("^X", "", colnames(all_temp_results))
colnames(all_rain_results) <- gsub("^X", "", colnames(all_rain_results))

# Write the combined results to single CSV files
write.csv(all_temp_results, "all_temp_results.csv", row.names = FALSE)
write.csv(all_rain_results, "all_rain_results.csv", row.names = FALSE)

# Notify the user
cat("Combined results have been saved to all_temp_results.csv and all_rain_results.csv.\n")
