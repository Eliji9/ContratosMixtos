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
    DATA lv_fecha TYPE d.
    DATA lv_hora  TYPE t.
    DATA lv_texto TYPE string.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    " Errores del log (más reciente primero)
    SELECT FROM zi_con_mix_log
      FIELDS ZcontConsec, EtapaTexto, Ebeln, Ebelp, Msgid, Msgno, Mensaje, CreatedAt
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

        CONVERT TIME STAMP ls_log-CreatedAt TIME ZONE sy-zonlo
          INTO DATE lv_fecha TIME lv_hora.

        lv_texto = |[{ ls_log-EtapaTexto }]|.
        IF ls_log-Ebeln IS NOT INITIAL.
          lv_texto = |{ lv_texto } Pedido { ls_log-Ebeln ALPHA = OUT }|.
          IF ls_log-Ebelp IS NOT INITIAL.
            lv_texto = |{ lv_texto }/{ ls_log-Ebelp ALPHA = OUT }|.
          ENDIF.
          lv_texto = |{ lv_texto }:|.
        ENDIF.
        lv_texto = |{ lv_texto } { ls_log-Mensaje } ({ lv_fecha DATE = USER } { lv_hora TIME = USER }|.
        IF ls_log-Msgid IS NOT INITIAL.
          lv_texto = |{ lv_texto } · { ls_log-Msgid } { ls_log-Msgno }|.
        ENDIF.
        lv_texto = |{ lv_texto })|.

        APPEND VALUE #( %tky = ls_key-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = lv_texto ) )
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
