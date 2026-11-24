unmanaged implementation in class ZBP_R_REP_APR_CONT unique;
strict ( 2 );

define behavior for ZR_REP_APR_CONT alias RepAprCont
lock master
authorization master ( instance )
{
  action display_attachment result [1] $self;
  action display_text result [1] $self;
  action display_observations result [1] $self;
  action display_deny_text result [1] $self;

  // NUEVO: ventana con los errores de los jobs (deshabilitada si no hay errores)
  action ( features : instance ) display_errors result [1] $self;

  field ( readonly )
  ZcontConsec,
  Land1,
  Zstatus,
  Konnr,
  Suser,
  Erdat,
  Lifnr,
  Nombre_Proveedor,
  Meins,
  Menge,
  Waers,
  ZprecUni,
  ZprecTot,
  Zaprob1,
  Zpaedat,
  zaprob2,
  Zpaedat2,
  Frgzu,
  Zfrgzu,
  Zfdecline,
  Zuserd,
  Ebeln,
  ConErrores,
  NumErrores,
  ErrorCriticality,
  UltEtapaError,
  UltMensajeError,
  UltFechaError,
  Localcreatedby,
  Localcreatedat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat;
}
