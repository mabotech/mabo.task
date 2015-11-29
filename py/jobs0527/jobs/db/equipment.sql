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
ALTER TABLE equipment
  OWNER TO mabotech;
