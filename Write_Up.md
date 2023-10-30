<!--- Rmarkdown for the paper. --->
<!--- Zachary Perry group 5 I think --->

---
title: "Summary of Research and EDA Process on the Apartment Rental Dataset"
author: "Zachary Perry"
date: "`r Sys.Date()`"
output: html_document
---

## Introduction

The rental market is a significant component of the US economy, influencing and being influenced by various economic and societal factors. With the continuous growth in data availability, there's an opportunity to derive insights from data to better understand this market. 

In this study, we explore a dataset detailing apartment rentals in the USA, sourced from the UCI database and supplemented with listings from "RentLingo". Comprising 10,000 observations across 22 variables, this dataset provides a comprehensive look into factors like pricing, amenities, location, and more.

Our primary goal is straightforward: to analyze the dataset, understand its intricacies, and derive actionable insights that could be beneficial for stakeholders in the rental market. This report summarizes our approach, findings, and the potential implications of those findings.

## 1. What do we know about this dataset?

The dataset serves as a window into the apartment rental landscape in the USA. It provides an amalgamation of attributes that paint a comprehensive picture of rental listings. Let's delve deeper into its characteristics:

### 1.1 Data Source and Observations

Sourced from the UCI database and enriched with listings from "RentLingo", the dataset comprises 10,000 observations. Each observation represents a unique rental listing, providing a robust foundation for our analysis. Cleaning the data is mandatory for imported datasets and this is no exception. Below is the dataset overview and tables of variable definitions, with missing values shown to display the amount of rows omitted.

![Summary Statistics of Dataset](./Summary stats of dataset.png)

### 1.2 Attributes and Data Dimensions

The dataset's richness lies in its 22 meticulously curated columns. Each attribute captures a specific facet of rental listings, and understanding these can pave the way for more in-depth analyses:

- **Identifiers**: Columns like `id` and `title` uniquely distinguish each listing, ensuring data integrity and facilitating easier referencing.
- **Geographical Details**: With attributes such as `cityname`, `state`, `latitude`, and `longitude`, the dataset provides a granular view of the geographical spread of listings. This can be pivotal in understanding regional rental trends.
- **Economic Indicators**: The `price_display` column is more than just a price tag; it's a reflection of various influencing factors, from location to amenities and apartment size.
- **Physical Characteristics**: By detailing the number of `bedrooms`, `bathrooms`, and the `square_feet` area, the dataset allows for analyses based on apartment size and structure.
- **Qualitative Descriptors**: The `body` and `amenities` columns add depth, offering a narrative and a list of extras that come with each listing. This qualitative data can be crucial when trying to understand the perceived value of a listing.

To understand the relationships between these attributes, especially the numerical ones, a correlation matrix can be invaluable:

![Correlation Matrix](./Correllation Matrix.png)


This matrix provides a visual representation of how different variables in the dataset relate to each other. Strong correlations, whether positive or negative, can hint at underlying patterns and relationships that might be pivotal in subsequent analyses.

### 1.3 Dataset's Relevance, Potential, and Limitations

The dataset, with its diverse attributes, serves as a valuable resource for understanding the broader dynamics of the US apartment rental market. Its coverage of different geographical areas, apartment sizes, and amenities allows for a variety of analyses, from trend spotting to predictive modeling. 

However, as with any dataset, it's essential to recognize both its strengths and limitations:

- **Strengths**:
  - **Comprehensive Attributes**: The dataset's columns offer insights ranging from basic listing details to more nuanced aspects like amenities and geospatial information.
  - **Broad Coverage**: With 10,000 observations, it provides a substantial snapshot of the US apartment rental landscape.

- **Limitations**:
  - **State-Level Analyses**: Upon breaking down the dataset by states, many states appear to lack a sufficient number of observations, challenging the derivation of robust statistical inferences at the state level.
  - **Reduced Statistical Power**: With limited observations for several states, our ability to detect genuine patterns or trends is hampered, potentially missing out on genuine insights for those states.
  - **Potential for Bias**: States with sparse data are susceptible to skewed insights, where outlier listings can disproportionately influence results.
  - **Period Limitations**: The dataset captures listings from September to December, preventing a comprehensive seasonal analysis and potentially missing trends evident in other months.

In essence, the dataset offers a broad view of the US apartment rental market, but its limitations, especially concerning state-level analyses and seasonal trends, must be considered to ensure accurate and meaningful conclusions. 

## 3. How was the information gathered?

The genesis of this dataset is the UCI database, but the original data compilation was executed by "RentLingo", an online platform. This suggests a digital scraping or aggregation method, wherein listings from various sources might have been collated. It's essential to recognize the potential biases that might arise from such collection methods, such as over-representation of certain types of listings or geographies.

## 4. Prior Analyses and Insights

The initial analysis was a multi-faceted approach. Beginning with data manipulation, the team curated the dataset to enhance its usability. Through rigorous Exploratory Data Analysis (EDA), patterns began to emerge, relationships between variables were identified, and the groundwork for more complex statistical inferences was laid. Preliminary models were built to understand the potential predictive capabilities of the dataset.

An ANOVA test can be run to make sure the states column is truly signifigant and the grouping by states is warranted. The output of this ANOVA is below.

![Correlation Matrix](./ANOVA.png)

A p-value of 2*10^(-16) means a grouping by state is heavily statistic, and a grouping by states can be helpful to add controls for inference.

## 5. Research Contribution to Question Development

The extensive nature of the dataset and its intricate details spurred numerous questions. Initial hypotheses revolved around understanding the primary drivers of rental prices and discerning patterns in rental listings across various geographies. As research deepened, the focus shifted towards the impact of amenities on pricing and the role of apartment size in influencing rental rates.

## 6. Beneficial Augmentations to the Dataset

To truly harness the potential of this dataset, a few additions would be invaluable:
- **Historical Data**: Capturing rental trends over a span of years would offer insights into market evolution.
- **Detailed Amenities Data**: A clearer breakdown of amenities could help in understanding their precise impact on pricing.
- **Feedback/Reviews Data**: Tenant feedback or reviews could provide a qualitative perspective on rental listings.

## 7. Evolution of the Research Question Post-EDA

The beauty of EDA is its ability to mold and refine the research direction. While the foundational questions around rental drivers remained, the nuances changed. The emphasis shifted towards a more granular understanding, such as the role of specific amenities in price determination or the impact of apartment location vis-
