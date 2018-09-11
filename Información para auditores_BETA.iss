Dim var_usuario, var_password, var_oficina, var_oficina1, var_oficina2 
Dim var_fecha_ini, var_fecha_fin

Sub Main

	var_usuario = InputBox("Ingrese el usuario de la BD: ")
	var_password = InputBox("Ingrese la contraseña de la BD: ")

	var_fecha_ini = InputBox("Ingrese la fecha INICIAL en formato AAAAMMDD: ")
	var_fecha_fin = InputBox("Ingrese la fecha FINAL en formato AAAAMMDD: ")
	
	var_oficina = InputBox("Ingrese el número de oficina: ")
	'var_oficina1 = InputBox("Ingrese el nombre de oficina: ")
	var_oficina2 = InputBox("Ingrese el número de la Ventanilla: ")

	
          If var_usuario = "" Or var_password = "" Or var_oficina = "" Or var_oficina <= 0 Or var_fecha_ini = "" Or var_fecha_fin = "" Or var_oficina2 = "" Then
	 
	  MsgBox "TODAS LAS VARIABLES DEBEN TENER UN VALOR VALIDO"
       
          Else
	If var_fecha_fin < var_fecha_ini Then

  	     MsgBox "LA FECHA FINAL DEBE SER MENOR QUE LA INICIAL"
	Else
	
	'-Call ODBCImport01()	'Importar certificaciones de cheques CC_certi_cks.IMD    ESTE YA NO ES NECESARIO SEGUN LA MINUTA
	Call ODBCImport02()	'Importar notas de debito para la certificación de cheques CC_ND_cert_ck.IMD
	'-Call ODBCImport03()	'Importar personalizaciones de cuentas de ahorro AH_personaliza_cta.IMD
	'-Call ODBCImport04()	'Importar personalizaciones de cuentas corrientes CC_personaliza_cta.IMD
	'-Call ODBCImport05()	'Importar tramites saneados  Saneados.IMD
	
		
	Call ODBCImport06()	'Importar movimientos de cuentas de ahorro y corrientes Mov_AHO.IMD	
	Call ODBCImport07()	'Importar movimientos de cuentas de ahorro y corrientes Mov_CTE.IMD	
	
	
	'Call ODBCImport08() 	'Importar modificaciones de tasas de CDPs PF_modif_tasas.IMD
	'Call ODBCImport09()	'Importar ordenes de pago de intereses de CDPs PF_ordenpag_int.IMD
	'Call ODBCImport10()	'Importar liberaciones anticipadas de reservas de cuentas corrientes CC_liber_anti_reser.IMD
	'Call ODBCImport11()	'Importar liberaciones anticipadas de reservas de cuentas de ahorro AH_liber_anti_reser.IMD
	'Call ODBCImport12()	'Importar nuevos firmantes de cuentas de ahorro AH_nuevos_firmantes.IMD
	'Call ODBCImport13()	'Importar nuevos firmantes de cuentas corrientes CC_nuevos_firmantes.IMD
	'Call ODBCImport14()	'Importar pinoración y liberación de CDPs PF_pig_lib.IMD
	'Call ODBCImport15()	'Importar movimientos de cuentas de ahorro y corrientes Mov_AHO_CTE.IMD
	'Call ODBCImport16()	 'Importar clientes nuevos con sus productos EN_cli_new_conprod.IMD
	'Call ODBCImport17()	'Importar sobregiros de cuentas corrientes CC_sobregiros_cta.IMD

					
	MsgBox "FIN DEL PROCESO GENERACION DE INFORMACIÓN"

	End If

       End If
		
End Sub


' Archivo -Asistente de importación: ODBC
' ESTE YA NO ES NECESARIO SEGUN LA MINUTA
Function ODBCImport01
	dbName = "CC_certi_cks_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select 'fecha'=convert(char(10),hm_fecha,103),hm_secuencial,hm_tipo_tran,hm_oficina,hm_usuario,hm_terminal,hm_nodo, hm_cta_banco,hm_cheque,hm_valor,hm_moneda,hm_signo,hm_causa,hm_saldo_contable,hm_saldo_disponible,tn_descripcion from cob_cuentas_his..cc_his_movimiento, cobis..cl_ttransaccion where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hm_oficina = " & var_oficina & " And hm_moneda > 0 And hm_tipo_tran = 55 And hm_tipo_tran = tn_trn_code "
	Client.OpenDatabase (dbName)
End Function


' Archivo -Asistente de importación: ODBC
Function ODBCImport02
	dbName = "CC_ND_cert_ck_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select 'cfecha'=convert(char(10),hm_fecha,103),hm_secuencial,'chm_tipo_tran'=hm_tipo_tran,'chm_oficina'=hm_oficina, 'chm_usuario' =hm_usuario,'chm_terminal'=hm_terminal,'chm_nodo'=hm_nodo,'chm_cta_banco'=hm_cta_banco,'chm_cheque'=hm_cheque, 'chm_valor'=hm_valor,'chm_moneda'=hm_moneda,'chm_signo'=hm_signo,'chm_causa'=hm_causa,'chm_saldo_contable'=hm_saldo_contable, 'chm_saldo_disponible'=hm_saldo_disponible,'ctn_descripcion'=tn_descripcion, cc_cliente,  (Select en_nomlar from cobis..cl_ente where en_ente = cob_cuentas..cc_ctacte.cc_cliente) As nombre, (Select en_subtipo from cobis..cl_ente where en_ente = cob_cuentas..cc_ctacte.cc_cliente) As tipo, (Select max(hm_valor) from cob_cuentas_his..cc_his_movimiento where hm_fecha = A.hm_fecha And hm_oficina = A.hm_oficina And hm_tipo_tran = 55 And hm_cta_banco = A.hm_cta_banco) As hm_valor from cob_cuentas_his..cc_his_movimiento A, cob_cuentas..cc_ctacte, cobis..cl_ttransaccion where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hm_oficina in (" & var_oficina & ", " & var_oficina2 & ") And hm_moneda > 0 And hm_tipo_tran =50 And hm_cta_banco = cc_cta_banco And hm_causa = '9' And hm_tipo_tran = tn_trn_code "
	Client.OpenDatabase (dbName)
End Function


' Archivo -Asistente de importación: ODBC
Function ODBCImport03
	dbName = "AH_personaliza_cta_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select ah_cta_banco, ah_moneda, ah_cliente, ah_nombre, ah_estado, convert(varchar(12),ts_fecha,103) as ts_fecha, ts_tipo_transaccion, tn_descripcion, ts_valor_con, ts_tipo_variacion, ts_oficina, ts_usuario, ts_terminal, vs_descripcion, tr_descripcion, pf_descripcion, (Select en_preferen from cobis..cl_ente where en_ente = A.ah_cliente) As preferencial from cob_ahorros..ah_cuenta A, cob_remesas..pe_tran_servicio B, cobis..cl_ttransaccion C, cob_remesas..pe_servicio_per D, cob_remesas..pe_var_servicio E, cob_remesas..pe_tipo_rango F, cob_remesas..pe_pro_final G where A.ah_cuenta = B.ts_codigo And B.ts_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And B.ts_tipo_transaccion = C.tn_trn_code And B.ts_oficina = " & var_oficina & " And B.ts_servicio_per = D.sp_servicio_per And D.sp_servicio_dis = E.vs_servicio_dis And D.sp_rubro = E.vs_rubro And D.sp_tipo_rango = F.tr_tipo_rango And B.ts_pro_final = G.pf_pro_final And A.ah_cta_banco In (Select ah_cta_banco from cob_ahorros..ah_cuenta where ah_estado <> 'C' And ah_personalizada = 'S') "
	Client.OpenDatabase (dbName)
End Function


' Archivo -Asistente de importación: ODBC
Function ODBCImport04
	dbName = "CC_personaliza_cta_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select cc_cta_banco, cc_moneda, cc_cliente, cc_nombre, cc_estado, convert(varchar(12),ts_fecha,103) as ts_fecha, ts_tipo_transaccion, tn_descripcion, ts_valor_con, ts_tipo_variacion, ts_oficina, ts_usuario, ts_terminal, vs_descripcion, tr_descripcion, pf_descripcion, (Select en_preferen from cobis..cl_ente where en_ente = A.cc_cliente) As preferencial from cob_cuentas..cc_ctacte A, cob_remesas..pe_tran_servicio B, cobis..cl_ttransaccion C, cob_remesas..pe_servicio_per D, cob_remesas..pe_var_servicio E, cob_remesas..pe_tipo_rango F, cob_remesas..pe_pro_final G where A.cc_ctacte = B.ts_codigo And B.ts_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And B.ts_tipo_transaccion = C.tn_trn_code And B.ts_oficina = " & var_oficina & " And B.ts_servicio_per = D.sp_servicio_per And D.sp_servicio_dis = E.vs_servicio_dis And D.sp_rubro = E.vs_rubro And D.sp_tipo_rango = F.tr_tipo_rango And B.ts_pro_final = G.pf_pro_final And A.cc_cta_banco In (Select cc_cta_banco from cob_cuentas..cc_ctacte where cc_estado <> 'C' And cc_personalizada = 'S') "
	Client.OpenDatabase (dbName)
End Function


' Archivo -Asistente de importación: ODBC
Function ODBCImport05
	dbName = "Saneados_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select *, (select fu_nombre from cobis..cl_funcionario where fu_funcionario = cob_cartera..ca_operacion.op_oficial)as name_op_oficial from cob_cartera..ca_transaccion, cob_cartera..ca_det_trn,cob_cartera..ca_operacion where tr_operacion=dtr_operacion and tr_operacion= op_operacion and tr_secuencial=dtr_secuencial and tr_estado in ('CON','ING') and tr_tran in ('CCCNS') and tr_fecha_mov between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' and dtr_concepto in ('CAP') and tr_toperacion in ('805') and tr_ofi_oper in  (" & var_oficina & ", " & var_oficina2 & ")"
	Client.OpenDatabase (dbName)
End Function




' Archivo -Asistente de importación: ODBC
Function ODBCImport06
	dbName = "Mov_AH_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select hm_cta_banco, ah_tipocta, 'FECHA' = convert(varchar(12), hm_fecha,103),hm_tipo_tran,tn_descripcion, hm_correccion,hm_valor,hm_signo,hm_moneda,hm_efectivo,hm_causa,hm_saldo_contable, hm_saldo_disponible,hm_ctadestino, (case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then (select ah_nombre from cob_ahorros..ah_cuenta where ah_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) else '' end) as name_ctaahodestino, (case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then (select cc_nombre from cob_cuentas..cc_ctacte where cc_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) else '' end) as name_ctactedestino,	(case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then (select ah_cliente from cob_ahorros..ah_cuenta where ah_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) else 0 end) as codcliente_ctaahodestino, (case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then (select cc_cliente from cob_cuentas..cc_ctacte where cc_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) else 0 end) as codcliente_ctactedestino, hm_tipo_xfer,hm_concepto, 'HORA' = convert(varchar(8), hm_hora, 8),hm_usuario,hm_terminal,hm_nodo, hm_transaccion,	hm_serial,hm_secuencial, hm_oficina_cta,hm_oficina,ah_cliente, en_ced_ruc as cedula_cliente, ah_nombre,hm_chq_propios,hm_chq_locales,hm_chq_ot_plazas, (select tr_id from cob_externos..ex_transacciones where tr_fecha = cob_ahorros_his..ah_his_movimiento.hm_fecha and tr_producto > 0 and tr_codigo_tran > 0 and tr_oficina = cob_ahorros_his..ah_his_movimiento.hm_oficina and tr_ssn = cob_ahorros_his..ah_his_movimiento.hm_ssn_branch and tr_rol = 'G') as cedula_gestor, (select tr_nombre from cob_externos..ex_transacciones where tr_fecha = cob_ahorros_his..ah_his_movimiento.hm_fecha and tr_producto > 0 and tr_codigo_tran > 0 and tr_oficina = cob_ahorros_his..ah_his_movimiento.hm_oficina and tr_ssn = cob_ahorros_his..ah_his_movimiento.hm_ssn_branch and tr_rol = 'G') as nombre_gestor from cob_ahorros_his..ah_his_movimiento, cobis..cl_ttransaccion, cob_ahorros..ah_cuenta, cobis..cl_ente where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' and hm_oficina in (" & var_oficina & ", " & var_oficina2 & ") and hm_moneda in (1, 3) and hm_tipo_tran *= tn_trn_code and hm_transaccion > 0 and hm_cta_banco = ah_cta_banco and hm_prod_banc <> 11 and ah_cliente = en_ente and not ah_cliente in (select ef_ente from cobis..cl_relacion_ente_func where ef_ente = cob_ahorros..ah_cuenta.ah_cliente)"
	Client.OpenDatabase (dbName)
End Function


' Archivo -Asistente de importación: ODBC
Function ODBCImport07
	dbName = "Mov_CTE_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select hm_cta_banco, 'FECHA' = convert(varchar(12), hm_fecha,103),hm_tipo_tran,tn_descripcion, 	    hm_correccion,hm_valor,hm_signo,hm_moneda,hm_efectivo,hm_causa,hm_saldo_contable, 	    hm_saldo_disponible,hm_ctadestino, 	    (case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then  	(select max(ah_nombre) from cob_ahorros..ah_cuenta where ah_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) 		else '' end) as name_ctaahodestino,		(case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then 			(select max(cc_nombre) from cob_cuentas..cc_ctacte where cc_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) 		else '' end) as codcliente_ctactedestino,				(case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then 			(select max(ah_cliente) from cob_ahorros..ah_cuenta where ah_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) 		else 0 end) as codclidest_ctaahodestino,		(case when hm_tipo_tran in (300,2627,294,2626,237,239,2520,26063,18305,2519) then 			(select max(cc_cliente) from cob_cuentas..cc_ctacte where cc_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) 		else 0 end) as codclidest_ctactedestino,	 hm_tipo_xfer,hm_concepto,	   hm_tipo_xfer,hm_concepto,  'HORA' = convert(varchar(8), hm_hora, 8),hm_usuario,hm_terminal,hm_nodo,   hm_transaccion,hm_serial,hm_secuencial,hm_oficina_cta,hm_oficina,cc_cliente, en_ced_ruc as cedula_cliente, cc_nombre,hm_chq_propios,hm_chq_locales,hm_chq_ot_plazas, (select max(tr_id) from cob_externos..ex_transacciones where tr_fecha = cob_cuentas_his..cc_his_movimiento.hm_fecha and tr_producto > 0 and tr_codigo_tran > 0     and tr_oficina = cob_cuentas_his..cc_his_movimiento.hm_oficina and tr_ssn = cob_cuentas_his..cc_his_movimiento.hm_ssn_branch and tr_rol = 'G') as cedula_gestor,  (select max(tr_nombre) from cob_externos..ex_transacciones where tr_fecha = cob_cuentas_his..cc_his_movimiento.hm_fecha and tr_producto > 0 and tr_codigo_tran > 0   and tr_oficina = cob_cuentas_his..cc_his_movimiento.hm_oficina and tr_ssn = cob_cuentas_his..cc_his_movimiento.hm_ssn_branch and tr_rol = 'G') as nombre_gestor   from cob_cuentas_his..cc_his_movimiento (Index cc_his_movimiento_1), cobis..cl_ttransaccion, cob_cuentas..cc_ctacte (Index i_cc_servicio), cobis..cl_ente   where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "'	and hm_oficina in (" & var_oficina & ", " & var_oficina2 & ")  and hm_moneda in (1, 3)        and hm_tipo_tran *= tn_trn_code   and hm_transaccion > 0   and hm_cta_banco =cc_cta_banco   and cc_cliente = en_ente"
	Client.OpenDatabase (dbName)
End Function






' Archivo -Asistente de importación: ODBC
Function ODBCImport08
	dbName = "PF_modif_tasas_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select hi_operacion, hi_secuencial,'fecha'= convert(varchar(12), hi_fecha, 103), hi_trn_code, tn_trn_code,hi_valor,op_descripcion As nombre_cliente, hi_oficina,hi_observacion,hi_total_int_estimado, hi_total_int_ganado,hi_tasa_ant,'fecha_crea'= convert(varchar(12), hi_fecha_crea, 103),hi_fecha_mod,op_ente,op_num_banco,op_estado,op_oficina, op_moneda,op_monto,op_fpago, op_tasa As tasa_negociada, op_tasa_mer As tasa_vigente, op_num_dias, op_historia, op_renovaciones, op_num_prorroga, 'op_fecha_ven' = convert(varchar(12), op_fecha_ven, 103), 'op_fecha_cancela' = convert(varchar(12), op_fecha_cancela, 103), 'op_fecha_ingreso' = convert(varchar(12), op_fecha_ingreso, 103), 'op_fecha_crea' = convert(varchar(12), op_fecha_crea, 103), tn_descripcion, 'forma pago' = (select mm_producto from cob_pfijo..pf_mov_monet where mm_operacion = cob_pfijo..pf_historia.hi_operacion And mm_tran = 14903 And mm_sub_secuencia = 1 And mm_estado = 'A'), 'cuenta pago' = (select mm_cuenta from cob_pfijo..pf_mov_monet where mm_operacion = cob_pfijo..pf_historia.hi_operacion And mm_tran = 14903 And mm_sub_secuencia = 1 And mm_estado = 'A'), op_monto, hi_funcionario, 'solicitante'=(case when op_tasa >= op_tasa_mer Then (Select nt_usr_solic from cob_pfijo..pf_neg_tasa where nt_operacion = cob_pfijo..pf_historia.hi_operacion And nt_fecha_solicitud = cob_pfijo..pf_historia.hi_fecha) Else '' end), 'autoriza'= (case when op_tasa >= op_tasa_mer Then (Select nt_usr_decid from cob_pfijo..pf_neg_tasa where nt_operacion = cob_pfijo..pf_historia.hi_operacion And nt_fecha_solicitud = cob_pfijo..pf_historia.hi_fecha) Else '' end), 'tasa_original'= (select nt_tasa_original from cob_pfijo..pf_neg_tasa where nt_operacion = cob_pfijo..pf_historia.hi_operacion And nt_fecha_solicitud = cob_pfijo..pf_historia.hi_fecha), 'tasa_propuesta'= (select nt_tasa_propuesta from cob_pfijo..pf_neg_tasa where nt_operacion = cob_pfijo..pf_historia.hi_operacion And nt_fecha_solicitud = cob_pfijo..pf_historia.hi_fecha), 'tasa_autorizada'= (select nt_tasa_autorizada from cob_pfijo..pf_neg_tasa where nt_operacion = cob_pfijo..pf_historia.hi_operacion And nt_fecha_solicitud = cob_pfijo..pf_historia.hi_fecha) from cob_pfijo..pf_historia, cob_pfijo..pf_operacion, cobis..cl_ttransaccion where op_operacion = hi_operacion And tn_trn_code = hi_trn_code And hi_fecha_crea between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hi_trn_code In (14902, 14916,14917,14911,12959,14903,14307) And hi_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport09
	dbName = "PF_ordenpag_int_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select mm_tran,tn_descripcion,mm_producto, op_descripcion as nombre_cliente, 'fecha_aplicacion' = convert(varchar(12),mm_fecha_aplicacion,103), 'fecha_crea' = convert(varchar(12),mm_fecha_crea,103), 'fecha_real'= convert(varchar(12),mm_fecha_real,103), mm_valor,mm_beneficiario,mm_impuesto,mm_moneda,mm_oficina,op_ente, op_num_banco,op_estado,op_oficina,op_moneda,op_monto,op_tasa, 'op_fecha_ven' = convert(varchar(12), op_fecha_ven, 103), 'op_fecha_cancela' = convert(varchar(12), op_fecha_cancela, 103), 'op_fecha_ingreso' = convert(varchar(12), op_fecha_ingreso, 103), 'op_fecha_crea' = convert(varchar(12), op_fecha_crea, 103), op_fpago, 'tiene_cta_aho' = (select max(ah_cta_banco) from cob_ahorros..ah_cuenta where ah_cliente = cob_pfijo..pf_operacion.op_ente and ah_moneda = cob_pfijo..pf_operacion.op_moneda and ah_estado <> 'C'), 'tiene_cta_cte' = (select max(cc_cta_banco) from cob_cuentas..cc_ctacte where cc_cliente = cob_pfijo..pf_operacion.op_ente and cc_moneda = cob_pfijo..pf_operacion.op_moneda and cc_estado <> 'C') from cob_pfijo..pf_mov_monet, cob_pfijo..pf_operacion, cobis..cl_ttransaccion where mm_operacion=op_operacion And tn_trn_code=mm_tran And mm_tran=14905 And mm_producto In ('EFECT','CKGER') And mm_fecha_crea between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And mm_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport10
	dbName = "CC_liber_anti_reser_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select 'CUENTA'  = substring(hs_cta_banco, 1, 15), 'COD CLIE' = cc_cliente,'CLIENTE'= cc_nombre,'CONTRATO' = hs_default, 'TIPO SOBR'  = hs_tipo, 'FECHA AUT'  = convert(varchar(12),hs_fecha,103),'MONTO AUT' = hs_valor, 'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),'MONTO USO' = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),'USUARIO' = substring(hs_usuario, 1, 15), 'TERMINAL' = substring(hs_terminal, 1, 15), 'SECUENCIAL'  = hs_secuencial,'ALT' = hs_cod_alterno, 'FECHA' = convert(varchar(10),hs_tsfecha,103),'HORA' = convert(varchar(8), hs_hora, 8), 'AGENCIA' = hs_oficina, 'MONEDA' = hs_moneda,'TIPO TRN' = hs_tipo_transaccion,'DESCRIPCION TRANSACCION' = tn_descripcion, 'OFICINA' = cc_oficina from cob_cuentas_his..cc_his_servicio, cob_cuentas..cc_ctacte, cobis..cl_ttransaccion where hs_tsfecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hs_oficina = " & var_oficina & " And hs_moneda > 0 And hs_tipo_transaccion = tn_trn_code And hs_tipo_transaccion In (332,2812,404,403) And hs_cta_banco=cc_cta_banco And ((hs_secuencial > 0) Or (hs_secuencial = 0 And hs_cod_alterno > 0))  "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport11
	dbName = "AH_liber_anti_reser_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select 'CUENTA' = substring(hs_cta_banco, 1, 15),'COD CLIE'= ah_cliente,'CLIENTE'= ah_nombre,'CONTRATO'= hs_default, 'TIPO SOBR'  = hs_tipo, 'FECHA AUT' = convert(varchar(12),hs_fecha,103), 'MONTO AUT'= hs_valor, 'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103), 'MONTO USO' = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103), 'USUARIO' = substring(hs_usuario, 1, 15), 'TERMINAL'   = substring(hs_terminal, 1, 15),'SECUENCIAL' = hs_secuencial,'ALT' = hs_cod_alterno, 'FECHA' = convert(varchar(10),hs_tsfecha,103),'HORA' = convert(varchar(8), hs_hora, 8), 'AGENCIA' = hs_oficina,'MONEDA'= hs_moneda,'TIPO TRN'= hs_tipo_transaccion, 'DESCRIPCION TRANSACCION' = tn_descripcion,'OFICINA' = ah_oficina from cob_ahorros_his..ah_his_servicio, cob_ahorros..ah_cuenta, cobis..cl_ttransaccion where hs_tsfecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hs_oficina = " & var_oficina & " And hs_moneda > 0 And hs_tipo_transaccion = tn_trn_code And hs_tipo_transaccion In (332,2812,404,403) And hs_cta_banco=ah_cta_banco And ((hs_secuencial   > 0) Or (hs_secuencial = 0 And hs_cod_alterno > 0)) "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport12
	dbName = "AH_nuevos_firmantes_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select  im_fecha_reg, im_fecha_autorizada, im_autorizada, im_ente, ah_cliente, ah_nombre, im_oficina, cb_producto, cb_cuenta, ah_moneda, ah_fecha_aper, ah_estado, cb_condicion, cb_imagen, im_subtipo, im_operador from firmas..fi_combinacion, firmas..fi_imagen, cob_ahorros..ah_cuenta where cb_producto = 'AHO' And cb_imagen = im_secuencial And cb_cuenta = ah_cta_banco And im_fecha_reg between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And im_fecha_reg <> ah_fecha_aper And im_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport13
	dbName = "CC_nuevos_firmantes_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select  im_fecha_reg, im_fecha_autorizada, im_autorizada, im_ente, cc_cliente, cc_nombre, im_oficina, cb_producto, cb_cuenta, cc_moneda, cc_fecha_aper, cc_estado, cb_condicion, cb_imagen, im_subtipo, im_operador from firmas..fi_combinacion, firmas..fi_imagen, cob_cuentas..cc_ctacte where cb_producto = 'CTE' And cb_imagen = im_secuencial And cb_cuenta = cc_cta_banco And im_fecha_reg between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And im_fecha_reg <> cc_fecha_aper And im_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
' mm_tran in (14107, 14307)	-- (14107 Pignorado, 14307 Liberado)
Function ODBCImport14
	dbName = "PF_pig_lib_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select op_num_banco, op_operacion, op_ente, op_toperacion, op_categoria, op_estado, op_oficina, op_moneda, op_num_dias, op_monto, op_pignorado, op_oficial, op_descripcion, mm_operacion, mm_tran, convert(varchar(12),mm_fecha_crea,103) As mm_fecha_crea, mm_cuenta, mm_producto, mm_oficina As oficina_mov, tn_descripcion from cob_pfijo..pf_operacion, cob_pfijo..pf_mov_monet, cobis..cl_ttransaccion  where op_operacion = mm_operacion And mm_tran In (14107, 14307) And mm_tran = tn_trn_code And mm_fecha_crea between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And mm_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
Function ODBCImport15
	dbName = "Mov_AHO_CTE_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select hm_cta_banco,'FECHA' = convert(varchar(12), hm_fecha,103),hm_tipo_tran, tn_descripcion,hm_correccion,hm_valor,hm_signo, hm_moneda, hm_efectivo, hm_causa, (Case when hm_signo = 'C' then (Select A.valor from cobis..cl_catalogo A inner join cobis..cl_tabla B On B.codigo = A.tabla where B.tabla In ('ah_causa_nc') And A.codigo = cob_ahorros_his..ah_his_movimiento.hm_causa) Else (Select A.valor from cobis..cl_catalogo A inner join cobis..cl_tabla B On B.codigo = A.tabla where B.tabla In ('ah_causa_nd') And A.codigo = cob_ahorros_his..ah_his_movimiento.hm_causa) End) As valor, hm_saldo_contable,hm_saldo_disponible,hm_ctadestino, (Case when Len(hm_ctadestino) = 10 Then (Select ah_nombre from cob_ahorros..ah_cuenta (index ah_cuenta_Key) where ah_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) Else '' end) as name_ctaahodestino, (Case when Len(hm_ctadestino) = 10 Then (Select max(ah_cliente) from cob_ahorros..ah_cuenta (index ah_cuenta_Key) where ah_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) Else 0 End) As codcli_ctaahodestino, (Case when Len(hm_ctadestino) = 10 Then (Select cc_nombre from cob_cuentas..cc_ctacte (index cc_ctacte_Key) where cc_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) Else '' end) as name_ctactedestino, (Case when Len(hm_ctadestino) = 10 Then (Select cc_cliente from cob_cuentas..cc_ctacte (index cc_ctacte_Key) where cc_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) Else 0 End) As codcli_ctactedestino, hm_tipo_xfer,hm_concepto, 'HORA' = convert(varchar(8), hm_hora, 8), hm_usuario,hm_terminal,hm_nodo, hm_transaccion, hm_serial, (Select op_nombre from cob_cartera..ca_operacion (index ca_operacion_2) where op_banco = cob_ahorros_his..ah_his_movimiento.hm_serial) As nombrecredito, (Select op_cliente from cob_cartera..ca_operacion (index ca_operacion_2) where op_banco = cob_ahorros_his..ah_his_movimiento.hm_serial) As codcli_credito, (Select nombre_tarjeta from cob_cartera..ca_cdr_tar_tarjetas (index idx_tarjeta) where tarjeta = cob_ahorros_his..ah_his_movimiento.hm_serial) As nombre_tc, (Select en_ente from cobis..cl_ente (index ien_ente) where en_ced_ruc In (Select cedula from cob_cartera..ca_cdr_tar_tarjetas (index idx_tarjeta) where tarjeta = cob_ahorros_his..ah_his_movimiento.hm_serial)) As codcli_tc, (Select ta_nombre_tarjeta from cob_atm..tm_tarjeta (index i_ta_codigo) where ta_codigo = cob_ahorros_his..ah_his_movimiento.hm_serial) As nombre_td, (Select ta_cliente from cob_atm..tm_tarjeta (index i_ta_codigo) where ta_codigo = cob_ahorros_his..ah_his_movimiento.hm_serial) As codcli_td, hm_secuencial,hm_oficina_cta, hm_oficina, en_ente, en_nomlar,en_tipo_vinculacion,hm_chq_propios,hm_chq_locales,hm_chq_ot_plazas from cob_ahorros_his..ah_his_movimiento (index ah_his_movimiento_1), cobis..cl_ttransaccion (index cl_ttransaccion_Key), cob_ahorros..ah_cuenta (index ah_cuenta_Key), cobis..cl_ente (index ien_ente) where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hm_oficina = " & var_oficina & " And hm_moneda > 0 And hm_tipo_tran = tn_trn_code And hm_cta_banco = ah_cta_banco And hm_usuario <> 'sa' And ah_cliente = en_ente UNION Select hm_cta_banco,'FECHA' = convert(varchar(12), hm_fecha,103),hm_tipo_tran, tn_descripcion, hm_correccion,hm_valor,hm_signo,hm_moneda,hm_efectivo,hm_causa, (Case when hm_signo = 'C' then (Select A.valor from cobis..cl_catalogo A inner join cobis..cl_tabla B On B.codigo = A.tabla where B.tabla In ('cc_causa_nc') And A.codigo = cob_cuentas_his..cc_his_movimiento.hm_causa) Else (Select A.valor from cobis..cl_catalogo A inner join cobis..cl_tabla B On B.codigo = A.tabla where B.tabla In ('cc_causa_nd') And A.codigo = cob_cuentas_his..cc_his_movimiento.hm_causa) End) As valor, hm_saldo_contable,hm_saldo_disponible,hm_ctadestino, (Case when Len(hm_ctadestino) = 10 Then (Select ah_nombre from cob_ahorros..ah_cuenta (index ah_cuenta_Key) where ah_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) Else '' end) as name_ctaahodestino, (Case when Len(hm_ctadestino) = 10 Then (Select  ah_cliente from cob_ahorros..ah_cuenta (index ah_cuenta_Key) where ah_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) Else 0 End) As codcli_ctaahodestino, (Case when Len(hm_ctadestino) = 10 Then (Select cc_nombre from cob_cuentas..cc_ctacte (index cc_ctacte_Key) where cc_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) Else '' end) as name_ctactedestino, (Case when Len(hm_ctadestino) = 10 Then (Select cc_cliente from cob_cuentas..cc_ctacte (index cc_ctacte_Key) where cc_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) Else 0 End) As codcli_ctactedestino, hm_tipo_xfer,hm_concepto, 'HORA' = convert(varchar(8), hm_hora, 8),hm_usuario,hm_terminal,hm_nodo, hm_transaccion,hm_serial, (Select op_nombre from cob_cartera..ca_operacion (index ca_operacion_2) where op_banco = cob_cuentas_his..cc_his_movimiento.hm_serial) As nombrecredito, (Select op_cliente from cob_cartera..ca_operacion (index ca_operacion_2) where op_banco = cob_cuentas_his..cc_his_movimiento.hm_serial) As codcli_credito, (Select nombre_tarjeta from cob_cartera..ca_cdr_tar_tarjetas (index idx_tarjeta) where tarjeta = cob_cuentas_his..cc_his_movimiento.hm_serial) As nombre_tc, (Select en_ente from cobis..cl_ente (index ien_ente) where en_ced_ruc In (Select cedula from cob_cartera..ca_cdr_tar_tarjetas (index idx_tarjeta) where tarjeta = cob_cuentas_his..cc_his_movimiento.hm_serial)) As codcli_tc, (Select ta_nombre_tarjeta from cob_atm..tm_tarjeta (index i_ta_codigo) where ta_codigo = cob_cuentas_his..cc_his_movimiento.hm_serial) As nombre_td, (Select ta_cliente from cob_atm..tm_tarjeta (index i_ta_codigo) where ta_codigo = cob_cuentas_his..cc_his_movimiento.hm_serial) As codcli_td, hm_secuencial,hm_oficina_cta,hm_oficina,en_ente, en_nomlar,en_tipo_vinculacion,hm_chq_propios,hm_chq_locales,hm_chq_ot_plazas from cob_cuentas_his..cc_his_movimiento (index cc_his_movimiento_1),cobis..cl_ttransaccion (index cl_ttransaccion_Key), cob_cuentas..cc_ctacte (index cc_ctacte_Key),cobis..cl_ente (index ien_ente) where hm_fecha between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And hm_oficina = " & var_oficina & " And hm_moneda > 0 And hm_tipo_tran = tn_trn_code And hm_cta_banco =cc_cta_banco And hm_usuario <> 'sa' And cc_cliente = en_ente  "
	Client.OpenDatabase (dbName)
End Function

' Archivo -Asistente de importación: ODBC
' Solo devuelve una cuenta cuando el cliente tiene mas de una del mismo producto
Function ODBCImport16
	dbName = "EN_cli_new_conprod_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select en_ente, en_nomlar, en_ced_ruc, en_oficina, convert(varchar(12),en_fecha_crea,103) As en_fecha_crea, (Select count(1)  from cob_ahorros..ah_cuenta where cob_ahorros..ah_cuenta.ah_cliente = cobis..cl_ente.en_ente) As Ctas_Ah, (Select max(ah_cta_banco) 	from cob_ahorros..ah_cuenta where cob_ahorros..ah_cuenta.ah_cliente = cobis..cl_ente.en_ente) As Num_cta_Ah, (Select count(1) from cob_cuentas..cc_ctacte where cob_cuentas..cc_ctacte.cc_cliente = cobis..cl_ente.en_ente) As Ctas_Cte, (Select max(cc_cta_banco) from cob_cuentas..cc_ctacte where cob_cuentas..cc_ctacte.cc_cliente = cobis..cl_ente.en_ente) As Num_cta_Cte, (Select count(1) from cob_pfijo..pf_operacion where cob_pfijo..pf_operacion.op_ente = cobis..cl_ente.en_ente) As CDPs, (Select max(op_num_banco) from cob_pfijo..pf_operacion where cob_pfijo..pf_operacion.op_ente = cobis..cl_ente.en_ente) As Num_CDP, (Select count(1) from cob_cartera..ca_operacion where cob_cartera..ca_operacion.op_cliente = cobis..cl_ente.en_ente) As Ctas_cartera, (Select max(op_banco) from cob_cartera..ca_operacion where cob_cartera..ca_operacion.op_cliente = cobis..cl_ente.en_ente) As Num_Cartera from cobis..cl_ente where en_fecha_crea between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And en_oficina = " & var_oficina & " "
	Client.OpenDatabase (dbName)
End Function



' Archivo -Asistente de importación: ODBC
' sb_tipo:
' --C: Contratado
' --O: Ocasional
' --L: Sobregiro por Liberaci=n de Reserva local
' --R: Sobregiro por Liberaci=n de Reserva del exterior
Function ODBCImport17
	dbName = "CC_sobregiros_cta_" & var_oficina2 &"_" & var_oficina & "_"& var_fecha_ini & "_" & var_fecha_fin &".IMD"
	Client.ImportODBCFile " dbo . rs_threads ", dbName, FALSE, ";DSN=REMOTO;UID=" & var_usuario & ";PWD=" & var_password & ";NA=192.168.11.119,4100;DB=cob_sbancarios", "select cc_cta_banco, cc_cliente, cc_nombre, cc_estado, cc_moneda, sb_tipo, sb_contrato, convert(varchar(12),sb_fecha_aut,103) as sb_fecha_aut, sb_monto_aut, convert(varchar(12),sb_fecha_ven,103)As sb_fecha_ven, sb_filial, sb_oficina, sb_autorizante, fu_nombre, sb_especial from cob_cuentas..cc_sobregiro, cob_cuentas..cc_ctacte, cobis..cl_funcionario where sb_cuenta = cc_ctacte And sb_fecha_ven between '" & var_fecha_ini & "' and '" & var_fecha_fin & "' And sb_oficina = " & var_oficina & " And sb_autorizante = fu_login "
	Client.OpenDatabase (dbName)
End Function