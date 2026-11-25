@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Trazabilidad de errores contratos mixtos'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CON_MIX_LOG
  as select from ZI_CON_MIX_LOG
{
  key LogUuid,
      ZcontConsec,
      ExecUuid,
      MsgSeq,
      Etapa,
      @EndUserText.label: 'Etapa'
      EtapaTexto,
      @EndUserText.label: 'Pedido de compra'
      Ebeln,
      @EndUserText.label: 'Posición'
      Ebelp,
      @EndUserText.label: 'Tipo'
      Msgty,
      @EndUserText.label: 'Clase mensaje'
      Msgid,
      @EndUserText.label: 'Nro. mensaje'
      Msgno,
      @EndUserText.label: 'Mensaje de error'
      Mensaje,
      @EndUserText.label: 'Usuario'
      CreatedBy,
      @EndUserText.label: 'Fecha / hora'
      CreatedAt,
      // Siempre 1 (rojo): en este log solo hay errores
      cast( 1 as abap.int1 ) as Criticidad
}
