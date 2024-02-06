/* Highest prices of rental? */

SELECT top 10
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

FROM 
airbnb.dbo.airbnb

WHERE 
price > 0
  
GROUP BY
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

ORDER BY price DESC
;

/* Lowest prices */

SELECT top 10
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

FROM airbnb.dbo.airbnb

WHERE price > 0
GROUP BY
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

ORDER BY price ASC
;

/*Most popular room type*/
SELECT 
id, 
room_type
host_id,
host_name, 
price,
neighbourhood,
neighbourhood_group,
FORMAT(rating_sql,'N2') as rating_sql

FROM 
airbnb.dbo.airbnb


WHERE
rating_sql >= 5
order by room_type
;

/*Finding room types*/
SELECT
distinct room_type
FROM
airbnb.dbo.airbnb
;

/* Counting room types */
SELECT
count(room_type)
FROM
airbnb.dbo.airbnb

WHERE 
room_type = 'Private room'

--shared room 293
--entire home/apt 11549
--hotel room 112
--private room 8804

/*Finding neighborhood groups*/
SELECT
distinct neighbourhood_group AS neighborhood_group

FROM
airbnb.dbo.airbnb
;

/*How many properties in each group*/
SELECT
count (neighbourhood_group)
FROM
airbnb.dbo.airbnb

WHERE
neighbourhood_group = ' '
;

-- Manhattan: 8038
-- Brooklyn: 7719
-- Queens: 3761
-- Bronx: 949
-- Staten Island: 291

/*Finding all the hosts*/
SELECT 
distinct host_id,
host_name

FROM
airbnb.dbo.airbnb
;

/*Each distinct host's properties*/
SELECT
distinct host_name,
host_id,
count(*) AS property_count

FROM
airbnb.dbo.airbnb

GROUP BY
host_name,
host_id

ORDER BY property_count desc
;

/*Jennifer example of owning different properties*/
SELECT
distinct host_name,
host_id,
COUNT(*) as property_count,
neighbourhood,
neighbourhood_group

FROM 
airbnb.dbo.airbnb

WHERE host_id = '51501835'

GROUP BY
host_name,
host_id,
neighbourhood,
neighbourhood_group

ORDER BY 
property_count DESC
;

/**/
SELECT
host_id,
host_name,
id as property_id,
latitude,
longitude,
property_type,
room_type,
price,
beds,
baths_sql,
neighbourhood,
neighbourhood_group


FROM 
airbnb.dbo.airbnb

WHERE
host_id = '51501835' 
;

/*Which neighborhood group has properties with the highest prices?
SUM totals
*/
SELECT
SUM(price) as nG_total
FROM 
airbnb.dbo.airbnb
WHERE neighbourhood_group = 'Brooklyn'
;

/*Example to get averages instead*/
SELECT
AVG(price) as nG_avg
FROM 
airbnb.dbo.airbnb
WHERE neighbourhood_group = 'Staten Island'
;


/*Finding what properties are licensed*/
SELECT
id,
host_name,
room_type,
neighbourhood,
neighbourhood_group,
license
FROM 
airbnb.dbo.airbnb

WHERE license NOT IN ('No License', 'Exempt')

ORDER BY neighbourhood_group
;

/*Reviews but no ratings?*/
SELECT
id, 
property_type,
host_id,
host_name,
neighbourhood_group,
number_of_reviews,
format (rating_sql, 'N2') AS rating_sql

FROM
airbnb.dbo.airbnb

WHERE 
rating_sql < 1 AND number_of_reviews > 0

ORDER BY rating_sql ASC
;

/*Finding NULL values*/
SELECT
id, 
property_type,
host_id,
host_name,
neighbourhood_group,
number_of_reviews,
format (rating_sql, 'N2') AS rating_sql

FROM
airbnb.dbo.airbnb

WHERE rating_sql IS NULL
ORDER BY rating_sql ASC
;



