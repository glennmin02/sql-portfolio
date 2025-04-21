-- Find the number of unique companies and their total carbon footprint PCF for each industry group, filtering for the most recent year in the database.

WITH recent_year_emission AS (
	SELECT MAX(year)
	FROM product_emissions
	)

SELECT industry_group, COUNT(DISTINCT company) AS num_companies, ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint
FROM product_emissions
WHERE year IN (SELECT * FROM recent_year_emission)
GROUP BY industry_group
ORDER BY total_industry_footprint DESC;
