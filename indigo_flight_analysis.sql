CREATE DATABASE indigo_flight_analysis;
USE indigo_flight_analysis;

#TABLE 1 AIRPORTS

CREATE TABLE airports (
    airport_id      VARCHAR(10)  PRIMARY KEY,
    airport_name    VARCHAR(100) NOT NULL,
    city            VARCHAR(50)  NOT NULL,
    state           VARCHAR(50),
    country         VARCHAR(50)  DEFAULT 'India',
    iata_code       VARCHAR(5)   UNIQUE NOT NULL,
    total_runways   INT,
    is_international BOOLEAN     DEFAULT FALSE
);

#TABLE 2 AIRCRAFTS

CREATE TABLE aircraft (
    aircraft_id     VARCHAR(10)  PRIMARY KEY,
    aircraft_model  VARCHAR(50)  NOT NULL,
    manufacturer    VARCHAR(50)  DEFAULT 'Airbus',
    total_seats     INT          NOT NULL,
    manufacture_year INT,
    last_service_date DATE,
    status          VARCHAR(20)  DEFAULT 'Active'
                    CHECK (status IN ('Active','Maintenance','Retired'))
);

#TABLE 3 ROUTES

CREATE TABLE routes (
    route_id        VARCHAR(10)  PRIMARY KEY,
    origin_airport  VARCHAR(10)  NOT NULL,
    dest_airport    VARCHAR(10)  NOT NULL,
    distance_km     INT,
    scheduled_duration_mins INT,
    flight_number   VARCHAR(10)  UNIQUE NOT NULL,
    is_active       BOOLEAN      DEFAULT TRUE,
    FOREIGN KEY (origin_airport) REFERENCES airports(airport_id),
    FOREIGN KEY (dest_airport)   REFERENCES airports(airport_id)
);

#TABLE 4 FLIGHTS(MAIN TABLE)

CREATE TABLE flights (
    flight_id           VARCHAR(15)  PRIMARY KEY,
    route_id            VARCHAR(10)  NOT NULL,
    aircraft_id         VARCHAR(10)  NOT NULL,
    flight_date         DATE         NOT NULL,
    scheduled_departure TIME         NOT NULL,
    actual_departure    TIME,
    scheduled_arrival   TIME         NOT NULL,
    actual_arrival      TIME,
    departure_delay_mins INT         DEFAULT 0,
    arrival_delay_mins   INT         DEFAULT 0,
    flight_status       VARCHAR(20)  DEFAULT 'On Time'
                        CHECK (flight_status IN
                        ('On Time','Delayed','Cancelled',
                         'Diverted','Early')),
    FOREIGN KEY (route_id)    REFERENCES routes(route_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
);

#TABLE 5 DELAY(DELAY REASON)

CREATE TABLE delays (
    delay_id        INT          PRIMARY KEY AUTO_INCREMENT,
    flight_id       VARCHAR(15)  NOT NULL,
    delay_category  VARCHAR(50)  NOT NULL
                    CHECK (delay_category IN (
                    'Weather','Technical','Crew',
                    'Air Traffic','Security',
                    'Passenger','Fueling','Other')),
    delay_duration_mins INT      NOT NULL,
    delay_description   VARCHAR(200),
    reported_by     VARCHAR(50),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

#TABLE 6 PASSENGERS

CREATE TABLE passengers (
    passenger_id    INT          PRIMARY KEY AUTO_INCREMENT,
    flight_id       VARCHAR(15)  NOT NULL,
    total_booked    INT          DEFAULT 0,
    total_boarded   INT          DEFAULT 0,
    total_no_show   INT          DEFAULT 0,
    total_cancelled INT          DEFAULT 0,
    load_factor     DECIMAL(5,2),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

#TABLE 7 CREW

CREATE TABLE crew (
    crew_id         INT          PRIMARY KEY AUTO_INCREMENT,
    flight_id       VARCHAR(15)  NOT NULL,
    captain_name    VARCHAR(100) NOT NULL,
    copilot_name    VARCHAR(100),
    total_cabin_crew INT         DEFAULT 4,
    crew_experience_yrs INT,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

#TABLE 8 WEATHER 

CREATE TABLE weather (
    weather_id      INT          PRIMARY KEY AUTO_INCREMENT,
    airport_id      VARCHAR(10)  NOT NULL,
    weather_date    DATE         NOT NULL,
    weather_time    TIME,
    condition_type  VARCHAR(50)
                    CHECK (condition_type IN (
                    'Clear','Cloudy','Rainy','Foggy',
                    'Stormy','Windy','Hail','Snow')),
    visibility_km   DECIMAL(5,2),
    wind_speed_kmh  INT,
    temperature_c   DECIMAL(5,2),
    is_severe       BOOLEAN      DEFAULT FALSE,
    FOREIGN KEY (airport_id) REFERENCES airports(airport_id)
);

# Insert Airports Data

INSERT INTO airports VALUES
('APT001', 'Indira Gandhi International Airport', 'Delhi',     'Delhi',      'India', 'DEL', 3, TRUE),
('APT002', 'Chhatrapati Shivaji International',   'Mumbai',    'Maharashtra','India', 'BOM', 2, TRUE),
('APT003', 'Kempegowda International Airport',    'Bangalore', 'Karnataka',  'India', 'BLR', 2, TRUE),
('APT004', 'Chennai International Airport',       'Chennai',   'Tamil Nadu', 'India', 'MAA', 3, TRUE),
('APT005', 'Netaji Subhas Chandra Bose Intl',     'Kolkata',   'West Bengal','India', 'CCU', 2, TRUE),
('APT006', 'Rajiv Gandhi International Airport',  'Hyderabad', 'Telangana',  'India', 'HYD', 2, TRUE),
('APT007', 'Sardar Vallabhbhai Patel Intl',       'Ahmedabad', 'Gujarat',    'India', 'AMD', 1, FALSE),
('APT008', 'Pune Airport',                        'Pune',      'Maharashtra','India', 'PNQ', 1, FALSE),
('APT009', 'Goa International Airport',           'Goa',       'Goa',        'India', 'GOI', 1, FALSE),
('APT010', 'Jaipur International Airport',        'Jaipur',    'Rajasthan',  'India', 'JAI', 1, FALSE);

#Insert Aircraft Data

INSERT INTO aircraft VALUES
('AC001', 'A320neo', 'Airbus', 186, 2019, '2024-01-15', 'Active'),
('AC002', 'A320',    'Airbus', 180, 2015, '2024-02-10', 'Active'),
('AC003', 'A321neo', 'Airbus', 232, 2021, '2024-01-20', 'Active'),
('AC004', 'A320neo', 'Airbus', 186, 2020, '2024-03-01', 'Active'),
('AC005', 'A320',    'Airbus', 180, 2016, '2023-12-20', 'Active'),
('AC006', 'A321',    'Airbus', 222, 2018, '2024-02-28', 'Maintenance'),
('AC007', 'A320neo', 'Airbus', 186, 2022, '2024-01-05', 'Active'),
('AC008', 'A320',    'Airbus', 180, 2014, '2023-11-15', 'Active'),
('AC009', 'A321neo', 'Airbus', 232, 2023, '2024-03-10', 'Active'),
('AC010', 'A320',    'Airbus', 180, 2013, '2023-10-20', 'Retired');

#Insert Routes Data

INSERT INTO routes VALUES
('RT001', 'APT001', 'APT002', 1148, 125, '6E-101', TRUE),
('RT002', 'APT002', 'APT001', 1148, 130, '6E-102', TRUE),
('RT003', 'APT001', 'APT003', 2056, 165, '6E-201', TRUE),
('RT004', 'APT003', 'APT001', 2056, 170, '6E-202', TRUE),
('RT005', 'APT002', 'APT004', 1334, 140, '6E-301', TRUE),
('RT006', 'APT004', 'APT002', 1334, 145, '6E-302', TRUE),
('RT007', 'APT001', 'APT005', 1530, 145, '6E-401', TRUE),
('RT008', 'APT005', 'APT001', 1530, 150, '6E-402', TRUE),
('RT009', 'APT001', 'APT006', 1568, 150, '6E-501', TRUE),
('RT010', 'APT006', 'APT001', 1568, 155, '6E-502', TRUE),
('RT011', 'APT002', 'APT003', 984,  110, '6E-601', TRUE),
('RT012', 'APT003', 'APT006', 508,  75,  '6E-701', TRUE),
('RT013', 'APT001', 'APT007', 951,  105, '6E-801', TRUE),
('RT014', 'APT002', 'APT009', 597,  80,  '6E-901', TRUE),
('RT015', 'APT003', 'APT004', 346,  60,  '6E-111', TRUE);

#Insert Flights Data

INSERT INTO flights VALUES
('FL001', 'RT001', 'AC001', '2024-01-15', '06:00', '06:15', '08:05', '08:45', 15,  40,  'Delayed'),
('FL002', 'RT002', 'AC002', '2024-01-15', '09:00', '09:00', '11:10', '11:05', 0,   0,   'On Time'),
('FL003', 'RT003', 'AC003', '2024-01-15', '07:30', '08:45', '10:15', '12:00', 75,  105, 'Delayed'),
('FL004', 'RT004', 'AC004', '2024-01-16', '11:00', '11:00', '13:50', '13:45', 0,   0,   'On Time'),
('FL005', 'RT005', 'AC005', '2024-01-16', '14:00', '14:30', '16:20', '17:00', 30,  40,  'Delayed'),
('FL006', 'RT006', 'AC001', '2024-01-16', '08:00', '08:00', '10:25', '10:20', 0,   0,   'On Time'),
('FL007', 'RT007', 'AC007', '2024-01-17', '16:00', '16:00', '18:25', '18:20', 0,   0,   'On Time'),
('FL008', 'RT008', 'AC002', '2024-01-17', '10:00', '11:30', '12:30', '14:15', 90,  105, 'Delayed'),
('FL009', 'RT009', 'AC003', '2024-01-17', '12:00', '12:00', '14:30', '14:25', 0,   0,   'On Time'),
('FL010', 'RT010', 'AC004', '2024-01-18', '07:00', '07:00', '09:35', '09:30', 0,   0,   'On Time'),
('FL011', 'RT011', 'AC005', '2024-01-18', '15:00', '15:45', '16:50', '17:35', 45,  45,  'Delayed'),
('FL012', 'RT012', 'AC007', '2024-01-18', '09:00', '09:00', '10:15', '10:10', 0,   0,   'On Time'),
('FL013', 'RT013', 'AC008', '2024-01-19', '13:00', '13:00', '14:45', '14:40', 0,   0,   'On Time'),
('FL014', 'RT014', 'AC009', '2024-01-19', '17:00', '17:20', '18:20', '18:45', 20,  25,  'Delayed'),
('FL015', 'RT015', 'AC001', '2024-01-19', '08:00', '08:00', '09:00', '08:55', 0,   0,   'On Time'),
('FL016', 'RT001', 'AC002', '2024-01-20', '06:00', NULL,    '08:05', NULL,    0,   0,   'Cancelled'),
('FL017', 'RT003', 'AC003', '2024-01-20', '07:30', '09:00', '10:15', '11:45', 90,  90,  'Delayed'),
('FL018', 'RT005', 'AC004', '2024-01-20', '14:00', '14:00', '16:20', '16:15', 0,   0,   'On Time'),
('FL019', 'RT007', 'AC007', '2024-01-21', '16:00', '16:15', '18:25', '18:50', 15,  25,  'Delayed'),
('FL020', 'RT009', 'AC008', '2024-01-21', '12:00', '12:00', '14:30', '14:25', 0,   0,   'On Time');

#Insert Delays Data

INSERT INTO delays VALUES
(1,  'FL001', 'Air Traffic',  15,  'ATC hold due to congestion',          'ATC'),
(2,  'FL001', 'Passenger',    25,  'Late boarding passengers',             'Ground Staff'),
(3,  'FL003', 'Weather',      75,  'Dense fog at Delhi airport',           'Meteorology'),
(4,  'FL005', 'Technical',    30,  'Engine sensor check required',         'Engineering'),
(5,  'FL008', 'Crew',         90,  'Crew exceeded duty hours limit',       'Operations'),
(6,  'FL011', 'Fueling',      45,  'Fuel truck delayed at stand',          'Ground Staff'),
(7,  'FL014', 'Security',     20,  'Suspicious baggage screening',         'CISF'),
(8,  'FL017', 'Weather',      90,  'Thunderstorm warning at Bangalore',    'Meteorology'),
(9,  'FL019', 'Air Traffic',  15,  'Runway occupied by previous flight',   'ATC'),
(10, 'FL003', 'Passenger',    30,  'Wheelchair assistance took extra time','Ground Staff');

#Insert Weather Data

INSERT INTO weather VALUES
(1,  'APT001', '2024-01-15', '05:00', 'Foggy',  0.5,  8,  12.5, TRUE),
(2,  'APT001', '2024-01-15', '09:00', 'Clear',  10.0, 12, 15.0, FALSE),
(3,  'APT003', '2024-01-15', '07:00', 'Cloudy', 6.0,  15, 22.0, FALSE),
(4,  'APT002', '2024-01-16', '14:00', 'Rainy',  3.0,  20, 28.0, FALSE),
(5,  'APT005', '2024-01-17', '10:00', 'Clear',  10.0, 10, 18.0, FALSE),
(6,  'APT003', '2024-01-20', '07:00', 'Stormy', 1.0,  45, 20.0, TRUE),
(7,  'APT001', '2024-01-20', '06:00', 'Foggy',  0.2,  5,  10.0, TRUE),
(8,  'APT006', '2024-01-21', '12:00', 'Clear',  10.0, 18, 30.0, FALSE),
(9,  'APT004', '2024-01-16', '14:00', 'Cloudy', 7.0,  12, 26.0, FALSE),
(10, 'APT002', '2024-01-19', '17:00', 'Windy',  8.0,  35, 27.0, FALSE);

#Insert Passengers Data

INSERT INTO passengers VALUES
(1,  'FL001', 180, 175, 5,  0,  97.22),
(2,  'FL002', 180, 178, 2,  0,  98.89),
(3,  'FL003', 232, 220, 8,  4,  94.83),
(4,  'FL004', 186, 185, 1,  0,  99.46),
(5,  'FL005', 180, 172, 5,  3,  95.56),
(6,  'FL006', 186, 180, 4,  2,  96.77),
(7,  'FL007', 186, 184, 2,  0,  98.92),
(8,  'FL008', 180, 165, 10, 5,  91.67),
(9,  'FL009', 232, 228, 4,  0,  98.28),
(10, 'FL010', 186, 183, 3,  0,  98.39),
(11, 'FL011', 180, 170, 7,  3,  94.44),
(12, 'FL012', 186, 182, 4,  0,  97.85),
(13, 'FL013', 180, 176, 4,  0,  97.78),
(14, 'FL014', 186, 180, 5,  1,  96.77),
(15, 'FL015', 186, 186, 0,  0,  100.00),
(16, 'FL016', 180, 0,   0,  180,0.00),
(17, 'FL017', 232, 215, 12, 5,  92.67),
(18, 'FL018', 186, 184, 2,  0,  98.92),
(19, 'FL019', 186, 178, 6,  2,  95.70),
(20, 'FL020', 232, 225, 7,  0,  96.98);

#Insert Crew Data

INSERT INTO crew VALUES
(1,  'FL001', 'Capt. Rajesh Kumar',    'FO Anita Sharma',   6, 15),
(2,  'FL002', 'Capt. Priya Singh',     'FO Amit Verma',     6, 12),
(3,  'FL003', 'Capt. Suresh Patel',    'FO Neha Gupta',     6, 18),
(4,  'FL004', 'Capt. Meera Joshi',     'FO Ravi Kumar',     6, 10),
(5,  'FL005', 'Capt. Vikram Malhotra', 'FO Sneha Reddy',    6, 20),
(6,  'FL006', 'Capt. Arjun Kapoor',    'FO Divya Nair',     6, 8),
(7,  'FL007', 'Capt. Rajesh Kumar',    'FO Pooja Mehta',    6, 15),
(8,  'FL008', 'Capt. Rohan Sharma',    'FO Kiran Rao',      4, 5),
(9,  'FL009', 'Capt. Priya Singh',     'FO Amit Verma',     6, 12),
(10, 'FL010', 'Capt. Suresh Patel',    'FO Rahul Joshi',    6, 18),
(11, 'FL011', 'Capt. Meera Joshi',     'FO Ravi Kumar',     6, 10),
(12, 'FL012', 'Capt. Vikram Malhotra', 'FO Sneha Reddy',    6, 20),
(13, 'FL013', 'Capt. Arjun Kapoor',    'FO Divya Nair',     6, 8),
(14, 'FL014', 'Capt. Rohan Sharma',    'FO Kiran Rao',      6, 5),
(15, 'FL015', 'Capt. Rajesh Kumar',    'FO Anita Sharma',   6, 15),
(16, 'FL016', 'Capt. Priya Singh',     'FO Amit Verma',     0, 12),
(17, 'FL017', 'Capt. Suresh Patel',    'FO Neha Gupta',     6, 18),
(18, 'FL018', 'Capt. Meera Joshi',     'FO Pooja Mehta',    6, 10),
(19, 'FL019', 'Capt. Vikram Malhotra', 'FO Sneha Reddy',    6, 20),
(20, 'FL020', 'Capt. Arjun Kapoor',    'FO Rahul Joshi',    6, 8);

#Basic Analysis

-- 1. Total flights and their status count
SELECT flight_status,
       COUNT(*) AS total_flights,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM flights), 2) AS percentage
FROM flights
GROUP BY flight_status
ORDER BY total_flights DESC;

-- 2. Average delay per route
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

-- 3. Most common delay reasons
SELECT delay_category,
       COUNT(*) AS total_occurrences,
       SUM(delay_duration_mins) AS total_delay_mins,
       ROUND(AVG(delay_duration_mins), 2) AS avg_delay_mins
FROM delays
GROUP BY delay_category
ORDER BY total_delay_mins DESC;

-- 4. Which aircraft causes most delays?
SELECT ac.aircraft_model,
       ac.aircraft_id,
       COUNT(f.flight_id) AS total_flights,
       SUM(CASE WHEN f.flight_status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_flights,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay
FROM flights f
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
GROUP BY ac.aircraft_model, ac.aircraft_id
ORDER BY delayed_flights DESC;

#Intermediate Analysis

-- 5. On time performance by route
SELECT r.flight_number,
       a1.city AS origin,
       a2.city AS destination,
       COUNT(*) AS total,
       SUM(CASE WHEN f.flight_status = 'On Time' THEN 1 ELSE 0 END) AS on_time,
       ROUND(SUM(CASE WHEN f.flight_status = 'On Time' THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*), 2) AS on_time_percentage
FROM flights f
JOIN routes r  ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
GROUP BY r.flight_number, a1.city, a2.city
ORDER BY on_time_percentage DESC;

-- 6. Passenger impact of delays
SELECT f.flight_id,
       f.flight_status,
       f.departure_delay_mins,
       p.total_boarded,
       p.total_cancelled,
       f.departure_delay_mins * p.total_boarded AS total_passenger_delay_mins
FROM flights f
JOIN passengers p ON f.flight_id = p.flight_id
WHERE f.flight_status = 'Delayed'
ORDER BY total_passenger_delay_mins DESC;

-- 7. Weather vs delay correlation
SELECT w.condition_type,
       COUNT(f.flight_id) AS total_flights,
       SUM(CASE WHEN f.flight_status = 'Delayed' THEN 1 ELSE 0 END) AS `delayed`,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay
FROM weather w
JOIN airports a ON w.airport_id = a.airport_id
JOIN routes r ON a.airport_id = r.origin_airport
JOIN flights f ON r.route_id = f.route_id
AND f.flight_date = w.weather_date
GROUP BY w.condition_type
ORDER BY avg_delay DESC;

-- 8. Captain wise performance
SELECT cr.captain_name,
       COUNT(f.flight_id) AS total_flights,
       SUM(CASE WHEN f.flight_status = 'Delayed' THEN 1 ELSE 0 END) AS delays,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay,
       cr.crew_experience_yrs AS experience
FROM flights f
JOIN crew cr ON f.flight_id = cr.flight_id
GROUP BY cr.captain_name, cr.crew_experience_yrs
ORDER BY avg_delay ASC;

#Advanced Analysis — Window Functions
-- 9. Rank routes by delay
SELECT r.flight_number,
       a1.city AS origin,
       a2.city AS destination,
       ROUND(AVG(f.departure_delay_mins), 2) AS avg_delay,
       RANK() OVER (ORDER BY AVG(f.departure_delay_mins) DESC) AS delay_rank
FROM flights f
JOIN routes r  ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
GROUP BY r.flight_number, a1.city, a2.city;

-- 10. Running total of delays per day
SELECT flight_date,
       COUNT(*) AS flights_per_day,
       SUM(departure_delay_mins) AS daily_delay,
       SUM(SUM(departure_delay_mins)) OVER
           (ORDER BY flight_date) AS running_total_delay
FROM flights
GROUP BY flight_date
ORDER BY flight_date;

-- 11. Worst delayed flight each day
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

#Final Report Queries

-- 12. Complete flight report
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
    IFNULL(d.delay_category, 'No Delay') AS delay_reason
FROM flights f
JOIN routes r    ON f.route_id = r.route_id
JOIN airports a1 ON r.origin_airport = a1.airport_id
JOIN airports a2 ON r.dest_airport = a2.airport_id
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
JOIN passengers p ON f.flight_id = p.flight_id
JOIN crew cr     ON f.flight_id = cr.flight_id
LEFT JOIN delays d ON f.flight_id = d.flight_id
ORDER BY f.flight_date, f.scheduled_departure;

-- 13. Airport performance summary
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







