-- ================================================
-- INDIGO FLIGHT DELAY ANALYSIS
-- File: Basic Analysis Queries
-- ================================================

USE indigo_flight_analysis;

-- Q1. Total flights by status
SELECT flight_status,
       COUNT(*) AS total_flights,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM flights), 2) AS percentage
FROM flights
GROUP BY flight_status
ORDER BY total_flights DESC;

-- Q2. Most delayed routes
SELECT r.flight_number,
       a1.city AS from_city,
       a2.city AS to_city,
       COUNT(f.flight_id) AS total_flights,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay_mins,
       MAX(f.departure_delay_mins) AS max_delay_mins
FROM flights f
JOIN routes r ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
GROUP BY r.flight_number, a1.city, a2.city
ORDER BY avg_delay_mins DESC;

-- Q3. Most common delay reasons
SELECT delay_category,
       COUNT(*) AS total_occurrences,
       SUM(delay_duration_mins) AS total_delay_mins,
       ROUND(AVG(delay_duration_mins), 2) AS avg_delay_mins
FROM delays
GROUP BY delay_category
ORDER BY total_delay_mins DESC;

-- Q4. On time performance by route
SELECT r.flight_number,
       a1.city AS origin,
       a2.city AS destination,
       COUNT(*) AS total,
       SUM(CASE WHEN f.flight_status = 'On Time' THEN 1 ELSE 0 END) AS on_time,
       ROUND(SUM(CASE WHEN f.flight_status = 'On Time' THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*), 2) AS on_time_percentage
FROM flights f
JOIN routes r ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
GROUP BY r.flight_number, a1.city, a2.city
ORDER BY on_time_percentage DESC;

-- Q5. Aircraft delay performance
SELECT ac.aircraft_model,
       COUNT(f.flight_id) AS total_flights,
       SUM(CASE WHEN f.flight_status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_flights,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay
FROM flights f
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
GROUP BY ac.aircraft_model
ORDER BY avg_delay ASC;
