-- Function: mtp_get_task_count(json)

-- DROP FUNCTION mtp_get_task_count(json);

CREATE OR REPLACE FUNCTION mtp_get_task_count(i_json json)
  RETURNS json AS
$BODY$

v_month = i_json.month

v_sql = "select to_char(date_,'YYYY-MM-DD') as date_, val1, val2, val3, val4
 from buss_task_count
 where to_char(date_, 'YYYY-MM') = '#{v_month}'
 order by date_
"
try
    rtn = plv8.execute(v_sql)
catch err
    plv8.elog(DEBUG, v_sql)
    
return {"retuning":rtn}

$BODY$
  LANGUAGE plcoffee VOLATILE
  COST 100;