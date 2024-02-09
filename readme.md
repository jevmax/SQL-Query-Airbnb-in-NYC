This project's objective was to answer some questions through MYSQL queries using a dataset involving real estate.

<b>Dataset:</b> Airbnb data</br>
<b>Source:</b> Kaggle </br>
<b>Queried using:</b> Microsoft SQL Server Management Studio 19 </br>

Objectives
---
For this project I used a dataset from Kaggle that collected AirBnB listings in New York City up to early January, 2024.


Questions to Answer when looking through this dataset:

•Highest price of rental?</br>
•Lowest price of rental?</br>
•Most popular room type?</br>
•Least popular room type?</br>
•Most popular Neighborhood Group?</br>
•Least popular Neighborhood Group?</br>
•Most common host (and how many non-duplicate properties they have)</br>

•Prices based by neighborhood groups to compare against each other.

•What properties are licensed?</br>
•How many properties have reviews BUT no ratings?</br>

Source: 
https://www.kaggle.com/datasets/vrindakallu/new-york-dataset/data


Process
---

Thankfully, the null values were removed , but I still have to continue cleaning and modifying this data to make sure that it's more accessible and readible when querying.


•Added an ID type column specific for SQL while keeping the Airbnb id column.

•Removed extraneous text in the 'name' column so it's more readable at a glance.

•Removed redundant property type from the 'name'column and kept what type of property it is. This new column is named 'property_type'.

````
FORMULA:
 =LEFT(B2,FIND("in",B2)-1)
````
 
•Changed 'last_review'format to make it a compatible date for SQL. The date format went from mm/dd/yyyy to yyyy-mm-dd


•Added a SQL-friendly duplicate column to the 'rating' column called 'rating_sql'. 'rating' can stay as source data, but for 'rating_sql' I simply made "No Rating" a 0. When calculating, I can use 'rating_sql'for numeric values.

•I had to do the same for the 'baths' column since one row had text not specifying how many bathrooms available on the property. 'baths' being the source column, but 'baths_sql' as a FLOAT datatype with a 'NULL' value on the non-specified bathroom.

Import
---

SQL Server import CSV using 'Flat File' due to the immense size of the table. For Beekeeper Community,I would need an external tool to convert the table's data into an 'INSERT INTO'.

Datatypes for each column:
````
id INT
name VARCHAR(255)
property_type VARCHAR(255)
host_id INT
host_name VARCHAR(255)
neighbourhood_group VARCHAR(255)
neighbourhood VARCHAR(255)
latitude DECIMAL(for accuracy rather than FLOAT)
longitude DECIMAL(for accuracy rather than FLOAT)
room_type VARCHAR(255)
price INT
minimum_nights INT
number_of_reviews INT
last_review VARCHAR(255)
last_review_2 DATE
reviews_per_month DECIMAL(for accuracy rather than FLOAT)
calculated_host_listings_count INT
availability_365 INT
number_of_reviews_ltm INT
license VARCHAR(255)
rating VARCHAR(255)
rating_sql FLOAT
bedrooms VARCHAR(255)
beds INT
baths VARCHAR(255)
baths_sql FLOAT (with NULL)
````


Queries for the questions
---
These queries are SQL Server syntax:


> Highest prices of rental?
````
select top 10
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

from airbnb.dbo.airbnb

where price > 0
group by 
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

order by price desc
;
````

> Lowest prices of rental?

````
select top 10
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

from airbnb.dbo.airbnb

where price > 0
group by 
id, 
property_type,
host_id,
host_name,
price,
beds,
baths_sql,
neighbourhood

order by price asc
;
````


> Most popular room type?

In this case, I chose rooms with the highest ratings, but it still presents over 2000 results:

````
select 
id, 
room_type
host_id,
host_name, 
price,
neighbourhood,
neighbourhood_group,
FORMAT(rating_sql,'N2') as rating_sql

from 
airbnb.dbo.airbnb


where rating_sql >= 5
order by room_type
;
````

This shows me that Entire home/apt, Private room, and Shared room are the highest rated types of rooms.

Out of the entire dataset though, the queries would look like this:
```
select
distinct room_type
from airbnb.dbo.airbnb
;
```
```
select 
count(room_type)
from airbnb.dbo.airbnb

where room_type = 'Private room'

--shared room 293
--entire home/apt 11549
--hotel room 112
--private room 8804
```

The most popular room type regardless of rating was 'Entire home/apt'.


> Most and least popular Neighbourhood Group?

I find out how many neighborhood groups I had:

```
select 
distinct neighbourhood_group as neighborhood_group

from 
airbnb.dbo.airbnb
;
```

Then I collect how many properties categorized in each neighborhood group:

```
select
count (neighbourhood_group)
from 
airbnb.dbo.airbnb

where neighbourhood_group = ' '
;

-- Manhattan: 8038
-- Brooklyn: 7719
-- Queens: 3761
-- Bronx: 949
-- Staten Island: 291
```

> Most common host?

12449 different hosts from:

```
select 
distinct host_id,
host_name

from
airbnb.dbo.airbnb
;
```

In this case, I wanted to find out how many properties owned by each different host, but at this point I noticed that some of the same host names have different host IDs.

Meanwhile, this query gets me the total properties of each distinct host:

```
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
```

But what if a host has properties in different neighborhoods?</br>

For example, I'll use Jennifer with ID number 51501835:

```
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
```

From there I can narrow in and and see what specific properties Jennifer owns:

```
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
```

Latitude and longitude is there to confirm the location (you can copy and paste into Google Maps to compare locations too!) 


> Which neighborhood group has properties with the highest prices?

Now that I know the neighborhood groups, I use this query to get the sum totals:

```
SELECT
SUM(price) as nG_total
FROM 
airbnb.dbo.airbnb
WHERE neighbourhood_group = 'Brooklyn'
;

-- Manhattan: $ 1,831,492
-- Brooklyn: $ 1,443,715
-- Queens: $ 475,726
-- Bronx: $ 112,369
-- Staten Island: $ 34,565
```

For averages, I replace the SUM function with the AVG function:

```
SELECT
AVG(price) as nG_avg
FROM 
airbnb.dbo.airbnb
WHERE neighbourhood_group = 'Staten Island'
;

-- Manhattan: $ 227
-- Brooklyn: $ 187
-- Queens: $ 126
-- Bronx: $ 118
-- Staten Island: $ 118
```

>What properties are licensced? 

To find the properties that that has their OSE-STRREG license:

```
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
```

Meanwhile I can just take the 'NOT' out of my WHERE clause to show how many properties without a license are there. 

Licensed: 1054
Exempt: 2135
No License: 17569

> How many properties have reviews but NO RATINGS?
(I found it odd)

Using this query:

```
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

WHERE rating_sql < 1 AND number_of_reviews > 0

ORDER BY rating_sql ASC
;
```
I found 3593 properties that have reviews but no ratings, (not counting null values)

Query for null values:

```
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
```

This brings us 159 additional properties not having a rating, totaling 3752 properties.

-A hotel has the highest number of reviews at 1865.

-2329 properties have only ONE reveiw.
