CREATE TABLE equipment
(
  id serial NOT NULL,
  fk_station integer,
  fk_equipment_type integer,
  fk_task integer,
  name character varying(255),
  equipmentno character varying(200),
  seq smallint NOT NULL,
  ch_logic smallint,
  ch_occupied smallint,
  ch_ori_eqpt smallint,
  ch_eqpt smallint,
  ch_manual smallint,
  ch_task smallint,
  state smallint,
  laststate character varying(40),
  laststateon timestamp without time zone,
  picture character varying(255),
  modifiedon timestamp without time zone,
  modifiedby character varying(200) NOT NULL,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_equipment PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE equipment_history
(
  id serial NOT NULL,
  fk_equipment integer,
  fk_task integer,
  state character varying(200),
  stategroup character varying(200),
  statestart timestamp without time zone,
  stateend timestamp without time zone,
  duration integer,
  client character varying(40),
  pid integer,
  modifiedon timestamp without time zone,
  modifiedby character varying(200) NOT NULL,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_equipment_history PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

CREATE TABLE equipment_state_count
(
  id serial NOT NULL,
  running integer NOT NULL DEFAULT 0,
  idle integer NOT NULL DEFAULT 0,
  issue integer NOT NULL DEFAULT 0,
  maintain integer NOT NULL DEFAULT 0,
  modifiedon timestamp without time zone,
  modifiedby character varying(40),
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_state_count PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);



-- functions

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

--

