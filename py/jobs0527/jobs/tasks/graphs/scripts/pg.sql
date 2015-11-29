--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.1
-- Dumped by pg_dump version 9.3.1
-- Started on 2015-05-05 10:50:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- TOC entry 2225 (class 0 OID 674047)
-- Dependencies: 243
-- Data for Name: buss_eqpt_kpi; Type: TABLE DATA; Schema: public; Owner: mabotech
--

INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (1, '2015-04-01', 'eqm001', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (5, '2015-04-01', 'eqm005', 'lab2', 33, 36, 2.2999999999999998, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (6, '2015-04-01', 'eqm006', 'lab2', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (7, '2015-04-01', 'eqm007', 'lab2', 27, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (8, '2015-04-01', 'eqm008', 'lab3', 32, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (9, '2015-04-01', 'eqm009', 'lab4', 31, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (10, '2015-04-01', 'eqm010', 'lab4', 30.600000000000001, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (2, '2015-04-01', 'eqm002', 'lab1', 32, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (15, '2015-03-01', 'eqm009', 'lab2', 31, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (16, '2015-03-01', 'eqm008', 'lab2', 32, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (17, '2015-03-01', 'eqm005', 'lab2', 33, 36, 2.2999999999999998, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (18, '2015-03-01', 'eqm004', 'lab3', 32.5, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (19, '2015-03-01', 'eqm003', 'lab4', 28, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (20, '2015-03-01', 'eqm010', 'lab4', 30.600000000000001, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (4, '2015-04-01', 'eqm004', 'lab1', 32.5, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (3, '2015-04-01', 'eqm003', 'lab1', 28, 36, 1.5, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (11, '2015-03-01', 'eqm001', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (12, '2015-03-01', 'eqm002', 'lab1', 32, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (13, '2015-03-01', 'eqm006', 'lab1', 30, 36, 1, 'H', 0.83330000000000004, 0.97219999999999995);
INSERT INTO buss_eqpt_kpi (id, kmonth, identifier, labname, worktime, plantime, downtime, uom, kpi1, kpi2) VALUES (14, '2015-03-01', 'eqm007', 'lab1', 27, 36, 2, 'H', 0.88890000000000002, 0.94440000000000002);


--
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 242
-- Name: buss_eqpt_kpi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mabotech
--

SELECT pg_catalog.setval('buss_eqpt_kpi_id_seq', 20, true);


--
-- TOC entry 2229 (class 0 OID 674099)
-- Dependencies: 249
-- Data for Name: buss_lab_kpi; Type: TABLE DATA; Schema: public; Owner: mabotech
--

INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (1, '2015-04-01', 4, 'lab1', 'util', 0.96299999999999997, 0.98999999999999999);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (2, '2015-04-01', 4, 'lab2', 'util', 0.93300000000000005, 0.97999999999999998);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (3, '2015-04-01', 4, 'lab3', 'util', 0.84540000000000004, 0.96999999999999997);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (4, '2015-04-01', 4, 'lab4', 'util', 0.79000000000000004, 0.96999999999999997);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (5, '2015-05-01', 5, 'lab1', 'util', 0.69330000000000003, 0.95999999999999996);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (6, '2015-05-01', 5, 'lab2', 'util', 0.93300000000000005, 0.95999999999999996);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (7, '2015-05-01', 5, 'lab3', 'util', 0.73299999999999998, 0.97999999999999998);
INSERT INTO buss_lab_kpi (id, date_, month_, labid, kpi_name, kpi_value, av_value) VALUES (8, '2015-05-01', 5, 'lab4', 'util', 0.73299999999999998, 0.94999999999999996);


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 248
-- Name: buss_lab_kpi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mabotech
--

SELECT pg_catalog.setval('buss_lab_kpi_id_seq', 1, true);


--
-- TOC entry 2227 (class 0 OID 674089)
-- Dependencies: 247
-- Data for Name: buss_task_count; Type: TABLE DATA; Schema: public; Owner: mabotech
--

INSERT INTO buss_task_count (id, date_, val1, val2, val3, val4) VALUES (1, '2015-05-01', 6, 5, 6, 8);
INSERT INTO buss_task_count (id, date_, val1, val2, val3, val4) VALUES (3, '2015-05-03', 4, 7, 0, 7);
INSERT INTO buss_task_count (id, date_, val1, val2, val3, val4) VALUES (2, '2015-05-02', 5, 2, 8, 4);


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 246
-- Name: buss_task_count_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mabotech
--

SELECT pg_catalog.setval('buss_task_count_id_seq', 1, false);


-- Completed on 2015-05-05 10:50:47

--
-- PostgreSQL database dump complete
--

