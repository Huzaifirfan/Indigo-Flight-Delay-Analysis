-- ================================================
-- INDIGO FLIGHT DELAY ANALYSIS
-- File: Final Complete Report
-- ================================================

USE indigo_flight_analysis;

-- COMPLETE FLIGHT REPORT — 7 Table JOIN
SELECT
    f.flight_id,
    r.flight_number,
    a1.city AS from_city,
    a2.city AS to_city,
    f.flight_date,
    f.scheduled_departure,
    f.actual_departure,
    f.departure_delay_mins AS delay_mins,
    f.flight_status,
    ac.aircraft_model,
    p.total_boarded AS passengers,
    ROUND(p.load_factor, 2) AS load_pct,
    cr.captain_name,
    IFNULL(d.delay_category, 'No Delay') AS delay_reason,
    CASE
        WHEN f.departure_delay_mins = 0    THEN 'No Delay'
        WHEN f.departure_delay_mins <= 30  THEN 'Minor'
        WHEN f.departure_delay_mins <= 60  THEN 'Moderate'
        WHEN f.departure_delay_mins <= 120 THEN 'Major'
        ELSE 'Severe'
    END AS delay_severity
FROM flights f
JOIN routes r     ON f.route_id = r.route_id
JOIN airports a1  ON r.origin_airport = a1.airport_id
JOIN airports a2  ON r.dest_airport = a2.airport_id
JOIN aircraft ac  ON f.aircraft_id = ac.aircraft_id
JOIN passengers p ON f.flight_id = p.flight_id
JOIN crew cr      ON f.flight_id = cr.flight_id
LEFT JOIN delays d ON f.flight_id = d.flight_id
ORDER BY f.departure_delay_mins DESC;

-- AIRPORT PERFORMANCE SUMMARY
SELECT
    a.city AS airport_city,
    a.iata_code,
    COUNT(DISTINCT f.flight_id) AS total_departures,
    SUM(CASE WHEN f.flight_status = 'On Time'   THEN 1 ELSE 0 END) AS on_time,
    SUM(CASE WHEN f.flight_status = 'Delayed'   THEN 1 ELSE 0 END) AS `delayed`,
    SUM(CASE WHEN f.flight_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay_mins
FROM airports a
JOIN routes r ON a.airport_id = r.origin_airport
JOIN flights f ON r.route_id = f.route_id
GROUP BY a.city, a.iata_code
ORDER BY avg_delay_mins DESC;
