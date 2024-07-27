# Load necessary library
library(dplyr)

# Read the CSV file
data <- read.csv("Final_data.csv")

# Define the range of years we are interested in
required_years <- 2006:2021

# Filter districts with complete data from 2006 to 2021
filtered_data <- data %>%
  # Filter for specific 'var' and 'measure'
  filter(var == 'ww' & measure == 'yield') %>%
  # Remove rows with NA values in important columns (adjust if necessary)
  drop_na(value) %>%
  # Group by district
  group_by(district) %>%
  # Filter districts with data for all required years
  filter(all(required_years %in% year)) %>%
  ungroup() %>%
  # Ensure data includes only rows from required years
  filter(year %in% required_years)

# Write the filtered data to a new CSV file
write.csv(filtered_data, "filtered_data.csv", row.names = FALSE)
