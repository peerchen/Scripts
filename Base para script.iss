Begin Dialog dlgImport 0,10,175,119,"Auditoría Interna-Generación de muestra", .NewDialog
  Text 11,14,34,7, "Usuario", .Text3
  TextBox 90,14,65,10, .txtUserName
  Text 11,26,36,9, "Contraseña", .Text4
  TextBox 90,25,65,10, .txtPassword, 32
  Text 9,58,73,9, "Fecha_Procesamiento", .Text5
  TextBox 90,56,65,10, .txtInitialDate
  OKButton 12,81,65,14, "OK", .OKButton1
  CancelButton 89,81,66,14, "Cancel", .CancelButton1
  GroupBox 4,2,156,38, "Inicio de Sesión", .GroupBox1
  GroupBox 4,46,156,31, "Datos de muestra", .GroupBox2
End Dialog
'**************************************************************************************************************************************************************
'Script:		Import Sybase
'Date:		28 de Marzo 2017
'Developed By:	Elías Gonzalez - Basado en la idea de Brian Element - ideascripting.com
'Prupose:	Este script reune las consultas para generación de muestra de los auditores financieros, las variables de entrada son alimentadas a través de un
'		objeto dialog, por medio del cual es posible colocar una máscara a la contraseña del usuario. De igual forma en el historial, la contraseña 
'                                queda encriptada. Se respetó la estructura de los scripts originales y se agregaron los comentarios ya existentes.
'**************************************************************************************************************************************************************
Option Explicit
	Dim var_usuario As String
	Dim var_password As String
	Dim var_fecha_ini As String
	Dim exitScript As Boolean
	Dim dbname 

Sub Main
	Call mainMenu()
	If Not exitScript Then
	
		Call CAL_LIQ_REC_CAR()
		Call CAL_CALIF_PROD()
		Call CDP_MTO_VAL ()
		Call CDP_RANGOS ()
		Call CDP_INT_RATE_RISK ()
		
		MsgBox "FIN DEL PROCESO DE GENERACION DE INFORMACION"
	

	End If
End Sub

Function mainMenu()
	Dim dlg As dlgImport
	Dim button As Integer
	Dim exitMenu As Boolean
	exitMenu = FALSE
	Do
		button = Dialog(dlg)  
		If button = 0 Then
			exitScript = True 'cancel button selected
			exitMenu = True
		Else
			'get the variables
			var_usuario = dlg.txtUserName
			var_password= dlg.txtPassword
			var_fecha_ini= dlg.txtInitialDate
			
					'check to make sure the variables have been entered
			If var_usuario = "" Or var_password = ""  Or var_fecha_ini = "" Then
				If var_usuario  = "" Then
					MsgBox "Escriba el usuario"
					
				End If
							If var_password = "" Then
					MsgBox "Escriba la contraseña"
					
				End If
							If var_fecha_ini = "" Then
					MsgBox "Fecha de procesamiento? (AAAAMMDD)"
					
				End If
				
			Else
				'no errors
				exitMenu = TRUE
			End If
		End If
				Loop Until exitMenu
End Function

Function CAL_LIQ_REC_CAR
	dbName = "CALCE_REC_CALC_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID= " & var_usuario & ";PWD= " & var_password &";","Select op_moneda, Case when DateDiff(dd, '" & var_fecha_ini & "', di_fecha_ven) < 0 then '<0' when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 0 and 7 then '0-7D' when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 8 and 15 then '8-15D'    when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 16 and 30 then '16-30D'   when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 31 and 90 then '31-90D'         when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 91 and 180 then '91-180D'       when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) > 180 then '>180D' end as om_nivel, sum(case when op_moneda = 1 then am_cuota + am_gracia - am_pagado else ct_valor * (am_cuota + am_gracia - am_pagado) end ) as deuda, sum(case am_concepto when 'CAP' then (case when op_moneda = 1 then am_cuota + am_gracia - am_pagado else ct_valor * (am_cuota + am_gracia - am_pagado) end) else 0 end) as capital, sum(case am_concepto when 'INT' then (case when op_moneda = 1 then am_cuota + am_gracia - am_pagado else ct_valor * (am_cuota + am_gracia - am_pagado) end) else 0 end) as intereses from cob_cartera..ca_operacion, cob_cartera..ca_dividendo, cob_cartera..ca_amortizacion, cob_cartera..ca_cdr_creditos_his, cob_contanm..cb_cotizacion where cr_fecha_proceso = '" & var_fecha_ini & "' and op_operacion = di_operacion and op_banco = cr_id_credito and di_operacion = am_operacion and di_dividendo = am_dividendo and op_clase_cont = 'N' and op_tipo_rees in ('N','R') -- Normal y reestructurado. and op_estado in (1, 2, 10) and am_concepto in ('CAP','INT') and cr_clasificacion_credito_final < 3 -- Solamente cr‚dito a y b and di_estado < 3 -- no incluye dividendos pagados and ct_empresa =1 and ct_fecha = '" & var_fecha_ini & "' and ct_moneda = 3 --and di_fecha_ven >= '" & var_fecha_ini & "' group by op_moneda, am_concepto, case when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) < 0 then '<0' when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 0 and 7 then '0-7D'  when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 8 and 15 then '8-15D'    when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 16 and 30 then '16-30D'    when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 31 and 90 then '31-90D'          when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) between 91 and 180 then '91-180D'       when datediff(dd, '" & var_fecha_ini & "', di_fecha_ven) > 180 then '>180D' end "
	Client.OpenDatabase (dbName)
End Function

Function CAL_CALIF_PROD
	dbName = "CALCE_CALIF_PROD_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID= "& var_usuario &";PWD=" & var_password &";","selectcr_clasificacion_credito_final, cr_modalidad_credito, cr_moneda_credito, Capital = sum(cr_saldo_cap), Intereses = sum(cr_int_corriente), Int_vencidos = sum(cr_int_vencidos) from cob_cartera..ca_cdr_creditos_his where cr_fecha_proceso = '" & var_fecha_ini &"' and cr_modalidad_credito not in (23,26,31,32,35) and cr_situacion_credito in (1,2,4,5) group by cr_modalidad_credito, cr_moneda_credito,cr_clasificacion_credito_final" 
	Client.OpenDatabase (dbName) 
End Function

Function CDP_MTO_VAL
	dbName = "CDPxMto_Mtto_Val_Sin_BCN_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID=" & var_usuario & ";PWD=  "& var_password &";","Select ac_moneda As om_moneda, casewhen ac_dias_calce between 0 And 7 Then '0-7D' when ac_dias_calce between 8 and 15 then '8-15D' when ac_dias_calce between 16 and 30 then '16-30D' when ac_dias_calce between 31 and 90 then '31-90D' when ac_dias_calce between 91 and 180 then '91-180D' when ac_dias_calce >180 then '>180D' end as Bandas, sum(ac_monto + ac_int_ganado) as total, sum(ac_monto) as Monto, sum(ac_int_ganado) as intereses from cob_pfijo..pf_amortizacion_cdp where ac_num_banco not in (select op_num_banco from cob_pfijo..pf_operacion where op_ente <>2) group by ac_moneda, case when ac_dias_calce between 0 and 7 then '0-7D' when ac_dias_calce between 8 and 15 then '8-15D' when ac_dias_calce between 16 and 30 then '16-30D' when ac_dias_calce between 31 and 90 then '31-90D' when ac_dias_calce between 91 and 180 then '91-180D' when ac_dias_calce >180 then '>180D' end"
	Client.OpenDatabase (dbName)
End Function

Function CDP_RANGOS
	dbName = "CDP_RNG_CRR_BCN_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID= "& var_usuario &";PWD= " & var_password &";","Select ac_moneda As om_moneda, casewhen ac_dias_calce between 0 And 7   Then '0-7D' when ac_dias_calce between 8 and 15  then '8-15D' when ac_dias_calce between 16 and 30  then '16-30D' when ac_dias_calce between 31 and 90  then '31-90D' when ac_dias_calce between 91 and 180  then '91-180D' when ac_dias_calce >180         then '>180D' end as Bandas, sum(ac_monto + ac_int_ganado) as total, sum(ac_monto) as monto, sum(ac_int_ganado) as intereses from cob_pfijo..pf_amortizacion_cdp where ac_num_banco in (select op_num_banco from cob_pfijo..pf_operacion where op_ente = 2) group by ac_moneda,  case when ac_dias_calce between 0 and 7   then '0-7D' when ac_dias_calce between 8 and 15  then '8-15D' when ac_dias_calce between 16 and 30  then '16-30D' when ac_dias_calce between 31 and 90  then '31-90D' when ac_dias_calce between 91 and 180  then '91-180D' when ac_dias_calce >180         then '>180D' end"
	Client.OpenDatabase (dbName)
End Function

Function CDP_INT_RATE_RISK 
	dbName = "CDP_INT_RATE_RISK_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID=" & var_usuario & ";PWD=" & var_password & ";","selectop_reajustable as reajuste, sum(saldoFacturaC) As Saldo, op_moneda As Moneda from cob_cartera..deuda wheretipo_rees In ('NN','NR') And op_estado In (1,2,10) And fecha_proceso = '" & var_fecha_ini & "' And substring(op_cuenta_principal,1,4)In ('1401','1402','1403') group by op_reajustable, op_moneda" 
	Client.OpenDatabase (dbName) 
End Function

Function SAL_CAR_T_FIJA
	dbName = "SAL_CAR_T_FIJA_"& var_fecha_ini &".IMD"
	Client.ImportODBCFile " dbo . asiento_tmp1 ", dbName, FALSE, ";DSN=CDR;NA=192.168.10.176,4100;DB=cob_cartera;UID="& var_usuario &";PWD="& var_password &";", "select op_reajustable as ajustable, op_moneda as moneda, sum(saldoFacturaC) as saldo, case when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) <= 1 then '0-1M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 2 and 3 then '2-3M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 4 and 6 then '4-6M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 7 and 12 then '7-12M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 13 and 24 then '13-24M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 25 And 36 Then '25-36M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 37 and 48 then '37-48M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 49 and 60 then '49-60M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 61 and 84 then '61-84M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 85 and 120 then '85-120M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 121 and 180 then '121-180M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 181 and 240 then '181-240M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) > 240 then '>240M' end as saldos2 from cob_cartera..deuda where tipo_rees in ('NN','NR') and op_estado in (1,2,10) and fecha_proceso = 20170930 and substring(op_cuenta_principal,1,4)in ('1401','1402','1403') and op_reajustable = 'N' group by op_reajustable, op_moneda, case when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) <= 1 then '0-1M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 2 and 3 then '2-3M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 4 and 6 then '4-6M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 7 and 12 then '7-12M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 13 and 24 then '13-24M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 25 and 36 then '25-36M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 37 and 48 then '37-48M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 49 and 60 then '49-60M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 61 and 84 then '61-84M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 85 and 120 then '85-120M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 121 and 180 then '121-180M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) between 181 and 240 then '181-240M' when datediff(mm,(convert(datetime,convert(varchar(10),fecha_proceso,103))),(convert(datetime,convert(varchar(10),fecha_ven_legal_num,103)))) > 240 then '>240M' end "
	Client.OpenDatabase (dbName)
End Function

