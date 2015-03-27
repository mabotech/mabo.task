-- Table: employee

-- DROP TABLE employee;

CREATE TABLE employee
(
  id serial NOT NULL,
  uid character varying(40) NOT NULL,
  name character varying(255),
  password character varying(40),
  email character varying(40),
  department character varying(40),
  title character varying(40),
  mobile character varying(30),
  phone character varying(30),
  employeeno character varying(40),
  employeetype character varying(40),
  status smallint,
  modifiedon timestamp without time zone,
  modifiedby character varying(200) NOT NULL,
  createdon timestamp without time zone,
  createdby character varying(40),
  active smallint NOT NULL DEFAULT 1,
  rowversion integer NOT NULL DEFAULT 1,
  CONSTRAINT pk_employee PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE employee
  OWNER TO mabotech;