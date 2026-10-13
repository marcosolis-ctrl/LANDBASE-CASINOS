-- QA select-only para business-intelligence-470119.LB_RECARGAS_RAW
-- No crea, modifica ni elimina objetos.
-- Ejecutar cada bloque por separado y exportar los resultados indicados.

-- 01_qa_nulos_llaves.csv
SELECT 'ACCOUNTS_RAW' AS table_name, 'Num_Cliente' AS column_name,
       COUNT(*) AS total_rows,
       COUNTIF(Num_Cliente IS NULL) AS null_rows,
       SAFE_DIVIDE(COUNTIF(Num_Cliente IS NULL), COUNT(*)) AS null_rate
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ACCOUNTS_RAW`
UNION ALL
SELECT 'ARTURITO_RAW', 'Num_Cliente', COUNT(*), COUNTIF(Num_Cliente IS NULL),
       SAFE_DIVIDE(COUNTIF(Num_Cliente IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
UNION ALL
SELECT 'ARTURITO_RAW', 'Operacion_id', COUNT(*), COUNTIF(Operacion_id IS NULL),
       SAFE_DIVIDE(COUNTIF(Operacion_id IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
UNION ALL
SELECT 'CAJA_RAW', 'Cuenta', COUNT(*), COUNTIF(Cuenta IS NULL),
       SAFE_DIVIDE(COUNTIF(Cuenta IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.CAJA_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', 'Num_Cliente', COUNT(*), COUNTIF(Num_Cliente IS NULL),
       SAFE_DIVIDE(COUNTIF(Num_Cliente IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', 'mbm_operation_id', COUNT(*), COUNTIF(mbm_operation_id IS NULL),
       SAFE_DIVIDE(COUNTIF(mbm_operation_id IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', 'mbm_request_id', COUNT(*), COUNTIF(mbm_request_id IS NULL),
       SAFE_DIVIDE(COUNTIF(mbm_request_id IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
UNION ALL
SELECT 'NIVEL_MENSUAL_RAW', 'Num_Cliente', COUNT(*), COUNTIF(Num_Cliente IS NULL),
       SAFE_DIVIDE(COUNTIF(Num_Cliente IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.NIVEL_MENSUAL_RAW`
UNION ALL
SELECT 'TARJETA_FISICA_RAW', 'Num_Cliente', COUNT(*), COUNTIF(Num_Cliente IS NULL),
       SAFE_DIVIDE(COUNTIF(Num_Cliente IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`
UNION ALL
SELECT 'TARJETA_FISICA_RAW', 'Operacion_id', COUNT(*), COUNTIF(Operacion_id IS NULL),
       SAFE_DIVIDE(COUNTIF(Operacion_id IS NULL), COUNT(*))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`;

-- 02_qa_duplicados_operaciones.csv
SELECT 'ARTURITO_RAW' AS table_name, CAST(Operacion_id AS STRING) AS candidate_key,
       COUNT(*) AS rows_same_key
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
WHERE Operacion_id IS NOT NULL
GROUP BY candidate_key
HAVING COUNT(*) > 1
ORDER BY rows_same_key DESC
LIMIT 1000;

SELECT 'TARJETA_FISICA_RAW' AS table_name, CAST(Operacion_id AS STRING) AS candidate_key,
       COUNT(*) AS rows_same_key
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`
WHERE Operacion_id IS NOT NULL
GROUP BY candidate_key
HAVING COUNT(*) > 1
ORDER BY rows_same_key DESC
LIMIT 1000;

SELECT 'NIVEL_MENSUAL_RAW' AS table_name,
       CONCAT(CAST(Year AS STRING), '-', CAST(Month AS STRING), '-', CAST(Num_Cliente AS STRING)) AS candidate_key,
       COUNT(*) AS rows_same_key
FROM `business-intelligence-470119.LB_RECARGAS_RAW.NIVEL_MENSUAL_RAW`
WHERE Year IS NOT NULL AND Month IS NOT NULL AND Num_Cliente IS NOT NULL
GROUP BY candidate_key
HAVING COUNT(*) > 1
ORDER BY rows_same_key DESC
LIMIT 1000;

-- 03_qa_cobertura_fechas.csv
SELECT 'ACCOUNTS_RAW' AS table_name,
       MIN(Fecha_Alta) AS min_fecha_1,
       MAX(Fecha_Alta) AS max_fecha_1,
       COUNTIF(Fecha_Alta IS NULL) AS null_fecha_1,
       CAST(NULL AS TIMESTAMP) AS min_fecha_2,
       CAST(NULL AS TIMESTAMP) AS max_fecha_2,
       0 AS null_fecha_2
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ACCOUNTS_RAW`
UNION ALL
SELECT 'ARTURITO_RAW', MIN(Gameday), MAX(Gameday), COUNTIF(Gameday IS NULL),
       MIN(Fecha), MAX(Fecha), COUNTIF(Fecha IS NULL)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
UNION ALL
SELECT 'CAJA_RAW', MIN(GameDay), MAX(GameDay), COUNTIF(GameDay IS NULL),
       CAST(NULL AS TIMESTAMP), CAST(NULL AS TIMESTAMP), 0
FROM `business-intelligence-470119.LB_RECARGAS_RAW.CAJA_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', MIN(GameDay), MAX(GameDay), COUNTIF(GameDay IS NULL),
       MIN(mbr_time_request), MAX(mbr_time_request), COUNTIF(mbr_time_request IS NULL)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
UNION ALL
SELECT 'TARJETA_FISICA_RAW', MIN(Gameday), MAX(Gameday), COUNTIF(Gameday IS NULL),
       MIN(Fecha), MAX(Fecha), COUNTIF(Fecha IS NULL)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`;

-- 04_qa_periodo_vs_fecha.csv
SELECT 'ARTURITO_RAW' AS table_name,
       COUNT(*) AS total_rows,
       COUNTIF(Gameday IS NOT NULL AND (EXTRACT(YEAR FROM Gameday) != Year OR EXTRACT(MONTH FROM Gameday) != Month)) AS inconsistent_gameday_rows
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
UNION ALL
SELECT 'CAJA_RAW', COUNT(*),
       COUNTIF(GameDay IS NOT NULL AND (EXTRACT(YEAR FROM GameDay) != Year OR EXTRACT(MONTH FROM GameDay) != Month))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.CAJA_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', COUNT(*),
       COUNTIF(GameDay IS NOT NULL AND (EXTRACT(YEAR FROM GameDay) != Year OR EXTRACT(MONTH FROM GameDay) != Month))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
UNION ALL
SELECT 'NIVEL_MENSUAL_RAW', COUNT(*),
       COUNTIF(Year IS NULL OR Month IS NULL OR Month NOT BETWEEN 1 AND 12)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.NIVEL_MENSUAL_RAW`
UNION ALL
SELECT 'TARJETA_FISICA_RAW', COUNT(*),
       COUNTIF(Gameday IS NOT NULL AND (EXTRACT(YEAR FROM Gameday) != Year OR EXTRACT(MONTH FROM Gameday) != Month))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`;

-- 05_qa_montos.csv
SELECT 'ARTURITO_RAW' AS table_name, 'Recarga' AS measure,
       COUNT(*) AS total_rows,
       COUNTIF(Recarga IS NULL) AS null_rows,
       COUNTIF(Recarga = 0) AS zero_rows,
       COUNTIF(Recarga < 0) AS negative_rows,
       MIN(Recarga) AS min_value,
       MAX(Recarga) AS max_value,
       SUM(Recarga) AS total_value
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW`
UNION ALL
SELECT 'TARJETA_FISICA_RAW', 'Recarga', COUNT(*), COUNTIF(Recarga IS NULL), COUNTIF(Recarga = 0),
       COUNTIF(Recarga < 0), MIN(Recarga), MAX(Recarga), SUM(Recarga)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW`
UNION ALL
SELECT 'MOVIBANK_RAW', 'mbm_sub_amount', COUNT(*), COUNTIF(mbm_sub_amount IS NULL), COUNTIF(mbm_sub_amount = 0),
       COUNTIF(mbm_sub_amount < 0), MIN(mbm_sub_amount), MAX(mbm_sub_amount), SUM(mbm_sub_amount)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`;

-- 06_qa_categorias.csv
SELECT 'ACCOUNTS_RAW.Genero' AS field_name, Genero AS value, COUNT(*) AS rows_count
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ACCOUNTS_RAW`
GROUP BY value
UNION ALL
SELECT 'ACCOUNTS_RAW.Nivel_Wigos', Nivel_Wigos, COUNT(*)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ACCOUNTS_RAW`
GROUP BY value
UNION ALL
SELECT 'MOVIBANK_RAW.Tipo', Tipo, COUNT(*)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW`
GROUP BY value
UNION ALL
SELECT 'NIVEL_MENSUAL_RAW.Nivel_Mensual', Nivel_Mensual, COUNT(*)
FROM `business-intelligence-470119.LB_RECARGAS_RAW.NIVEL_MENSUAL_RAW`
GROUP BY value
ORDER BY field_name, rows_count DESC;

-- 07_qa_cobertura_clientes.csv
WITH accounts AS (
  SELECT DISTINCT Num_Cliente
  FROM `business-intelligence-470119.LB_RECARGAS_RAW.ACCOUNTS_RAW`
  WHERE Num_Cliente IS NOT NULL
)
SELECT 'ARTURITO_RAW' AS source_table,
       COUNTIF(s.Num_Cliente IS NOT NULL) AS rows_with_client,
       COUNT(DISTINCT s.Num_Cliente) AS distinct_clients,
       COUNT(DISTINCT IF(a.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL)) AS matched_clients,
       COUNT(DISTINCT IF(a.Num_Cliente IS NULL AND s.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL)) AS unmatched_clients
FROM `business-intelligence-470119.LB_RECARGAS_RAW.ARTURITO_RAW` AS s
LEFT JOIN accounts AS a USING (Num_Cliente)
UNION ALL
SELECT 'MOVIBANK_RAW', COUNTIF(s.Num_Cliente IS NOT NULL), COUNT(DISTINCT s.Num_Cliente),
       COUNT(DISTINCT IF(a.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL)),
       COUNT(DISTINCT IF(a.Num_Cliente IS NULL AND s.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.MOVIBANK_RAW` AS s
LEFT JOIN accounts AS a USING (Num_Cliente)
UNION ALL
SELECT 'NIVEL_MENSUAL_RAW', COUNTIF(s.Num_Cliente IS NOT NULL), COUNT(DISTINCT s.Num_Cliente),
       COUNT(DISTINCT IF(a.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL)),
       COUNT(DISTINCT IF(a.Num_Cliente IS NULL AND s.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.NIVEL_MENSUAL_RAW` AS s
LEFT JOIN accounts AS a USING (Num_Cliente)
UNION ALL
SELECT 'TARJETA_FISICA_RAW', COUNTIF(s.Num_Cliente IS NOT NULL), COUNT(DISTINCT s.Num_Cliente),
       COUNT(DISTINCT IF(a.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL)),
       COUNT(DISTINCT IF(a.Num_Cliente IS NULL AND s.Num_Cliente IS NOT NULL, s.Num_Cliente, NULL))
FROM `business-intelligence-470119.LB_RECARGAS_RAW.TARJETA_FISICA_RAW` AS s
LEFT JOIN accounts AS a USING (Num_Cliente);

