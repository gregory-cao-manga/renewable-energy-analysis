
-- =======================================
-- Project: Renewable Energy Adoption Analysis
-- Author: Greg Manga
-- =======================================


-- =======================================
-- SECTION 1: Setting up Database
-- =======================================
  
CREATE DATABASE renewable_energy_db;
USE renewable_energy_db;

CREATE TABLE renewable_energy_pct (
    location VARCHAR(5),
    indicator VARCHAR(20),
    subject VARCHAR(10),
    measure VARCHAR(30),
    frequency CHAR(1),
    year INT,
    value DECIMAL(10,2),
    flag_code CHAR(1)
);

SHOW TABLES;

-- =======================================
-- SECTION 2: Data Validation
-- =======================================
  
-- Row counting  
SELECT COUNT(*)
FROM renewable_energy_pct;

-- Checking nulls 
SELECT COUNT(*)
FROM renewable_energy_pct
WHERE value IS NULL;

-- Checking Distinct Location
SELECT DISTINCT 
	location
FROM renewable_energy_pct
ORDER BY location ASC;


-- =======================================
-- SECTION 3: Data Exploration
-- =======================================

-- Checking the year range 
SELECT 
	MIN(year),
    MAX(year)
FROM renewable_energy_pct;

-- Counting the number of countries
SELECT 
	COUNT(DISTINCT location) AS total_countries
FROM renewable_energy_pct;

-- Value distribution
SELECT 
    MIN(value) AS min_value,
    MAX(value) AS max_value,
    AVG(value) AS avg_value
FROM renewable_energy_pct;

-- Inspecting the outlier (177.55) max value 
SELECT
	location, 
	MAX(value) AS max_value,
    COUNT(*) AS value_freq
FROM renewable_energy_pct
WHERE 
	value > 100
GROUP BY 
	location
HAVING 
	MAX(value) > 100
ORDER BY 
	max_value DESC;


-- =======================================
-- SECTION 4: Core Analysis
-- =======================================

-- Q1. How has renewable energy adoption changed over time globally?
SELECT 
	year,
    ROUND(AVG(value),2) AS avg_renewable_pct
FROM renewable_energy_pct
GROUP BY 
	year
ORDER BY 
	year ASC;

-- Q2. Which countries have the highest renewable energy adoption?
SELECT
	location,
    ROUND(AVG(value),2) AS avg_pct
FROM renewable_energy_pct
GROUP BY 
	location
ORDER BY
	avg_pct DESC
LIMIT 
	10;

-- Q3. Which countries showed the greatest improvement over time?  
SELECT
	location,
    MAX(CASE WHEN year = 2015 THEN value END) - 
    MAX(CASE WHEN year = 1960 THEN value END) AS growth
FROM renewable_energy_pct
GROUP BY
	location
HAVING 
	growth IS NOT NULL
ORDER BY
	growth DESC
LIMIT 
	10;

