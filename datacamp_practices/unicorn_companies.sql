--Findinig the top ranked industries first.
WITH top_industries AS (
    SELECT 
        i.industry, 
        COUNT(*) AS count
    FROM 
        industries i
        JOIN dates d ON i.company_id = d.company_id
    WHERE 
        EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY 
        i.industry
    ORDER BY 
        count DESC
    LIMIT 3
)

--Finnal query
  SELECT 
    i.industry,
    EXTRACT(YEAR FROM d.date_joined) AS year,
    COUNT(*) AS num_unicorns,
    ROUND(AVG(f.valuation / 1000000000), 2) AS average_valuation_billions
FROM 
    industries i
    JOIN dates d ON i.company_id = d.company_id
    JOIN funding f ON i.company_id = f.company_id
WHERE 
    i.industry IN (SELECT industry FROM top_industries)
    AND EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
GROUP BY 
    i.industry, 
    EXTRACT(YEAR FROM d.date_joined)
ORDER BY 
    year DESC, 
    num_unicorns DESC;
