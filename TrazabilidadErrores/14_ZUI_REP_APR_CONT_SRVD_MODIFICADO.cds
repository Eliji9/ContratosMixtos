@EndUserText.label: 'Reporte de aprobaciones de contratos'
define service ZUI_REP_APR_CONT {
  expose ZC_REP_APR_CONT;
  expose ZC_CON_MIX_LOG;   // NUEVO: log de errores (navegación _Errores)
}
