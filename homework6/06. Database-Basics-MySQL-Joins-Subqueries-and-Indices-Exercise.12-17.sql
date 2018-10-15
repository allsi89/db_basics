USE geography;

#12---

SELECT 
    c.country_code AS country_code,
    m.mountain_range AS mountain_range,
    peak_name,
    p.elevation AS elevation
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        JOIN
    mountains AS m ON mc.mountain_id = m.id
        JOIN
    peaks AS p ON m.id = p.mountain_id 
WHERE
    c.country_name LIKE 'Bulgaria'
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

#13---
    
SELECT 
    new_tab.country_code AS country_code,
    COUNT(new_tab.mountain_range) AS mountain_range
FROM
    (SELECT 
        c.country_code, m.mountain_range
    FROM
        countries AS c
    JOIN mountains_countries AS mc ON mc.country_code = c.country_code
    JOIN mountains AS m ON mc.mountain_id = m.id
    WHERE
        country_name IN ('United States' , 'Russia', 'Bulgaria')) AS new_tab
GROUP BY country_code
ORDER BY mountain_range DESC;

#14---
SELECT 
    c.country_name, r.river_name
FROM
    countries AS c
        JOIN
    continents AS con ON c.continent_code = con.continent_code
        LEFT JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers AS r ON cr.river_id = r.id
WHERE
    con.continent_name LIKE 'Africa'
ORDER BY c.country_name
LIMIT 5;

#15---
           
CREATE TABLE IF NOT EXISTS continents_currencies AS SELECT c.continent_code,
    c.currency_code,
    COUNT(c.currency_code) AS currency_usage FROM
    countries AS c
GROUP BY c.continent_code , c.currency_code
HAVING currency_usage > 1
ORDER BY c.continent_code , c.currency_code;

SELECT 
    cc.*
FROM
    continents_currencies AS cc
        LEFT JOIN
    continents_currencies AS cc2 ON cc.continent_code = cc2.continent_code
        AND cc.currency_usage < cc2.currency_usage
WHERE
    cc2.currency_usage IS NULL;

DROP TABLE continents_currencies;

#16---

SELECT 
    COUNT(c.country_code) AS country_count
FROM
    countries AS c
        LEFT JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
WHERE
    mc.country_code IS NULL;

#17---
SELECT 
    c.country_name AS country_name,
    MAX(p.elevation) AS highest_peak_elevation,
    MAX(r.length) AS longest_river_length
FROM
    countries AS c
        JOIN
    mountains_countries AS mc ON c.country_code = mc.country_code
        JOIN
    mountains AS m ON mc.mountain_id = m.id
        LEFT JOIN
    peaks AS p ON m.id = p.mountain_id
        JOIN
    countries_rivers AS cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers AS r ON cr.river_id = r.id
GROUP BY country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , country_name
LIMIT 5;




    
   
