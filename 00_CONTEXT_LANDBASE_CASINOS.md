---
name: context-landbase-casinos
description: "Contexto inicial del mapeo de fuentes, dependencias y modelos BI de LANDBASE CASINOS."
---

# LANDBASE CASINOS — contexto inicial

- **Cobertura y autoridad:** Primer inventario visual del archivo suministrado `C:\Users\marco.solis\Downloads\Mapeo_BI_Exportable.html`. El archivo contiene 7 modelos y 4 diagramas generales con dependencias entre conexiones TI, sistemas/fuentes, tablas transaccionales y catálogos, reportes TI, agrupaciones BI y modelos BI.
- **Estado de evidencia:** **Directional**. Se verificó visualmente el linaje y los nombres mostrados en los diagramas el 2026-10-13. El mapeo no permite confirmar por sí solo schema, grano físico, llaves, filtros, periodicidad, cifras ni reglas de negocio.
- **Regla de uso:** Este documento conserva contexto de arquitectura y dependencias. No debe tratarse como validación de ejecución ni como diccionario físico hasta revisar schemas, SQL/procesos y muestras.

## Entities

| Entidad / área | Qué representa en el mapeo | Identificador o grano | Fuente / dependencia visible |
| --- | --- | --- | --- |
| Wigos | Núcleo operativo de casinos/salas y punto de entrada a múltiples tablas y reportes | No verificable en el diagrama | Conexión Alestra → Wigos |
| Sesiones de juego | Reporte TI de actividad de juego; alimenta clientes de máquinas e indicadores | No verificable | Play Sessions, Accounts, Terminals y catálogos relacionados |
| Sesiones juego mesas | Reporte TI de actividad de mesas; alimenta clientes de mesas | No verificable | Accounts, GT Play Sessions, Gaming Tables Types, GuiUsers, Gt Seats y Gaming Tables |
| Recargas | Agrupación BI de recargas | No verificable | Recargas app, Movimientos caja, Banco móvil y fuentes de cuentas |
| Dataset `LB_RECARGAS_RAW` | Dataset RAW de BigQuery para el dominio de recargas | No verificable | `business-intelligence-470119.LB_RECARGAS_RAW`; snapshot con 6 tablas visibles |
| Clientes Máquinas | Agrupación BI de clientes asociados a máquinas | No verificable | Sesiones de juego |
| Clientes Mesas | Agrupación BI de clientes asociados a mesas | No verificable | Sesiones juego mesas y Movimientos de cuenta mesas |
| Indicadores LB | Agrupación BI intermedia para indicadores de LANDBASE | No verificable | Clientes Máquinas, Clientes Mesas, Recargas y otros flujos del diagrama |
| Carteras | Modelo BI de carteras de máquinas y mesas | No verificable | Wigos, Salesforce y Excel; el modelo indica 10 hojas |
| Recargas | Modelo BI específico de recargas | No verificable | Wigos y Excel; el modelo indica 7 hojas |
| Mesas | Modelo BI de operación de mesas | No verificable | Wigos y Excel; el modelo indica 27 hojas |
| Alimentos y Bebidas | Modelo BI de ingresos/consumos de A y B | No verificable | Simphony; el modelo indica 12 hojas |
| Tablero Comercial | Modelo BI comercial consolidado | No verificable | Wigos, Simphony, LOS, SAP, Excel y agrupaciones; el modelo indica 21 hojas |
| Clientes | Modelo BI relacionado con clientes | No verificable | Wigos y Excel; el modelo indica 10 hojas |
| Flash | Modelo BI ejecutivo de operación | No verificable | Wigos, Simphony, LOS, Salesforce y Excel |
| Online | Modelo BI de Calimaco/Optimove/Ingenious | No verificable | Calimaco, Optimove, Optimove-Calimaco e Ingenious |

## Metrics

| Métrica o salida | Evidencia visible | Definición / población | Fuente o caveat |
| --- | --- | --- | --- |
| Indicadores LB | Existe una agrupación BI con ese nombre | No definida en el mapeo | Requiere catálogo de métricas y SQL |
| Indicadores Flash | Existe una agrupación BI con ese nombre | No definida en el mapeo | Requiere catálogo de métricas y SQL |
| Recargas por hora | Agrupación BI visible en el modelo de Recargas | No definida en el mapeo | Requiere timestamp, zona horaria y grano |
| Puntos a la fecha | Agrupación BI visible en Clientes | No definida en el mapeo | Requiere regla de corte y fecha de referencia |
| Presupuestos diarios | Agrupación BI visible en varios modelos | No definida en el mapeo | Requiere fuente, periodicidad y tratamiento de parciales |
| Nivel cierre mes | Agrupación BI visible | No definida en el mapeo | Requiere calendario y regla de cierre |

## Filters

| Filtro | Regla y alcance | Excepciones | Fuente |
| --- | --- | --- | --- |
| Estado visual del mapeo | Las cajas verdes con marca aparecen como objetos incluidos/identificados en el diagrama | No se interpreta automáticamente como aprobado, activo o ejecutado | HTML suministrado |
| Hojas de modelo | Algunos modelos muestran el número de hojas: Clientes 10, Carteras 10, Recargas 7, Mesas 27, A y B 12, Tablero Comercial 21 | El HTML no explica si son hojas actuales, planeadas o históricas | HTML suministrado |

## Dimensions

| Dimensión | Valores o áreas visibles | Aplica a | Fuente |
| --- | --- | --- | --- |
| Capa de linaje | Conexión, Sistemas/Fuentes, Tablas transaccionales y catálogos, Reportes, Agrupaciones, Modelo | Todo el mapa | Estructura visual del HTML |
| Sistema / conexión | Alestra, Drive | Flujos operativos y archivos | Diagramas generales y modelos 1–7 |
| Plataforma o sistema origen | Wigos, Simphony, LOS, SAP, Salesforce, Calimaco, Optimove, Optimove-Calimaco, Ingenious, Workday, Kronos | Según el modelo | Diagramas suministrados |
| Dominio operativo | Máquinas, mesas, recargas, alimentos y bebidas, comercial, capital humano, finanzas, cadena de suministro, promociones/CRM, Online | Según modelo | Diagramas suministrados |
| Dataset de recargas RAW | `LB_RECARGAS_RAW` | Inventario de recargas | Captura de BigQuery suministrada |

## Pitfalls

| Riesgo | Qué hacer | Evidencia |
| --- | --- | --- |
| Un diagrama no demuestra grano ni llave | Solicitar schema, PK/FK o llaves de negocio, partición y muestra mínima antes de escribir SQL | Limitación del HTML |
| Una flecha no demuestra tipo de join | Confirmar joins, cardinalidad, deduplicación y reglas de prioridad en SQL o documentación técnica | Limitación del HTML |
| Nombre de reporte o agrupación puede ocultar varias reglas | Separar fuente, transformación, agrupación y salida; documentar cada paso | Capas visuales del mapeo |
| Cajas grises y verdes tienen estados visuales distintos | No convertir el color en estado operativo sin una definición del autor | Convención no explicada en el HTML |
| Dependencia de Excel/Drive | Identificar archivo, pestaña, propietario, frecuencia, histórico y controles de versión | Modelos 1–7 y diagramas generales |
| El modelo Online mezcla plataformas | Mantener separadas las definiciones de Calimaco, Optimove, Optimove-Calimaco e Ingenious hasta validar las 34 tablas referidas | Diagrama 3 |
| El mapa no muestra cifras ni cobertura temporal | Validar frescura, fecha inicial/final, faltantes y reconciliación con las fuentes | Limitación del HTML |
| El catálogo RAW no demuestra calidad ni modelo físico | Validar schema, grano, llaves, particiones, duplicados y downstream antes de usarlo | Captura de `LB_RECARGAS_RAW` |

## Open Questions

| Pregunta abierta | Por qué importa | Cómo resolverla |
| --- | --- | --- |
| ¿Cuál es el inventario físico y schema de cada objeto? | Permite construir diccionario y SQL sin inventar campos | DDL/schema exportado por sistema o BigQuery |
| ¿Qué significan exactamente las marcas verdes y los objetos grises? | Determina qué está aprobado, activo, pendiente o histórico | Confirmación del responsable del mapeo |
| ¿Cuáles son las llaves y cardinalidades entre cuentas, sesiones, clientes, mesas y recargas? | Evita fanout y doble conteo | SQL productivo, PK/FK y pruebas de duplicados |
| ¿Cuál es la definición de cada indicador LB/Flash y de cada hoja? | Permite documentar métricas, numeradores, denominadores y ventanas | Diccionario de KPIs y archivos de modelo |
| ¿Qué procesos generan cada reporte y con qué frecuencia? | Permite documentar frescura y operación | Jobs, procedimientos, orquestador o bitácoras |
| ¿Qué fuente gobierna cuando Wigos, Excel, Simphony, Salesforce o SAP se contradicen? | Define autoridad y reconciliación | Regla de negocio aprobada por dominio |
| ¿Dónde están físicamente las 26 tablas Calimaco, ClientBase, las 5 tablas Optimove-Calimaco y las 3 tablas Ingenious? | Permite completar el modelo Online | Accesos, schemas y catálogo de objetos |
| ¿Cuál es el schema, grano y llave de las 6 tablas de `LB_RECARGAS_RAW`? | Define joins y evita doble conteo en Recargas | Schema de BigQuery y muestra mínima |

## Sources

| Fuente | Uso y autoridad | Revisada / límites |
| --- | --- | --- |
| [Mapeo_BI_Exportable.html](C:\Users\marco.solis\Downloads\Mapeo_BI_Exportable.html) | Fuente suministrada para el inventario visual de dependencias y modelos | Revisada visualmente el 2026-10-13; contiene diagramas PNG incrustados, no schemas ni SQL |
| `Modelo1_Flash.png` a `Modelo7_Tablero_Comercial.png` | Modelos detallados de Flash, Clientes, Carteras, Recargas, Mesas, A y B y Tablero Comercial | Extraídos del HTML para inspección visual; no prueban ejecución |
| `Diagrama1.png` a `Diagrama4.png` | Dependencias generales y extensiones hacia mantenimiento, capital humano, finanzas, cadena de suministro, Calimaco y Salesforce | Extraídos del HTML para inspección visual; nombres y flechas requieren validación técnica |
| [LB_RECARGAS_RAW.md](docs/datasets/LB_RECARGAS_RAW.md) | Inventario inicial y pendientes del dataset `business-intelligence-470119.LB_RECARGAS_RAW` | Elaborado a partir de la captura suministrada; no contiene schema ni QA ejecutado |

