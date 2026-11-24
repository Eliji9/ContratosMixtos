@Metadata.layer: #CUSTOMER
@UI.headerInfo: { typeName: 'Error',
                  typeNamePlural: 'Trazabilidad de errores',
                  title: { type: #STANDARD, value: 'EtapaTexto' },
                  description: { type: #STANDARD, value: 'Mensaje' } }
@UI.presentationVariant: [{ sortOrder: [{ by: 'CreatedAt', direction: #DESC }],
                            visualizations: [{ type: #AS_LINEITEM }] }]
annotate entity ZC_CON_MIX_LOG with
{
  @UI.facet: [{ id: 'Detalle', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE,
                label: 'Detalle del error', position: 10 }]
  @UI.hidden: true
  LogUuid;

  @UI.hidden: true
  ZcontConsec;

  @UI.hidden: true
  ExecUuid;

  @UI.hidden: true
  MsgSeq;

  @UI.hidden: true
  Etapa;

  @UI.lineItem:       [{ position: 10, importance: #HIGH }]
  @UI.identification: [{ position: 10 }]
  CreatedAt;

  @UI.lineItem:       [{ position: 20, importance: #HIGH, criticality: 'Criticidad' }]
  @UI.identification: [{ position: 20, criticality: 'Criticidad' }]
  EtapaTexto;

  @UI.lineItem:       [{ position: 30, importance: #MEDIUM }]
  @UI.identification: [{ position: 30 }]
  Ebeln;

  @UI.lineItem:       [{ position: 40, importance: #LOW }]
  @UI.identification: [{ position: 40 }]
  Ebelp;

  @UI.lineItem:       [{ position: 50, importance: #HIGH }]
  @UI.identification: [{ position: 50 }]
  Mensaje;

  @UI.lineItem:       [{ position: 60, importance: #LOW }]
  @UI.identification: [{ position: 60 }]
  Msgid;

  @UI.lineItem:       [{ position: 70, importance: #LOW }]
  @UI.identification: [{ position: 70 }]
  Msgno;

  @UI.identification: [{ position: 80 }]
  Msgty;

  @UI.lineItem:       [{ position: 80, importance: #LOW }]
  @UI.identification: [{ position: 90 }]
  Jobname;

  @UI.hidden: true
  Jobcount;

  @UI.identification: [{ position: 100 }]
  CreatedBy;

  @UI.hidden: true
  Criticidad;
}
