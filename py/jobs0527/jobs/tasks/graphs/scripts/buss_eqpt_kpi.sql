-- Table: buss_eqpt_kpi

-- DROP TABLE buss_eqpt_kpi;

CREATE TABLE buss_eqpt_kpi
(
  id serial NOT NULL,
  kmonth date,
  identifier character varying(10),
  labname character varying(40),
  worktime double precision,
  plantime double precision,
  downtime double precision,
  uom character varying(10),
  kpi1 double precision,
  kpi2 double precision,
  CONSTRAINT buss_eqpt_kpi_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);