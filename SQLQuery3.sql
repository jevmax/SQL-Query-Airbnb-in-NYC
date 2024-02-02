-- most popular host??

select 
distinct host_id,
host_name

from
airbnb.dbo.airbnb
;


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