/*
Question 3:
## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), 
how many trips, **respectively**, happened:

1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles
*/

-- before running subquery or CTE, select October rows that can be easily verified
-- from the output
SELECT CAST(lpep_pickup_datetime AS date)
 FROM green_taxi_data
 WHERE CAST(lpep_pickup_datetime AS date) >= '2019-10-01'
    AND CAST(lpep_pickup_datetime AS date) < '2019-11-01';

-- total number of "Up to 1 mile" trips

SELECT COUNT(1) AS up_to_1_mile_trips
 FROM green_taxi_data
 WHERE CAST(lpep_dropoff_datetime AS date) >= '2019-10-01'
    AND CAST(lpep_dropoff_datetime AS date) < '2019-11-01'
    AND trip_distance <= 1;

/*
+--------+
| count  |
|--------|
| 104802 |
+--------+
*/

-- 2. In between 1 (exclusive) and 3 miles (inclusive)
SELECT COUNT(1) AS up_to_1_mile_trips
 FROM green_taxi_data
 WHERE CAST(lpep_dropoff_datetime AS date) >= '2019-10-01'
    AND CAST(lpep_dropoff_datetime AS date) < '2019-11-01'
    AND trip_distance > 1
    AND trip_distance <= 3;

/*
+--------------------+
| up_to_1_mile_trips |
|--------------------|
| 198924             |
+--------------------+
SELECT 1
Time: 0.242s
*/

-- 3. * In between 3 (exclusive) and 7 miles (inclusive)
SELECT COUNT(1) AS up_to_1_mile_trips
 FROM green_taxi_data
 WHERE CAST(lpep_dropoff_datetime AS date) >= '2019-10-01'
    AND CAST(lpep_dropoff_datetime AS date) < '2019-11-01'
    AND trip_distance > 3
    AND trip_distance <= 7;

/*
+--------------------+
| up_to_1_mile_trips |
|--------------------|
| 109603             |
+--------------------+
SELECT 1
Time: 0.129s
*/

-- In between 7 (exclusive) and 10 miles (inclusive)
SELECT COUNT(1) AS up_to_1_mile_trips
    FROM green_taxi_data
    WHERE CAST(lpep_dropoff_datetime AS date) >= '2019-10-01'
        AND CAST(lpep_dropoff_datetime AS date) < '2019-11-01'
        AND trip_distance > 7
        AND trip_distance <= 10;

/*
+--------------------+
| up_to_1_mile_trips |
|--------------------|
| 27678              |
+--------------------+
SELECT 1
Time: 0.283s
*/

-- 5. Over 10 miles
SELECT COUNT(1) AS ten_mile_and_more_trips
    FROM green_taxi_data
    WHERE CAST(lpep_dropoff_datetime AS date) >= '2019-10-01'
        AND CAST(lpep_dropoff_datetime AS date) < '2019-11-01'
        AND trip_distance > 10;
/*
+-------------------------+
| ten_mile_and_more_trips |
|-------------------------|
| 35189                   |
+-------------------------+
SELECT 1
Time: 0.086s
*/

-- Question 4. Longest trip for each day

SELECT 
    CAST(lpep_pickup_datetime AS date), 
    MAX(trip_distance) AS daily_max_distance
FROM green_taxi_data 
GROUP BY CAST(lpep_pickup_datetime AS date)
ORDER BY daily_max_distance DESC LIMIT 1;

/*
+----------------------+--------------------+
| lpep_pickup_datetime | daily_max_distance |
|----------------------+--------------------|
| 2019-10-31           | 515.89             |
+----------------------+--------------------+
SELECT 1
Time: 0.628s
*/
