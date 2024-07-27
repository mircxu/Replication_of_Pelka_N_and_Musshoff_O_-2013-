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


or # Clear the workspace
rm(list = ls())

# Load required packages
library(dplyr)
library(broom)
library(lme4)
library(lmerTest)

# Load your data (adjust the path as necessary)
df <- read.csv('final_merged_data.csv')

# Verify the type and structure of df
if (!is.data.frame(df)) {
  stop("The object 'df' is not a data frame. Please check your data loading process.")
}

# Inspect the first few rows and structure
print(head(df))
str(df)

# Print column names to verify
print(names(df))

# Rename columns if necessary (update the names to match your data)
df <- df %>%
  rename(
    IR_t = `IR`,        # Update to actual column names if different
    IT_t = `IT`,        # Update to actual column names if different
    Y_t = `Yield`,      # Update to actual column names if different
    Farm = `stations_id`, # Update to actual column names if different
    Year = `year`       # Update to actual column names if different
  )

# Re-check column names after renaming
print(names(df))

# Proceed only if all required columns are present
required_columns <- c("IR_t", "IT_t", "Y_t", "Farm", "Year")
missing_columns <- setdiff(required_columns, names(df))
if (length(missing_columns) > 0) {
  stop(paste("The following required columns are missing:", paste(missing_columns, collapse = ", ")))
}

# Remove rows with NA values in critical columns
df <- df %>%
  filter(!is.na(IR_t) & !is.na(IT_t) & !is.na(Y_t))

# Recreate additional columns
df <- df %>%
  mutate(IR_t_squared = IR_t^2,
         IT_t_squared = IT_t^2,
         IR_t_IT_t = IR_t * IT_t)

# Check for any remaining NA values in the new columns
na_check <- df %>%
  summarise(across(c(IR_t, IT_t, IR_t_squared, IT_t_squared, IR_t_IT_t, Y_t), ~ sum(is.na(.))))
print(na_check)

# Print group sizes
group_sizes <- df %>%
  group_by(Farm) %>%
  summarise(count = n())
print(group_sizes)

# Debug data for each group
df %>%
  group_by(Farm) %>%
  do({
    cat("Group:", unique(.$Farm), "\n")
    print(head(.))
    .
  })

# Separate Models for Each Farm
models_farms <- df %>%
  group_by(Farm) %>%
  do({
    data <- .
    if (nrow(data) > 0) { # Ensure there is data to model
      model <- lm(Y_t ~ IR_t + IT_t + IR_t_squared + IT_t_squared + IR_t_IT_t, data = data)
      tidy(model)
    } else {
      tibble() # Return an empty tibble if no data
    }
  })

# Print summaries of models for each farm
print(models_farms)

