-- Function: mtp_get_lab_kpi(json)

-- DROP FUNCTION mtp_get_lab_kpi(json);

CREATE OR REPLACE FUNCTION mtp_get_lab_kpi(i_json json)
  RETURNS json AS
$BODY$

v_type = i_json.type
v_month = i_json.month

if v_type == 'U'
	v_sql = "select para.labid, para.useratemax, para.userate, para.useratemin, 100 * COALESCE ( kpi.kpi_value ,0 ) as rate
	 from  buss_kpiparameter  para
	 left join buss_lab_kpi kpi on (para.labid = kpi.labid and  to_char(kpi.date_, 'YYYY-MM') = '#{v_month}')  
	 where para.labid in ('lab1','lab2','lab3','lab4')
	 order by para.labid
	"
else
	v_sql = "select para.labid, para.usableratemax, para.usablerate, para.usableratemin, 100 * COALESCE ( kpi.kpi_value ,0 ) as rate
	 from  buss_kpiparameter  para
	 left join buss_lab_kpi kpi on (para.labid = kpi.labid and  to_char(kpi.date_, 'YYYY-MM') = '#{v_month}')
	 where para.labid in ('lab1','lab2','lab3','lab4')
	 order by para.labid
	"

try
    rtn = plv8.execute(v_sql)
catch err
    plv8.elog(DEBUG, v_sql)
    
return {"retuning": rtn, "sql":v_sql}

$BODY$
  LANGUAGE plcoffee VOLATILE
  COST 100;