/* Menterness sql project*/




--Q1. Write a code to check NULL values

SELECT 
    *
FROM
    coronadata
WHERE
    Province IS NULL
        OR Country_Region IS NULL
        OR Latitude IS NULL
        OR Longitude IS NULL
        OR Date IS NULL
        OR Confirmed IS NULL
        OR Deaths IS NULL
        OR Recovered IS NULL
;


--Q2. If NULL values are present, update them with zeros for all columns. 

UPDATE coronadata
SET
    Province = COALESCE(Province, '0'),
    Country_Region = COALESCE(Country_Region, '0'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, '1970-01-01'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0)
WHERE
    Province IS NULL
    OR Country_Region IS NULL
    OR Latitude IS NULL
    OR Longitude IS NULL
    OR Date IS NULL
    OR Confirmed IS NULL
    OR Deaths IS NULL
    OR Recovered IS NULL;


	/*
Update coronadata.

UPDATE coronadata.corona
SET Province = COALESCE(Province, ''),     
    Country/Region = COALESCE(Country/Region, ''),     
    Latitude = COALESCE(Latitude, 0),  
    Longitude = COALESCE(Longitude, 0),     
    CDate = COALESCE(CDate, ''),     
    Confirmed = COALESCE(Confirmed, 0),     
    Deaths = COALESCE(Deaths, 0),     
    Recovered = COALESCE(Recovered, 0)
WHERE Province IS NOT NULL;
*/

SELECT * FROM coronadata;


-- Q3. check total number of rows
select count(*)
from coronadata;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(Date) AS start_date,
    MAX(date) AS end_date
FROM 
coronadata;

-- Q5. Number of month present in dataset

SELECT 
    COUNT(DISTINCT FORMAT(Date, 'yyyy-MM')) AS distinct_months
FROM
    coronadata;


-- Q6. Find monthly average for confirmed, deaths, recovered


SELECT 
    FORMAT(Date, 'yyyy-MM') AS year_month,
    AVG(CAST(Confirmed AS FLOAT)) AS avg_confirmed,
    AVG(CAST(Deaths AS FLOAT)) AS avg_deaths,
    AVG(CAST(Recovered AS FLOAT)) AS avg_recovered
FROM
    coronadata
GROUP BY
    FORMAT(Date, 'yyyy-MM');


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
 
WITH MonthlyData AS (
    SELECT 
        FORMAT(Date, 'yyyy-MM') AS year_month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM') ORDER BY COUNT(*) DESC) AS rn_confirmed,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM') ORDER BY COUNT(*) DESC) AS rn_deaths,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM') ORDER BY COUNT(*) DESC) AS rn_recovered
    FROM
        coronadata
    GROUP BY
        FORMAT(Date, 'yyyy-MM'), Confirmed, Deaths, Recovered
)
SELECT
    year_month,
    Confirmed AS most_frequent_confirmed,
    Deaths AS most_frequent_deaths,
    Recovered AS most_frequent_recovered
FROM
    MonthlyData
WHERE
    rn_confirmed = 1
    AND rn_deaths = 1
    AND rn_recovered = 1;



-- Q8. Find minimum values for confirmed, deaths, recovered per year


SELECT 
    YEAR(Date) AS year,
    MIN(CAST(Confirmed AS INT)) AS min_confirmed,
    MIN(CAST(Deaths AS INT)) AS min_deaths,
    MIN(CAST(Recovered AS INT)) AS min_recovered
FROM
    coronadata
GROUP BY
    YEAR(Date)
ORDER BY
    year;



-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT
    EXTRACT(YEAR FROM CDate) AS year,
    EXTRACT(MONTH FROM CDate) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM
    coronadata
GROUP BY
    EXTRACT(YEAR FROM CDate),
    EXTRACT(MONTH FROM CDate)
ORDER BY
    year, month;



-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT
    COUNT(*) AS total_cases,
    AVG(Confirmed) AS average_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDDEV(Confirmed) AS stdev_confirmed
FROM
    coronadata;



-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT
    EXTRACT(YEAR FROM CDate) AS year,
    EXTRACT(MONTH FROM CDate) AS month,
    COUNT(*) AS total_cases,
    AVG(Deaths) AS average_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDDEV(Deaths) AS stdev_deaths
FROM
    coronadata
GROUP BY
    EXTRACT(YEAR FROM CDate),
    EXTRACT(MONTH FROM CDate)
ORDER BY
    year, month;



-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT
    COUNT(*) AS total_cases,
    AVG(Recovered) AS average_recovered,
    VARIANCE (Recovered) AS variance_recovered,
    STDDEV (Recovered) AS stdev_recovered
FROM
    coronadata;


-- Q14. Find Country having highest number of the Confirmed case

SELECT Country/Region, MAX(Confirmed) AS max_confirmed
FROM coronadata
GROUP BY `Country/Region`
ORDER BY max_confirmed DESC
LIMIT 1;


-- Q15. Find Country having lowest number of the death case

SELECT `Country/Region`, MIN(Deaths) AS min_deaths
FROM coronadata
GROUP BY `Country/Region`
ORDER BY min_deaths ASC
LIMIT 1;


-- Q16. Find top 5 countries having highest recovered case

SELECT `Country/Region`, SUM(Recovered) AS total_recovered
FROM coronadata
GROUP BY `Country/Region`
ORDER BY total_recovered DESC
LIMIT 5;
