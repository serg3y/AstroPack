--
-- Automatic generated file by xlsx2sql.py
-- Origin file: D:\Ultrasat\AstroPack.git\database\xlsx\unittest__tables.xlsx
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2021-04-27 11:16:52

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2998 (class 1262 OID 16394)
-- Name: pipeline; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE unittest WITH TEMPLATE = template0 ENCODING = 'UTF8';


ALTER DATABASE unittest OWNER TO postgres;

\connect unittest

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;



-- Source file: D:\Ultrasat\AstroPack.git\database\xlsx\unittest\csv\unittest - details_table.csv
CREATE TABLE public.details_table (
RecID VARCHAR NOT NULL,
InsertTime TIMESTAMP,
UpdateTime TIMESTAMP,
FInt INTEGER,
FBigInt BIGINT,
FBool BOOLEAN,
FDouble DOUBLE PRECISION,
FTimestamp TIMESTAMP,
FString VARCHAR,
details_string VARCHAR,

CONSTRAINT details_table_pkey PRIMARY KEY(RecID)
);

-- Source file: D:\Ultrasat\AstroPack.git\database\xlsx\unittest\csv\unittest - master_table.csv
CREATE TABLE public.master_table (
RecID VARCHAR NOT NULL,
InsertTime TIMESTAMP,
UpdateTime TIMESTAMP,
FInt INTEGER,
FBigInt BIGINT,
FBool BOOLEAN,
FDouble DOUBLE PRECISION,
FTimestamp TIMESTAMP,
FString VARCHAR,
master_string VARCHAR,

CONSTRAINT master_table_pkey PRIMARY KEY(RecID)
);

