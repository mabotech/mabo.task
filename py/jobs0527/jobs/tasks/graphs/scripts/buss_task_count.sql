-- Table: buss_task_count

-- DROP TABLE buss_task_count;

CREATE TABLE buss_task_count
(
  id serial NOT NULL,
  date_ date,
  val1 integer,
  val2 integer,
  val3 integer,
  val4 integer,
  CONSTRAINT buss_task_count_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);