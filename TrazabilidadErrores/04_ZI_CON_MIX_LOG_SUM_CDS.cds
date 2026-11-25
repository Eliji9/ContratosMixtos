@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log errores contratos mixtos - Resumen'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CON_MIX_LOG_SUM
  as select from ztmm_log_con_mix
{
  key zcont_consec                 as ZcontConsec,
      count( distinct exec_uuid )  as NumErrores,
      max( created_at )            as UltimaFecha
}
group by
  zcont_consec
