# Dataset `LB_RECARGAS_RAW`

## Identificacion

| Campo | Valor |
| --- | --- |
| Proyecto | `business-intelligence-470119` |
| Dataset | `LB_RECARGAS_RAW` |
| Tipo de evidencia | Captura de catalogo en BigQuery |
| Estado | Inventario inicial; pendiente de validacion fisica |
| Expiration time visible | `None` para las tablas mostradas |
| Label visible | `None` para las tablas mostradas |

## Tablas visibles

| Tabla | Tipo | Create time visible |
| --- | --- | --- |
| `ACCOUNTS_RAW` | Table | 2026-10-06 18:12:00 UTC-6 |
| `ARTURITO_RAW` | Table | 2026-10-06 19:17:09 UTC-6 |
| `CAJA_RAW` | Table | 2026-10-06 18:32:47 UTC-6 |
| `MOVIBANK_RAW` | Table | 2026-10-06 19:12:24 UTC-6 |
| `NIVEL_MENSUAL_RAW` | Table | 2026-10-06 18:38:01 UTC-6 |
| `TARJETA_FISICA_RAW` | Table | 2026-10-06 19:15:57 UTC-6 |

## Schema confirmado por `INFORMATION_SCHEMA.COLUMNS`

Todas las columnas aparecen como anulables (`is_nullable=YES`).

| Tabla | Columnas en orden | Tipos visibles |
| --- | --- | --- |
| `ACCOUNTS_RAW` | `Num_Cliente`, `Titular`, `Genero`, `Edad`, `Sala_Alta`, `Fecha_Alta`, `Nivel_Wigos` | INT64, STRING, STRING, INT64, STRING, TIMESTAMP, STRING |
| `ARTURITO_RAW` | `Year`, `Month`, `Gameday`, `Sala`, `Fecha`, `Banco_Movil`, `Recarga`, `Terminal`, `Num_Cliente`, `Operacion_id` | INT64, INT64, TIMESTAMP, STRING, TIMESTAMP, STRING, FLOAT64, STRING, INT64, INT64 |
| `CAJA_RAW` | `Year`, `Month`, `GameDay`, `Sala`, `Cuenta`, `Caja_Monto`, `Caja_Cuenta`, `TC_Monto`, `TC_Cuenta`, `TD_Monto`, `TD_Cuenta`, `App_Monto`, `App_Cuenta`, `Efectivo_Monto`, `Efectivo_Cuenta` | INT64, INT64, TIMESTAMP, STRING, INT64, FLOAT64, INT64, FLOAT64, INT64, FLOAT64, INT64, FLOAT64, INT64, FLOAT64, INT64 |
| `MOVIBANK_RAW` | `Year`, `Month`, `GameDay`, `Sala`, `Num_Cliente`, `mbr_time_request`, `mbr_finished_time_request`, `Segundos`, `mbr_status_id`, `mbrs_name`, `mbm_sub_amount`, `mbr_bank_transaction_type`, `Tipo`, `mbm_mb_id`, `mbr_terminal_id`, `mbm_terminal_name`, `mbm_request_id`, `mb_holder_name`, `mbm_operation_id` | INT64, INT64, TIMESTAMP, STRING, INT64, TIMESTAMP, TIMESTAMP, INT64, INT64, STRING, FLOAT64, INT64, STRING, INT64, INT64, STRING, INT64, STRING, INT64 |
| `NIVEL_MENSUAL_RAW` | `Year`, `Month`, `Num_Cliente`, `Nivel_Mensual` | INT64, INT64, INT64, STRING |
| `TARJETA_FISICA_RAW` | `Year`, `Month`, `Gameday`, `Sala`, `Fecha`, `Banco_Movil`, `Recarga`, `Terminal`, `Num_Cliente`, `Operacion_id` | INT64, INT64, TIMESTAMP, STRING, TIMESTAMP, STRING, FLOAT64, STRING, INT64, INT64 |

## Metadata y cobertura observada

| Tabla | Filas | Tamano MB | Ultima modificacion visible |
| --- | ---: | ---: | --- |
| `ACCOUNTS_RAW` | 876,011 | 66.68 | 2026-10-13 15:32:27 UTC |
| `ARTURITO_RAW` | 189,992 | 20.18 | 2026-10-13 01:05:29 UTC |
| `CAJA_RAW` | 1,657,430 | 195.31 | 2026-10-13 15:33:29 UTC |
| `MOVIBANK_RAW` | 13,519,454 | 2,178.49 | 2026-10-13 01:07:54 UTC |
| `NIVEL_MENSUAL_RAW` | 320,483 | 9.79 | 2026-10-07 00:38:01 UTC |
| `TARJETA_FISICA_RAW` | 3,138,522 | 313.57 | 2026-10-13 01:06:35 UTC |
| **Total visible** | **19,701,892** | **2,784.02** | — |

El resultado de `INFORMATION_SCHEMA.PARTITIONS` muestra `partition_id` vacio para las seis tablas. Esto es evidencia de que no se observan particiones declaradas en ese resultado; debe conservarse la verificacion antes de concluir que ninguna tiene otra estrategia fisica.

## Muestra recibida

Se recibieron 10 filas por tabla, 60 filas en total, devueltas como JSON. La consulta uso `LIMIT 10` sin `ORDER BY`, por lo que la muestra es direccional y no aleatoria ni representativa.

Observaciones iniciales:

- `ACCOUNTS_RAW` contiene atributos de cliente y alta: `Num_Cliente`, `Titular`, `Genero`, `Edad`, `Sala_Alta`, `Fecha_Alta` y `Nivel_Wigos`.
- `ARTURITO_RAW` y `TARJETA_FISICA_RAW` comparten una estructura de recarga con `Sala`, `Fecha`, `Banco_Movil`, `Recarga`, `Terminal`, `Num_Cliente` y `Operacion_id`.
- `MOVIBANK_RAW` contiene eventos/solicitudes de banco movil, estados, tiempos, terminales y posibles identificadores de operacion.
- `CAJA_RAW` contiene importes y conteos por categoria (`Caja`, `TC`, `TD`, `App`, `Efectivo`) junto con `Cuenta`, sala y dia de juego.
- `NIVEL_MENSUAL_RAW` contiene una aparente asignacion mensual de nivel por `Num_Cliente`.

## Relaciones candidatas, pendientes de prueba

| Relacion candidata | Evidencia | No confirmado |
| --- | --- | --- |
| `Num_Cliente` entre `ACCOUNTS_RAW`, `ARTURITO_RAW`, `MOVIBANK_RAW`, `NIVEL_MENSUAL_RAW` y `TARJETA_FISICA_RAW` | El campo existe en las cinco tablas | Unicidad, cobertura, vigencia y si representa la misma entidad |
| `Operacion_id` entre `ARTURITO_RAW` y `TARJETA_FISICA_RAW` | El campo existe con el mismo nombre y tipo | Que sea una llave global y no solo local a cada origen |
| `mbm_operation_id` con `Operacion_id` | Ambos parecen identificadores de operacion y son INT64 | Correspondencia real, nullabilidad efectiva y cardinalidad |
| `Year` + `Month` + `Num_Cliente` en `NIVEL_MENSUAL_RAW` | La estructura contiene periodo mensual y cliente | Unicidad del nivel mensual y regla de cierre |

## QA pendiente

- Nulos por columna y por tabla.
- Duplicados de `Num_Cliente`, `Operacion_id` y combinaciones de periodo/sala.
- Cobertura mínima y máxima de `Gameday`, `GameDay`, `Fecha`, `Fecha_Alta` y timestamps de Movibank.
- Valores negativos, ceros y distribución de `Recarga`, importes de caja y `mbm_sub_amount`.
- Coherencia entre `Year`/`Month` y las fechas timestamp.
- Valores distintos de `Tipo`, `Genero`, `Nivel_Wigos`, `Nivel_Mensual` y estados.
- Cruces de cobertura entre clientes, recargas, banco movil, niveles y tarjeta fisica.

## Resultados QA recibidos

| Control | Resultado observado | Interpretacion provisional |
| --- | --- | --- |
| Nulos en llaves candidatas | No hubo nulos en las columnas revisadas, excepto `MOVIBANK_RAW.mbm_request_id` y `MOVIBANK_RAW.mbm_operation_id`: 1,694,882 de 13,519,454 filas, 12.5366% | La nulidad puede ser valida para solicitudes sin operacion final, pero requiere regla de negocio |
| Cobertura de `Num_Cliente` contra `ACCOUNTS_RAW` | `ARTURITO_RAW`, `NIVEL_MENSUAL_RAW` y `TARJETA_FISICA_RAW`: 0 clientes no encontrados. `MOVIBANK_RAW`: 2 clientes no encontrados de 172,774 distintos | Cobertura alta; investigar los 2 casos antes de declarar integridad total |
| Consistencia de periodo | 0 inconsistencias entre `Year`/`Month` y `Gameday`/`GameDay` en las 5 tablas revisadas | Resultado favorable para esta regla, sujeto a que la conversion UTC sea la esperada |
| `Recarga` en ARTURITO y tarjeta fisica | Sin nulos, ceros ni negativos. Minimo 50 y maximo 10,000 | Valores dentro de rango observado; falta validar limites de negocio |
| `mbm_sub_amount` en Movibank | 1,694,882 nulos; sin ceros ni negativos entre los valores informados. Minimo 50 y maximo 10,000 | Nulidad alineada en conteo con los identificadores Movibank; requiere entender estados |
| Duplicados de `ARTURITO_RAW.Operacion_id` | 105 claves repetidas; todas con 2 filas en el resultado recibido | `Operacion_id` no es llave unica en este snapshot |
| Duplicados de `TARJETA_FISICA_RAW.Operacion_id` | El resultado estaba limitado a 1,000 claves repetidas: 955 con 2 filas y 45 con 3 filas | Hay al menos 1,000 claves repetidas; se requiere una consulta sin `LIMIT` para cuantificar todo el universo |

Estos resultados son evidencia de calidad del snapshot recibido, no una aprobación del modelo. La regla de grano y la decisión de deduplicacion siguen abiertas.

## Dependencias y uso

El nombre del dataset lo ubica en el dominio de recargas de LANDBASE. La captura por si sola no demuestra las dependencias upstream/downstream, el proceso de carga, la periodicidad ni el uso en el modelo `4. Recargas`.

## Pendiente de documentar

- Schema completo y tipos de datos por tabla.
- Grano de cada tabla y llaves primarias o de negocio.
- Particionamiento, clustering y cobertura temporal.
- Fuente upstream, proceso de carga y frecuencia.
- Reglas de deduplicacion y tratamiento de historicos.
- Relaciones entre `ACCOUNTS_RAW`, `CAJA_RAW`, `MOVIBANK_RAW`, `TARJETA_FISICA_RAW`, `ARTURITO_RAW` y `NIVEL_MENSUAL_RAW`.
- Conteos, nulos, duplicados, fechas min/max y freshness.
- Tablas o modelos downstream que consumen este dataset.

## Fuente

Captura de pantalla proporcionada en la conversacion, con la vista de BigQuery del dataset `LB_RECARGAS_RAW`. La captura es evidencia de inventario, no reemplaza el schema ni una validacion de datos ejecutada.

