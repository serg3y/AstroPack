--
-- Automatic generated file by xlsx2sql.py
-- Origin file: ../../../database/xlsx/lastdb__tables.xlsx
--

-- To create the database, run from command line:
-- psql -U postgres -f <dbname>.sql

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

CREATE DATABASE lastdb WITH TEMPLATE = template0 ENCODING = 'UTF8';


ALTER DATABASE lastdb OWNER TO postgres;

\connect lastdb

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



-- Source file: ../../../database/xlsx\lastdb\csv\lastdb - processed_cropped_images.csv
CREATE TABLE public.processed_cropped_images (
proc_image_id VARCHAR NOT NULL,
raw_image_id VARCHAR,
BIAS_IID VARCHAR,
FLAT_IID VARCHAR,
TEL VARCHAR,
NODE INTEGER,
MOUNT INTEGER,
CAMERA INTEGER,
JD DOUBLE PRECISION,
TIMEZONE INTEGER,
FILTER VARCHAR,
FIELD_ID VARCHAR,
CROP_ID INTEGER,
IMTYPE VARCHAR,
IMLEVEL VARCHAR,
IMSLEVEL VARCHAR,
IMPROD VARCHAR,
IMVER INTEGER,
FILETYPE VARCHAR,
PATHSTR VARCHAR,
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ DOUBLE PRECISION,
ALT DOUBLE PRECISION,
EQUINOX DOUBLE PRECISION,
HTM_ID VARCHAR,
NAXIS1 INTEGER,
NAXIS2 INTEGER,
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS DOUBLE PRECISION,
PARANG DOUBLE PRECISION,
CCDID INTEGER,
EXPTIME DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
LST DOUBLE PRECISION,
IMMEAN DOUBLE PRECISION,
IMMED DOUBLE PRECISION,
IMBACK DOUBLE PRECISION,
IMVAR DOUBLE PRECISION,
NSAT BIGINT,
SUNALT DOUBLE PRECISION,
MOONALT DOUBLE PRECISION,
MOONDIST DOUBLE PRECISION,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT DOUBLE PRECISION,
TEMPTEL DOUBLE PRECISION,
TEMPCAM DOUBLE PRECISION,
CAMPOW DOUBLE PRECISION,
HUMID DOUBLE PRECISION,
PRESS DOUBLE PRECISION,
CLOUD DOUBLE PRECISION,
GAIN DOUBLE PRECISION,
READNOI DOUBLE PRECISION,
DARKCUR DOUBLE PRECISION,
CAMMODE INTEGER,
CAMGAIN DOUBLE PRECISION,
X_MIN DOUBLE PRECISION,
X_MAX DOUBLE PRECISION,
Y_MIN DOUBLE PRECISION,
Y_MAX DOUBLE PRECISION,
XMIN_NOOVERLAP DOUBLE PRECISION,
XMAX_NOOVERLAP DOUBLE PRECISION,
YMIN_NOOVERLAP DOUBLE PRECISION,
YMAX_NOOVERLAP DOUBLE PRECISION,

CONSTRAINT processed_cropped_images_pkey PRIMARY KEY(proc_image_id)
);

CREATE INDEX processed_cropped_images_idx_raw_image_id ON public.processed_cropped_images
  USING btree (raw_image_id);

CREATE INDEX processed_cropped_images_idx_BIAS_IID ON public.processed_cropped_images
  USING btree (BIAS_IID);

CREATE INDEX processed_cropped_images_idx_FLAT_IID ON public.processed_cropped_images
  USING btree (FLAT_IID);

CREATE INDEX processed_cropped_images_idx_JD ON public.processed_cropped_images
  USING btree (JD);

CREATE INDEX processed_cropped_images_idx_RA ON public.processed_cropped_images
  USING btree (RA);

CREATE INDEX processed_cropped_images_idx_DEC ON public.processed_cropped_images
  USING btree (DEC);

CREATE INDEX processed_cropped_images_idx_HTM_ID ON public.processed_cropped_images
  USING btree (HTM_ID);

CREATE INDEX processed_cropped_images_idx_MIDJD ON public.processed_cropped_images
  USING btree (MIDJD);

-- Source file: ../../../database/xlsx\lastdb\csv\lastdb - raw_images.csv
CREATE TABLE public.raw_images (
raw_iid VARCHAR NOT NULL,
TEL VARCHAR,
NODE INTEGER,
MOUNT INTEGER,
CAMERA INTEGER,
JD DOUBLE PRECISION,
TIMEZONE INTEGER,
FILTER VARCHAR,
FIELD_ID VARCHAR,
CROP_ID INTEGER,
IMTYPE VARCHAR,
IMLEVEL VARCHAR,
IMSLEVEL VARCHAR,
IMPROD VARCHAR,
IMVER INTEGER,
FILETYPE VARCHAR,
PATHSTR VARCHAR,
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ DOUBLE PRECISION,
ALT DOUBLE PRECISION,
EQUINOX DOUBLE PRECISION,
HTM_ID VARCHAR,
NAXIS1 INTEGER,
NAXIS2 INTEGER,
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS DOUBLE PRECISION,
PARANG DOUBLE PRECISION,
CCDID INTEGER,
EXPTIME DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
LST DOUBLE PRECISION,
IMMEAN DOUBLE PRECISION,
IMMED DOUBLE PRECISION,
IMBACK DOUBLE PRECISION,
IMVAR DOUBLE PRECISION,
NSAT BIGINT,
SUNALT DOUBLE PRECISION,
MOONALT DOUBLE PRECISION,
MOONDIST DOUBLE PRECISION,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT DOUBLE PRECISION,
TEMPTEL DOUBLE PRECISION,
TEMPCAM DOUBLE PRECISION,
CAMPOW DOUBLE PRECISION,
HUMID DOUBLE PRECISION,
PRESS DOUBLE PRECISION,
CLOUD DOUBLE PRECISION,
GAIN DOUBLE PRECISION,
READNOI DOUBLE PRECISION,
DARKCUR DOUBLE PRECISION,
CAMMODE INTEGER,
CAMGAIN DOUBLE PRECISION,

CONSTRAINT raw_images_pkey PRIMARY KEY(raw_iid)
);

CREATE INDEX raw_images_idx_JD ON public.raw_images
  USING btree (JD);

CREATE INDEX raw_images_idx_RA ON public.raw_images
  USING btree (RA);

CREATE INDEX raw_images_idx_DEC ON public.raw_images
  USING btree (DEC);

CREATE INDEX raw_images_idx_HTM_ID ON public.raw_images
  USING btree (HTM_ID);

CREATE INDEX raw_images_idx_MIDJD ON public.raw_images
  USING btree (MIDJD);

-- Source file: ../../../database/xlsx\lastdb\csv\lastdb - sources_proc_cropped.csv
CREATE TABLE public.sources_proc_cropped (
proc_iid VARCHAR NOT NULL,
src_id INTEGER NOT NULL,
RA DOUBLE PRECISION,
Dec DOUBLE PRECISION,
Flags INTEGER,
SN_Best DOUBLE PRECISION,
SN_Delta DOUBLE PRECISION,
SN_1 DOUBLE PRECISION,
SN_2 DOUBLE PRECISION,
FLUX_PSF_CONV DOUBLE PRECISION,
FLUXERR_PSF_CONV DOUBLE PRECISION,
MAG_PSF_CONV DOUBLE PRECISION,
MAGERR_PSF_CONV DOUBLE PRECISION,
FLUX_APER_1 DOUBLE PRECISION,
FLUXERR_APER_1 DOUBLE PRECISION,
MAG_APER_1 DOUBLE PRECISION,
MAGERR_APER_1 DOUBLE PRECISION,
FLUX_APER_2 DOUBLE PRECISION,
FLUXERR_APER_2 DOUBLE PRECISION,
MAG_APER_2 DOUBLE PRECISION,
MAGERR_APER_2 DOUBLE PRECISION,
FLUX_APER_3 DOUBLE PRECISION,
FLUXERR_APER_3 DOUBLE PRECISION,
MAG_APER_3 DOUBLE PRECISION,
MAGERR_APER_3 DOUBLE PRECISION,
FLUX_PEAK DOUBLE PRECISION,
BACK_IM DOUBLE PRECISION,
STD_IM DOUBLE PRECISION,
BACK_ANNULUS DOUBLE PRECISION,
STD_ANNULUS DOUBLE PRECISION,
X_PEAK DOUBLE PRECISION,
Y_PEAK DOUBLE PRECISION,
X DOUBLE PRECISION,
Y DOUBLE PRECISION,
X2 DOUBLE PRECISION,
Y2 DOUBLE PRECISION,
XY DOUBLE PRECISION,

CONSTRAINT sources_proc_cropped_pkey PRIMARY KEY(proc_iid, src_id)
);

