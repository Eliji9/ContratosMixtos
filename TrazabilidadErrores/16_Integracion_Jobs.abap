*======================================================================
* INTEGRACIÓN EN LOS JOBS – solo una línea junto a cada correo de error
* Regla: donde hoy se llama zcl_mm_util_pfa=>send_email por un error,
*        se agrega la llamada al log. Los éxitos NO se registran.
*======================================================================

*----------------------------------------------------------------------
* A) Job de creación de OC – ZCL_MAN_CON_MIX_DATA->CREATE_PO
*----------------------------------------------------------------------
CALL FUNCTION 'BAPI_PO_CREATE1'
  EXPORTING
    poheader         = ls_poheader
    poheaderx        = ls_poheaderx
  IMPORTING
    exppurchaseorder = lv_ebeln
  TABLES
    return           = lt_return
    poitem           = lt_poitem
    poitemx          = lt_poitemx.

IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  " >>> NUEVO
  zcl_mm_con_mix_log=>log_bapiret2(
    iv_consec = ls_contrato-zcont_consec
    iv_etapa  = zcl_mm_con_mix_log=>gc_etapa-orden_compra
    it_return = lt_return ).
  " <<< NUEVO

  zcl_mm_util_pfa=>send_email( ... ).   " existente, sin cambios
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = abap_true.
ENDIF.

*----------------------------------------------------------------------
* B) Job post-aprobación – Hoja de entrada de servicio
*----------------------------------------------------------------------
IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  zcl_mm_con_mix_log=>log_bapiret2(
    iv_consec = ls_contrato-zcont_consec
    iv_etapa  = zcl_mm_con_mix_log=>gc_etapa-hoja_servicio
    iv_ebeln  = ls_contrato-ebeln
    iv_ebelp  = lv_ebelp
    it_return = lt_return ).

  zcl_mm_util_pfa=>send_email( ... ).   " existente
ENDIF.

*----------------------------------------------------------------------
* C) Job post-aprobación – MIGO 101 (BAPI_GOODSMVT_CREATE)
*----------------------------------------------------------------------
IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  zcl_mm_con_mix_log=>log_bapiret2(
    iv_consec = ls_contrato-zcont_consec
    iv_etapa  = zcl_mm_con_mix_log=>gc_etapa-entrada_mcia
    iv_ebeln  = ls_contrato-ebeln
    it_return = lt_return ).

  zcl_mm_util_pfa=>send_email( ... ).   " existente
ENDIF.

*----------------------------------------------------------------------
* D) Errores que no vienen de una BAPI (validaciones propias, CATCH, etc.)
*----------------------------------------------------------------------
zcl_mm_con_mix_log=>log_texto(
  iv_consec  = ls_contrato-zcont_consec
  iv_etapa   = zcl_mm_con_mix_log=>gc_etapa-orden_compra
  iv_mensaje = |No se encontró aprobador para el país { ls_contrato-land1 }| ).

* Nota: el log va por conexión secundaria (R/3*ZCON_MIX_LOG), así que el orden
* respecto al ROLLBACK no importa y no hace COMMIT del LUW del job.
