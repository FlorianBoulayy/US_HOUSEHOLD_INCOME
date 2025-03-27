#US Household Income Data Cleaning

-- Load raw data from both tables
SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_householdincome_statistics;

-- Fix corrupted column name in 'us_householdincome_statistics'
ALTER TABLE us_project.us_householdincome_statistics 
RENAME COLUMN `ï»¿id` TO `id`;

-- Check for duplicate IDs in 'us_household_income'
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

-- Remove duplicates from 'us_household_income' based on ID, keeping the first row
DELETE FROM us_project.us_household_income
WHERE row_id IN (
  SELECT row_id 
  FROM (
    SELECT row_id, id, ROW_NUMBER () OVER(PARTITION BY id ORDER BY id) row_num
    FROM us_project.us_household_income
  ) duplicates
  WHERE row_num > 1
);

-- Check for duplicate IDs in 'us_householdincome_statistics'
SELECT id, COUNT(id)
FROM us_project.us_householdincome_statistics
GROUP BY id
HAVING COUNT(id) > 1;

-- Count number of rows per state (to spot inconsistencies)
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income 
GROUP BY State_Name;

-- Check all distinct values in 'State_Name'
SELECT DISTINCT State_Name
FROM us_project.us_household_income 
ORDER BY 1;

-- Fix typos in state names
UPDATE us_project.us_household_income 
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income 
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Check for empty values in the 'Place' column
SELECT *
FROM us_project.us_household_income
WHERE Place = '';

-- Manually update a missing place name based on county and city
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
  AND City = 'Vinemont';

-- Standardize the values in the 'Type' column
UPDATE us_project.us_household_income 
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Find rows with missing or 0 values in 'AWater'
SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL);

#US Household Income Data Exploratory

-- Calculate total land and water area by state, sorted by land size (descending)
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income 
GROUP BY State_Name
ORDER BY 2 DESC;

-- Same query as above, but return only the top 10 states by land size
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income 
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Join both tables on 'id' and filter out rows where Mean income = 0
SELECT *
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0;

-- Show states with the lowest average Mean and Median household income (top 5)
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0 
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5;

-- Show states with the highest average Mean and Median household income (top 5)
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0 
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5;

-- Top 10 states by highest average **Median** income (not Mean)
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0 
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

-- Average income by household type (show most lucrative types)
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0 
GROUP BY Type
ORDER BY 3 DESC
LIMIT 20;

-- Same as above, but only include types with at least 100 entries
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
WHERE Mean <> 0 
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 3 DESC
LIMIT 20;

-- List average Mean income by City and State (grouped by both)
SELECT u.State_Name, City, u.State_Name, ROUND(AVG(Mean),1)
FROM us_project.us_household_income u
JOIN us_householdincome_statistics us
ON u.id = us.id 
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC;

