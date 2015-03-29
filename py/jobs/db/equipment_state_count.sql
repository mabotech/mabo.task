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
ALTER TABLE equipment_state_count
  OWNER TO mabotech;
