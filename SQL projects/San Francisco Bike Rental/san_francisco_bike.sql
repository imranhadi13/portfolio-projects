-- you may refer to screenshot folder for the screenshot of outcome of each SQL query 

-- code 1 assessing columns under station table 
SELECT * 
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info;
-- code 2 assessing columns under region table 
SELECT * 
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_regions;

-- code 3 assessing columns under trips table 
SELECT * 
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips; 

-- given that station and region shared the key region_id, they will be combined 

-- code 4 joining station table and region table with region_id as common key
SELECT station.station_id, station.name as station_name, station.region_id, region.name as region_name
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info as station
INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions as region
 ON station.region_id = region.region_id;

-- code 5 create CTE to insert region name in trips table from joined table
WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.duration_sec,
  trip.start_date,
  trip.start_station_name,
  start_region.region_name AS start_region_name,
  trip.end_date,
  trip.end_station_name,
  end_region.region_name AS end_region_name,
  trip.subscriber_type
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64);

-- code 6 identify region with highest bike trips based on start region name 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  start_region.region_name as region_name, 
  COUNT(start_region.region_name) AS number_of_trips
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name IS NOT NULL
GROUP BY region_name 
ORDER BY number_of_trips DESC
;

-- from the result, San Francisco region has the higher number of trips, thus it will be the focus for the data analysis
-- code 7 - assessing the years included in the dataset


WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  DISTINCT EXTRACT(YEAR FROM trip.start_date) AS start_year
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
ORDER BY start_year ASC;

-- the data consists of bike trips from 2013 - 2018
-- code 8 - assessing highest number of trips for stations in San Francisco


WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.start_station_name, 
  COUNT(trip.start_station_name) AS number_of_trips_station
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
GROUP BY start_station_name
ORDER BY number_of_trips_station DESC
;
-- from the result, highest number of trips is in San Francisco Caltrain with 72683 trips 
-- code 9 identify longest trip durations in San Francisco


WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.start_station_name, 
  trip.duration_sec / 60 / 60 AS duration_hour
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
ORDER BY duration_sec DESC
LIMIT 10;

-- from the result - the highest duration was 4700 hours, which may raised concern that this might be an outlier to the dataset 
-- code 10 identify duration's upper and lower limit 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)

SELECT
  Q3 - Q1 AS IQR,
  Q1 - 1.5 * (Q3-Q1) AS lower_limit,
  Q3 + 1.5 * (Q3-Q1) AS upper_limit
FROM 
  (SELECT 
    PERCENTILE_CONT(trip.duration_sec, 0.25) OVER () AS Q1,
    PERCENTILE_CONT(trip.duration_sec, 0.75) OVER () AS Q3
    
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
    LEFT JOIN joined AS start_region 
        ON trip.start_station_id = CAST(start_region.station_id AS INT64)
    LEFT JOIN joined AS end_region 
        ON trip.end_station_id = CAST(end_region.station_id AS INT64)
    WHERE start_region.region_name = 'San Francisco')
    LIMIT 1;

-- based on the result, the upper limit for duration of trip 1523 seconds - thus trips above the upper limit will be excluded by including filter. 
-- given the lower limit from the calculation resulted in negative number - only duration above 0 seconds will be accepted (given it is not logical to have duration less than 0 seconds)   
-- code 11 longest bike trip within limits


WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.start_station_name, 
  trip.duration_sec / 60 / 60 AS duration_hour
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
ORDER BY duration_sec DESC
LIMIT 10;

-- within this limit, the longest duration for bike trip is 0.4 hours (equivalent to approximately 25 minutes)
-- code 12 computing statistical summary for duration of bike trip 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  AVG(trip.duration_sec)/60 AS mean_duration_in_min, 
  MIN(trip.duration_sec)/60 AS min_duration_in_min,
  MAX(trip.duration_sec)/60 AS max_duration_in_min,
  STDDEV(trip.duration_sec)/60 AS standard_deviation_duration_in_min
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
;

-- based on the result, the mean for bike trip duration is 9.6 minutes, with minimum duration of 1 minute and maximum duration of 25.8 minutes, with standard deviation of 5 minutes 
-- code 13 analyse number of trips based on days of the week 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  EXTRACT(DAYOFWEEK FROM trip.start_date) AS day_of_week,
  COUNT(*) AS trip_count
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
GROUP BY day_of_week
ORDER BY day_of_week;

-- from the result day 2-6 of the week has proportionately higher bike rental compared to other days of the week
-- however, at this moment it is not specified what is the day of the week based on the number 
-- code 14 identify day of the week based on few rows 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.start_date,
  EXTRACT(DAYOFWEEK FROM trip.start_date) AS day_of_week,
  
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523;

-- based on top result - for the date of 1 October 2017 (which is Sunday) is equivalent to 1st day of the week, which corresponded to the second result of 29th April 2018 - which also a Sunday 
-- code 15 - mapping the previous result with day of the week's name

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  CASE EXTRACT(DAYOFWEEK FROM trip.start_date) 
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Satuday'
    END AS day_of_week,
  COUNT(*) AS trip_count
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
GROUP BY day_of_week
ORDER BY day_of_week;

-- there are lower number of bike rentals during the weekend compared to other days of the week 
-- code 16 identifying type of subscribers for bike rental 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT 
  trip.subscriber_type,
  COUNT(*) AS subscriber_count, 
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
GROUP BY subscriber_type;

-- based on the result there are more subscribe than regular customer who rented the bike - however there was also significant numbers of null values under the column. This may prompt further discussion with the owner of the dataset regarding the null values or opteing to exclude the null values from further analysis 
-- for the project purpose - null values from the subscriber_type will be excluded
-- code 17 - creating table for future use 

CREATE TABLE astute-sky-433705-b7.cycling.new_table AS 

WITH joined AS (
    SELECT 
        station.station_id AS station_id, 
        station.name AS station_name, 
        station.region_id, 
        region.name AS region_name
    FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info AS station
    INNER JOIN bigquery-public-data.san_francisco_bikeshare.bikeshare_regions AS region
        ON station.region_id = region.region_id
)
SELECT
  trip.duration_sec,
  trip.start_date,
  trip.start_station_name,
  start_region.region_name AS start_region_name,
  trip.end_date,
  trip.end_station_name,
  end_region.region_name AS end_region_name,
  trip.subscriber_type
    
FROM bigquery-public-data.san_francisco_bikeshare.bikeshare_trips AS trip
LEFT JOIN joined AS start_region 
    ON trip.start_station_id = CAST(start_region.station_id AS INT64)
LEFT JOIN joined AS end_region 
    ON trip.end_station_id = CAST(end_region.station_id AS INT64)
WHERE start_region.region_name = 'San Francisco'
  AND duration_sec BETWEEN 0 AND 1523
  AND subscriber_type IS NOT NULL
