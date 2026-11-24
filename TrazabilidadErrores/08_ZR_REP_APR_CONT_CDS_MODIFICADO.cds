@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte aprobaciones de contratos ZBAC'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] } */
define root view entity ZR_REP_APR_CONT
  as select from ZR_TMM_H_COT
    // NUEVO: resumen + último error de los jobs (OC / HES / MIGO 101)
    left outer to one join ZI_CON_MIX_LOG_ULT as _Ult on _Ult.ZcontConsec = ZR_TMM_H_COT.ZcontConsec

  // association to ZZ1_APROBADORES_CONTRATOS as _ACont
  //   on  _ACont.usuarioescaneo = ZR_TMM_H_COT.Suser
  //   and _ACont.sociedad       = ZR_TMM_H_COT.Land1

  association to I_Supplier as _Supplier
    on _Supplier.Supplier = ZR_TMM_H_COT.Lifnr
{
      /* ===== Claves ===== */
  key ZR_TMM_H_COT.ZcontConsec,

      @EndUserText.label: 'Sociedad'
  key ZR_TMM_H_COT.Land1,

      /* ===== Datos del contrato ===== */
      @EndUserText.label: 'Estado'
      ZR_TMM_H_COT.Zstatus,

      @EndUserText.label: 'Contrato'
      ZR_TMM_H_COT.Konnr,

      @EndUserText.label: 'Usuario'
      ZR_TMM_H_COT.Suser,

      @EndUserText.label: 'Fecha de creación'
      ZR_TMM_H_COT.Erdat,

      /* ===== Proveedor y textos ===== */
      @EndUserText.label: 'Proveedor'
      ZR_TMM_H_COT.Lifnr,

      @EndUserText.label: 'Nombre proveedor'
      _Supplier.SupplierName as Nombre_Proveedor,

      /* ===== Cantidades y importes con semántica ===== */
      @EndUserText.label: 'Unidad'
      ZR_TMM_H_COT.Meins,

      @EndUserText.label: 'Cantidad'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      ZR_TMM_H_COT.Menge,

      @EndUserText.label: 'Moneda'
      ZR_TMM_H_COT.Waers,

      @EndUserText.label: 'Precio unitario'
      @Semantics.amount.currencyCode: 'Waers'
      ZR_TMM_H_COT.ZprecUni,

      @EndUserText.label: 'Precio total'
      @Semantics.amount.currencyCode: 'Waers'
      ZR_TMM_H_COT.ZprecTot,

      /* ===== Aprobaciones ===== */
      @EndUserText.label: 'Aprobador 1'
      ZR_TMM_H_COT.Zaprob1,

      @EndUserText.label: 'Fecha aprob. 1'
      ZR_TMM_H_COT.Zpaedat,

      @EndUserText.label: 'Aprobador 2'
      ZR_TMM_H_COT.Zaprob2,

      @EndUserText.label: 'Fecha aprob. 2'
      ZR_TMM_H_COT.Zpaedat2,

      /* ===== Otros campos ===== */
      @EndUserText.label: 'Liberación'
      ZR_TMM_H_COT.Frgzu,

      @EndUserText.label: 'Liberación Z'
      ZR_TMM_H_COT.Zfrgzu,

      @EndUserText.label: 'Declinación'
      ZR_TMM_H_COT.Zfdecline,

      @EndUserText.label: 'Usuario declinación'
      ZR_TMM_H_COT.Zuserd,

      @EndUserText.label: 'Pedido de compra'
      ZR_TMM_H_COT.Ebeln,

      @EndUserText.label: 'Texto Cabecera'
      ZR_TMM_H_COT.header_text,

      @EndUserText.label: 'Texto declinación'
      ZR_TMM_H_COT.decline_reason,

      @EndUserText.label: 'Observaciones'
      ZR_TMM_H_COT.observaciones,

      /* ===== NUEVO: Trazabilidad de errores de los jobs ===== */
      @EndUserText.label: 'Con errores'
      cast( case when _Ult.NumErrores > 0 then 'X' else ' ' end as abap_boolean ) as ConErrores,

      @EndUserText.label: 'Errores'
      coalesce( _Ult.NumErrores, 0 )                                            as NumErrores,

      // 1 = rojo, 0 = neutro
      cast( case when _Ult.NumErrores > 0 then 1 else 0 end as abap.int1 )      as ErrorCriticality,

      @EndUserText.label: 'Etapa último error'
      _Ult.UltEtapaTexto                                                        as UltEtapaError,

      @EndUserText.label: 'Último error'
      _Ult.UltMensaje                                                           as UltMensajeError,

      @EndUserText.label: 'Fecha último error'
      _Ult.UltimaFecha                                                          as UltFechaError,

      /* ===== Administrativos ===== */
      @EndUserText.label: 'Creado por'
      @Semantics.user.createdBy: true
      ZR_TMM_H_COT.Localcreatedby,

      @EndUserText.label: 'Creado en'
      @Semantics.systemDateTime.createdAt: true
      ZR_TMM_H_COT.Localcreatedat,

      @EndUserText.label: 'Último cambio por'
      @Semantics.user.lastChangedBy: true
      ZR_TMM_H_COT.Locallastchangedby,

      @EndUserText.label: 'Último cambio en'
      @Semantics.systemDateTime.lastChangedAt: true
      ZR_TMM_H_COT.Locallastchangedat,

      @EndUserText.label: 'Timestamp último cambio'
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ZR_TMM_H_COT.Lastchangedat,

      /* Asociaciones */
      // _ACont,
      _Supplier
}
