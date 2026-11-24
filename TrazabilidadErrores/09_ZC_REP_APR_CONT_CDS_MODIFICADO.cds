@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte aprobaciones de contratos ZBAC'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_REP_APR_CONT
  provider contract transactional_query
  as projection on ZR_REP_APR_CONT

  // NUEVO: navegación de solo lectura al log de errores (no forma parte del BO)
  association [0..*] to ZC_CON_MIX_LOG as _Errores on _Errores.ZcontConsec = $projection.ZcontConsec
{
      @UI.selectionField: [{position: 30}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Consecutivo'
  key ZcontConsec,
  key Land1,

      @UI.selectionField: [{position: 50}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Estado'
      Zstatus,

      @UI.selectionField: [{position: 10}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Contrato'
      Konnr,

      @UI.selectionField: [{position: 20}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Usuario escaneo'
      Suser,

      @UI.selectionField: [{position: 30}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Fecha creación'
      Erdat,

      Lifnr,
      Nombre_Proveedor,
      Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Menge,
      Waers,
      @Semantics.amount.currencyCode: 'Waers'
      ZprecUni,
      @Semantics.amount.currencyCode: 'Waers'
      ZprecTot,
      Zaprob1,
      Zpaedat,
      Zaprob2,
      Zpaedat2,
      Frgzu,
      Zfrgzu,

      @UI.selectionField: [{position: 60}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Fecha declinación'
      Zfdecline,

      @UI.selectionField: [{position: 70}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Usuario declinación'
      Zuserd,

      @UI.selectionField: [{position: 50}]
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: false
      Ebeln,

      header_text,
      decline_reason,
      observaciones,

      /* ===== NUEVO: Trazabilidad de errores ===== */
      @UI.selectionField: [{position: 80}]
      @Consumption.filter.mandatory: false
      @EndUserText.label: 'Con errores'
      ConErrores,
      NumErrores,
      ErrorCriticality,
      UltEtapaError,
      UltMensajeError,
      UltFechaError,

      @Semantics.user.createdBy: true
      Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      Localcreatedat,
      @Semantics.user.lastChangedBy: true
      Locallastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Locallastchangedat,
      Lastchangedat,

      /* Associations */
      _Supplier,
      _Errores
}
