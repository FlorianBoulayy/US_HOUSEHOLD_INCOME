# 🏡 US Household Income Analysis

This project focuses on data cleaning and exploratory data analysis (EDA) using SQL on household income data across the United States. The aim is to ensure data quality, uncover inconsistencies, and derive initial insights about income distribution by geography and household type.

## 📁 Files Included

- `USHouseholdIncome.csv` — Raw demographic and location data by city.
- `USHouseholdIncome_Statistics.csv` — Contains income statistics (mean, median, etc.) by location.
- `US_HouseholdIncome_Analysis.sql` — Full SQL script for data cleaning and SQL queries for exploratory analysis.


# SQL Techniques Used

 Data Cleaning

- Corrupted column fix: Renamed malformed column names (e.g., `ï»¿id` → `id`).
- Deduplication: Removed duplicate entries using the `ROW_NUMBER()` window function.
- Standardization: 
- Fixed typos in state names (e.g., `georia` → `Georgia`) - Normalized values in the `Type` column (e.g., `Boroughs` → `Borough`)
- Missing values handling: Identified and updated blank entries in key fields like `Place`.
- Validation: Checked for null or zero values in land/water area columns.

📊 Exploratory Data Analysis (EDA)

- Geographic aggregations:
  - Total land and water area by state.
  - Top 10 largest states by land area.
- Income distribution:
  - Average mean and median income per state.
  - Top/bottom 5 states by income levels.
  - Cities with highest average income.
- Grouped analysis:
  - Income by `Type` (household classification).
  - Filtered income insights where sample size was significant (`HAVING COUNT(Type) > 100`).



🧠 Key Concepts Demonstrated

- Data deduplication with `ROW_NUMBER() OVER(PARTITION BY ...)`
- Aggregation with `SUM`, `AVG`, `ROUND`, `GROUP BY`, and `HAVING`
- SQL joins across datasets using shared ID fields
- Null and typo handling
- Analytical sorting with `ORDER BY` and `LIMIT`


🚀 How to Use

1. Import both CSV files into your SQL database (e.g., MySQL or PostgreSQL).
2. Run the first part of the SQL script to clean and prepare the data.
3. Run the second part of the SQL script to explore income patterns across the U.S.


 👤 Author

Florian Boulay 
📧 florian.boulay@hec.ca  
🔗 [LinkedIn](https://www.linkedin.com/in/florian-boulay-524298179/)

 If you found this project helpful or insightful, consider giving it a ⭐ on GitHub!
