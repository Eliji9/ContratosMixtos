"! Log de errores de los jobs de Contratos Mixtos.
"! Solo persiste mensajes de error (E / A / X). Los éxitos no se guardan.
"! Escribe por una conexión secundaria de BD para que el registro
"! sobreviva al BAPI_TRANSACTION_ROLLBACK del job y no haga COMMIT de su LUW.
CLASS zcl_mm_con_mix_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES ty_etapa TYPE c LENGTH 4.

    CONSTANTS:
      BEGIN OF gc_etapa,
        orden_compra  TYPE ty_etapa VALUE 'OC',   " Creación de la OC (BAPI_PO_CREATE1)
        hoja_servicio TYPE ty_etapa VALUE 'HES',  " Hoja de entrada de servicio
        entrada_mcia  TYPE ty_etapa VALUE 'EM',   " MIGO 101 (BAPI_GOODSMVT_CREATE)
      END OF gc_etapa.

    "! Registra los mensajes de error de un BAPIRET2. Si no hay errores, no hace nada.
    CLASS-METHODS log_bapiret2
      IMPORTING
        iv_consec TYPE zde_cont_consec
        iv_etapa  TYPE ty_etapa
        iv_ebeln  TYPE ebeln OPTIONAL
        iv_ebelp  TYPE ebelp OPTIONAL
        it_return TYPE bapiret2_t.

    "! Registra un error de texto libre (validaciones propias, excepciones, etc.)
    CLASS-METHODS log_texto
      IMPORTING
        iv_consec  TYPE zde_cont_consec
        iv_etapa   TYPE ty_etapa
        iv_ebeln   TYPE ebeln OPTIONAL
        iv_ebelp   TYPE ebelp OPTIONAL
        iv_mensaje TYPE bapi_msg.

  PRIVATE SECTION.
    TYPES tt_log TYPE STANDARD TABLE OF ztmm_log_con_mix WITH EMPTY KEY.

    CONSTANTS gc_conexion TYPE dbcon_name VALUE 'R/3*ZCON_MIX_LOG'.

    CLASS-METHODS guardar
      IMPORTING it_log TYPE tt_log.

    CLASS-METHODS nuevo_uuid
      RETURNING VALUE(rv_uuid) TYPE sysuuid_x16.
ENDCLASS.


CLASS zcl_mm_con_mix_log IMPLEMENTATION.

  METHOD log_bapiret2.
    DATA lt_log  TYPE tt_log.
    DATA lv_seq  TYPE i.
    DATA lv_ts   TYPE timestampl.
    DATA lv_msg  TYPE bapi_msg.

    " Solo errores
    DATA(lt_err) = VALUE bapiret2_t( FOR ls IN it_return
                                     WHERE ( type = 'E' OR type = 'A' OR type = 'X' )
                                     ( ls ) ).
    IF lt_err IS INITIAL.
      RETURN.
    ENDIF.

    " Excluir el mensaje genérico de la BAPI (BAPI 001: "No se ha creado ninguna
    " instancia de tipo objeto ...") cuando hay otros errores que dan la causa real.
    " Si fuera el único error, se conserva para no perder el registro.
    IF lines( lt_err ) > 1.
      DELETE lt_err WHERE id = 'BAPI' AND number = '001'.
    ENDIF.

    GET TIME STAMP FIELD lv_ts.
    DATA(lv_exec) = nuevo_uuid( ).

    LOOP AT lt_err INTO DATA(ls_err).
      lv_seq += 1.
      lv_msg = ls_err-message.
      IF lv_msg IS INITIAL AND ls_err-id IS NOT INITIAL.
        MESSAGE ID ls_err-id TYPE 'E' NUMBER ls_err-number
                WITH ls_err-message_v1 ls_err-message_v2 ls_err-message_v3 ls_err-message_v4
                INTO lv_msg.
      ENDIF.

      " Error de presupuesto: igual que en el correo, se completa con la variable 3
      IF ls_err-id = 'FMAVC' AND ls_err-number = '005' AND ls_err-message_v3 IS NOT INITIAL.
        lv_msg = |{ lv_msg } - { ls_err-message_v3 }|.
      ENDIF.

      APPEND VALUE #( log_uuid     = nuevo_uuid( )
                      zcont_consec = iv_consec
                      exec_uuid    = lv_exec
                      msg_seq      = lv_seq
                      etapa        = iv_etapa
                      ebeln        = iv_ebeln
                      ebelp        = iv_ebelp
                      msgty        = ls_err-type
                      msgid        = ls_err-id
                      msgno        = ls_err-number
                      mensaje      = lv_msg
                      created_by   = sy-uname
                      created_at   = lv_ts ) TO lt_log.
    ENDLOOP.

    guardar( lt_log ).
  ENDMETHOD.


  METHOD log_texto.
    DATA lv_ts TYPE timestampl.

    IF iv_mensaje IS INITIAL.
      RETURN.
    ENDIF.

    GET TIME STAMP FIELD lv_ts.

    guardar( VALUE #( ( log_uuid     = nuevo_uuid( )
                        zcont_consec = iv_consec
                        exec_uuid    = nuevo_uuid( )
                        msg_seq      = 1
                        etapa        = iv_etapa
                        ebeln        = iv_ebeln
                        ebelp        = iv_ebelp
                        msgty        = 'E'
                        mensaje      = iv_mensaje
                        created_by   = sy-uname
                        created_at   = lv_ts ) ) ).
  ENDMETHOD.


  METHOD guardar.
    " Conexión de servicio R/3*: misma BD, LUW de BD independiente.
    " El log no se pierde con el ROLLBACK del job y no confirma el LUW del job.
    TRY.
        INSERT ztmm_log_con_mix CONNECTION (gc_conexion) FROM TABLE @it_log.
        COMMIT CONNECTION (gc_conexion).
      CATCH cx_sy_open_sql_db cx_sy_dynamic_osql_error.
        " El log nunca debe interrumpir el job
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD nuevo_uuid.
    TRY.
        rv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        CLEAR rv_uuid.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
