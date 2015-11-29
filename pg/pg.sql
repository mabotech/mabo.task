-- Table: equipment

-- DROP TABLE equipment;

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

-- Table: equipment_history

-- DROP TABLE equipment_history;

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

-- Table: equipment_state

-- DROP TABLE equipment_state;

CREATE TABLE equipment_state
(
  id serial NOT NULL,
  name character varying(40),
  picture character varying(255),
  modifiedon timestamp without time zone,
  modifiedby character varying(200) NOT NULL,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_equipment_state PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

-- Table: equipment_state_count

-- DROP TABLE equipment_state_count;

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


-- Table: equipment_type

-- DROP TABLE equipment_type;

CREATE TABLE equipment_type
(
  id serial NOT NULL,
  name character varying(255),
  color character varying(20),
  modifiedon timestamp without time zone,
  modifiedby character varying(200) NOT NULL,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_equipment_type PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

-- Table: app_log

-- DROP TABLE app_log;

CREATE TABLE app_log
(
  id serial NOT NULL,
  fk_equipment_id bigint,
  message character varying(400),
  logtime timestamp without time zone,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  CONSTRAINT pk_app_log PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


-- Functions

-- Function: eqpt_state_count()

-- DROP FUNCTION eqpt_state_count();

CREATE OR REPLACE FUNCTION eqpt_state_count()
  RETURNS integer AS
$BODY$ 
DECLARE

 v_running int4 :=0;
 v_idle int4 := 0;
 v_issue int4 := 0;
 v_maintain int4 := 0;

 
begin

 

/* running */
select count(1) into v_running from equipment where  state = 1;

/* idle */
select count(1) into v_idle from equipment where  state = 2;

/* issue */
select count(1) into v_issue from equipment where  state = 3;

/* maintain */
select count(1) into v_maintain from equipment where  state = 4;

insert into equipment_state_count

(running,idle,issue, maintain,  createdon, active,rowversion )

values (  v_running, v_idle, v_issue, v_maintain, now(), 1,1 );


RETURN 1;


EXCEPTION

WHEN others THEN 
    RAISE;

RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
---- Function: mtp_state_update3(integer)

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




