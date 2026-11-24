@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log errores contratos mixtos - Último error'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] } */
define view entity ZI_CON_MIX_LOG_ULT
  as select from ZI_CON_MIX_LOG_SUM as Resumen
    inner join   ZI_CON_MIX_LOG     as Log on  Log.ZcontConsec = Resumen.ZcontConsec
                                           and Log.CreatedAt   = Resumen.UltimaFecha
                                           and Log.MsgSeq      = 1
{
  key Resumen.ZcontConsec,
      Resumen.NumErrores,
      Resumen.UltimaFecha,
      Log.Etapa      as UltEtapa,
      Log.EtapaTexto as UltEtapaTexto,
      Log.Mensaje    as UltMensaje
}
