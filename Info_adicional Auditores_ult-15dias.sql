----1.	Aperturas recientes de cuentas (ahorro, corriente, CDP).
--1.1. Cta Ahorro aperturas
-- A. AHORRO con la calificacion de riesgo calculada para el cliente (PLD) y si es cuenta pagadora de prâ€šstamos
select convert(varchar(12),ah_fecha_aper,103) as fecha_aper, convert(varchar(12), en_fecha_mod, 103) as fecha_mod_datacliente, 
			convert(varchar(12),ah_fecha_ult_mov,103) as ah_fecha_ult_mov, convert(varchar(12),ah_fecha_ult_mov_int,103) as ah_fecha_ult_mov_int,
			convert(varchar(12),ah_fecha_ult_upd,103) as ah_fecha_ult_upd, convert(varchar(12),ah_fecha_prx_corte,103) as ah_fecha_prx_corte,
			convert(varchar(12),ah_fecha_ult_corte,103) as ah_fecha_ult_corte, convert(varchar(12), ah_fecha_ult_capi, 103) as ah_fecha_ult_capi,
			convert(varchar(12),ah_fecha_prx_capita,103) as ah_fecha_prx_capita, convert(varchar(12), ah_fecha_ult_ret, 103) as ah_fecha_ult_ret, 
cob_ahorros..ah_cuenta.*, 

(select convert(varchar(12),hs_tsfecha,103) from cob_ahorros_his..ah_his_servicio a where hs_cta_banco = cob_ahorros..ah_cuenta.ah_cta_banco and hs_tipo_transaccion = 347) as fecha_activacion,

(select max(op_banco) from cob_cartera..ca_operacion where op_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and op_estado <> 3 and op_clase_cont = 'N') as pagadora,
(select valor from cobis..cl_catalogo where tabla = 1003 and codigo = (select in_proposito from cobis..cl_infocta where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco))) as proposito,
in_ntrandeb = (select in_ntrandeb from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)), 
in_ntrancre = (select in_ntrancre from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_mpromdeb = (select in_mpromdeb from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)), 
in_mpromcre = (select in_mpromcre from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)), 
in_balprome = (select in_balprome from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)), 
in_fecha =    (select convert(varchar(12), in_fecha, 103) from cobis..cl_infocta a where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_ente = cob_ahorros..ah_cuenta.ah_cliente and in_cuenta = cob_ahorros..ah_cuenta.ah_cta_banco),
(select pa_descripcion from cobis..cl_pais where pa_pais = cobis..cl_ente.en_nacionalidad) as nacionalidad, 
(select valor from cobis..cl_catalogo where tabla = 53 and codigo = cobis..cl_ente.p_profesion) as profesion,
(select valor from cobis..cl_catalogo where tabla = 1366 and codigo = cobis..cl_ente.en_actividad) as ocupacion, 
(select valor from cobis..cl_catalogo where tabla = 1373 and convert(int,codigo) = cobis..cl_ente.p_soc_hecho) as actividad, 
(select fp_cargo_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_publico,
(select fp_cargo_oficial from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_oficial,
(select fp_familiar_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as familiar_publico,
(select fp_nombre_fam from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as fp_nombre_fam,
(select fp_notoria_publica from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as notoria_publica,
c_camara as riesgo
from cob_ahorros..ah_cuenta inner join cobis..cl_ente on ah_cliente = en_ente
where ah_oficina in (24)
and ah_prod_banc <> 11 	-- No incluir las ctas de ahorro navideñas
and ah_estado <> 'C'
and ah_fecha_aper between '04/01/2013' and '03/10/2014'



-- 1.2. Cta Corriente aperturas
-- B. CORRIENTE con la calificacion de riesgo calculada para el cliente (PLD) y si es cuenta pagadora de prestamos
select convert(varchar(12),cc_fecha_aper,103) as fecha_aper, convert(varchar(12), en_fecha_mod, 103) as fecha_mod_datacliente, 
			convert(varchar(12),cc_fecha_ult_mov,103) as cc_fecha_ult_mov, convert(varchar(12),cc_fecha_ult_mov_int,103) as cc_fecha_ult_mov_int,
			convert(varchar(12),cc_fecha_ult_upd,103) as cc_fecha_ult_upd, convert(varchar(12), cc_fecha_prx_corte, 103) as cc_fecha_prx_corte,
			convert(varchar(12),cc_fecha_ult_corte,103) as cc_fecha_ult_corte, convert(varchar(12), cc_fecha_ult_capi, 103) as cc_fecha_ult_capi,
			convert(varchar(12),cc_fecha_prx_capita,103) as cc_fecha_prx_capita,
cob_cuentas..cc_ctacte.*, 

(select convert(varchar(12),hs_tsfecha,103) from cob_cuentas_his..cc_his_servicio a where hs_cta_banco = cob_cuentas..cc_ctacte.cc_cta_banco and hs_tipo_transaccion = 2559) as fecha_activacion,

(select max(op_banco) from cob_cartera..ca_operacion where op_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and op_estado <> 3 and op_clase_cont = 'N') as pagadora,
(select valor from cobis..cl_catalogo where tabla = 1003 and codigo = (select in_proposito from cobis..cl_infocta where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco))) as proposito,
in_ntrandeb = (select in_ntrandeb from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_ntrancre = (select in_ntrancre from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_mpromdeb = (select in_mpromdeb from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_mpromcre = (select in_mpromcre from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_balprome = (select in_balprome from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_fecha =    (select convert(varchar(12), in_fecha, 103) from cobis..cl_infocta a where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco and in_secuencial in (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_ente = cob_cuentas..cc_ctacte.cc_cliente and in_cuenta = cob_cuentas..cc_ctacte.cc_cta_banco),
(select pa_descripcion from cobis..cl_pais where pa_pais = cobis..cl_ente.en_nacionalidad) as nacionalidad, 
(select valor from cobis..cl_catalogo where tabla = 53 and codigo = cobis..cl_ente.p_profesion) as profesion,
(select valor from cobis..cl_catalogo where tabla = 1366 and codigo = cobis..cl_ente.en_actividad) as ocupacion, 
(select valor from cobis..cl_catalogo where tabla = 1373 and convert(int,codigo) = cobis..cl_ente.p_soc_hecho) as actividad, 
(select fp_cargo_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_publico,
(select fp_cargo_oficial from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_oficial,
(select fp_familiar_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as familiar_publico,
(select fp_nombre_fam from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as fp_nombre_fam,
(select fp_notoria_publica from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as notoria_publica,
c_camara as riesgo
from cob_cuentas..cc_ctacte inner join cobis..cl_ente on cc_cliente = en_ente
where cc_oficina in (24)
and cc_estado <> 'C'
and cc_fecha_aper between '04/01/2013' and '03/10/2014'



-- 1.3. Plazo Fijo aperturas
-- C. PLAZO FIJO con la calificacion de riesgo calculada para el cliente (PLD)
select convert(varchar(12),op_fecha_crea,103) as fecha_crea, convert(varchar(12), en_fecha_mod, 103) as fecha_mod_datacliente, 
			convert(varchar(12),op_fecha_valor,103) as op_fecha_valor, convert(varchar(12), op_fecha_ven, 103) as op_fecha_ven,
			convert(varchar(12),op_fecha_ingreso,103) as op_fecha_ingreso, convert(varchar(12), op_fecha_pg_int, 103) as op_fecha_pg_int,
			convert(varchar(12),op_fecha_ult_pg_int,103) as op_fecha_ult_pg_int, convert(varchar(12), op_ult_fecha_calculo, 103) as op_ult_fecha_calculo,
			convert(varchar(12),op_fecha_mod,103) as op_fecha_mod, convert(varchar(12), op_fecha_total, 103) as op_fecha_total,
			convert(varchar(12),op_fecven_ant,103) as op_fecven_ant, convert(varchar(12), op_fecha_ord_act, 103) as op_fecha_ord_act,
			convert(varchar(12),op_fecha_real,103) as op_fecha_real, convert(varchar(12), op_fecha_ult_renovacion, 103) as op_fecha_ult_renovacion,
cob_pfijo..pf_operacion.*,
(select valor from cobis..cl_catalogo where tabla = 1003 and codigo = (select in_proposito from cobis..cl_infocta where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = cob_pfijo..pf_operacion.op_num_banco))) as proposito,
in_ntrandeb = (select in_ntrandeb from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_ntrancre = (select in_ntrancre from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_mpromdeb = (select in_mpromdeb from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_mpromcre = (select in_mpromcre from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_balprome = (select in_balprome from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_fecha =    (select convert(varchar(12), in_fecha, 103) from cobis..cl_infocta a where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco and in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_cuenta = a.in_cuenta)),
in_secuencial = (select max(in_secuencial) from cobis..cl_infocta where in_ente = cob_pfijo..pf_operacion.op_ente and in_cuenta = cob_pfijo..pf_operacion.op_num_banco), 
(select pa_descripcion from cobis..cl_pais where pa_pais = cobis..cl_ente.en_nacionalidad) as nacionalidad, 
(select valor from cobis..cl_catalogo where tabla = 53 and codigo = cobis..cl_ente.p_profesion) as profesion,
(select valor from cobis..cl_catalogo where tabla = 1366 and codigo = cobis..cl_ente.en_actividad) as ocupacion, 
(select valor from cobis..cl_catalogo where tabla = 1373 and convert(int,codigo) = cobis..cl_ente.p_soc_hecho) as actividad, 
(select fp_cargo_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_publico,
(select fp_cargo_oficial from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as cargo_oficial,
(select fp_familiar_publico from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as familiar_publico,
(select fp_nombre_fam from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as fp_nombre_fam,
(select fp_notoria_publica from cobis..cl_figura_publica where fp_ente = cobis..cl_ente.en_ente) as notoria_publica,
c_camara as riesgo
from cob_pfijo..pf_operacion inner join cobis..cl_ente on op_ente = en_ente
where op_oficina in (24)
and not op_estado in ('ANU','CAN')
and op_fecha_crea between '04/01/2013' and '03/10/2014'





----2.	Reporte de cuentas canceladas en el período en el cual se pueda ver la forma de pago y el código de cliente del beneficiario de la cancelación (cuando se transfirió a terceros). 
/*  2.1.	Reporte de cuentas de ahorro canceladas en el período, en donde se pueda ver la forma de pago y el código de cliente del beneficiario de la cancelación 
(cuando se transfirió a terceros).*/
 select  hm_cta_banco,
	'FECHA' = convert(varchar(12), hm_fecha,103),en_ced_ruc,
	'No.CLIENTE'= ah_cliente,
	'NOMBRE_CLIENTE'=	ah_nombre,hm_tipo_tran,tn_descripcion,hm_valor,
		(case when hm_signo = 'D' then ISNULL(hm_valor,0) + ISNULL(hm_chq_propios,0) + ISNULL(hm_chq_locales,0) + ISNULL(hm_chq_ot_plazas,0) 
		else 0 end) as debito,                  
		(case when hm_signo = 'C' then ISNULL(hm_valor,0) + ISNULL(hm_chq_propios,0) + ISNULL(hm_chq_locales,0) + ISNULL(hm_chq_ot_plazas,0) 
		else 0 end) as credito,
	hm_moneda,hm_causa,	hm_saldo_contable,hm_saldo_disponible,	hc_forma_pg,hm_ctadestino,
		(case when len(hm_ctadestino) = 10 then 
			(select ah_nombre from cob_ahorros..ah_cuenta where ah_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) 
		else '' end) as name_ctaahodestino,
		(case when len(hm_ctadestino) = 10 then 
			(select cc_nombre from cob_cuentas..cc_ctacte where cc_cta_banco = cob_ahorros_his..ah_his_movimiento.hm_ctadestino) 
		else '' end) as name_ctactedestino,
	hm_concepto,
	'HORA' = convert(varchar(8), hm_hora, 8),hm_transaccion, hm_usuario,
		(select fu_nombre from cobis..cl_funcionario where fu_login = cob_ahorros_his..ah_his_movimiento.hm_usuario) as fu_nombre,
		(select fu_estado from cobis..cl_funcionario where fu_login = cob_ahorros_his..ah_his_movimiento.hm_usuario) as fu_estado,
	of_nombre
from cob_ahorros_his..ah_his_movimiento, cobis..cl_ttransaccion, cob_ahorros..ah_cuenta, cobis..cl_oficina, cobis..cl_ente, cob_ahorros..ah_his_cierre
	where hm_fecha >= '12/01/2013' and hm_fecha <= '03/10/2014'
	and hm_oficina in (24)  
	and hm_oficina = of_oficina
	and hm_tipo_tran = tn_trn_code
	and hm_cta_banco = ah_cta_banco
	and ah_cuenta=hc_cuenta
	and ah_prod_banc <> 11  -- No incluir las ctas de ahorro navideñas 
	and hm_tipo_tran=213 -- cierre de cuentas
	and hc_forma_pg in ('E','C','T','N') -- Forma de Cancelacion E: efectivo, C=cheque, T = transferencia, N=normal que equivale a E)
	and ah_cliente = en_ente
	and ah_estado = 'C' --  cuentas canceladas



--- 2.2 Ctas Ctes canceladas 
select cc_cta_banco, cc_producto, cc_estado, cc_oficina, cc_moneda, cc_fecha_aper, cc_cliente, cc_ced_ruc, cc_nombre, cc_nombre1, hm_tipo_tran, hm_usuario, 
		(select fu_nombre
			 from cobis..cl_funcionario where fu_login = cob_cuentas_his..cc_his_movimiento.hm_usuario) as Nomb_Usuario,
		
		(select cc_cliente 
			from cob_cuentas..cc_ctacte where cc_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) as Cliente_DestCTE,
			
		(select ah_cliente 
			from cob_ahorros..ah_cuenta where ah_cta_banco = cob_cuentas_his..cc_his_movimiento.hm_ctadestino) as Cliente_DestAHO,
		
		hm_valor, hm_ctadestino, hm_fecha 
from cob_cuentas..cc_ctacte, cob_cuentas_his..cc_his_movimiento
where hm_tipo_tran = 50 -- Cierre de cuentas
and cc_cta_banco = hm_cta_banco
and hm_oficina in (24)
--and  hm_ctadestino <> (null)   -- Tiene una cuenta destino
and cc_estado = 'C'
and hm_fecha between '12/01/2013' and '03/10/2014'





----3.	Cancelaciones de CDP.
--.	Cancelaciones de certificados con la forma de pago.
-- Buscar CDP cancelados con su forma de pago y codigo de cliente de la cuenta destino
select *,
--(select max(dp_forma_pago) from cob_pfijo..pf_det_pago where dp_operacion = A.op_operacion and dp_tipo = 'INT' and dp_estado = 'I') as forma_pago,
--(select max(dp_cuenta) from cob_pfijo..pf_det_pago where dp_operacion = A.op_operacion and dp_tipo = 'INT' and dp_estado = 'I') as cuenta
(select max(mm_producto) from cob_pfijo..pf_mov_monet where mm_operacion = A.op_operacion and mm_tran = 14903 and mm_tipo = 'C') as forma_pago,
(select max (mm_cuenta) from cob_pfijo..pf_mov_monet where mm_operacion = A.op_operacion and mm_tran = 14903 and mm_tipo = 'C') as cuenta

from cob_pfijo..pf_operacion A
where op_fecha_cancela between '12/01/2013' and '03/10/2014'
and op_oficina in (24)
-- mm_tran =  14903 CANCELACION DE PLAZO FIJO, mm_tipo=C 
-- forma de pago seria mm_producto, 
---- AGREGAR NUMEROS DE CLIENTES AH, y CTE de donde se cancelo el CDP




----4.	Reporte de emisiones de tarjeta de débito relacionadas (ahorro y corriente).
---- Reporte de emisiones de tarjeta de dTbito.
--- Tarjetas de DEBITO Emitidas con sus cuentas       :ERC 24/AGO/2010 NUEVO -- agregar # cliente: ta_cliente -nrivas 20.09.2010 
select ta_codigo, em_producto, em_moneda, em_cuenta, ta_cliente,ta_nombre_tarjeta,ta_saludo, ta_principal, 		----'em_fecha'=convert(varchar(12), em_fecha,103),
       ta_estado_tarjeta, ta_motivo, ta_comentario_estado, 'ta_fecha_sol'=convert(varchar(12), ta_fecha_sol,103), ta_tipo_sol_org, 
       'ta_fecha_elaboracion'=convert(varchar(12), ta_fecha_elaboracion,103), 'ta_fecha_entregada'=convert(varchar(12), ta_fecha_entregada,103),
       ta_persona_retira, 'ta_fecha_can'=convert(varchar(12), ta_fecha_can,103), 'ta_fecha_expiracion'=convert(varchar(12), ta_fecha_expiracion,103), 
       ta_lugar_primer_mov, 'ta_fecha_primer_mov'=convert(varchar(12), ta_fecha_primer_mov,103), ta_ofi_org, ta_ofi_actual, ta_ofi_ent
from cob_atm..tm_emision, cob_atm..tm_tarjeta
where em_tarjeta = ta_tarjeta 
and ta_fecha_elaboracion between '12/01/2013' and '03/10/2014'
--and ta_lugar_primer_mov like  '%SBERRIOS%'
and ta_ofi_org in (24)  -- Oficina origen





----5.	Reporte de reimpresiones de pin de tarjeta de débito.
----   Reporte de reimpresiones de pin de tarjeta de dTbito. 
---  Tarjetas de DEBITO Reimpresion de PINES        :ERC 24/AGO/2010 NUEVO -- incluir # y nombre de cliente ta_cliente, ta_nombre_tarjeta -nrivas 20.09.2010
--- NRivas 07.02.2012: Agregar tipo de tarjeta
--- -- LG 08.02.2012: Agregar estado de tarjeta, nombre oficina, nombre cliente
select br_numero, br_codigo_tarjeta,
  (select ta_tipo_tarjeta from cob_atm..tm_tarjeta
   where ta_codigo = cob_atm..tm_bitacora_impresion.br_codigo_tarjeta) as tipo_tarjeta,
   
 (select ta_estado_tarjeta from cob_atm..tm_tarjeta where ta_codigo = cob_atm..tm_bitacora_impresion.br_codigo_tarjeta)as estado,  
   
  br_oficina,  (select of_nombre from cobis..cl_oficina where of_oficina = cob_atm..tm_bitacora_impresion.br_oficina)as oficina, 
  br_usuario, 'fecha_reimp' = convert(varchar(12), br_fecha_reimp,103), br_motivo,
 (select valor from cobis..cl_catalogo where tabla = 579 and codigo = cob_atm..tm_bitacora_impresion.br_motivo) 
   as descripcion_motivo,
 (select fu_nombre from cobis..cl_funcionario where fu_login = cob_atm..tm_bitacora_impresion.br_usuario) 
   as fu_nombre,
 (select valor from cobis..cl_catalogo, cobis..cl_funcionario where tabla = 2 and estado = 'V' and convert(int,codigo) = fu_cargo 
   and fu_login = cob_atm..tm_bitacora_impresion.br_usuario) as fu_cargo,
 (select ta_cliente from cob_atm..tm_tarjeta where ta_codigo = cob_atm..tm_bitacora_impresion.br_codigo_tarjeta)
   as ta_cliente,
 
 (select en_nomlar from cobis..cl_ente where en_ente = cob_atm..tm_tarjeta.ta_cliente) as nombre_cliente,
     
  em_cuenta numero_cuenta --NRivas 07.02.2012: Agregar # de cuenta asociada a la TD

from cob_atm..tm_bitacora_impresion,cob_atm..tm_emision,cob_atm..tm_tarjeta
where cob_atm..tm_emision.em_tarjeta = cob_atm..tm_tarjeta.ta_tarjeta
  and cob_atm..tm_tarjeta.ta_codigo = cob_atm..tm_bitacora_impresion.br_codigo_tarjeta
and br_fecha_reimp between '12/01/2013' and '03/10/2014'
--and br_motivo = 'IPR'  -- IPR = Impresion inicial, el resto de motivos es Reimpresion
and br_oficina in (24) 





----6.	Levantamiento de bloqueos de valores y movimientos (ahorro y corriente)    
----6.1 CtasCorrientes bloqueos y levantamiento de bloqueos
select 'CUENTA'     = substring(hs_cta_banco, 1, 15), 'COD CLIE' = cc_cliente,'CLIENTE'	= cc_nombre,'CONTRATO'= hs_default,
       'TIPO'  = hs_tipo, 'DESC_TIPO' = (select valor from cobis..cl_catalogo where tabla = 1000 and codigo = A.hs_tipo),
       'CAUSA' = hs_causa, 'DESC_CAUSA' = (case when hs_tipo_transaccion = 218 then (select valor from cobis..cl_catalogo where tabla = 312 and codigo = A.hs_causa) else
                      (select valor from cobis..cl_catalogo where tabla = 1001 and codigo = A.hs_causa) end),
       'FECHA AUT'  = convert(varchar(12),hs_fecha,103),'MONTO AUT'  = hs_saldo,'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),
       'MONTO USO'  = hs_monto,'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),'USUARIO'    = substring(hs_usuario, 1, 15),
       'TERMINAL'   = substring(hs_terminal, 1, 15),'SECUENCIAL'       = hs_secuencial,'ALT' = hs_cod_alterno,
       'FECHA'      = convert(varchar(10),hs_tsfecha,103),'HORA'       = convert(varchar(8), hs_hora, 8),'AGENCIA'    = hs_oficina,
       'MONEDA'		= hs_moneda, 'TIPO TRN'		= hs_tipo_transaccion,'DESCRIPCION TRANSACCION' = tn_descripcion,
       'OFICINA'    = cc_oficina, 
       'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = cc_estado, 'SALDO_ACTUAL'= ISNULL(cc_disponible,0)+ISNULL(cc_12h,0)+ISNULL(cc_12h_dif,0)+ISNULL(cc_24h,0)+ISNULL(cc_48h,0)+ISNULL(cc_remesas,0),
       'SOLICITADO_POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
       'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = A.hs_autorizante),
       'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = A.hs_cta_banco),
       'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_cuentas_his..cc_his_movimiento where hm_cta_banco = A.hs_cta_banco and hm_fecha = A.hs_tsfecha and hm_signo = 'D'),
       'FEC_BLOQUEO' = (select max(convert(varchar(12),hs_fecha,103)) from cob_cuentas_his..cc_his_servicio where hs_cta_banco = A.hs_cta_banco and hs_fecha <= A.hs_fecha and hs_tipo_transaccion in (9,11))
from cob_cuentas_his..cc_his_servicio A, cob_cuentas..cc_ctacte, cobis..cl_ttransaccion
where hs_tipo_transaccion = tn_trn_code
      and hs_cta_banco=cc_cta_banco
      and hs_tsfecha  between '12/01/2013' and '03/10/2014'
      and hs_tipo_transaccion in (9, 10, 11, 12)	---(9-Bloqueo de valores, 10-Levantamiento de bloqueo de valores, 11-Bloqueo de movimientos, 12-Levantamiento de bloqueo de movimientos
      and ((hs_secuencial   > 0)
      or (hs_secuencial = 0
      and hs_cod_alterno > 0))
      and hs_oficina in (24)



----6.2 CtasAhorro bloqueos y levantamiento de bloqueos -----------------   :ERC 24/AGO/2010
---- CtasAhorro Levantamiento de bloqueos movimientos y valores
select 'CUENTA'     = substring(hs_cta_banco, 1, 15),'COD CLIE'	= ah_cliente,'CLIENTE'= ah_nombre,'CONTRATO' = hs_default,
       'TIPO'  = hs_tipo, 'DESC_TIPO' = (select valor from cobis..cl_catalogo where tabla = 1000 and codigo = A.hs_tipo),
       'CAUSA' = hs_causa, 'DESC_CAUSA' = (case when hs_tipo_transaccion in (218) then (select valor from cobis..cl_catalogo where tabla = 312 and codigo = A.hs_causa) else
                      (select valor from cobis..cl_catalogo where tabla = 1000 and codigo = A.hs_causa) end),    
       'FECHA AUT'  = convert(varchar(12),hs_fecha,103),'MONTO AUT' = hs_saldo,'FECHA USO'= convert(varchar(12),hs_fecha_uso,103),
       'MONTO USO'  = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),'USUARIO'= substring(hs_usuario, 1, 15),
       'TERMINAL'   = substring(hs_terminal, 1, 15),'SECUENCIAL' = hs_secuencial,'ALT' = hs_cod_alterno,
       'FECHA'      = convert(varchar(10),hs_tsfecha,103),'HORA'= convert(varchar(8), hs_hora, 8),'AGENCIA' = hs_oficina,
       'MONEDA'	    = hs_moneda, 'TIPO TRN' = hs_tipo_transaccion,'DESCRIPCION TRANSACCION' = tn_descripcion,'OFICINA' = ah_oficina,
       'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = ah_estado, 'SALDO_ACTUAL'= ISNULL(ah_disponible,0)+ISNULL(ah_12h,0)+ISNULL(ah_12h_dif,0)+ISNULL(ah_24h,0)+ISNULL(ah_48h,0)+ISNULL(ah_remesas,0),
       'SOLICITADO POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
       'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = A.hs_autorizante),
       'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = A.hs_cta_banco),
       'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_ahorros_his..ah_his_movimiento where hm_cta_banco = A.hs_cta_banco and hm_fecha = A.hs_tsfecha and hm_signo = 'D'),
       'FEC_BLOQUEO' = (select max(convert(varchar(12),hs_fecha,103)) from cob_ahorros_his..ah_his_servicio where hs_cta_banco = A.hs_cta_banco and hs_fecha <= A.hs_fecha and hs_tipo_transaccion in (211,217))
from cob_ahorros_his..ah_his_servicio A, cob_ahorros..ah_cuenta, cobis..cl_ttransaccion
where hs_tipo_transaccion =tn_trn_code
      and hs_cta_banco=ah_cta_banco
      and hs_tsfecha  between '12/01/2013' and '03/10/2014'
      and hs_tipo_transaccion  in (212, 218)---(211-Bloqueo de moviemiento, 212-Levantamiento de bloqueo de movimientos, 217-Bloqueo de valores, 218-Levantamiento de bloqueo de valores
      and ((hs_secuencial   > 0)
      or (hs_secuencial = 0
      and hs_cod_alterno > 0))
      and hs_oficina in (24)
      and hs_usuario <> 'sa'





----7.	Reporte de actualización o eliminación de firmas.  (ahorro y corriente)
----7.1	Reporte de actualización o eliminación de firmas AHORRO. */
-- campos claves: ts_im_secuencial, ts_cuenta

select *,
	'Desc_transacion'=(select tn_descripcion 
								from firmas..fi_ttransaccion 
								where tn_tipo_transaccion = a.ts_tipo_transaccion),
								
		'ah_cuenta' =(case when a.ts_ente <> NULL then (select ah_cta_banco from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente and ah_fecha_ult_upd =a.ts_tsfecha) else
						(select ah_cta_banco from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta and ah_fecha_ult_upd =a.ts_tsfecha)end),
		
		'ah_cliente' =(case when a.ts_ente <> NULL then (select ah_cliente from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select ah_cliente from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),
						
		'ah_nombre' =(case when a.ts_ente <> NULL then (select ah_nombre from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select ah_nombre from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),

		'ah_moneda' =(case when a.ts_ente <> NULL then (select max(ah_moneda) from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select max(ah_moneda) from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),
		
		'ah_fecha_aper' =(case when a.ts_ente <> NULL then (select ah_fecha_aper from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select ah_fecha_aper from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),
		
		'ah_estado' =(case when a.ts_ente <> NULL then (select ah_estado from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select ah_estado from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),
						
		'ah_fecha_ult_mov' =(case when a.ts_ente <> NULL then (select ah_fecha_ult_mov from cob_ahorros..ah_cuenta where ah_cliente = a.ts_ente) else
						(select ah_fecha_ult_mov from cob_ahorros..ah_cuenta where ah_cta_banco = a.ts_cuenta)end),
						
		'im_autorizada' =(select im_autorizada from firmas..fi_imagen where im_secuencial = a.ts_im_secuencial),			
		
		'im_fecha_autorizada' =(select im_fecha_autorizada from firmas..fi_imagen where im_secuencial = a.ts_im_secuencial)		
		
from firmas..fi_tran_servicio a
where a.ts_tsfecha between '12/01/2013' and '03/10/2014'
and a.ts_oficina in (24)
and a.ts_producto = 'AHO'
--where a.ts_cuenta in ('6010057190', '6000616964')



----7.2 Reporte de actualización o eliminación de firmas CORRIENTE. */
-- campos claves: ts_im_secuencial, ts_cuenta

select *,
	'Desc_transacion'=(select tn_descripcion 
								from firmas..fi_ttransaccion 
								where tn_tipo_transaccion = a.ts_tipo_transaccion),
								
		'ah_cuenta' =(case when a.ts_ente <> NULL then (select cc_cta_banco from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente and cc_fecha_ult_upd =a.ts_tsfecha) else
						(select cc_cta_banco from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta and cc_fecha_ult_upd =a.ts_tsfecha)end),
		
		'ah_cliente' =(case when a.ts_ente <> NULL then (select cc_cliente from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select cc_cliente from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),
						
		'ah_nombre' =(case when a.ts_ente <> NULL then (select cc_nombre from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select cc_nombre from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),

		'ah_moneda' =(case when a.ts_ente <> NULL then (select max(cc_moneda) from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select max(cc_moneda) from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),
		
		'ah_fecha_aper' =(case when a.ts_ente <> NULL then (select cc_fecha_aper from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select cc_fecha_aper from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),
		
		'ah_estado' =(case when a.ts_ente <> NULL then (select cc_estado from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select cc_estado from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),
						
		'ah_fecha_ult_mov' =(case when a.ts_ente <> NULL then (select cc_fecha_ult_mov from cob_cuentas..cc_ctacte where cc_cliente = a.ts_ente) else
						(select cc_fecha_ult_mov from cob_cuentas..cc_ctacte where cc_cta_banco = a.ts_cuenta)end),
						
		'im_autorizada' =(select im_autorizada from firmas..fi_imagen where im_secuencial = a.ts_im_secuencial),			
		
		'im_fecha_autorizada' =(select im_fecha_autorizada from firmas..fi_imagen where im_secuencial = a.ts_im_secuencial)		
		
from firmas..fi_tran_servicio a
where a.ts_tsfecha between '12/01/2013' and '03/10/2014'
and a.ts_oficina in (24)
and a.ts_producto = 'CTE'





----8.	Reporte de cuentas que tuvieron cambios de estado (Reactivaciones, reaperturas tanto ahorro como corriente)
---8.1 Cuentas corrientes que tuvieron cambios de estados     REACTIVACIONES    :ERC 24/AGO/2010
--Inactivacion_Reactivacion Normal CtaCte
--Inact_React Normal CtaCte
select cob_cuentas..cc_ctacte.*, 'CUENTA'     = substring(hs_cta_banco, 1, 15),'COD CLIE'	= cc_cliente,'CLIENTE'	= cc_nombre,
       'CONTRATO'   = hs_default, 'TIPO SOBR'  = hs_tipo,'FECHA AUT'  = convert(varchar(12),hs_fecha,103),
       'MONTO AUT'  = hs_saldo, 'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),
       'MONTO USO'  = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),
       'USUARIO'    = substring(hs_usuario, 1, 15),'TERMINAL'   = substring(hs_terminal, 1, 15),
       'SECUENCIAL' = hs_secuencial, 'ALT'        = hs_cod_alterno, 
       'FECHA'      = convert(varchar(10),hs_tsfecha,103),
       'HORA'       = convert(varchar(8), hs_hora, 8), 'AGENCIA' = hs_oficina,
       'MONEDA'		= hs_moneda, 'TIPO TRN'   = hs_tipo_transaccion, 'DESCRIPCION TRANSACCION'= tn_descripcion, 'OFICINA' = cc_oficina,
       'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = cc_estado, 'SALDO_ACTUAL'= ISNULL(cc_disponible,0)+ISNULL(cc_12h,0)+ISNULL(cc_12h_dif,0)+ISNULL(cc_24h,0)+ISNULL(cc_48h,0)+ISNULL(cc_remesas,0),
       'SOLICITADO_POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
       'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = cob_cuentas_his..cc_his_servicio.hs_autorizante),
       'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = cob_cuentas_his..cc_his_servicio.hs_cta_banco),
       'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_cuentas_his..cc_his_movimiento where hm_cta_banco = cob_cuentas_his..cc_his_servicio.hs_cta_banco and hm_fecha = cob_cuentas_his..cc_his_servicio.hs_tsfecha and hm_signo = 'D'),
	
		'fecha inact' = (select max(hs_tsfecha) from cob_cuentas_his..cc_his_servicio where hs_ctacte= cob_cuentas..cc_ctacte.cc_ctacte and hs_tipo_transaccion in (2619)), 
	    cc_tasa_hoy, cc_promedio1, cc_promedio2, cc_promedio3, cc_promedio4, cc_promedio5, cc_promedio6
	 
from cob_cuentas_his..cc_his_servicio, cob_cuentas..cc_ctacte, cobis..cl_ttransaccion	
      where hs_tipo_transaccion =tn_trn_code and
      hs_cta_banco=cc_cta_banco and
      hs_tsfecha between '12/01/2013' and '03/10/2014'				--- Mes,Dia,Año
      and hs_tipo_transaccion in (77)---(2569 (Reapertura), 2870 (Inactivacion por perfil incompleto), 2619(Inactivacion normal), 77(Reactivacion normal), 2871(Reactivacion por perfil incompleto)---
      and ((hs_secuencial > 0) or (hs_secuencial = 0 and hs_cod_alterno > 0))
      and hs_oficina in (24)


---8.2 Cuentas corrientes que tuvieron cambios de estados     REACTIVACIONES    :ERC 24/AGO/2010
--Inactivacion_Reactivacion x Perfil imcompleto, Reapertura CtaCte
--Inact_React x Perfil Incompleto, Reapertura CtaCte
select 'CUENTA'     = substring(hs_cta_banco, 1, 15),'COD CLIE'	= cc_cliente,'CLIENTE'	= cc_nombre,
       'CONTRATO'   = hs_default, 'TIPO SOBR'  = hs_tipo,'FECHA AUT'  = convert(varchar(12),hs_fecha,103),
       'MONTO AUT'  = hs_saldo, 'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),
       'MONTO USO'  = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),
       'USUARIO'    = substring(hs_usuario, 1, 15),'TERMINAL'   = substring(hs_terminal, 1, 15),
       'SECUENCIAL' = hs_secuencial, 'ALT'        = hs_cod_alterno, 
       'FECHA'      = convert(varchar(10),hs_tsfecha,103),
       'HORA'       = convert(varchar(8), hs_hora, 8), 'AGENCIA' = hs_oficina,
       'MONEDA'		= hs_moneda, 'TIPO TRN'   = hs_tipo_transaccion, 'DESCRIPCION TRANSACCION'= tn_descripcion, 'OFICINA' = cc_oficina,
       'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = cc_estado, 'SALDO_ACTUAL'= ISNULL(cc_disponible,0)+ISNULL(cc_12h,0)+ISNULL(cc_12h_dif,0)+ISNULL(cc_24h,0)+ISNULL(cc_48h,0)+ISNULL(cc_remesas,0),
       'SOLICITADO_POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
       'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = cob_cuentas_his..cc_his_servicio.hs_autorizante),
       'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = cob_cuentas_his..cc_his_servicio.hs_cta_banco),
       'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_cuentas_his..cc_his_movimiento where hm_cta_banco = cob_cuentas_his..cc_his_servicio.hs_cta_banco and hm_fecha = cob_cuentas_his..cc_his_servicio.hs_tsfecha and hm_signo = 'D'),
	
		'fecha inact' = (select max(hs_tsfecha) from cob_cuentas_his..cc_his_servicio where hs_ctacte= cob_cuentas..cc_ctacte.cc_ctacte and hs_tipo_transaccion in (2870)), 
	    cc_tasa_hoy, cc_promedio1, cc_promedio2, cc_promedio3, cc_promedio4, cc_promedio5, cc_promedio6
	 
from cob_cuentas_his..cc_his_servicio, cob_cuentas..cc_ctacte, cobis..cl_ttransaccion	
      where hs_tipo_transaccion =tn_trn_code and
      hs_cta_banco=cc_cta_banco and
      hs_tsfecha between '12/01/2013' and '03/10/2014' 	--'11/01/10' and '03/01/11'				--- Mes,Dia,Año
      and hs_tipo_transaccion in (2569, 2871)---(2569 (Reapertura), 2870 (Inactivacion por perfil incompleto), 2619(Inactivacion normal), 77(Reactivacion normal), 2871(Reactivacion por perfil incompleto)---
      and ((hs_secuencial > 0) or (hs_secuencial = 0 and hs_cod_alterno > 0))
      and hs_oficina in (24)



--8.3 Cuentas de ahorros que tuvieron cambios de estado          REACTIVACIONES     :ERC 24/AGO/2010
-- Inact_React Normal Ahorro
    select cob_ahorros..ah_cuenta.*, 'CUENTA'     = substring(hs_cta_banco, 1, 15), 'COD CLIE'	= ah_cliente, 'CLIENTE'	= ah_nombre,
             'CONTRATO'   = hs_default, 'TIPO SOBR'  = hs_tipo, 'FECHA AUT'  = convert(varchar(12),hs_fecha,103),
             'MONTO AUT'  = hs_saldo,'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),
             'MONTO USO'  = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),
             'USUARIO'    = substring(hs_usuario, 1, 15), 'TERMINAL'   = substring(hs_terminal, 1, 15),
             'SECUENCIAL'       = hs_secuencial, 'ALT'        = hs_cod_alterno,
             'FECHA'      = convert(varchar(10),hs_tsfecha,103), 'HORA'       = convert(varchar(8), hs_hora, 8),
             'AGENCIA'    = hs_oficina, 'MONEDA'		= hs_moneda, 'TIPO TRN'		= hs_tipo_transaccion,
             'DESCRIPCION TRANSACCION' = tn_descripcion,'OFICINA' = ah_oficina,
             'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = ah_estado, 'SALDO_ACTUAL'= ISNULL(ah_disponible,0)+ISNULL(ah_12h,0)+ISNULL(ah_12h_dif,0)+ISNULL(ah_24h,0)+ISNULL(ah_48h,0)+ISNULL(ah_remesas,0),
             'SOLICITADO_POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
             'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = A.hs_autorizante),
             'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = A.hs_cta_banco),
             'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_ahorros_his..ah_his_movimiento where hm_cta_banco = A.hs_cta_banco and hm_fecha = A.hs_tsfecha and hm_signo = 'D'),
    
      'fecha inact' = (select max(hs_tsfecha) from cob_ahorros_his..ah_his_servicio where hs_ctacte= cob_ahorros..ah_cuenta.ah_cuenta and hs_tipo_transaccion in (242)), 
	  ah_tasa_hoy, ah_promedio1, ah_promedio2, ah_promedio3, ah_promedio4, ah_promedio5, ah_promedio6
    
      from cob_ahorros_his..ah_his_servicio A, cob_ahorros..ah_cuenta, cobis..cl_ttransaccion
      where hs_tipo_transaccion =tn_trn_code and
      hs_cta_banco=ah_cta_banco and
      hs_tsfecha between '12/01/2013' and '03/10/2014'
         and hs_tipo_transaccion in (203)---(242 (Inactivacion Normal), 356 (Inactivacion por perfil incompleto), 204(Reapertura), 203(Reactivacion normal), 357(Reactivacion por perfil incompleto)----
         and ((hs_secuencial  > 0)or (hs_secuencial = 0 and hs_cod_alterno > 0))
         and hs_oficina in (24)
         

--8.4 Cuentas de ahorros que tuvieron cambios de estado          REACTIVACIONES     :ERC 24/AGO/2010
-- Inact_React x Perfil Incompleto, Reapertura Ahorro
    select 'CUENTA'     = substring(hs_cta_banco, 1, 15), 'COD CLIE'	= ah_cliente, 'CLIENTE'	= ah_nombre,
             'CONTRATO'   = hs_default, 'TIPO SOBR'  = hs_tipo, 'FECHA AUT'  = convert(varchar(12),hs_fecha,103),
             'MONTO AUT'  = hs_saldo,'FECHA USO'  = convert(varchar(12),hs_fecha_uso,103),
             'MONTO USO'  = hs_monto, 'FECHA VEN'  = convert(varchar(12),hs_fecha_ven,103),
             'USUARIO'    = substring(hs_usuario, 1, 15), 'TERMINAL'   = substring(hs_terminal, 1, 15),
             'SECUENCIAL'       = hs_secuencial, 'ALT'        = hs_cod_alterno,
             'FECHA'      = convert(varchar(10),hs_tsfecha,103), 'HORA'       = convert(varchar(8), hs_hora, 8),
             'AGENCIA'    = hs_oficina, 'MONEDA'		= hs_moneda, 'TIPO TRN'		= hs_tipo_transaccion,
             'DESCRIPCION TRANSACCION' = tn_descripcion,'OFICINA' = ah_oficina,
             'MONTO DESBLOQ' = hs_valor, 'ESTADO_ACTUAL' = ah_estado, 'SALDO_ACTUAL'= ISNULL(ah_disponible,0)+ISNULL(ah_12h,0)+ISNULL(ah_12h_dif,0)+ISNULL(ah_24h,0)+ISNULL(ah_48h,0)+ISNULL(ah_remesas,0),
             'SOLICITADO_POR' = hs_autoriz_aut, 'AUTORIZANTE' = hs_autorizante,
             'NOM_AUTORIZANTE' = (select fu_nombre from cobis..cl_funcionario where fu_login = A.hs_autorizante),
             'ETDO_PTMO' = (select avg(op_estado) from cob_cartera..ca_operacion where op_cuenta = A.hs_cta_banco),
             'DB_MISMODIA' = (select sum(ISNULL(hm_valor,0)+ISNULL(hm_chq_propios,0)+ISNULL(hm_chq_locales,0)+ISNULL(hm_chq_ot_plazas,0)) from cob_ahorros_his..ah_his_movimiento where hm_cta_banco = A.hs_cta_banco and hm_fecha = A.hs_tsfecha and hm_signo = 'D'),
    
      'fecha inact' = (select max(hs_tsfecha) from cob_ahorros_his..ah_his_servicio where hs_ctacte= cob_ahorros..ah_cuenta.ah_cuenta and hs_tipo_transaccion in (356)), 
	  ah_tasa_hoy, ah_promedio1, ah_promedio2, ah_promedio3, ah_promedio4, ah_promedio5, ah_promedio6
    
      from cob_ahorros_his..ah_his_servicio A, cob_ahorros..ah_cuenta, cobis..cl_ttransaccion
      where hs_tipo_transaccion =tn_trn_code and
      hs_cta_banco=ah_cta_banco and
      hs_tsfecha between '12/01/2013' and '03/10/2014'			--'11/01/10' and '03/01/11'
         and hs_tipo_transaccion in (357, 204)---(242 (Inactivacion Normal), 356 (Inactivacion por perfil incompleto), 204(Reapertura), 203(Reactivacion normal), 357(Reactivacion por perfil incompleto)----
         and ((hs_secuencial  > 0)or (hs_secuencial = 0 and hs_cod_alterno > 0))
         and hs_oficina in (24)





----9.	Reporte de apertura de usuarios iBDF 
----IV.  C=digos IBDF aperturados con los productos asociados a usuarios y C=digos IBDF con nuevos productos relacionados
--Ejecutar en SQL server (Servidor C25180), el server esta al dia.
--- iBDF Perfiles
select *
from cob_bvirtual..bv_ente_servicio_perfil, cob_bvirtual..bv_ente, cob_bvirtual..bv_perfil
where es_ente = en_ente
and es_perfil = pe_perfil				-- pe_perfil es descripcion del tipo de transaccion 
and es_estado = 'V'
and en_oficina in (6)
and en_fecha_reg >= '20-01-2014'		-- Dia, Mes, Año
and en_fecha_reg <= '20-02-2013'





----10.	Reporte de impresiones y reimpresiones de PIN iBDF
--iBDF reimpresion de pines
Select *
from cob_bvirtual..ts_login, cob_bvirtual..bv_ente
where fecha BETWEEN '01/20/2014' and '02/20/2014'			--Dia, mes, año
and en_ente = ente
and oficina in (6)
and (clase = 'U' and cod_alterno = 2)
--and (clase = 'I')




----X.    Reporte de solicitudes de chequeras.
---  Solicitudes de chequeras            :ERC 24/AGO/2010 NUEVO
select cc_cta_banco, cc_oficina, cc_nombre, cc_cliente, cc_estado, 'ch_fecha_emision'=convert(varchar(12), ch_fecha_emision,103), 
'ch_fecha_eimprenta'=convert(varchar(12), ch_fecha_eimprenta,103), 'ch_fecha_rimprenta'=convert(varchar(12), ch_fecha_rimprenta,103),
'ch_fecha_roficina'=convert(varchar(12), ch_fecha_roficina,103), 'ch_fecha_entrega'=convert(varchar(12), ch_fecha_entrega,103), 
ch_ofi_emision, ch_ofi_entrega, ch_autorizante, 
'nom_autorizante' = (select fu_nombre from cobis..cl_funcionario where fu_login = cob_cuentas..cc_chequera.ch_autorizante)
from cob_cuentas..cc_chequera, cob_cuentas..cc_ctacte
where ch_cuenta = cc_ctacte
and ch_fecha_entrega between '12/01/2013' and '03/10/2014'
and ch_ofi_entrega in (24)





----11. Clientes nuevos y tipo de vinculacion ---------
---- Clientes nuevos en el banco
select en_ente, en_ced_ruc, en_nomlar, en_oficina, en_fecha_crea, c_camara, en_tipo_vinculacion, en_preferen, en_cod_otro_pais
from cobis..cl_ente
where en_fecha_crea between '12/01/2013' and '03/10/2014'
and en_oficina in (24)
order by en_fecha_crea



---- Catalogo tipo de vinculacion de un cliente: ej empleado, accionista----
select *
from cobis..cl_catalogo
where tabla = 56 
and estado = 'V'




