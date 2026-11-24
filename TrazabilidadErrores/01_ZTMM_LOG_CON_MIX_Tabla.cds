@EndUserText.label : 'Log de errores contratos mixtos (solo errores)'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmm_log_con_mix {

  key client       : abap.clnt not null;
  key log_uuid     : sysuuid_x16 not null;
  zcont_consec     : zde_cont_consec;
  exec_uuid        : sysuuid_x16;
  msg_seq          : abap.int2;
  etapa            : abap.char(4);
  ebeln            : ebeln;
  ebelp            : ebelp;
  msgty            : symsgty;
  msgid            : symsgid;
  msgno            : symsgno;
  mensaje          : bapi_msg;
  jobname          : btcjob;
  jobcount         : btcjobcnt;
  created_by       : syuname;
  created_at       : timestampl;

}
