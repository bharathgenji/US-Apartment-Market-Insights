# Erica's Parts of the project

# Part 1. Chi Square Tests * 3
# Part 2. Smart Questions 4, 5, 8


# 1. Chi Square Tests

###################################################################
# 1.1 Chi-Square Test on the Distribution of Listings Across States
###################################################################

# Install necessary packages
# install.packages("readxl")
# install.packages("tidyverse")

# Load necessary libraries
library(readxl)
library(tidyverse)

# Read the dataset
data <- read_excel("/Users/ericazhao/Documents/midterm_project/cleaned_data.xlsx")

# Data cleaning
# Check the number of unique states
num_states <- length(unique(data$state))

# Create a vector of expected frequencies
expected_frequencies <- rep(1/num_states, num_states)

# Creating a contingency table of the number of listings in each state
contingency_table <- table(data$state)

# Performing the Chi-Square test
chi_square_test_state <- chisq.test(contingency_table)

# Printing the results of the Chi-Square test
print(chi_square_test_state)

# Visualize the distribution of listings across states using a bar plot
ggplot(data, aes(x = state)) +
  geom_bar(fill = "#ADD8E6") +
  labs(title = "Distribution of Listings Across States",
       x = "State",
       y = "Number of Listings") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

####################################################################################
# 1.2 Chi-Square Test on the Relationship Between Photo Availability and Price Type
####################################################################################

# Creating a contingency table for photo availability and price type
contingency_table_photo_price <- table(data$has_photo, data$price_type)

# Performing the Chi-Square Test of Independence
chi_square_test_photo_price <- chisq.test(contingency_table_photo_price)

# Printing the results of the Chi-Square test
print(chi_square_test_photo_price)

# Using ggplot to create a stacked bar plot to show the relationship between photo availability and price type

library(ggplot2)
library(scales)

ggplot(data, aes(x = price_type, fill = has_photo)) +
  geom_bar(position = "fill", color = "white") +  # Creating a stacked bar plot
  scale_y_continuous(labels = percent_format(scale = 1)) +  # Setting y-axis labels to percentage format
  labs(title = "Relationship between Photo Availability and Price Type",
       x = "Price Type",
       y = "Percentage") +  
  theme_minimal() +  # Using a minimal theme for a cleaner look
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotating x-axis text for better readability
        plot.margin = unit(c(1, 1, 1, 1), "cm"))  # Adjusting plot margin to prevent clipping

######################################################################################
# 1.3 Chi-Square Test on the Relationship Between Pets Allowed Status and Price Range
######################################################################################

# Creating a new variable for price range based on the 'price' variable
data$price_category <- cut(data$price,
                           breaks = c(-Inf, 1000, 2000, Inf),
                           labels = c("Low", "Medium", "High"))

# Creating a contingency table of pets allowed status against price range
contingency_table_pets_price <- table(data$pets_allowed, data$price_category)

# Perform Chi-Square Test
chi_square_test_pets_price <- chisq.test(contingency_table_pets_price)

# Printing the results of the Chi-Square test
print(chi_square_test_pets_price)

mosaicplot(contingency_table_pets_price, main = "Pets Allowed vs. Price Range",
           cex.axis = 0.7, 
           las = 2,   
           mar = c(5, 4, 2, 2) + 0.1)  

##############################################################
# 2.1 Question 4 (1/3) the Impact of Photos on Rental Prices
##############################################################

# Loading the necessary libraries
library(readr)
library(ggplot2)
library(dplyr)

# Reading the CSV file
data <- read_csv("Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv")

# Reading the First 10 Lines of the File to check the file's structure
lines <- readLines("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv", n = 10)
print(lines)

# Successfully Reading the CSV File
data <- read_csv2("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv")

# Data Cleaning and Transformation
data$has_photo <- as.numeric(data$has_photo == "Yes")
data$bathrooms <- ifelse(is.na(data$bathrooms), median(data$bathrooms, na.rm = TRUE), data$bathrooms)
data$bedrooms <- ifelse(is.na(data$bedrooms), median(data$bedrooms, na.rm = TRUE), data$bedrooms)
data$square_feet <- as.numeric(data$square_feet)
data$square_feet[is.na(data$square_feet)] <- median(data$square_feet, na.rm = TRUE)

# Data Analysis
# Calculate average prices
avg_price_with_photo <- mean(data$price[data$has_photo == 1])
avg_price_without_photo <- mean(data$price[data$has_photo == 0])

# Perform a t-test
t_test_result <- t.test(price ~ has_photo, data = data)
print(t_test_result)

# Multivariate Linear Regression
model <- lm(price ~ has_photo + bathrooms + bedrooms + square_feet, data = data)
summary(model)

# Visualization
p1 <- ggplot(data, aes(x = as.factor(has_photo), y = price)) +
  geom_boxplot() +
  labs(title = "Rental Price Comparison: Apartments with Photos vs Without Photos",
       x = "Has Photo",
       y = "Rental Price ($)") +
  theme_minimal()

p2 <- ggplot(data, aes(x = bathrooms, y = price, color = as.factor(has_photo))) +
  geom_point(alpha = 0.5) +
  labs(title = "Price vs Bathrooms",
       x = "Number of Bathrooms",
       y = "Rental Price ($)") +
  theme_minimal()

print(p1)
print(p2)


##############################################################
# 2.2 Question 5 (2/3) Detecting Anomalies in Rental Prices
##############################################################

# Load necessary libraries
library(readr)
library(ggplot2)
library(dplyr)

# Read the data
data <- read_csv2("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv")

# Data Cleaning and Transformation
data <- data %>%
  mutate(
    has_photo = if_else(has_photo == "Yes", 1, 0),
    bathrooms = as.numeric(bathrooms),
    bedrooms = as.numeric(bedrooms),
    square_feet = as.numeric(square_feet)
  ) %>%
  mutate(
    bathrooms = ifelse(is.na(bathrooms), median(bathrooms, na.rm = TRUE), bathrooms),
    bedrooms = ifelse(is.na(bedrooms), median(bedrooms, na.rm = TRUE), bedrooms),
    square_feet = ifelse(is.na(square_feet), median(square_feet, na.rm = TRUE), square_feet)
  )

# Visualizing the Distribution of Rental Prices
p1 <- ggplot(data, aes(x = price)) +
  geom_histogram(binwidth = 100) +
  theme_minimal() +
  labs(title = "Distribution of Rental Prices", x = "Rental Price ($)", y = "Frequency",
       caption = "The histogram shows the distribution of rental prices. Notice any skewness or potential outliers.")
print(p1)
ggsave("Distribution_of_Rental_Prices.jpg", plot = p1, width = 10, height = 8, units = "cm")

# Summary Statistics of Rental Prices
summary_stats <- summary(data$price)
print(summary_stats)

# Identifying and Visualizing Anomalies in Rental Prices
Q1 <- quantile(data$price, 0.25)
Q3 <- quantile(data$price, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

outliers <- data %>% filter(price < lower_bound | price > upper_bound)

# Using Box Plot to visualize anomalies in rental prices
p_boxplot <- ggplot(data, aes(y = price)) + 
  geom_boxplot(outlier.colour = "red", outlier.shape = 8, outlier.size = 4) + 
  labs(title = "Detecting Price Outliers", y = "Rental Price ($)",
       caption = "The box plot visualizes the spread of rental prices. The middle 50% of the prices are within the box, while the lines (whiskers) extend to the smallest and largest values within 1.5 times the interquartile range. Prices beyond these whiskers are considered outliers and are highlighted in red.") +
  theme_minimal()
print(p_boxplot)
ggsave("Detecting_Price_Outliers.jpg", plot = p_boxplot, width = 10, height = 8, units = "cm")


# High Price Outliers

# Analyze high price outliers to understand the characteristics of listings that are priced high.
high_price_outliers <- subset(data, price > upper_bound)
p_high <- ggplot(high_price_outliers, aes(x = bedrooms, y = price)) +
  geom_point(aes(color = "High Price Outliers"), size = 3) +
  theme_minimal() +
  labs(title = "High Rental Prices", x = "Number of Bedrooms", y = "Rental Price",
       caption = "This plot shows listings with unusually high rental prices. Each point represents a listing.")
print(p_high)
ggsave("Low_Rental_Prices.jpg", plot = p_low, width = 10, height = 8, units = "cm")


# Low Price Outliers

# Analyze low price outliers to understand the characteristics of listings that are priced low.
low_price_outliers <- subset(data, price < lower_bound)
p_low <- ggplot(low_price_outliers, aes(x = bedrooms, y = price)) +
  geom_point(aes(color = "Low Price Outliers"), size = 3) +
  theme_minimal() +
  labs(title = "Low Rental Prices", x = "Number of Bedrooms", y = "Rental Price",
       caption = "This plot shows listings with unusually low rental prices. Each point represents a listing.")
print(p_low)
ggsave("Low_Rental_Prices.jpg", plot = p_low, width = 10, height = 8, units = "cm")


# Jitter Plot for Low Price Outliers

# Jitter plot is used here to better visualize the distribution of listings with low rental prices across different bedroom categories.
p_low_jitter <- ggplot(low_price_outliers, aes(x = as.factor(bedrooms), y = price)) +
  geom_jitter(aes(color = "Low Price Outliers"), width = 0.2, size = 3) +
  theme_minimal() +
  labs(title = "Low Rental Prices (Jittered)", x = "Number of Bedrooms", y = "Rental Price",
       caption = "This jitter plot helps to spread out points for better visualization and understanding of the data.")
print(p_low_jitter)
ggsave("Low_Rental_Prices_Jittered.jpg", plot = p_low_jitter, width = 10, height = 8, units = "cm")

# Investigating Contextual Information of Outliers
summary_outliers <- summary(subset(data, price < lower_bound | price > upper_bound))
print(summary_outliers)

# Conclusion
# Summarize the findings and discuss any interesting patterns or insights gained from the analysis.
cat("In conclusion, this analysis has helped to identify and visualize rental price outliers in the dataset. The box plot and scatter plots provide a clear view of where these outliers lie in relation to the rest of the data, and the jitter plot helps to better visualize the distribution of low-priced listings. The summary statistics and contextual information of the outliers give us a deeper understanding of their characteristics.")


#############################################################################################
# 2.3 Question 8 (3/3) Segmenting Apartments by Amenities: Insights into Renter Preferences
#############################################################################################

# Loading packages
library(tidyverse)
library(cluster)
library(factoextra)

# Reading the CSV file
data <- read_csv("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv")

# Reading the First 10 Lines of the File to check the file's structure
lines <- readLines("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv", n = 10)
print(lines)

# Successfully Reading the CSV File
data <- read_csv2("/Users/ericazhao/Documents/midterm_project/apartments_for_rent_classified_10K.csv")

# Reading and checking the structure of the CSV file
glimpse(data)

# Checking for NA/NaN/Inf values and converting data to numeric type
binary_amenities_cleaned <- binary_amenities %>%
  mutate(across(everything(), as.numeric)) %>%  # Convert all columns to numeric
  mutate(across(everything(), ~replace(., is.na(.) | is.nan(.) | is.infinite(.), 0)))  # Replace NA/NaN/Inf with 0

# Checking the structure of the cleaned data
str(binary_amenities_cleaned)

# Determining the optimal number of clusters again
set.seed(123)
wss <- sapply(1:10, function(k) kmeans(binary_amenities_cleaned, centers = k, nstart = 50)$tot.withinss)

# Generating the Elbow plot again
elbow_plot <- data.frame(k = 1:10, WSS = wss)
ggplot(elbow_plot, aes(x = k, y = WSS)) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  labs(title = "Elbow Method for Optimal k", x = "Number of Clusters (k)", y = "Total Within-Cluster Sum of Squares")

# Conducting the k-means clustering with the chosen number of clusters
set.seed(123)
k_chosen <- 3
final_clusters <- kmeans(select(binary_amenities_cleaned, -cluster), centers = k_chosen, nstart = 50)

# Adding the cluster assignments back to the original data
binary_amenities$cluster <- final_clusters$cluster

# Analyzing the cluster results
cluster_summary <- binary_amenities %>%
  group_by(cluster) %>%
  summarise(across(everything(), mean, na.rm = TRUE)) %>%
  pivot_longer(-cluster, names_to = "amenity", values_to = "average_presence")

# Visualizing the clusters
ggplot(cluster_summary, aes(x = reorder(amenity, -average_presence), y = average_presence, fill = as.factor(cluster))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Amenities", y = "Average Presence", fill = "Cluster", title = "Clustered Amenities Presence") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



