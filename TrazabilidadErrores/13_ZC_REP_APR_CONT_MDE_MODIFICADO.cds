@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName: 'Reporte de estatus Contratos Mixtos',
    typeNamePlural: 'Reporte de estatus Contratos Mixtos'
  }
}
annotate entity ZC_REP_APR_CONT with
{
  @UI.facet: [ {
    id: 'idIdentification',
    type: #IDENTIFICATION_REFERENCE,
    label: 'Detalle de solicitud Contratos Mixtos',
    position: 10
  },
  // NUEVO: tabla de errores en el Object Page
  {
    id: 'idTrazabilidadErrores',
    purpose: #STANDARD,
    type: #LINEITEM_REFERENCE,
    label: 'Trazabilidad de errores',
    position: 20,
    targetElement: '_Errores'
  } ]
  @UI.lineItem: [ {
    position: 10 ,
    importance: #MEDIUM,
    label: 'Consecutivo'
  },
  // NUEVO: botón "Ver errores" en cada fila (abre ventana de mensajes)
  {
    type: #FOR_ACTION,
    dataAction: 'display_errors',
    label: 'Ver errores',
    position: 79.3,
    inline: true,
    importance: #HIGH,
    cssDefault.width: '8rem'
  } ]
  @UI.identification: [ {
    position: 10 ,
    label: ''
  },
  // NUEVO: botón "Ver errores" en la cabecera del Object Page
  {
    type: #FOR_ACTION,
    dataAction: 'display_errors',
    label: 'Ver errores'
  } ]
  ZcontConsec;

  @UI.lineItem: [ {
    position: 20 ,
    importance: #MEDIUM,
    label: 'País'
  } ]
  @UI.identification: [ {
    position: 20 ,
    label: 'País'
  } ]
  Land1;

  @UI.lineItem: [ {
    position: 30 ,
    importance: #MEDIUM,
    label: 'Estatus'
  } ]
  @UI.identification: [ {
    position: 30 ,
    label: 'Estatus'
  } ]
  Zstatus;

  /* ===== NUEVO: Trazabilidad de errores ===== */
  @UI.lineItem: [ {
    position: 79.1 ,
    importance: #HIGH,
    label: 'Errores',
    criticality: 'ErrorCriticality',
    criticalityRepresentation: #WITH_ICON,
    cssDefault.width: '5rem'
  } ]
  @UI.identification: [ {
    position: 205 ,
    label: 'Errores',
    criticality: 'ErrorCriticality'
  } ]
  NumErrores;

  @UI.lineItem: [ {
    position: 79.2 ,
    importance: #MEDIUM,
    label: 'Etapa último error',
    cssDefault.width: '9rem'
  } ]
  @UI.identification: [ {
    position: 210 ,
    label: 'Etapa último error'
  } ]
  UltEtapaError;

  // Sin columna en la lista: el texto se ve con el botón "Ver errores" y en el detalle
  @UI.identification: [ {
    position: 215 ,
    label: 'Último error'
  } ]
  UltMensajeError;

  @UI.identification: [ {
    position: 220 ,
    label: 'Fecha último error'
  } ]
  UltFechaError;

  @UI.hidden: true
  ErrorCriticality;
  /* ===== FIN NUEVO ===== */

  @UI.lineItem: [ {
    position: 40 ,
    importance: #MEDIUM,
    label: 'Contrato'
  } ]
  @UI.identification: [ {
    position: 40 ,
    label: 'Contrato'
  } ]
  Konnr;

  @UI.lineItem: [ {
    position: 50 ,
    importance: #MEDIUM,
    label: 'Documento de compras'
  } ]
  @UI.identification: [ {
    position: 50 ,
    label: 'Documento de compras'
  } ]
  Ebeln;

  @UI.lineItem: [ {
    position: 60 ,
    importance: #MEDIUM,
    label: 'Usuario escaneo'
  } ]
  @UI.identification: [ {
    position: 60 ,
    label: 'Usuario escaneo'
  } ]
  Suser;

  @UI.lineItem: [ {
    position: 65 ,
    importance: #MEDIUM,
    label: 'Creado el'
  } ]
  @UI.identification: [ {
    position: 65 ,
    label: 'Creado el'
  } ]
  Erdat;

  @UI.lineItem: [ {
    position: 70 ,
    importance: #MEDIUM,
    label: 'Acreedor'
  } ]
  @UI.identification: [ {
    position: 70 ,
    label: 'Acreedor'
  } ]
  Lifnr;

  @UI.lineItem: [ {
    position: 78 ,
    importance: #MEDIUM,
    label: 'Nombre Acreedor'
  } ]
  @UI.identification: [ {
    position: 75 ,
    label: 'Nombre Acreedor'
  } ]
  Nombre_Proveedor;

  @UI.lineItem: [ {
    position: 80 ,
    importance: #MEDIUM,
    label: 'Cantidad'
  } ]
  @UI.identification: [ {
    position: 80 ,
    label: 'Cantidad'
  } ]
  Menge;

  @UI.lineItem: [ {
    position: 90 ,
    importance: #MEDIUM,
    label: 'Precio Unitario'
  } ]
  @UI.identification: [ {
    position: 90 ,
    label: 'Precio Unitario'
  } ]
  ZprecUni;

  @UI.lineItem: [ {
    position: 100 ,
    importance: #MEDIUM,
    label: 'Precio Total'
  } ]
  @UI.identification: [ {
    position: 100 ,
    label: 'Precio Total'
  } ]
  ZprecTot;

  @UI.lineItem: [ {
    position: 110 ,
    importance: #MEDIUM,
    label: 'Aprobador 1'
  } ]
  @UI.identification: [ {
    position: 110 ,
    label: 'Aprobador 1'
  } ]
  Zaprob1;

  @UI.lineItem: [ {
    position: 115 ,
    importance: #MEDIUM,
    label: 'Fecha primera aprobación'
  } ]
  @UI.identification: [ {
    position: 115 ,
    label: 'Fecha primera aprobación'
  } ]
  Zpaedat;

  @UI.lineItem: [ {
    position: 120 ,
    importance: #MEDIUM,
    label: 'Aprobador 2'
  } ]
  @UI.identification: [ {
    position: 120 ,
    label: 'Aprobador 2'
  } ]
  Zaprob2;

  @UI.lineItem: [ {
    position: 125 ,
    importance: #MEDIUM,
    label: 'Fecha segunda aprobación'
  } ]
  @UI.identification: [ {
    position: 125 ,
    label: 'Fecha segunda aprobación'
  } ]
  Zpaedat2;

  @UI.lineItem: [ {
    position: 130 ,
    importance: #MEDIUM,
    label: 'Estado-liberación'
  } ]
  @UI.identification: [ {
    position: 130 ,
    label: 'Estado-liberación'
  } ]
  Frgzu;

  @UI.lineItem: [ {
    position: 140 ,
    importance: #MEDIUM,
    label: 'Aprobaciones requeridas'
  } ]
  @UI.identification: [ {
    position: 140 ,
    label: 'Aprobaciones requeridas'
  } ]
  Zfrgzu;

  @UI.lineItem: [ {
    position: 160 ,
    importance: #MEDIUM,
    label: 'Texto declinación'
  } ]
  @UI.identification: [ {
    position: 160 ,
    label: 'Texto declinación'
  } ]
  decline_reason;

  @UI.lineItem: [ {
    position: 170 ,
    importance: #MEDIUM,
    label: 'Fecha declinación'
  } ]
  @UI.identification: [ {
    position: 170 ,
    label: 'Fecha declinación'
  } ]
  Zfdecline;

  @UI.lineItem: [ {
    position: 180 ,
    importance: #MEDIUM,
    label: 'Usuario declinación'
  } ]
  @UI.identification: [ {
    position: 180 ,
    label: 'Usuario declinación'
  } ]
  Zuserd;

  @UI.lineItem: [ {
    position: 190 ,
    importance: #MEDIUM,
    label: 'Texto de Cabecera'
  } ]
  @UI.identification: [ {
    position: 190 ,
    label: 'Texto de Cabecera'
  } ]
  header_text;

  @UI.lineItem: [ {
    position: 200 ,
    importance: #MEDIUM,
    label: 'Observaciones'
  } ]
  @UI.identification: [ {
    position: 200 ,
    label: 'Observaciones'
  } ]
  observaciones;
}
