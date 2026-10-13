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

