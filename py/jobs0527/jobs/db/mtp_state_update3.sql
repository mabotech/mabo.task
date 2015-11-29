-- Function: mtp_state_update3(integer)

-- DROP FUNCTION mtp_state_update3(integer);

CREATE OR REPLACE FUNCTION mtp_state_update3(id integer)
  RETURNS json AS
$BODY$

v_id  = id

v_sql = "select fk_task, ch_logic, ch_occupied, ch_ori_eqpt, ch_eqpt,ch_manual,ch_task, state, laststateon, 
         EXTRACT(EPOCH FROM (now()- laststateon)) as duration 
         from equipment where id = #{v_id}"

try
    result = plv8.execute( v_sql )

    if result.length > 0
    
        item = result[0]
        
        v_fk_task = item.fk_task        
        
        v_ch_logic = item.ch_logic
        v_ch_occupied = item.ch_occupied
        v_ch_ori_eqpt = item.ch_ori_eqpt
        v_ch_eqpt = item.ch_eqpt
        v_ch_manual = item.ch_manual
        v_ch_task = item.ch_task

        p_state = item.state
        laststateon = item.laststateon.toISOString()
        v_duration = item.duration
        
        # 0: no signal
        # 1: running
        # 2: idle
        # 3: issue
        # 4: maintain
        
        if v_ch_occupied != 0
            v_ch_eqpt = v_ch_occupied
        else
            v_ch_eqpt = v_ch_ori_eqpt
            
        if v_ch_task != 0
           v_state = v_ch_task 
        else
           if v_ch_manual != 0
              v_state = v_ch_manual
              
           else
              v_state = v_ch_eqpt

        # no signal to idle
        if v_state == 0
              v_state = 2
              
        v_sql = "update equipment set state = #{v_state}, laststate=#{p_state}, laststateon= now() where id = #{v_id}"
        plv8.execute( v_sql )

        v_sql = "insert into equipment_history (fk_equipment, fk_task, state,statestart, stateend, duration, modifiedby) 
                 values(#{v_id},#{v_fk_task}, #{p_state}, '#{laststateon}',  now(),#{v_duration},'mt')"
                 
        plv8.execute( v_sql )
    else
        msg = "no this equipment:#{v_id}"
        throw(msg)
    
catch err
    plv8.elog(DEBUG, v_sql)
    msg = "#{err},#{v_sql}"
    #return {"sql":v_sql,"error":msg}
    throw(msg)

return {"result":result[0],"state":v_state,"pstate":p_state}

$BODY$
  LANGUAGE plcoffee VOLATILE
  COST 100;
ALTER FUNCTION mtp_state_update3(integer)
  OWNER TO mabotech;
