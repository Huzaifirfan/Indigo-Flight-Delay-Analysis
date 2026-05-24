-- ================================================
-- INDIGO FLIGHT DELAY ANALYSIS
-- File: Schema / Table Creation
-- ================================================

CREATE DATABASE IF NOT EXISTS indigo_flight_analysis;
USE indigo_flight_analysis;

-- Table 1: Airports
CREATE TABLE airports (
    airport_id       VARCHAR(10)  PRIMARY KEY,
    airport_name     VARCHAR(100) NOT NULL,
    city             VARCHAR(50)  NOT NULL,
    state            VARCHAR(50),
    country          VARCHAR(50)  DEFAULT 'India',
    iata_code        VARCHAR(5)   UNIQUE NOT NULL,
    total_runways    INT,
    is_international BOOLEAN      DEFAULT FALSE
);

-- Table 2: Aircraft
CREATE TABLE aircraft (
    aircraft_id       VARCHAR(10)  PRIMARY KEY,
    aircraft_model    VARCHAR(50)  NOT NULL,
    manufacturer      VARCHAR(50)  DEFAULT 'Airbus',
    total_seats       INT          NOT NULL,
    manufacture_year  INT,
    last_service_date DATE,
    status            VARCHAR(20)  DEFAULT 'Active'
                      CHECK (status IN ('Active','Maintenance','Retired'))
);

-- Table 3: Routes
CREATE TABLE routes (
    route_id                 VARCHAR(10) PRIMARY KEY,
    origin_airport           VARCHAR(10) NOT NULL,
    dest_airport             VARCHAR(10) NOT NULL,
    distance_km              INT,
    scheduled_duration_mins  INT,
    flight_number            VARCHAR(10) UNIQUE NOT NULL,
    is_active                BOOLEAN     DEFAULT TRUE,
    FOREIGN KEY (origin_airport) REFERENCES airports(airport_id),
    FOREIGN KEY (dest_airport)   REFERENCES airports(airport_id)
);

-- Table 4: Flights
CREATE TABLE flights (
    flight_id              VARCHAR(15) PRIMARY KEY,
    route_id               VARCHAR(10) NOT NULL,
    aircraft_id            VARCHAR(10) NOT NULL,
    flight_date            DATE        NOT NULL,
    scheduled_departure    TIME        NOT NULL,
    actual_departure       TIME,
    scheduled_arrival      TIME        NOT NULL,
    actual_arrival         TIME,
    departure_delay_mins   INT         DEFAULT 0,
    arrival_delay_mins     INT         DEFAULT 0,
    flight_status          VARCHAR(20) DEFAULT 'On Time'
                           CHECK (flight_status IN
                           ('On Time','Delayed','Cancelled',
                            'Diverted','Early')),
    FOREIGN KEY (route_id)    REFERENCES routes(route_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
);

-- Table 5: Delays
CREATE TABLE delays (
    delay_id             INT         PRIMARY KEY AUTO_INCREMENT,
    flight_id            VARCHAR(15) NOT NULL,
    delay_category       VARCHAR(50) NOT NULL
                         CHECK (delay_category IN (
                         'Weather','Technical','Crew',
                         'Air Traffic','Security',
                         'Passenger','Fueling','Other')),
    delay_duration_mins  INT         NOT NULL,
    delay_description    VARCHAR(200),
    reported_by          VARCHAR(50),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Table 6: Passengers
CREATE TABLE passengers (
    passenger_id    INT         PRIMARY KEY AUTO_INCREMENT,
    flight_id       VARCHAR(15) NOT NULL,
    total_booked    INT         DEFAULT 0,
    total_boarded   INT         DEFAULT 0,
    total_no_show   INT         DEFAULT 0,
    total_cancelled INT         DEFAULT 0,
    load_factor     DECIMAL(5,2),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Table 7: Crew
CREATE TABLE crew (
    crew_id              INT         PRIMARY KEY AUTO_INCREMENT,
    flight_id            VARCHAR(15) NOT NULL,
    captain_name         VARCHAR(100) NOT NULL,
    copilot_name         VARCHAR(100),
    total_cabin_crew     INT         DEFAULT 4,
    crew_experience_yrs  INT,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Table 8: Weather
CREATE TABLE weather (
    weather_id      INT         PRIMARY KEY AUTO_INCREMENT,
    airport_id      VARCHAR(10) NOT NULL,
    weather_date    DATE        NOT NULL,
    weather_time    TIME,
    condition_type  VARCHAR(50)
                    CHECK (condition_type IN (
                    'Clear','Cloudy','Rainy','Foggy',
                    'Stormy','Windy','Hail','Snow')),
    visibility_km   DECIMAL(5,2),
    wind_speed_kmh  INT,
    temperature_c   DECIMAL(5,2),
    is_severe       BOOLEAN     DEFAULT FALSE,
    FOREIGN KEY (airport_id) REFERENCES airports(airport_id)
);
