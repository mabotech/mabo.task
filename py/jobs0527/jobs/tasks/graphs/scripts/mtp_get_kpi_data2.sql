-- Function: mtp_get_kpi_data2(json)

-- DROP FUNCTION mtp_get_kpi_data2(json);

CREATE OR REPLACE FUNCTION mtp_get_kpi_data2(i_json json)
  RETURNS json AS
$BODY$

v_month = i_json.month

v_sql = "select date_part('year', mkpi.kmonth) as year, date_part('month', mkpi.kmonth) as month, 
 eqpt.labname, eqpt.identifier, eqpt.equipid, eqpt.equipname,
 worktime, plantime, downtime,
 mkpi.kpi1, mkpi.kpi2
 from buss_eqpt_kpi  mkpi
 inner join buss_equipinfo eqpt on (mkpi.identifier = eqpt.identifier )
 and to_char(mkpi.kmonth, 'YYYY-MM') = '#{v_month}'
 order by eqpt.seq
"
try
    rtn = plv8.execute(v_sql)
catch err
    plv8.elog(DEBUG, v_sql)
    
return {"retuning":rtn}

$BODY$
  LANGUAGE plcoffee VOLATILE
  COST 100;
