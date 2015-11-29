-- Table: buss_lab_kpi

-- DROP TABLE buss_lab_kpi;

CREATE TABLE buss_lab_kpi
(
  id serial NOT NULL,
  date_ date,
  month_ smallint,
  labid character varying(10),
  kpi_name character varying(20),
  kpi_value double precision,
  av_value double precision,
  CONSTRAINT buss_lab_kpi_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);