-- ================================================
-- INDIGO FLIGHT DELAY ANALYSIS
-- File: Advanced Analysis Queries
-- ================================================

USE indigo_flight_analysis;

-- Q6. Rank routes by delay using Window Function
SELECT r.flight_number,
       a1.city AS origin,
       a2.city AS destination,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay,
       RANK() OVER (ORDER BY AVG(f.departure_delay_mins) DESC) AS delay_rank
FROM flights f
JOIN routes r ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
GROUP BY r.flight_number, a1.city, a2.city;

-- Q7. Running total of delays per day
SELECT flight_date,
       COUNT(*) AS flights_per_day,
       SUM(departure_delay_mins) AS daily_delay,
       SUM(SUM(departure_delay_mins))
           OVER (ORDER BY flight_date) AS running_total_delay
FROM flights
GROUP BY flight_date
ORDER BY flight_date;

-- Q8. Worst delayed flight each day using CTE
WITH daily_worst AS (
    SELECT flight_id,
           flight_date,
           departure_delay_mins,
           RANK() OVER (
               PARTITION BY flight_date
               ORDER BY departure_delay_mins DESC
           ) AS daily_rank
    FROM flights
)
SELECT f.flight_id,
       f.flight_date,
       a1.city AS from_city,
       a2.city AS to_city,
       dw.departure_delay_mins AS delay_mins
FROM daily_worst dw
JOIN flights f ON dw.flight_id = f.flight_id
JOIN routes r ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
WHERE dw.daily_rank = 1
ORDER BY f.flight_date;

-- Q9. Captain performance report
SELECT cr.captain_name,
       COUNT(*) AS total_flights,
       SUM(CASE WHEN f.flight_status='On Time' THEN 1 ELSE 0 END) AS on_time,
       ROUND(SUM(CASE WHEN f.flight_status='On Time' THEN 1 ELSE 0 END)
             *100.0/COUNT(*),2) AS on_time_pct,
       cr.crew_experience_yrs AS experience
FROM flights f
JOIN crew cr ON f.flight_id = cr.flight_id
GROUP BY cr.captain_name, cr.crew_experience_yrs
ORDER BY on_time_pct DESC;

-- Q10. Crew experience vs delay correlation
SELECT
    CASE
        WHEN cr.crew_experience_yrs >= 15 THEN 'Expert 15+ yrs'
        WHEN cr.crew_experience_yrs >= 10 THEN 'Senior 10-15 yrs'
        WHEN cr.crew_experience_yrs >= 5  THEN 'Mid 5-10 yrs'
        ELSE 'Junior under 5 yrs'
    END AS experience_level,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.departure_delay_mins),2) AS avg_delay_mins,
    SUM(CASE WHEN f.flight_status='Delayed' THEN 1 ELSE 0 END) AS delayed_flights
FROM flights f
JOIN crew cr ON f.flight_id = cr.flight_id
GROUP BY experience_level
ORDER BY avg_delay_mins ASC;
