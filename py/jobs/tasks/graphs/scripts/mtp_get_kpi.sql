-- Function: mtp_get_kpi(json)

-- DROP FUNCTION mtp_get_kpi(json);

CREATE OR REPLACE FUNCTION mtp_get_kpi(i_json json)
  RETURNS json AS
$BODY$

#v_month = i_json.month

v_sql = "select   month_,labid ,kpi_value
 from buss_lab_kpi 
 order by labid , month_"
try
    rtn = plv8.execute(v_sql)
catch err
    plv8.elog(DEBUG, v_sql)
    
return {"retuning":rtn}

$BODY$
  LANGUAGE plcoffee VOLATILE
  COST 100;