*======================================================================
* ZBP_R_REP_APR_CONT – pestaña "Local Types" (lhc_repaprcont)
* SOLO SE AGREGA: 2 definiciones + 2 implementaciones.
* No toques los métodos existentes (display_text, display_observations, etc.)
*======================================================================

*----------------------------------------------------------------------
* 1) En CLASS lhc_repaprcont DEFINITION ... PRIVATE SECTION, agregar:
*----------------------------------------------------------------------
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR repaprcont RESULT result.

    METHODS display_errors FOR MODIFY
      IMPORTING keys FOR ACTION repaprcont~display_errors RESULT result.


*----------------------------------------------------------------------
* 2) En CLASS lhc_repaprcont IMPLEMENTATION, agregar:
*----------------------------------------------------------------------
  METHOD get_instance_features.
    " Consecutivos que tienen al menos un error registrado
    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT FROM zi_con_mix_log_sum
      FIELDS ZcontConsec
      FOR ALL ENTRIES IN @keys
      WHERE ZcontConsec = @keys-ZcontConsec
      INTO TABLE @DATA(lt_con_error).

    result = VALUE #( FOR ls_key IN keys
                      ( %tky                   = ls_key-%tky
                        %action-display_errors = COND #(
                          WHEN line_exists( lt_con_error[ ZcontConsec = ls_key-ZcontConsec ] )
                          THEN if_abap_behv=>fc-o-enabled
                          ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.


  METHOD display_errors.
    " new_message_with_text solo muestra 50 caracteres.
    " Se usa el mensaje estándar 00/001 (&1&2&3&4&5&6&7&8) con 4 variables
    " de 50 caracteres: hasta 200 caracteres por mensaje en la ventana.
    TYPES ty_var TYPE c LENGTH 50.

    DATA lv_texto TYPE string.
    DATA lt_var   TYPE STANDARD TABLE OF ty_var WITH EMPTY KEY.
    DATA lv_trozo TYPE ty_var.
    DATA lv_len   TYPE i.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    " Errores del log (más reciente primero)
    SELECT FROM zi_con_mix_log
      FIELDS ZcontConsec, EtapaTexto, Ebeln, Ebelp, Mensaje, CreatedAt
      FOR ALL ENTRIES IN @keys
      WHERE ZcontConsec = @keys-ZcontConsec
      INTO TABLE @DATA(lt_log).

    SORT lt_log BY ZcontConsec ASCENDING CreatedAt DESCENDING.

    LOOP AT keys INTO DATA(ls_key).

      IF NOT line_exists( lt_log[ ZcontConsec = ls_key-ZcontConsec ] ).
        APPEND VALUE #( %tky = ls_key-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-information
                                 text     = |Consecutivo { ls_key-ZcontConsec ALPHA = OUT }: sin errores registrados| ) )
               TO reported-repaprcont.
        CONTINUE.
      ENDIF.

      LOOP AT lt_log INTO DATA(ls_log) WHERE ZcontConsec = ls_key-ZcontConsec.

        " Texto: [Etapa] Pedido xxx/yy: mensaje completo
        lv_texto = |[{ ls_log-EtapaTexto }]|.
        IF ls_log-Ebeln IS NOT INITIAL.
          lv_texto = |{ lv_texto } Pedido { ls_log-Ebeln ALPHA = OUT }|.
          IF ls_log-Ebelp IS NOT INITIAL.
            lv_texto = |{ lv_texto }/{ ls_log-Ebelp ALPHA = OUT }|.
          ENDIF.
          lv_texto = |{ lv_texto }:|.
        ENDIF.
        lv_texto = |{ lv_texto } { condense( val = CONV string( ls_log-Mensaje ) del = ` ` ) }|.

        IF strlen( lv_texto ) > 200.
          lv_texto = |{ substring( val = lv_texto len = 197 ) }...|.
        ENDIF.

        " Partir en trozos de 50 sin perder espacios: el mensaje elimina los
        " espacios finales de cada variable, así que un trozo nunca termina en espacio
        CLEAR lt_var.
        WHILE lv_texto IS NOT INITIAL AND lines( lt_var ) < 4.
          lv_len = nmin( val1 = 50 val2 = strlen( lv_texto ) ).
          IF lv_len = 50 AND strlen( lv_texto ) > 50 AND substring( val = lv_texto off = 49 len = 1 ) = ` `.
            lv_len = 49.
          ENDIF.
          lv_trozo = substring( val = lv_texto len = lv_len ).
          APPEND lv_trozo TO lt_var.
          lv_texto = substring( val = lv_texto off = lv_len ).
        ENDWHILE.

        APPEND VALUE #( %tky = ls_key-%tky
                        %msg = new_message(
                                 id       = '00'
                                 number   = '001'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = VALUE #( lt_var[ 1 ] OPTIONAL )
                                 v2       = VALUE #( lt_var[ 2 ] OPTIONAL )
                                 v3       = VALUE #( lt_var[ 3 ] OPTIONAL )
                                 v4       = VALUE #( lt_var[ 4 ] OPTIONAL ) ) )
               TO reported-repaprcont.
      ENDLOOP.
    ENDLOOP.

    " Resultado $self (la acción no modifica nada)
    SELECT FROM zr_rep_apr_cont
      FIELDS *
      FOR ALL ENTRIES IN @keys
      WHERE ZcontConsec = @keys-ZcontConsec
        AND Land1       = @keys-Land1
      INTO TABLE @DATA(lt_data).

    result = VALUE #( FOR ls_data IN lt_data
                      ( %tky-ZcontConsec = ls_data-ZcontConsec
                        %tky-Land1       = ls_data-Land1
                        %param           = CORRESPONDING #( ls_data ) ) ).
  ENDMETHOD.
