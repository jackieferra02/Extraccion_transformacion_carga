
-- Creación del modelo dimensional

-- Dim_Countries
CREATE TABLE Dim_Countries (
    iso_country_id INTEGER PRIMARY KEY AUTOINCREMENT,
    iso_country VARCHAR(10) NOT NULL UNIQUE,
    country_name VARCHAR(100)
);

-- Dim_Regions
CREATE TABLE Dim_Regions (
    iso_region_id INTEGER PRIMARY KEY AUTOINCREMENT,
    iso_region VARCHAR(20) NOT NULL UNIQUE,
    region_name VARCHAR(100)
);

-- Dim_Surface_Types
CREATE TABLE Dim_Surface_Types (
    surface_id INTEGER PRIMARY KEY AUTOINCREMENT,
    surface VARCHAR(100) NOT NULL UNIQUE
);

-- Dim_Airports
CREATE TABLE Dim_Airports (
    airport_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ident VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100),
    type VARCHAR(100) NOT NULL,
    latitude_deg DECIMAL(10,5),
    longitude_deg DECIMAL(10,5),
    elevation_meters DECIMAL(10,2) NOT NULL,
    municipality VARCHAR(100),
    iso_country_id INTEGER,
    iso_region_id INTEGER,
    gps_code VARCHAR(100),
    iata_code VARCHAR(100),
    local_code VARCHAR(100),
    FOREIGN KEY (iso_country_id) REFERENCES Dim_Countries(iso_country_id),
    FOREIGN KEY (iso_region_id) REFERENCES Dim_Regions(iso_region_id)
);

-- Dim_Runways
CREATE TABLE Dim_Runways (
    runway_id INTEGER PRIMARY KEY AUTOINCREMENT,
    airport_ref INTEGER NOT NULL,
    length_meters DECIMAL(10,2) NOT NULL,
    width_meters DECIMAL(10,2) NOT NULL,
    surface_id INTEGER NOT NULL,
    lighted BOOLEAN,
    closed BOOLEAN,
    le_ident VARCHAR(100),
    FOREIGN KEY (airport_ref) REFERENCES Dim_Airports(airport_id),
    FOREIGN KEY (surface_id) REFERENCES Dim_Surface_Types(surface_id)
);

-- Dim_Navaids
CREATE TABLE Dim_Navaids (
    navaid_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ident VARCHAR(100) NOT NULL,
    name VARCHAR(100),
    type VARCHAR(100) NOT NULL,
    frequency_mhz DECIMAL(10,2),
    latitude_deg DECIMAL(10,5),
    longitude_deg DECIMAL(10,5),
    iso_country_id INTEGER,
    power VARCHAR(100),
    magnetic_variation_deg DECIMAL(10,5),
    associated_airport VARCHAR(100),
    FOREIGN KEY (iso_country_id) REFERENCES Dim_Countries(iso_country_id)
);



-- Fact_Airport_Infrastructure
CREATE TABLE Fact_Airport_Infrastructure (
    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    airport_id INTEGER NOT NULL,
    runway_id INTEGER NOT NULL,
    navaid_id INTEGER NOT NULL,
    number_of_runways INTEGER,
    number_of_navaids INTEGER,
    average_navaid_frequency_mhz DECIMAL(10,2),
    elevation_airport_meters DECIMAL(10,2),
    runway_length_meters DECIMAL(10,2),
    runway_width_meters DECIMAL(10,2),
    FOREIGN KEY (airport_id) REFERENCES Dim_Airports(airport_id),
    FOREIGN KEY (runway_id) REFERENCES Dim_Runways(runway_id),
    FOREIGN KEY (navaid_id) REFERENCES Dim_Navaids(navaid_id)
);


-- Creación de índices
CREATE INDEX idx_airports_country ON Dim_Airports(iso_country_id);
CREATE INDEX idx_airports_region ON Dim_Airports(iso_region_id);
CREATE INDEX idx_runways_airport ON Dim_Runways(airport_ref);
CREATE INDEX idx_navaids_country ON Dim_Navaids(iso_country_id);



-- Cargar los datos 
INSERT INTO Dim_Countries (iso_country)
SELECT DISTINCT iso_country 
FROM airports 
WHERE iso_country IS NOT NULL;

-- Actualizar los nombres de los países en Dim_Countries con csv importado country_iso_name
UPDATE Dim_Countries
SET country_name = (
    SELECT Name  -- Nombre del país en la tabla country_iso_name
    FROM country_iso_name
    WHERE country_iso_name.Code = Dim_Countries.iso_country
)
WHERE country_name IS NULL OR country_name = '';


INSERT INTO Dim_Regions (iso_region)
SELECT DISTINCT iso_region 
FROM airports 
WHERE iso_region IS NOT NULL;

-- Actualizar los nombres de los países en Dim_Countries con csv importado region_iso_name
UPDATE Dim_Regions
SET region_name = (
    SELECT subdivision_name  -- Nombre de la región en la tabla region_iso_name
    FROM region_iso_name
    WHERE region_iso_name."subdivision_code_iso3166-2" = Dim_Regions.iso_region
)
WHERE region_name IS NULL OR region_name = '';


INSERT INTO Dim_Surface_Types (surface)
SELECT DISTINCT surface 
FROM runways 
WHERE surface IS NOT NULL;


INSERT INTO Dim_Airports (
    ident, name, type, latitude_deg, longitude_deg, elevation_meters, 
    municipality, iso_country_id, iso_region_id, gps_code, iata_code, local_code
)
SELECT 
    a.ident, a.name, a.type, a.latitude_deg, a.longitude_deg, a.elevation_meters, 
    a.municipality,
    c.iso_country_id, r.iso_region_id,
    a.gps_code, a.iata_code, a.local_code
FROM airports a
LEFT JOIN Dim_Countries c ON a.iso_country = c.iso_country
LEFT JOIN Dim_Regions r ON a.iso_region = r.iso_region;


INSERT INTO Dim_Runways (
    airport_ref, length_meters, width_meters, surface_id, lighted, closed, le_ident
)
SELECT 
    r.airport_ref, r.length_meters, r.width_meters,
    s.surface_id, r.lighted, r.closed, r.le_ident
FROM runways r
LEFT JOIN Dim_Surface_Types s ON r.surface = s.surface;


INSERT INTO Dim_Navaids (
    ident, name, type, frequency_mhz, latitude_deg, longitude_deg,
    iso_country_id, power, magnetic_variation_deg, associated_airport
)
SELECT 
    n.ident, n.name, n.type, n.frequency_mhz, n.latitude_deg, n.longitude_deg,
    c.iso_country_id, n.power, n.magnetic_variation_deg, n.associated_airport
FROM navaids n
LEFT JOIN Dim_Countries c ON n.iso_country = c.iso_country;



INSERT INTO Fact_Airport_Infrastructure (
    airport_id, runway_id, navaid_id, number_of_runways, number_of_navaids,
    average_navaid_frequency_mhz, elevation_airport_meters, 
    runway_length_meters, runway_width_meters
)
SELECT 
    a.airport_id, 
    r.runway_id, 
    n.navaid_id,
    (SELECT COUNT(*) FROM Dim_Runways WHERE airport_ref = a.airport_id) AS number_of_runways,
    (SELECT COUNT(*) FROM Dim_Navaids WHERE associated_airport = a.ident) AS number_of_navaids,
    (SELECT AVG(frequency_mhz) FROM Dim_Navaids WHERE associated_airport = a.ident) AS average_navaid_frequency_mhz,
    a.elevation_meters,
    (SELECT AVG(length_meters) FROM Dim_Runways WHERE airport_ref = a.airport_id) AS runway_length_meters,
    (SELECT AVG(width_meters) FROM Dim_Runways WHERE airport_ref = a.airport_id) AS runway_width_meters
FROM Dim_Airports a
INNER JOIN Dim_Runways r ON a.airport_id = r.airport_ref
INNER JOIN Dim_Navaids n ON a.ident = n.associated_airport;



-- Validación de la carga
-- Dimensiones
SELECT COUNT(*) AS Total_Dim_Countries FROM Dim_Countries;
SELECT COUNT(*) AS Total_Dim_Regions FROM Dim_Regions;
SELECT COUNT(*) AS Total_Dim_Surface_Types FROM Dim_Surface_Types;
SELECT COUNT(*) AS Total_Dim_Airports FROM Dim_Airports;
SELECT COUNT(*) AS Total_Dim_Runways FROM Dim_Runways;
SELECT COUNT(*) AS Total_Dim_Navaids FROM Dim_Navaids;

-- Tabla de hechos
SELECT COUNT(*) AS Total_Fact_Airport_Infrastructure FROM Fact_Airport_Infrastructure;

-- Verificación 1: Relaciones en la tabla de hechos
-- Asegurarse de que no haya IDs de aeropuertos no referenciados
SELECT COUNT(*) AS Invalid_Airport_References
FROM Fact_Airport_Infrastructure f
LEFT JOIN Dim_Airports d ON f.airport_id = d.airport_id
WHERE d.airport_id IS NULL; -- verificación comprobada

-- Verificación 2: Consistencia de Claves en Dim_Airports
-- Confirma que no haya registros duplicados en la clave primaria de Dim_Airports
SELECT COUNT(*) AS Total, COUNT(DISTINCT airport_id) AS Distinct_Count
FROM Dim_Airports;
