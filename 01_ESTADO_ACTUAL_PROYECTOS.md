# ESTADO ACTUAL DE PROYECTOS BI

**Corte:** 2026-07-20  
**Uso:** contexto operativo cambiante. Actualizar al cerrar cada avance relevante.

## 1. STRENDUS Dashboard V1

Estado general: primera hoja terminada y validada en Looker Studio.

Bloques validados:

- Depósitos y retiros.
- Apuestas y GGR.
- Depositantes Activos.
- Apuesta Promedio, Hold y ARPU.
- FTD, registros y conversión FTD.
- Base Total.
- Ratios de bonos.
- Series diarias de registros, jugadores activos y depositantes.
- Series de depósitos/retiros, apuestas y GGR.

Tablas integradas en Master 01:

- `FACT_DASHBOARD_KPI_DAILY_STRENDUS`.
- `FACT_DASHBOARD_KPI_USER_DAILY_STRENDUS`.
- `FACT_DASHBOARD_SERIES_DAILY_STRENDUS`.

Patrón de series múltiples en Looker:

- tabla larga con `FECHA`, `TIPO_GRAFICA`, `SERIE`, `VALOR`;
- `FECHA` como dimensión;
- `SERIE` como desglose;
- `SUM(VALOR)` como métrica;
- filtro por `TIPO_GRAFICA`.

Último Master conocido:

`01_UPDATE_STRENDUS_DAILY_PROCESS_V1_FINAL_DASHBOARD_V1_CANALES_SALA...`

Antes de editarlo, solicitar el archivo maestro más reciente a Blanca; no asumir que el nombre recordado es la última versión.

QA validado 1–14 julio 2026:

- FACT_DAILY: 14 filas.
- FACT_USER_DAILY: 35,594 filas y 17,646 usuarios.
- Reconciliaciones de filas, apuestas, GGR, finanzas, bonos y Daily vs User Daily: diferencia 0.

Pendientes:

- Continuar hoja 2 guiándose por capturas reales.
- PPTO/Presupuesto sigue desde archivo externo; no modificar hasta nuevo forecast o cambio de fuente.

## 2. Dashboard REGISTROS–FTD

Fuente oficial: `FACT_FTD_30D`.

- Página 5: FTD30D Cohort, lectura oficial/preferida de adquisición.
- Página 6: FTD Operativo.
- Dashboard `FTD corte mes`: deprecado y no debe ser referencia oficial.

Validación de referencia 1–7 julio 2026, cohorte:

- 6,656 registros.
- 254 FTD30D.
- $38,932 de monto FTD30D.
- 3.8161% de conversión.
- 0.90 días promedio.

El FTD calendario anterior dio 132; la diferencia de 122 no fue duplicación, sino efecto de la ventana de 30 días.

## 3. Compatibilidad STRENDUS → CALIMACO

Objetivo: replicar estructuras ejecutivas CALIMACO con información STRENDUS, tablas físicas terminadas en `_STRENDUS`, REAL MONEY por defecto y sin inventar campos.

Tablas creadas/validadas:

- `FACT_EXECUTIVE_DAILY_STRENDUS`: 50 campos.
- `FACT_EXECUTIVE_MONTHLY_STRENDUS`: 57 campos.
- `FACT_PAYMENT_METHOD_DAILY_STRENDUS`: 18 campos.
- `FACT_PAYMENT_STATUS_DAILY_STRENDUS`: WITHDRAWAL homologado a PAYOUT.
- `FACT_GAMING_DAILY_STRENDUS`: 32 campos, casino-only.
- `FACT_PROMOTION_DAILY_STRENDUS`: 14 campos.

Detalles importantes:

- Monthly se construye desde Daily y mes actual es MTD parcial.
- `peak_activos_*` mensual usa máximo diario.
- En `FACT_GAMING_DAILY_STRENDUS`, cantidad de jugadas, apuesta promedio y giros promedio permanecen NULL porque la fuente no lo proporciona.
- Cobertura validada de Gaming V1: 98.78% match USER_ID y 98.29% match DIM_GAME.
- Diferencia menor entre GGR fuente y wagers-winnings fue documentada y no bloqueante.

Trabajo parcialmente validado:

- `FACT_EXECUTIVE_MONTHLY_BY_ACQUISITION_STRENDUS`, 62 campos.
- Archivo conocido: `FACT_EXECUTIVE_MONTHLY_BY_ACQUISITION_STRENDUS_V1_CORREGIDA.sql`.
- Placeholders: `Sin affiliate` y `Sin affiliate_tag`.
- Falta confirmar formalmente QA de duplicados y reconciliaciones cuyo resultado fue “No data to display”.

## 4. Proceso diario STRENDUS

Flujo habitual:

1. Descargar CSV originales.
2. No abrir/re-guardar Registration Report en Excel.
3. Eliminar ventana correspondiente en RAW cuando aplique.
4. Cargar CSV limpios a RAW.
5. Ejecutar Master RAW → STAGING → GOLDEN/FACT.
6. Revisar QA incluidos al final.
7. Refrescar Looker Studio.

Sportsbook requiere recarga móvil de 60–90 días por tickets abiertos/liquidados tardíamente.

## 5. Dashboard de Bonos

Arquitectura actual:

- `VW_BONUS_MARKETING`.
- `VW_BONUS_DEPOSITOS_RECONSTRUIDOS`.
- `VW_DEPOSITA_Y_GANA_REPORTE`.
- `TBL_BONUS_DASHBOARD` como fuente ejecutiva.

Proceso diario:

1. Cargar BONUS_REPORT y TRANSACTIONS_REPORT en RAW.
2. Ejecutar RAW → STAGING.
3. En días de entrega de Deposita y Gana, reconstruir `FACT_DEPOSITA_Y_GANA`.
4. Recrear `TBL_BONUS_DASHBOARD`.
5. Validar y actualizar Looker.

## 6. Herramientas y automatización

### USER360 STRENDUS INVESTIGATION TOOL

Versión validada: `USER360_STRENDUS_EXPORTER_v2.py`.

- Entrada interactiva: USER_ID o USERNAME.
- Registro desde `STG_REGISTRATION_REPORT`.
- Transacciones y bonos por `USERNAME_MATCH_KEY` porque Transactions no trae USER_ID.
- Exporta Excel con: Resumen Ejecutivo, Perfil, Transacciones, Depósitos, Retiros, Bonos Resumen, Bonos Detalle, Timeline y Alertas.
- No depende del antiguo dataset `ONLINE_STRENDUS_INVESTIGATION`.

Mejoras futuras:

- integrar Gaming/GGR;
- net cash flow, tickets y máximos;
- conversión de bonos;
- Risk Score y comentario ejecutivo automático;
- interfaz simplificada.

### Playwright STRENDUS

- Instalado y funcionando localmente.
- Login llega hasta token manual por correo.
- Registration Report: RUN `#btnFilterRegistrationReport`; EXPORT `#ToolTables_tblRegistrationReport_2`.
- All Transaction Report: RUN `#btnFilterReport`; EXPORT `#ToolTables_tblAllTransactionsReport_2`.
- Regla: seleccionar únicamente Deposit y Withdrawal.
- Próximo paso: automatizar esa selección y obtener selectores de Bonus Report.

## 7. Roadmap BI Copilot / BI Operations Suite

Iniciativa estratégica: aplicación modular de escritorio para STRENDUS y CALIMACO.

Arquitectura preferida:

- core engine;
- módulos USER360, PROMO360 y AFFILIATE360;
- Promotoras y marketing enrichment;
- Deposita y Gana;
- utilidades CSV;
- automatización Playwright;
- Knowledge Base de reglas de negocio;
- motor SQL y BigQuery;
- exportación/reporting;
- capa posterior de lenguaje natural/IA.

Proyectos del roadmap:

- `PROMO360`: promoción completa desde BONUS_ID/NAME; usuarios, depósitos, revenue, conversión, ROI/GGR estimado.
- `AFFILIATE360`: registros, FTD, depósitos, GGR, NGR, AQS, retención, LTV y calidad.

## 8. CALIMACO — procesos recurrentes

Validación semanal de promotoras:

- llave principal `USER_ID`;
- `STG_USERS`: user_id, alias, affiliate_tag, created_datetime_mty, mobile;
- `STG_TRANSACTIONS`: operation_id, user_id, amount, operation_datetime_mty, type, status;
- salida: USER_ID, USUARIO, FECHA_REGISTRO, ID_DEPOSITO, FECHA_DEPOSITO, MONTO y clasificación de estado.

Detección de colaboradores:

- usar `STG_USERS` con user_id, alias, company, affiliate_tag, birthday y nombres;
- generar `FULL_NAME_NORMALIZED` y `NO_CURP_KEY`;
- filtro flexible: birthday no nulo, porque nombres pueden venir nulos.

## 9. LANDBASE CASINOS — contexto inicial

Fecha: 2026-10-13.

- Se incorporó el contexto inicial del mapeo en `00_CONTEXT_LANDBASE_CASINOS.md`.
- Evidencia revisada: `C:\Users\marco.solis\Downloads\Mapeo_BI_Exportable.html`, con 7 modelos y 4 diagramas generales incrustados como PNG.
- Cobertura identificada: Wigos como núcleo operativo; flujos de Flash, Clientes, Carteras, Recargas, Mesas, Alimentos y Bebidas y Tablero Comercial; además de dependencias con Simphony, LOS, Salesforce, SAP, Workday, Kronos, Calimaco, Optimove e Ingenious.
- Resultado: contexto arquitectónico inicial guardado; no se consideran confirmados schemas, granos, llaves, joins, métricas, periodicidad ni ejecución.
- Siguiente paso: recibir schemas/SQL o archivos fuente por dominio y documentar primero llaves, grano, cobertura, autoridad y QA.

## 10. Cómo actualizar este documento

Después de cada avance importante, registrar:

- fecha;
- objeto creado o modificado;
- regla aplicada;
- QA y periodo de control;
- resultado aprobado/no aprobado;
- pendientes y siguiente paso;
- nombre exacto del archivo SQL/Python maestro vigente.

No borrar hitos validados sin explicar por qué quedaron obsoletos.

