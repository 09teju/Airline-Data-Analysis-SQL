DROP DATABASE IF EXISTS airline_analysis;
CREATE DATABASE airline_analysis;

CREATE TABLE airline_analysis.airlines (
    carrier VARCHAR(10) PRIMARY KEY,
    carrier_name VARCHAR(100)
);

/*AIRPORTS TABLE*/
CREATE TABLE airline_analysis.airports (
    airport VARCHAR(10) PRIMARY KEY,
    airport_name VARCHAR(100)
);


/*FLIGHTS TABLE*/
CREATE TABLE  airline_analysis.flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    month INT,
    carrier VARCHAR(10),
    airport VARCHAR(10),
    arr_flights INT,
    arr_del15 INT,
    arr_cancelled INT,
    arr_diverted INT,
    arr_delay INT,
    FOREIGN KEY (carrier) REFERENCES airlines(carrier),
    FOREIGN KEY (airport) REFERENCES airports(airport)
);

/*DELAY_CAUSES TABLE*/
CREATE TABLE airline_analysis.delay_causes (
    delay_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    carrier_ct DECIMAL(10,2),
    weather_ct DECIMAL(10,2),
    nas_ct DECIMAL(10,2),
    security_ct DECIMAL(10,2),
    late_aircraft_ct DECIMAL(10,2),
    carrier_delay DECIMAL(10,2),
    weather_delay DECIMAL(10,2),
    nas_delay DECIMAL(10,2),
    security_delay DECIMAL(10,2),
    late_aircraft_delay DECIMAL(10,2),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);



ALTER TABLE airline_analysis.delay_causes 
MODIFY carrier_ct DECIMAL(10,2),
MODIFY weather_ct DECIMAL(10,2),
MODIFY nas_ct DECIMAL(10,2),
MODIFY security_ct DECIMAL(10,2),
MODIFY late_aircraft_ct DECIMAL(10,2),
MODIFY carrier_delay DECIMAL(10,2),
MODIFY weather_delay DECIMAL(10,2),
MODIFY nas_delay DECIMAL(10,2),
MODIFY security_delay DECIMAL(10,2),
MODIFY late_aircraft_delay DECIMAL(10,2);


/*TEMPORARY TABLE TO STORE THE ENTIRE CSV DATA*/
CREATE TABLE airline_analysis.flight_delays (
    year INT,
    month INT,
    carrier VARCHAR(10),
    carrier_name VARCHAR(100),
    airport VARCHAR(10),
    airport_name VARCHAR(100),
    arr_flights DECIMAL(10,2),
    arr_del15 DECIMAL(10,2),
    carrier_ct DECIMAL(10,2),
    weather_ct DECIMAL(10,2),
    nas_ct DECIMAL(10,2),
    security_ct DECIMAL(10,2),
    late_aircraft_ct DECIMAL(10,2),
    arr_cancelled DECIMAL(10,2),
    arr_diverted DECIMAL(10,2),
    arr_delay DECIMAL(10,2),
    carrier_delay DECIMAL(10,2),
    weather_delay DECIMAL(10,2),
    nas_delay DECIMAL(10,2),
    security_delay DECIMAL(10,2),
    late_aircraft_delay DECIMAL(10,2)
);

/*LOAD THE CSV DATA INTO TEMP TABLE*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airline_Delay_Cause_Cleaned.csv'  
INTO TABLE  airline_analysis.flight_delays  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS  
(@year, @month, @carrier, @carrier_name, @airport, @airport_name,   
 @arr_flights, @arr_del15, @carrier_ct, @weather_ct, @nas_ct,  
 @security_ct, @late_aircraft_ct, @arr_cancelled, @arr_diverted, @arr_delay,  
 @carrier_delay, @weather_delay, @nas_delay, @security_delay, @late_aircraft_delay)  
SET   
 year = NULLIF(@year, ''),  
 month = NULLIF(@month, ''),  
 carrier = NULLIF(@carrier, ''),  
 carrier_name = NULLIF(@carrier_name, ''),  
 airport = NULLIF(@airport, ''),  
 airport_name = NULLIF(@airport_name, ''),  
 arr_flights = NULLIF(@arr_flights, '') ,  
 arr_del15 = NULLIF(@arr_del15, ''),  
 carrier_ct = NULLIF(@carrier_ct, ''),  
 weather_ct = NULLIF(@weather_ct, ''),  
 nas_ct = NULLIF(@nas_ct, ''),  
 security_ct = NULLIF(@security_ct, ''),  
 late_aircraft_ct = NULLIF(@late_aircraft_ct, ''),  
 arr_cancelled = NULLIF(@arr_cancelled, ''),  
 arr_diverted = NULLIF(@arr_diverted, ''),  
 arr_delay = NULLIF(@arr_delay, ''),  
 carrier_delay = NULLIF(@carrier_delay, ''),  
 weather_delay = NULLIF(@weather_delay, ''),  
 nas_delay = NULLIF(@nas_delay, ''),  
 security_delay = NULLIF(@security_delay, ''),  
 late_aircraft_delay = NULLIF(@late_aircraft_delay, '');


/*LOADING THE PARTICULAR COLUMNS FROM TEMP TABLE TO OTHERS*/
INSERT INTO airline_analysis.airlines (carrier, carrier_name)
SELECT DISTINCT carrier, carrier_name FROM airline_analysis.flight_delays;


INSERT INTO airline_analysis.airports (airport, airport_name)
SELECT DISTINCT airport, airport_name FROM airline_analysis.flight_delays;


INSERT INTO airline_analysis.flights (year, month, carrier, airport, arr_flights, arr_del15, arr_cancelled, arr_diverted, arr_delay)
SELECT DISTINCT year, month, carrier, airport, arr_flights, arr_del15, arr_cancelled, arr_diverted, arr_delay
FROM airline_analysis.flight_delays;


INSERT INTO airline_analysis.delay_causes (flight_id, carrier_ct, weather_ct, nas_ct, security_ct, late_aircraft_ct, 
                                           carrier_delay, weather_delay, nas_delay, security_delay, late_aircraft_delay)
SELECT f.flight_id, fd.carrier_ct, fd.weather_ct, fd.nas_ct, fd.security_ct, fd.late_aircraft_ct, 
       fd.carrier_delay, fd.weather_delay, fd.nas_delay, fd.security_delay, fd.late_aircraft_delay
FROM airline_analysis.flight_delays fd
JOIN airline_analysis.flights f 
ON fd.year = f.year 
AND fd.month = f.month 
AND fd.carrier = f.carrier 
AND fd.airport = f.airport;



/*count of all the rows*/
SELECT 'airlines' AS table_name, COUNT(*) AS row_count FROM airline_analysis.airlines
UNION ALL
SELECT 'airports', COUNT(*) FROM airline_analysis.airports
UNION ALL
SELECT 'flights', COUNT(*) FROM airline_analysis.flights
UNION ALL
SELECT 'delay_causes', COUNT(*) FROM airline_analysis.delay_causes;

/*Find Top Airlines with Delays
(This shows airlines with the highest total delayed flights.)*/
SELECT a.carrier_name, 
       SUM(f.arr_del15) AS total_delayed_flights
FROM airline_analysis.flights f
JOIN airline_analysis.airlines a ON f.carrier = a.carrier
GROUP BY a.carrier_name
ORDER BY total_delayed_flights DESC
LIMIT 10;


/*Find Worst Airports for Delays
(This shows airports with the highest total delayed flights.)*/
SELECT ap.airport_name, 
       SUM(f.arr_del15) AS total_delayed_flights
FROM airline_analysis.flights f
JOIN airline_analysis.airports ap ON f.airport = ap.airport
GROUP BY ap.airport_name
ORDER BY total_delayed_flights DESC
LIMIT 10;

/*Identify the Main Causes of Flight Delays
(This shows which delay reasons contribute the most.)*/
SELECT 
    'Carrier Delay' AS delay_reason, SUM(dc.carrier_delay) AS total_minutes FROM airline_analysis.delay_causes dc
UNION ALL
SELECT 
    'Weather Delay', SUM(dc.weather_delay) FROM airline_analysis.delay_causes dc
UNION ALL
SELECT 
    'NAS Delay', SUM(dc.nas_delay) FROM airline_analysis.delay_causes dc
UNION ALL
SELECT 
    'Security Delay', SUM(dc.security_delay) FROM airline_analysis.delay_causes dc
UNION ALL
SELECT 
    'Late Aircraft Delay', SUM(dc.late_aircraft_delay) FROM airline_analysis.delay_causes dc
ORDER BY total_minutes DESC;


/* Total flight delays per month
This helps identify the months with the most delays.*/
SELECT month, SUM(arr_del15) AS total_delayed_flights
FROM airline_analysis.flights
GROUP BY month
ORDER BY total_delayed_flights DESC;



/*Total flight delays per year
See if delays increased or decreased over time.*/
SELECT year, SUM(arr_del15) AS total_delayed_flights
FROM airline_analysis.flights
GROUP BY year
ORDER BY total_delayed_flights DESC;


/*Which season had the most delays?*/
SELECT 
    CASE 
        WHEN month IN (12, 1, 2) THEN 'Winter'
        WHEN month IN (3, 4, 5) THEN 'Spring'
        WHEN month IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END AS season, 
    SUM(arr_del15) AS total_delayed_flights
FROM airline_analysis.flights
GROUP BY season
ORDER BY total_delayed_flights DESC;


/*Which airline had the longest average delay duration?
This tells which airline had the worst delay times on average.*/
SELECT a.carrier_name, AVG(f.arr_delay) AS avg_delay_minutes
FROM airline_analysis.flights f
JOIN airline_analysis.airlines a ON f.carrier = a.carrier
WHERE f.arr_delay IS NOT NULL
GROUP BY a.carrier_name
ORDER BY avg_delay_minutes DESC
LIMIT 10;


/*Which airport had the longest total delay time?
Shows the worst airports for total delay duration.*/
SELECT ap.airport_name, SUM(f.arr_delay) AS total_delay_minutes
FROM airline_analysis.flights f
JOIN airline_analysis.airports ap ON f.airport = ap.airport
WHERE f.arr_delay IS NOT NULL
GROUP BY ap.airport_name
ORDER BY total_delay_minutes DESC
LIMIT 10;


/*Total delays grouped by cause per year
To see if certain delays (weather, carrier issues, etc.) got worse over time.*/
SELECT f.year, 
       SUM(d.carrier_delay) AS carrier_delay,
       SUM(d.weather_delay) AS weather_delay,
       SUM(d.nas_delay) AS nas_delay,
       SUM(d.security_delay) AS security_delay,
       SUM(d.late_aircraft_delay) AS late_aircraft_delay
FROM airline_analysis.delay_causes d
JOIN airline_analysis.flights f ON d.flight_id = f.flight_id
GROUP BY f.year
ORDER BY f.year ASC;

/*Which month had the highest weather-related delays?
Find the month when weather caused the most disruptions.*/
SELECT month, SUM(weather_delay) AS total_weather_delay
FROM airline_analysis.delay_causes d
JOIN airline_analysis.flights f ON d.flight_id = f.flight_id
GROUP BY month
ORDER BY total_weather_delay DESC;


/*Which airline had the highest weather-related delays?
See which airline suffered most due to weather.*/
SELECT a.carrier_name, SUM(d.weather_delay) AS total_weather_delay
FROM airline_analysis.delay_causes d
JOIN airline_analysis.flights f ON d.flight_id = f.flight_id
JOIN airline_analysis.airlines a ON f.carrier = a.carrier
GROUP BY a.carrier_name
ORDER BY total_weather_delay DESC
LIMIT 10;


/*Which airport had the worst security-related delays?*/
SELECT ap.airport_name, SUM(d.security_delay) AS total_security_delay
FROM airline_analysis.delay_causes d
JOIN airline_analysis.flights f ON d.flight_id = f.flight_id
JOIN airline_analysis.airports ap ON f.airport = ap.airport
GROUP BY ap.airport_name
ORDER BY total_security_delay DESC
LIMIT 10;


/*Percentage of flights delayed vs. total flights
This shows how much of an impact delays had overall.*/
SELECT 
    SUM(arr_del15) / SUM(arr_flights) * 100 AS percentage_flights_delayed
FROM airline_analysis.flights;
