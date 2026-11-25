@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log errores contratos mixtos - Básica'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CON_MIX_LOG
  as select from ztmm_log_con_mix
{
  key log_uuid     as LogUuid,
      zcont_consec as ZcontConsec,
      exec_uuid    as ExecUuid,
      msg_seq      as MsgSeq,
      etapa        as Etapa,

      cast( case etapa
              when 'OC'  then 'Orden de compra'
              when 'HES' then 'Hoja entrada servicio'
              when 'EM'  then 'MIGO 101'
              else 'Otro'
            end as abap.char(30) ) as EtapaTexto,

      ebeln        as Ebeln,
      ebelp        as Ebelp,
      msgty        as Msgty,
      msgid        as Msgid,
      msgno        as Msgno,
      mensaje      as Mensaje,
      created_by   as CreatedBy,
      created_at   as CreatedAt
}
