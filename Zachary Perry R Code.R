# Zac portion of the project.

# Install and load the readxl package if you haven't already
#install.packages("readxl")
library(readxl)
# Install and load the knitr package if you haven't already
#install.packages("knitr")
library(knitr)

# Read the Excel file
df <- read_excel("C:/Users/Zac/Desktop/Fall 2023 Semester/Introduction to Data Science/Project/cleaned_data_project.xlsx")

# View the first few rows of the data
head(df)

# Compute summary statistics for the dataset
summary(df)

################################################################################
### This is question 9
################################################################################

# Install the dplyr package if you haven't already
#install.packages("dplyr")

# Load the dplyr package
library(dplyr)


# List of valid US state abbreviations
valid_states <- c(
    "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
    "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
    "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
    "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
    "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"
)

# Update the list of valid US state abbreviations to include DC
valid_states <- c(valid_states, "DC")

# Filter out rows where the state is not in the list of valid states
filtered_df_with_dc <- df[df$state %in% valid_states, ]

# Convert square_feet to numeric, setting any non-numeric values to NA
filtered_df_with_dc$square_feet <- as.numeric(as.character(filtered_df_with_dc$square_feet))

# Check for any non-numeric values that might have been converted to NAs
na_square_feet_count <- sum(is.na(filtered_df_with_dc$square_feet))
cat("Number of NA values in square_feet:", na_square_feet_count, "\n")

# Compute the average rental price per square foot and the count of observations for each state
statewise_stats <- filtered_df_with_dc %>%
  filter(!is.na(square_feet) & square_feet > 0) %>%
  group_by(state) %>%
  summarize(
    avg_price_per_sqft = round(mean(price / square_feet, na.rm = TRUE), 2),
    count = n()
  )

# Compute the weighted average rental price per square foot for each state
statewise_stats$weighted_avg_price_per_sqft <- statewise_stats$avg_price_per_sqft * statewise_stats$count

# Compute the overall weighted average rental price per square foot for the entire dataset
overall_weighted_avg_price_per_sqft <- sum(statewise_stats$weighted_avg_price_per_sqft) / sum(statewise_stats$count)

# Install and load the ggplot2 package if you haven't already
#install.packages("ggplot2")
library(ggplot2)

# Create a bubble plot with adjusted red line label and legend position
bubble_plot <- ggplot(statewise_stats, aes(x = state, y = avg_price_per_sqft, size = count)) +
  geom_point(alpha = 0.7, color = "dodgerblue") +
  geom_hline(yintercept = overall_weighted_avg_price_per_sqft, color = "red", linetype="dashed", size=0.7) +
  annotate("text", x = max(statewise_stats$state), y = overall_weighted_avg_price_per_sqft + 0.1, 
           label = paste0("$", round(overall_weighted_avg_price_per_sqft, 2)), color = "red", hjust = "right") +
  labs(
    title = "Weighted Average Rental Price Per Square Foot by State",
    subtitle = paste0("Overall avg. price/sqft: $", round(overall_weighted_avg_price_per_sqft, 2)),
    x = "State",
    y = "Price ($/sqft)",
    size = "Number of Listings"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels by 45 degrees
    legend.position = "top"  # Move the legend to the top
  )

# Display the plot
print(bubble_plot)

################################################################################
### This is question 10
################################################################################

# Load necessary packages
library(dplyr)
library(purrr)
library(tidyr)
library(ggplot2)

# Remove outliers
remove_outliers <- function(data, column_name) {
  Q1 <- quantile(data[[column_name]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[column_name]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  filter_condition <- (data[[column_name]] >= (Q1 - 1.5 * IQR)) & (data[[column_name]] <= (Q3 + 1.5 * IQR))
  return(data[filter_condition,])
}

filtered_df_no_outliers <- remove_outliers(filtered_df_with_dc, "price")
filtered_df_no_outliers <- remove_outliers(filtered_df_no_outliers, "square_feet")

# Group the data by state and apply the linear regression model to each group, with square_feet as the predictor and price as the response
regression_results <- filtered_df_no_outliers %>%
  group_by(state) %>%
  nest() %>%
  mutate(
    model = map(data, ~ lm(price ~ square_feet, data = .)),
    intercept = map_dbl(model, ~ coef(.)[1]),
    slope = map_dbl(model, ~ coef(.)[2]),
    r_squared = map_dbl(model, ~ summary(.)$r.squared)
  ) %>%
  select(state, intercept, slope, r_squared)

# Display the regression results by state
print(regression_results)

# As an example, visualize the regression line for the states CA, NY, and TX
selected_states <- c("CA", "NY", "TX")
plots <- list()

for (state in selected_states) {
  state_data <- filter(filtered_df_no_outliers, state == !!state)
  
  plot <- ggplot(state_data, aes(x = square_feet, y = price)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", color = "red") +
    labs(
      title = paste0("Regression of Price on Square Feet in ", state),
      x = "Square Feet",
      y = "Rental Price ($)"
    ) +
    theme_minimal()
  
  plots[[state]] <- plot
}

# Display the plots for the selected states
lapply(plots, print)


# Filter for the states CA, NY, and TX and select the slope column
selected_slopes <- regression_results %>%
  filter(state %in% selected_states) %>%
  select(slope)

# Display the slopes for the selected states
print(selected_slopes)

################################################################################
### This is question 11
################################################################################

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Convert Excel serial date numbers to R date format
# Convert Unix timestamps to a human-readable datetime format
filtered_df_no_outliers$datetime <- as.POSIXct(filtered_df_no_outliers$time, origin = "1970-01-01", tz = "UTC")
# Extract the month and year for the seasonality analysis
filtered_df_no_outliers$year_month <- format(filtered_df_no_outliers$datetime, "%Y-%m")

# Compute the monthly average rental prices
monthly_avg_prices <- filtered_df_no_outliers %>%
  group_by(year_month) %>%
  summarize(avg_price = mean(price, na.rm = TRUE))

monthly_avg_prices$year_month <- as.Date(paste0(monthly_avg_prices$year_month, "-01"), format = "%Y-%m-%d")

# Plot the monthly average prices
plot_seasonality <- ggplot(monthly_avg_prices, aes(x = year_month, y = avg_price)) +
  geom_line() +
  labs(title = "Monthly Average Rental Prices", x = "Month", y = "Average Price") +
  theme_minimal()

print(plot_seasonality)

################################################################################
### This is question 12
################################################################################

# Load necessary libraries
library(dplyr)
library(tidyr)

# Tokenize the amenities column based on comma separator, unnest, and count occurrences
amenities_counts <- df %>%
  filter(amenities != "Unknown") %>%
  mutate(amenities_list = strsplit(as.character(amenities), ",")) %>%
  unnest(amenities_list) %>%
  group_by(amenities_list) %>%
  count(sort = TRUE)

# Display the results
print(amenities_counts)

# Load the necessary libraries
library(ggplot2)

# Create the bar plot
amenities_plot <- ggplot(amenities_counts, aes(x = reorder(amenities_list, -n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # Makes the plot horizontal
  labs(title = "Distribution of Amenities",
       x = "Amenity",
       y = "Count") +
  theme_minimal()

# Display the plot in RStudio
print(amenities_plot)

################################################################################
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)  # for the spread function

# Create a binary column indicating if a listing mentions any amenity
df$has_amenities <- ifelse(df$amenities != "Unknown" & df$amenities != "", 1, 0)

# Group by state and has_amenities, then count listings
statewise_amenity_counts <- df %>%
  group_by(state, has_amenities) %>%
  summarise(count = n())

# Spread the data to have separate columns for listings with and without amenities
statewise_amenity_counts_spread <- statewise_amenity_counts %>%
  spread(key = has_amenities, value = count, fill = 0) %>%
  rename(Without_Amenities = `0`, With_Amenities = `1`)

# Calculate total listings per state
statewise_amenity_counts_spread$Total <- statewise_amenity_counts_spread$Without_Amenities + statewise_amenity_counts_spread$With_Amenities

# Calculate the percentages
statewise_amenity_counts_spread$Without_Amenities_Percent <- (statewise_amenity_counts_spread$Without_Amenities / statewise_amenity_counts_spread$Total) * 100
statewise_amenity_counts_spread$With_Amenities_Percent <- (statewise_amenity_counts_spread$With_Amenities / statewise_amenity_counts_spread$Total) * 100

# Display the results
print(statewise_amenity_counts_spread[, c("state", "Without_Amenities_Percent", "With_Amenities_Percent")])

# Arrange the data for better visualization
statewise_amenity_counts_spread <- statewise_amenity_counts_spread %>%
  arrange(With_Amenities_Percent)

# Adjust the plotting dimensions
options(repr.plot.width = 12, repr.plot.height = 8)

# Create the plot with legible y-axis ticks
amenities_plot <- ggplot(statewise_amenity_counts_spread, aes(x = state)) +
  geom_bar(aes(y = With_Amenities_Percent, fill = "With Amenities"), stat = "identity", position = "stack") +
  geom_bar(aes(y = Without_Amenities_Percent, fill = "Without Amenities"), stat = "identity", position = "stack") +
  coord_flip() +  # Makes the plot horizontal
  labs(title = "Percentage of Listings With and Without Amenities by State",
       x = "State",
       y = "Percentage",
       fill = "Amenity Presence") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)))

# Display the improved plot in RStudio
print(amenities_plot)

################################################################################

# Splitting the amenities column by ', '
all_amenities <- unlist(strsplit(as.character(df$amenities), split = ", "))

# Getting the unique amenities
unique_individual_amenities <- unique(all_amenities)

# Displaying the unique amenities
print(unique_individual_amenities)

