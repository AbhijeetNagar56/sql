create database airlineservices;
use airlineservices;
show tables;

CREATE TABLE AirlineCompanies (
    Id INT PRIMARY KEY,
    Airline VARCHAR(100) NOT NULL,
    Abbreviation VARCHAR(20),
    Country VARCHAR(50)
);

CREATE TABLE AirportsList (
    City VARCHAR(100) NOT NULL,
    AirportCode VARCHAR(10) PRIMARY KEY,
    AirportName VARCHAR(255) NOT NULL,
    Country VARCHAR(100),
    CountryAbbrev VARCHAR(5)
);

CREATE TABLE FlightServices (
    Airline INT,
    FlightNo INT,
    SourceAirport VARCHAR(10),
    DestAirport VARCHAR(10),
    PRIMARY KEY (Airline, FlightNo),
    FOREIGN KEY (Airline) REFERENCES AirlineCompanies(Id),
    FOREIGN KEY (SourceAirport) REFERENCES AirportsList(AirportCode),
    FOREIGN KEY (DestAirport) REFERENCES AirportsList(AirportCode)
);


drop table FlightServices;
drop table AirportsList;
drop table AirlineCompanies;

select * from AirportsList;


-- q1
WITH CityAirportCount AS (
    SELECT City, COUNT(*) as AirportCount
    FROM AirportsList
    GROUP BY City
)
SELECT City, AirportName
FROM AirportsList
WHERE City IN (SELECT City FROM CityAirportCount WHERE AirportCount > 1);

-- q2
WITH FilteredCities AS (
    SELECT DISTINCT City 
    FROM AirportsList
    WHERE City LIKE 'A%'
)
SELECT * FROM AirportsList where Country='United States';	

SELECT COUNT(*) AS CityCount FROM FilteredCities;
-- Query 2 Updated for Space Handling
WITH FilteredCities AS (
    SELECT DISTINCT City 
    FROM AirportsList
    -- TRIM removes trailing spaces so 'Aberdeen ' becomes 'Aberdeen'
    -- LOWER makes it case-insensitive to be safe
    WHERE TRIM(LOWER(City)) LIKE 'a%n'
)
-- Use TRIM here as well for the Country check
SELECT * FROM AirportsList 
WHERE TRIM(Country) = 'United States';

-- Final Count
SELECT COUNT(*) AS CityCount FROM FilteredCities;

SELECT * FROM AirportsList WHERE City LIKE 'A%';

-- q3
WITH AdaAirport AS (
    SELECT AirportCode FROM AirportsList WHERE AirportName = 'Ada'
),
AirlinesAtAda AS (
    SELECT DISTINCT Airline FROM FlightServices 
    WHERE SourceAirport IN (SELECT AirportCode FROM AdaAirport)
       OR DestAirport IN (SELECT AirportCode FROM AdaAirport)
)
SELECT * FROM AirlineCompanies
WHERE Id NOT IN (SELECT Airline FROM AirlinesAtAda);

-- q4
WITH MunicipalAirlines AS (
    SELECT DISTINCT Airline FROM FlightServices f 
    JOIN AirportsList a ON f.SourceAirport = a.AirportCode OR f.DestAirport = a.AirportCode
    WHERE a.AirportName = 'Municipal'
),
ZahnsAirlines AS (
    SELECT DISTINCT Airline FROM FlightServices f 
    JOIN AirportsList a ON f.SourceAirport = a.AirportCode OR f.DestAirport = a.AirportCode
    WHERE a.AirportName = 'Zahns'
)
SELECT * FROM AirlineCompanies
WHERE Id IN (SELECT Airline FROM MunicipalAirlines)
  AND Id IN (SELECT Airline FROM ZahnsAirlines);


-- q5
WITH FlightCounts AS (
    SELECT AirportCode, AirportName, 
    (SELECT COUNT(*) FROM FlightServices WHERE SourceAirport = AirportCode OR DestAirport = AirportCode) as TotalFlights
    FROM AirportsList
)
SELECT AirportName, TotalFlights 
FROM FlightCounts 
WHERE TotalFlights = (SELECT MIN(TotalFlights) FROM FlightCounts);



-- q6
WITH AirlineFlightTotals AS (
    SELECT Airline, COUNT(*) as FlightCount
    FROM FlightServices
    GROUP BY Airline
),
DeltaCount AS (
    SELECT FlightCount FROM AirlineFlightTotals 
    WHERE Airline = (SELECT Id FROM AirlineCompanies WHERE Airline = 'Delta Airlines')
)
SELECT ac.Airline, aft.FlightCount
FROM AirlineCompanies ac
JOIN AirlineFlightTotals aft ON ac.Id = aft.Airline
WHERE aft.FlightCount > (SELECT FlightCount FROM DeltaCount);

-- q7
WITH CombinedFlights AS (
    SELECT SourceAirport AS Port, Airline FROM FlightServices
    UNION ALL
    SELECT DestAirport AS Port, Airline FROM FlightServices
),
Ranking AS (
    SELECT a.AirportName, ac.Airline, COUNT(*) as FlightCount
    FROM CombinedFlights cf
    JOIN AirportsList a ON cf.Port = a.AirportCode
    JOIN AirlineCompanies ac ON cf.Airline = ac.Id
    GROUP BY a.AirportName, ac.Airline
)
SELECT * FROM Ranking ORDER BY FlightCount DESC;


-- q8
WITH TotalAirlineCount AS (
    SELECT COUNT(*) as cnt FROM AirlineCompanies
),
AirportServiceCount AS (
    SELECT Port, COUNT(DISTINCT Airline) as DistinctAirlines
    FROM (
        SELECT SourceAirport AS Port, Airline FROM FlightServices
        UNION
        SELECT DestAirport AS Port, Airline FROM FlightServices
    ) Combined
    GROUP BY Port
)
SELECT a.AirportName 
FROM AirportsList a
JOIN AirportServiceCount asct ON a.AirportCode = asct.Port
WHERE asct.DistinctAirlines = (SELECT cnt FROM TotalAirlineCount);

-- q9
WITH ServedAirports AS (
    SELECT SourceAirport FROM FlightServices
    UNION
    SELECT DestAirport FROM FlightServices
)
SELECT AirportName FROM AirportsList
WHERE AirportCode NOT IN (SELECT SourceAirport FROM ServedAirports);


-- q10

WITH ServiceStats AS (
    SELECT Port, COUNT(*) as TotalActivity
    FROM (
        SELECT SourceAirport AS Port FROM FlightServices
        UNION ALL
        SELECT DestAirport AS Port FROM FlightServices
    ) Activity
    GROUP BY Port
)
SELECT al.*, ss.TotalActivity
FROM AirportsList al
JOIN ServiceStats ss ON al.AirportCode = ss.Port
WHERE ss.TotalActivity = (SELECT MAX(TotalActivity) FROM ServiceStats);



