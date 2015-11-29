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


INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm001', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm002', 'lab1', 32, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm006', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm007', 'lab1', 27, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm009', 'lab1', 31, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm008', 'lab1', 32, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm005', 'lab1', 33, 36, 2.2999999999999998, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm004', 'lab1', 32.5, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm003', 'lab1', 28, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-03-01', 'eqm010', 'lab1', 30.600000000000001, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);


INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm001', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm002', 'lab1', 32, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm006', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm007', 'lab1', 27, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm009', 'lab1', 31, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm008', 'lab1', 32, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm005', 'lab1', 33, 36, 2.2999999999999998, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm004', 'lab1', 32.5, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm003', 'lab1', 28, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi ( kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES ( '2015-04-01', 'eqm010', 'lab1', 30.600000000000001, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);

