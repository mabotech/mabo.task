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
ALTER FUNCTION eqpt_state_count()
  OWNER TO mabotech;
