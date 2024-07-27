# Load necessary libraries
library(dplyr)
library(broom)

# Load the data
file_path <- 'final_merged_data.csv'
data <- read.csv(file_path)

# Prepare the data
data <- data %>%
  mutate(IR_squared = IR^2,
         IT_squared = IT^2,
         IR_IT = IR * IT)

# Remove rows with missing values
cleaned_data <- na.omit(data)

# Function to perform regression and return R-squared value
get_r_squared <- function(group) {
  model <- lm(Yield ~ IR + IT + IR_squared + IT_squared + IR_IT, data = group)
  summary(model)$r.squared
}

# Group the data by 'district_no' and 'Correlation' and calculate R-squared values
grouped_r_squared <- cleaned_data %>%
  group_by(district_no, Correlation) %>%
  summarize(R_squared = get_r_squared(cur_data()), .groups = 'drop')

# Identify the best correlation period for each district
best_correlation <- grouped_r_squared %>%
  group_by(district_no) %>%
  filter(R_squared == max(R_squared)) %>%
  ungroup()

# Save the result to a CSV file
write.csv(best_correlation, 'best_correlation_period.csv', row.names = FALSE)

# Display the best correlation period DataFrame
print(best_correlation)
