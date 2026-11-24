# Trazabilidad de errores – Reporte de estatus Contratos Mixtos

Registra **solo los errores** de los jobs (creación de OC, hoja de entrada de servicio y MIGO 101)
y los muestra en la app `ZUI_REP_APR_CONT_O4`: columna de errores, botón **Ver errores** (ventana)
y sección **Trazabilidad de errores** en el detalle.

## Orden de creación / activación

| # | Objeto | Tipo en ADT | Acción | Archivo |
|---|--------|-------------|--------|---------|
| 1 | `ZTMM_LOG_CON_MIX` | Dictionary > Database Table | Nuevo | 01_ZTMM_LOG_CON_MIX_Tabla.cds |
| 2 | `ZCL_MM_CON_MIX_LOG` | ABAP Class | Nuevo | 02_ZCL_MM_CON_MIX_LOG_Clase.abap |
| 3 | `ZI_CON_MIX_LOG` | Data Definition (view entity) | Nuevo | 03_ZI_CON_MIX_LOG_CDS.cds |
| 4 | `ZI_CON_MIX_LOG_SUM` | Data Definition (view entity) | Nuevo | 04_ZI_CON_MIX_LOG_SUM_CDS.cds |
| 5 | `ZI_CON_MIX_LOG_ULT` | Data Definition (view entity) | Nuevo | 05_ZI_CON_MIX_LOG_ULT_CDS.cds |
| 6 | `ZC_CON_MIX_LOG` | Data Definition (view entity) | Nuevo | 06_ZC_CON_MIX_LOG_CDS.cds |
| 7 | `ZC_CON_MIX_LOG` | Metadata Extension | Nuevo | 07_ZC_CON_MIX_LOG_MDE.cds |
| 8 | `ZR_REP_APR_CONT` | Data Definition | Modificar (reemplazar completo) | 08_ZR_REP_APR_CONT_CDS_MODIFICADO.cds |
| 9 | `ZC_REP_APR_CONT` | Data Definition | Modificar (reemplazar completo) | 09_ZC_REP_APR_CONT_CDS_MODIFICADO.cds |
| 10 | `ZR_REP_APR_CONT` | Behavior Definition | Modificar (reemplazar completo) | 10_ZR_REP_APR_CONT_BDEF_MODIFICADO.cds |
| 11 | `ZC_REP_APR_CONT` | Behavior Definition (proyección) | Modificar (reemplazar completo) | 11_ZC_REP_APR_CONT_BDEF_MODIFICADO.cds |
| 12 | `ZBP_R_REP_APR_CONT` | Clase de comportamiento (Local Types) | Modificar (**solo agregar** 2 métodos) | 12_ZBP_R_REP_APR_CONT_AGREGAR.abap |
| 13 | `ZC_REP_APR_CONT` | Metadata Extension | Modificar (reemplazar completo) | 13_ZC_REP_APR_CONT_MDE_MODIFICADO.cds |
| 14 | `ZUI_REP_APR_CONT` | Service Definition | Modificar | 14_ZUI_REP_APR_CONT_SRVD_MODIFICADO.cds |
| 15 | `ZUI_REP_APR_CONT_O4` | Service Binding | Verificar que aparezca `ZC_CON_MIX_LOG`; si no, Unpublish → Publish | — |
| 16 | Jobs (`ZCL_MAN_CON_MIX_DATA->CREATE_PO`, job HES / MIGO 101) | Clase / programa existente | Modificar (agregar llamada al log junto a cada correo de error) | 16_Integracion_Jobs.abap |

### Notas
- **Pasos 10, 11 y 12 se activan juntos** (Activate All / Ctrl+Shift+F3): el BDEF declara `display_errors` y `get_instance_features`, y la clase debe implementarlos.
- **Paso 8** usa los campos de `ZI_CON_MIX_LOG_ULT`, y **paso 9** la entidad `ZC_CON_MIX_LOG`: por eso van después del 1–7.
- **Paso 13**: el MDE se transcribió de fotos; comparar con el original antes de reemplazar (en especial `Menge`, lineItem 80).
- **Paso 1**: crear índice secundario en `ZCONT_CONSEC` (SE11) para el rendimiento.
- La clase de log escribe por la conexión de servicio `R/3*ZCON_MIX_LOG` (no requiere configuración): el error queda guardado aunque el job haga ROLLBACK.
- Cuando falla la OC, el consecutivo fallido queda con sus errores y el nuevo consecutivo sale limpio.
