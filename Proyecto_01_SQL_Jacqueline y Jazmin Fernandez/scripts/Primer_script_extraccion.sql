
-- primera tabla: airports

CREATE TABLE airports(
id INTEGER,
ident VARCHAR(100),
type VARCHAR(100),
name VARCHAR(100),
latitude_deg DECIMAL(10,5),
longitude_deg DECIMAL(10,5),
elevation_ft INTEGER,
continent VARCHAR(100),
iso_country VARCHAR(100),
iso_region VARCHAR(100),
municipality VARCHAR(100),
scheduled_service TINYINT(1), -- 0 para no, 1 para si
gps_code VARCHAR(100),
iata_code VARCHAR(100),
local_code VARCHAR(100)
);

-- segunda tabla: runways

CREATE TABLE runways(
id INTEGER,
airport_ref INTEGER,
airport_ident VARCHAR(100),
length_ft INTEGER,
width_ft INTEGER,
surface VARCHAR(100),
lighted TINYINT(1),
closed TINYINT(1),
le_ident VARCHAR(100)
);

-- tercera tabla: navaids

CREATE TABLE navaids(
id INTEGER,
filename VARCHAR(100),
ident VARCHAR(100),
name VARCHAR(100),
type VARCHAR(100),
frequency_khz INTEGER,
latitude_deg DECIMAL(10,5),
longitude_deg DECIMAL(10,5),
elevation_ft INTEGER,
iso_country VARCHAR(100),
magnetic_variation_deg DECIMAL(10,5),
usageType VARCHAR(100),
power VARCHAR(100),
associated_airport VARCHAR(100)
);

-- Comprobación de que se importó la misma cantidad de datos
-- por cada una de las tablas

SELECT * FROM airports;

SELECT * FROM navaids;

SELECT * FROM runways;

-- Conteo de los registros de cada tabla / se comprobó que están correctos

SELECT COUNT(*) AS total_airports FROM airports; -- 76.364

SELECT COUNT(*) AS total_runways FROM runways; -- 45.077

SELECT COUNT(*) AS total_navaids FROM navaids; -- 11.020


