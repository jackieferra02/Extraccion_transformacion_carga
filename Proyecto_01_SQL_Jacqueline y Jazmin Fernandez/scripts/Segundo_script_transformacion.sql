
-- Data quality metrics / métricas de calidad

-- Creación de la tabla temporal para almacenar los resultados de las métricas
CREATE TEMP TABLE metrics_summary (
    table_name VARCHAR(50),
    metric_name VARCHAR(100),
    percentage DECIMAL(5,2),
    description TEXT
);


-- Evaluación de las métricas para la tabla airports

-- 1. Completitud de todas las columnas
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Overall Completeness' AS metric_name,
    (SUM(CASE WHEN ident IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN type IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN name IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN latitude_deg IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN longitude_deg IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN elevation_ft IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN continent IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN iso_country IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN iso_region IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN municipality IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN scheduled_service IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN gps_code IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN iata_code IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN local_code IS NOT NULL THEN 1 ELSE 0 END)) * 100.0 / (COUNT(*) * 14) AS percentage,
    'Porcentaje de registros con todos los campos relevantes completos'
FROM airports;

-- 2. Precisión de latitude_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Latitude Precision' AS metric_name,
    (SUM(CASE WHEN latitude_deg BETWEEN -90 AND 90 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de latitudes dentro del rango válido'
FROM airports;

-- 3. Precisión de longitude_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Longitude Precision' AS metric_name,
    (SUM(CASE WHEN longitude_deg BETWEEN -180 AND 180 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de longitudes dentro del rango válido'
FROM airports;

-- 4. Identificabilidad
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Identificability' AS metric_name,
    (COUNT(DISTINCT id) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de registros únicos por ID'
FROM airports;

-- 5. Semántica de type
INSERT INTO metrics_summary (table_name, metric_name, percentage , description)
SELECT 
    'Airports' AS table_name,
    'Type Semantics' AS metric_name,
    (SUM(CASE WHEN type IN ('large_airport', 'small_airport', 'heliport') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de tipos válidos'
FROM airports;

-- 6. Estructura de ident
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Ident Structure' AS metric_name,
    (SUM(CASE WHEN LENGTH(ident) <= 100 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de longitud de ident válida'
FROM airports;

-- 7. Linaje (no se puede evaluar sin información adicional sobre la fuente de datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Airports', 'Data Lineage', NULL, 'No se puede evaluar sin información sobre la fuente de datos y su historial de cambios.');

 -- 8. Moneda
-- La tabla 'airports' no contiene la columna 'last_updated', por lo que no es posible calcular 
-- el porcentaje de registros actualizados en el último año. Esta métrica se omite debido a la 
-- ausencia de un campo que registre la última actualización de los datos.

-- 9. Puntualidad (no se puede evaluar sin información sobre el tiempo de acceso a los datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Airports', 'Timeliness', NULL, 'No se puede evaluar sin información sobre el tiempo de acceso a los datos.');

-- 10. Razonabilidad de latitude_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Latitude Reasonability' AS metric_name,
    (SUM(CASE WHEN latitude_deg IS NOT NULL AND latitude_deg BETWEEN -90 AND 90 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de latitudes razonables'
FROM airports;

-- 11. Razonabilidad de longitude_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Airports' AS table_name,
    'Longitude Reasonability' AS metric_name,
    (SUM(CASE WHEN longitude_deg IS NOT NULL AND longitude_deg BETWEEN -180 AND 180 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de longitudes razonables'
FROM airports;


-- Evaluación de las métricas para la tabla runways

-- 1. Completitud de todas las columnas
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Runways' AS table_name,
    'Overall Completeness' AS metric_name,
    (SUM(CASE WHEN airport_ref IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN airport_ident IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN length_ft IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN width_ft IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN surface IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN lighted IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN closed IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN le_ident IS NOT NULL THEN 1 ELSE 0 END)) * 100.0 / (COUNT(*) * 8) AS percentage,
    'Porcentaje de registros con todos los campos relevantes completos'
FROM runways;

-- 2. Precisión de length_ft
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Runways' AS table_name,
    'Length Precision' AS metric_name,
    (SUM(CASE WHEN length_ft > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de longitudes válidas'
FROM runways;

-- 3. Identificabilidad
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
 SELECT 
    'Runways' AS table_name,
    'Identificability' AS metric_name,
    (COUNT(DISTINCT id) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de registros únicos por ID'
FROM runways;

-- 4. Semántica de surface
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Runways' AS table_name,
    'Surface Semantics' AS metric_name,
    (SUM(CASE WHEN surface IN ('asphalt', 'concrete', 'grass', 'dirt') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de superficies válidas'
FROM runways;

-- 5. Estructura de airport_ref
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Runways' AS table_name,
    'Airport Ref Structure' AS metric_name,
    (SUM(CASE WHEN airport_ref IS NOT NULL AND airport_ref > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de referencias de aeropuerto válidas'
FROM runways;

-- 6. Linaje (no se puede evaluar sin información adicional sobre la fuente de datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Runways', 'Data Lineage', NULL, 'No se puede evaluar sin información sobre la fuente de datos y su historial de cambios.');

-- 7. Moneda
-- La tabla 'runways' no contiene la columna 'last_updated', por lo que no es posible calcular 
-- el porcentaje de registros actualizados en el último año. Esta métrica se omite debido a la 
-- ausencia de un campo que registre la última actualización de los datos.

-- 8. Puntualidad (no se puede evaluar sin información sobre el tiempo de acceso a los datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Runways', 'Timeliness', NULL, 'No se puede evaluar sin información sobre el tiempo de acceso a los datos.');

-- 9. Razonabilidad de length_ft
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Runways' AS table_name,
    'Length Reasonability' AS metric_name,
    (SUM(CASE WHEN length_ft IS NOT NULL AND length_ft > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de longitudes razonables'
FROM runways;


-- Evaluación de las métricas para la tabla navaids

-- 1. Completitud de todas las columnas
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Overall Completeness' AS metric_name,
    (SUM(CASE WHEN filename IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN ident IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN name IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN type IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN frequency_khz IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN latitude_deg IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN longitude_deg IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN elevation_ft IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN iso_country IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN magnetic_variation_deg IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN usageType IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN power IS NOT NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN associated_airport IS NOT NULL THEN 1 ELSE 0 END)) * 100.0 / (COUNT(*) * 13) AS percentage,
    'Porcentaje de registros con todos los campos relevantes completos'
FROM navaids;

-- 2. Identificabilidad
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Identificability' AS metric_name,
    (COUNT(DISTINCT id) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de registros únicos por ID'
FROM navaids;

-- 3. Precisión de frequency_khz
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Frequency Precision' AS metric_name,
    (SUM(CASE WHEN frequency_khz > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de frecuencias válidas'
FROM navaids;

-- 4. Semántica de type
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Type Semantics' AS metric_name,
    (SUM(CASE WHEN type IN ('VOR', 'NDB', 'ILS', 'GPS') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de tipos válidos'
FROM navaids;

-- 5. Estructura de latitude_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Latitude Structure' AS metric_name,
    (SUM(CASE WHEN latitude_deg IS NOT NULL AND latitude_deg BETWEEN -90 AND 90 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de latitudes estructuralmente correctas'
FROM navaids;

-- 6. Linaje (no se puede evaluar sin información adicional sobre la fuente de datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Navaids', 'Data Lineage', NULL, 'No se puede evaluar sin información sobre la fuente de datos y su historial de cambios.');
   
-- 7. Moneda
-- La tabla 'navaids' no contiene la columna 'last_updated', por lo que no es posible calcular 
-- el porcentaje de registros actualizados en el último año. Esta métrica se omite debido a la 
-- ausencia de un campo que registre la última actualización de los datos.

-- 8. Puntualidad (no se puede evaluar sin información sobre el tiempo de acceso a los datos)
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
VALUES 
    ('Navaids', 'Timeliness', NULL, 'No se puede evaluar sin información sobre el tiempo de acceso a los datos.');

-- 9. Razonabilidad de magnetic_variation_deg
INSERT INTO metrics_summary (table_name, metric_name, percentage, description)
SELECT 
    'Navaids' AS table_name,
    'Magnetic Variation Reasonability' AS metric_name,
    (SUM(CASE WHEN magnetic_variation_deg IS NOT NULL AND magnetic_variation_deg BETWEEN -180 AND 180 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage,
    'Porcentaje de variaciones magnéticas razonables'
FROM navaids;


-- Finalmente, consulta de la tabla de métricas para ver los resultados
SELECT * FROM metrics_summary;



-- Cálculo de las métricas globales
CREATE TEMP TABLE global_metrics_summary AS
SELECT 
    'Global' AS table_name,
    'Overall Completeness' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de completitud en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name = 'Overall Completeness'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Identificability' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de identificabilidad en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name = 'Identificability'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Precision' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de precisión en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name LIKE '%Precision%'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Semantics' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de semántica en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name LIKE '%Semantics%'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Structure' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de estructura en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name LIKE '%Structure%'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Timeliness' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de puntualidad en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name = 'Timeliness'

UNION ALL

SELECT 
    'Global' AS table_name,
    'Overall Reasonability' AS metric_name,
    (SUM(percentage) / COUNT(*)) AS percentage,
    'Porcentaje promedio de razonabilidad en todas las tablas' AS description
FROM metrics_summary
WHERE metric_name LIKE '%Reasonability%';


-- Consulta final para ver las métricas globales
SELECT * FROM global_metrics_summary;



-- Limpieza de datos / Data cleansing

-- Limpieza de Datos para airports, runways y navaids

-- Valores únicos válidos definidos
-- Tipos de aeropuertos: 'heliport', 'small_airport', 'closed', 'seaplane_base', 'balloonport', 'medium_airport', 'large_airport'
-- Tipos de ayudas a la navegación: 'NDB', 'DME', 'NDB-DME', 'VOR-DME', 'TACAN', 'VORTAC', 'VOR'

BEGIN TRANSACTION;

-- Renombrar columnas para reflejar unidades en metros
-- Para airports
ALTER TABLE airports 
RENAME COLUMN elevation_ft TO elevation_meters;

-- Para runways
ALTER TABLE runways 
RENAME COLUMN length_ft TO length_meters;

ALTER TABLE runways 
RENAME COLUMN width_ft TO width_meters;

-- Para navaids
ALTER TABLE navaids
RENAME COLUMN elevation_ft TO elevation_meters;

ALTER TABLE navaids
RENAME COLUMN frequency_khz TO frequency_mhz;

-- Limpieza de la tabla airports
-- 1. Imputación de valores nulos en coordenadas
UPDATE airports
SET 
    latitude_deg = COALESCE(latitude_deg, (SELECT AVG(latitude_deg) FROM airports WHERE latitude_deg IS NOT NULL)),
    longitude_deg = COALESCE(longitude_deg, (SELECT AVG(longitude_deg) FROM airports WHERE longitude_deg IS NOT NULL));

-- 2. Imputación de valores nulos en elevación (metros)
UPDATE airports
SET elevation_meters = ROUND(COALESCE(elevation_meters, (
    SELECT AVG(elevation_meters) 
    FROM airports 
    WHERE elevation_meters IS NOT NULL
)) * 0.3048, 2);

-- 3. Imputación de valores nulos en servicio programado
UPDATE airports
SET scheduled_service = COALESCE(scheduled_service, (
    SELECT scheduled_service 
    FROM (
        SELECT scheduled_service, COUNT(*) as frecuencia 
        FROM airports 
        WHERE scheduled_service IS NOT NULL 
        GROUP BY scheduled_service 
        ORDER BY frecuencia DESC 
        LIMIT 1
    )
));

-- 4. Normalización de valores en el campo de tipo
UPDATE airports
SET type = LOWER(TRIM(type)) 
WHERE LOWER(type) IN (
    'heliport', 'small_airport', 'closed', 'seaplane_base', 
    'balloonport', 'medium_airport', 'large_airport'
);

-- 5. Limpieza de campos de texto
UPDATE airports
SET 
    continent = NULLIF(TRIM(continent), ''),
    iso_country = NULLIF(TRIM(iso_country), ''),
    iso_region = NULLIF(TRIM(iso_region), ''),
    municipality = NULLIF(TRIM(municipality), ''),
    gps_code = NULLIF(TRIM(gps_code), ''),
    iata_code = NULLIF(TRIM(iata_code), ''),
    local_code = NULLIF(TRIM(local_code), '');

-- 6. Eliminación de columnas innecesarias

ALTER TABLE airports DROP COLUMN Column16;
ALTER TABLE airports DROP COLUMN Column17;
ALTER TABLE airports DROP COLUMN Column18;


-- Limpieza de la tabla runways
-- 1. Imputación de valores nulos en longitud y ancho (metros)
UPDATE runways
SET 
    length_meters = ROUND(COALESCE(length_meters, (
        SELECT AVG(length_meters) 
        FROM runways 
        WHERE length_meters IS NOT NULL
    )) * 0.3048, 2),
    width_meters = ROUND(COALESCE(width_meters, (
        SELECT AVG(width_meters) 
        FROM runways 
        WHERE width_meters IS NOT NULL
    )) * 0.3048, 2);

-- 2. Imputación de valores nulos en iluminación y estado
UPDATE runways
SET 
    lighted = COALESCE(lighted, (
        SELECT lighted 
        FROM (
            SELECT lighted, COUNT(*) as frecuencia 
            FROM runways 
            WHERE lighted IS NOT NULL 
            GROUP BY lighted 
            ORDER BY frecuencia DESC 
            LIMIT 1
        )
    )),
    closed = COALESCE(closed, (
        SELECT closed 
        FROM (
            SELECT closed, COUNT(*) as frecuencia 
            FROM runways 
            WHERE closed IS NOT NULL 
            GROUP BY closed 
            ORDER BY frecuencia DESC 
            LIMIT 1
        )
    ));

-- 3. Normalización exhaustiva de superficies de pistas
CREATE TEMP TABLE superficie_normalizada AS
SELECT 
    LOWER(TRIM(surface)) AS superficie_normalizada,
    COUNT(*) AS frecuencia
FROM runways
GROUP BY superficie_normalizada
ORDER BY frecuencia DESC;

-- Actualización de superficies
UPDATE runways
SET surface = CASE
    WHEN surface IS NULL OR surface = '' THEN 'unknown'
    ELSE (
        SELECT superficie_normalizada 
        FROM superficie_normalizada 
        WHERE superficie_normalizada = LOWER(TRIM(runways.surface))
        LIMIT 1
    )
END;


-- Limpieza de la tabla navaids
-- 1. Conversión de frecuencia de KHz a MHz
UPDATE navaids
SET frequency_mhz = COALESCE(frequency_mhz, (
    SELECT AVG(frequency_mhz) 
    FROM navaids 
    WHERE frequency_mhz IS NOT NULL
)) / 1000.0;

-- 2. Imputación de valores nulos en elevación (metros)
UPDATE navaids
SET elevation_meters = ROUND(COALESCE(elevation_meters, (
    SELECT AVG(elevation_meters) 
    FROM navaids 
    WHERE elevation_meters IS NOT NULL
)) * 0.3048, 2);

-- 3. Normalización de tipos de ayudas a la navegación
UPDATE navaids
SET type = LOWER(TRIM(type))
WHERE LOWER(type) IN (
    'ndb', 'dme', 'ndb-dme', 'vor-dme', 
    'tacan', 'vortac', 'vor'
);

-- 4. Limpieza de campos de texto en ayudas a la navegación
UPDATE navaids
SET 
    iso_country = NULLIF(TRIM(iso_country), ''),
    usageType = NULLIF(TRIM(usageType), ''),
    power = NULLIF(TRIM(power), ''),
    associated_airport = NULLIF(TRIM(associated_airport), '');

-- 5. Gestión de variación magnética
UPDATE navaids
SET magnetic_variation_deg = COALESCE(magnetic_variation_deg, 0);

-- Verificación final de cambios
SELECT 
    'Aeropuertos' AS tabla,
    COUNT(*) AS total_registros,
    (SELECT COUNT(*) FROM airports WHERE type IS NULL) AS registros_sin_tipo
FROM airports

UNION ALL

SELECT 
    'Pistas' AS tabla,
    COUNT(*) AS total_registros,
    (SELECT COUNT(*) FROM runways WHERE surface IS NULL) AS registros_sin_superficie
FROM runways

UNION ALL

SELECT 
    'Ayudas a la Navegación' AS tabla,
    COUNT(*) AS total_registros,
    (SELECT COUNT(*) FROM navaids WHERE type IS NULL) AS registros_sin_tipo
FROM navaids;

COMMIT;




-- Verificación de integridad de datos después de limpieza

-- 1. Resumen de cambios en airports
SELECT 
    'Airports' AS tabla,
    (SELECT COUNT(*) FROM airports) AS total_registros,
    (SELECT COUNT(*) FROM airports WHERE type IS NULL OR type = '') AS registros_sin_tipo,
    (SELECT COUNT(*) FROM airports WHERE elevation_meters IS NULL) AS registros_sin_elevacion,
    (SELECT COUNT(DISTINCT type) FROM airports) AS tipos_unicos,
    (SELECT COUNT(*) FROM airports WHERE latitude_deg IS NULL) AS coordenadas_nulas;

-- 2. Resumen de cambios en runways
SELECT 
    'Runways' AS tabla,
    (SELECT COUNT(*) FROM runways) AS total_registros,
    (SELECT COUNT(*) FROM runways WHERE surface IS NULL OR surface = '') AS registros_sin_superficie,
    (SELECT COUNT(*) FROM runways WHERE length_meters IS NULL) AS longitudes_nulas,
    (SELECT COUNT(DISTINCT surface) FROM runways) AS superficies_unicas,
    (SELECT MIN(length_meters) FROM runways) AS longitud_minima,
    (SELECT MAX(length_meters) FROM runways) AS longitud_maxima;
   
 -- Inspeccionar superficies
SELECT surface, COUNT(*) as count
FROM runways
GROUP BY surface
ORDER BY count DESC
LIMIT 20;

-- 3. Resumen de cambios en navaids
SELECT 
    'Navaids' AS tabla,
    (SELECT COUNT(*) FROM navaids) AS total_registros,
    (SELECT COUNT(*) FROM navaids WHERE type IS NULL OR type = '') AS registros_sin_tipo,
    (SELECT COUNT(*) FROM navaids WHERE elevation_meters IS NULL) AS registros_sin_elevacion,
    (SELECT COUNT(DISTINCT type) FROM navaids) AS tipos_unicos,
    (SELECT MIN(frequency_mhz) FROM navaids) AS frecuencia_minima,
    (SELECT MAX(frequency_mhz) FROM navaids) AS frecuencia_maxima;

-- 4. Verificar columnas eliminadas
PRAGMA table_info(airports);
-- ya no están las columnas extrañas 15, 16 y 17 / se eliminaron correctamente

-- 5. Distribución de tipos de aeropuertos
SELECT 
    type, 
    COUNT(*) AS cantidad 
FROM airports 
GROUP BY type 
ORDER BY cantidad DESC;

-- 6. Distribución de superficies de pistas
SELECT 
    surface, 
    COUNT(*) AS cantidad 
FROM runways 
GROUP BY surface 
ORDER BY cantidad DESC;
-- normalización con escritura en minúscula

-- 7. Distribución de tipos de ayudas a la navegación
SELECT 
    type, 
    COUNT(*) AS cantidad 
FROM navaids 
GROUP BY type 
ORDER BY cantidad DESC;
-- normalización con escritura en minúscula
