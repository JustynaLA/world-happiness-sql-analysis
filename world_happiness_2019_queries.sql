-- =====================================================================
-- Exploring Global Happiness with SQL (World Happiness Report 2019)
-- Database: PostgreSQL. Table name: "2019" (156 countries, one row each)
-- Numbering matches the slides in the project presentation.
-- =====================================================================

-- 1) Global happiness rankings: every country, happiest first
SELECT country_or_region, score
FROM "2019"
ORDER BY score DESC;

-- 2a) Top 10 happiest countries
SELECT country_or_region, score
FROM "2019"
ORDER BY score DESC
LIMIT 10;

-- 2b) Bottom 10 countries
SELECT country_or_region, score
FROM "2019"
ORDER BY score ASC
LIMIT 10;

-- 3) Dataset overview: number of countries and the average of each measure
SELECT COUNT(DISTINCT country_or_region)              AS total_countries,
       ROUND(AVG(score), 2)                           AS avg_happiness_score,
       ROUND(AVG(gdp_per_capita), 2)                  AS avg_gdp_per_capita,
       ROUND(AVG(social_support), 2)                  AS avg_social_support,
       ROUND(AVG(healthy_life_expectancy), 2)         AS avg_healthy_life_expectancy,
       ROUND(AVG(freedom_to_make_life_choices), 2)    AS avg_freedom_to_make_life_choices,
       ROUND(AVG(generosity), 2)                      AS avg_generosity,
       ROUND(AVG(perceptions_of_corruption), 2)       AS avg_perceptions_of_corruption
FROM "2019";

-- 4) Average global happiness score (result: 5.41)
SELECT ROUND(AVG(score), 2) AS global_avg_happiness
FROM "2019";

-- 5) Country with the highest GDP per capita, and its happiness score
SELECT country_or_region, gdp_per_capita, score
FROM "2019"
ORDER BY gdp_per_capita DESC
LIMIT 1;

-- 6) Top 5 countries for social support
SELECT country_or_region, ROUND(social_support, 2) AS social_support
FROM "2019"
ORDER BY social_support DESC
LIMIT 5;

-- 7) Top 5 countries for healthy life expectancy
SELECT country_or_region,
       ROUND(healthy_life_expectancy, 2) AS healthy_life_expectancy
FROM "2019"
ORDER BY healthy_life_expectancy DESC
LIMIT 5;

-- 8) Countries with the lowest perceived corruption, and their happiness
--    (in this dataset a HIGHER perceptions_of_corruption value means
--     LESS corruption is perceived, so we sort descending)
SELECT country_or_region,
       ROUND(perceptions_of_corruption, 2) AS corruption_score,
       ROUND(score, 2)                     AS happiness_score
FROM "2019"
ORDER BY perceptions_of_corruption DESC
LIMIT 5;

-- 9a) Average generosity across all countries
SELECT ROUND(AVG(generosity), 3) AS avg_generosity
FROM "2019";

-- 9b) Average happiness for countries above vs below average generosity
--     (subquery inside CASE compares each country with the global average)
SELECT CASE
           WHEN generosity >= (SELECT AVG(generosity) FROM "2019")
           THEN 'Above Average Generosity'
           ELSE 'Below Average Generosity'
       END                  AS generosity_group,
       ROUND(AVG(score), 2) AS avg_happiness,
       COUNT(*)             AS country_count
FROM "2019"
GROUP BY generosity_group;

-- 10) Largest gaps between GDP rank and happiness rank
--     (CTE + RANK() window functions; ABS gives the size of the gap)
WITH ranked_data AS (
    SELECT country_or_region,
           score AS happiness_score,
           gdp_per_capita,
           RANK() OVER (ORDER BY score DESC)          AS happiness_rank,
           RANK() OVER (ORDER BY gdp_per_capita DESC) AS gdp_rank
    FROM "2019"
)
SELECT country_or_region,
       happiness_rank,
       gdp_rank,
       ABS(happiness_rank - gdp_rank) AS rank_difference
FROM ranked_data
ORDER BY rank_difference DESC
LIMIT 10;

-- 11) GDP rank vs happiness rank for every country
--     (RANK() gives tied values the same rank, e.g. two countries ranked 4th)
SELECT country_or_region,
       RANK() OVER (ORDER BY gdp_per_capita DESC) AS gdp_rank,
       RANK() OVER (ORDER BY score DESC)          AS happiness_rank
FROM "2019";

-- 12) Countries split into three happiness groups: High, Medium, Low
--     (NTILE(3) always creates equal-sized groups by design)
WITH ranked_data AS (
    SELECT country_or_region,
           score,
           NTILE(3) OVER (ORDER BY score DESC) AS happiness_group
    FROM "2019"
)
SELECT CASE
           WHEN happiness_group = 1 THEN 'High'
           WHEN happiness_group = 2 THEN 'Medium'
           ELSE 'Low'
       END      AS happiness_category,
       COUNT(*) AS country_count
FROM ranked_data
GROUP BY happiness_category;

-- 12b) Alternative: fixed score thresholds instead of equal-sized groups
--      (NTILE puts the same number of countries in each group; thresholds
--       group countries by their actual score, so group sizes differ)
SELECT CASE
           WHEN score >= 7 THEN 'High'
           WHEN score >= 5 THEN 'Medium'
           ELSE 'Low'
       END      AS happiness_category,
       COUNT(*) AS country_count
FROM "2019"
GROUP BY happiness_category;

-- 13) Top 5 countries combining social support and freedom
SELECT country_or_region,
       ROUND(social_support, 2)                                 AS social_support,
       ROUND(freedom_to_make_life_choices, 2)                   AS freedom,
       ROUND((social_support + freedom_to_make_life_choices), 2) AS combined_score
FROM "2019"
ORDER BY combined_score DESC
LIMIT 5;
