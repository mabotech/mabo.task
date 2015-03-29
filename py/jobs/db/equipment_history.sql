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
ALTER TABLE equipment_history
  OWNER TO mabotech;
