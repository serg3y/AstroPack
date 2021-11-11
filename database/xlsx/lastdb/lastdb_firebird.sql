--
-- Automatic generated file by xlsx2sql.py
-- Origin file: /home/eran/matlab/AstroPack/database/xlsx/lastdb__tables.xlsx
--

--
-- FirebirdSQL database
--

CREATE DATABASE lastdb USER 'SYSDBA'
   PAGE_SIZE 4096
   DEFAULT CHARACTER SET UTF8;


-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - stacked_cropped_images.csv
CREATE TABLE stacked_cropped_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
StackedImageID VARCHAR(256) NOT NULL,
NCOADD DOUBLE PRECISION,
MINJD DOUBLE PRECISION,
MAXJD DOUBLE PRECISION
);


ALTER TABLE stacked_cropped_images_pkey ADD PRIMARY KEY(StackedImageID);
CREATE INDEX stacked_cropped_images_idx_RA ON stacked_cropped_images(RA);
CREATE INDEX stacked_cropped_images_idx_DEC ON stacked_cropped_images(DEC);
CREATE INDEX stacked_cropped_images_idx_HTM_ID ON stacked_cropped_images(HTM_ID);
CREATE INDEX stacked_cropped_images_idx_MIDJD ON stacked_cropped_images(MIDJD);
CREATE INDEX stacked_cropped_images_idx_DYEAR ON stacked_cropped_images(DYEAR);
CREATE INDEX stacked_cropped_images_idx_DMONTH ON stacked_cropped_images(DMONTH);
CREATE INDEX stacked_cropped_images_idx_DDAY ON stacked_cropped_images(DDAY);
CREATE INDEX stacked_cropped_images_idx_ImageUUID ON stacked_cropped_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - processed_cropped_images.csv
CREATE TABLE processed_cropped_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ProcImageID VARCHAR(256) NOT NULL,
ImageUUID VARCHAR(256),
RawImageID VARCHAR(256),
BiasImageID VARCHAR(256),
FlatImageID VARCHAR(256),
CropInd INTEGER,
XMIN DOUBLE PRECISION,
XMAX DOUBLE PRECISION,
YMIN DOUBLE PRECISION,
YMAX DOUBLE PRECISION,
XMIN_NOOVERLAP DOUBLE PRECISION,
XMAX_NOOVERLAP DOUBLE PRECISION,
YMIN_NOOVERLAP DOUBLE PRECISION,
YMAX_NOOVERLAP DOUBLE PRECISION,
Nbit00 BIGINT,
Nbit01 BIGINT,
Nbit02 BIGINT,
Nbit03 BIGINT,
Nbit04 BIGINT,
Nbit05 BIGINT,
Nbit06 BIGINT,
Nbit07 BIGINT,
Nbit08 BIGINT,
Nbit09 BIGINT,
Nbit10 BIGINT,
Nbit11 BIGINT,
Nbit12 BIGINT,
Nbit13 BIGINT,
Nbit14 BIGINT,
Nbit15 BIGINT,
Nbit16 BIGINT,
Nbit17 BIGINT,
Nbit18 BIGINT,
Nbit19 BIGINT,
Nbit20 BIGINT,
Nbit21 BIGINT,
Nbit22 BIGINT,
Nbit23 BIGINT,
Nbit24 BIGINT,
Nbit25 BIGINT,
Nbit26 BIGINT,
Nbit27 BIGINT,
Nbit28 BIGINT,
Nbit29 BIGINT,
Nbit30 BIGINT,
Nbit31 BIGINT,
Nbit32 BIGINT,
@ History of proc_steps DOUBLE PRECISION
);


ALTER TABLE processed_cropped_images_pkey ADD PRIMARY KEY(ProcImageID);
CREATE INDEX processed_cropped_images_idx_RA ON processed_cropped_images(RA);
CREATE INDEX processed_cropped_images_idx_DEC ON processed_cropped_images(DEC);
CREATE INDEX processed_cropped_images_idx_HTM_ID ON processed_cropped_images(HTM_ID);
CREATE INDEX processed_cropped_images_idx_MIDJD ON processed_cropped_images(MIDJD);
CREATE INDEX processed_cropped_images_idx_DYEAR ON processed_cropped_images(DYEAR);
CREATE INDEX processed_cropped_images_idx_DMONTH ON processed_cropped_images(DMONTH);
CREATE INDEX processed_cropped_images_idx_DDAY ON processed_cropped_images(DDAY);
CREATE INDEX processed_cropped_images_idx_ImageUUID ON processed_cropped_images(ImageUUID);
CREATE INDEX processed_cropped_images_idx_RawImageID ON processed_cropped_images(RawImageID);
CREATE INDEX processed_cropped_images_idx_BiasImageID ON processed_cropped_images(BiasImageID);
CREATE INDEX processed_cropped_images_idx_FlatImageID ON processed_cropped_images(FlatImageID);
CREATE INDEX processed_cropped_images_idx_CropInd ON processed_cropped_images(CropInd);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - calibration_images.csv
CREATE TABLE calibration_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
NCOADD DOUBLE PRECISION,
Nbit00 BIGINT,
Nbit01 BIGINT,
Nbit02 BIGINT,
Nbit03 BIGINT,
Nbit04 BIGINT,
Nbit05 BIGINT,
Nbit06 BIGINT,
Nbit07 BIGINT,
Nbit08 BIGINT,
Nbit09 BIGINT,
Nbit10 BIGINT,
Nbit11 BIGINT,
Nbit12 BIGINT,
Nbit13 BIGINT,
Nbit14 BIGINT,
Nbit15 BIGINT,
Nbit16 BIGINT,
Nbit17 BIGINT,
Nbit18 BIGINT,
Nbit19 BIGINT,
Nbit20 BIGINT,
Nbit21 BIGINT,
Nbit22 BIGINT,
Nbit23 BIGINT,
Nbit24 BIGINT,
Nbit25 BIGINT,
Nbit26 BIGINT,
Nbit27 BIGINT,
Nbit28 BIGINT,
Nbit29 BIGINT,
Nbit30 BIGINT,
Nbit31 BIGINT,
Nbit32 BIGINT
);


ALTER TABLE calibration_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX calibration_images_idx_RA ON calibration_images(RA);
CREATE INDEX calibration_images_idx_DEC ON calibration_images(DEC);
CREATE INDEX calibration_images_idx_HTM_ID ON calibration_images(HTM_ID);
CREATE INDEX calibration_images_idx_MIDJD ON calibration_images(MIDJD);
CREATE INDEX calibration_images_idx_DYEAR ON calibration_images(DYEAR);
CREATE INDEX calibration_images_idx_DMONTH ON calibration_images(DMONTH);
CREATE INDEX calibration_images_idx_DDAY ON calibration_images(DDAY);
CREATE INDEX calibration_images_idx_ImageUUID ON calibration_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - raw_images.csv
CREATE TABLE raw_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
RawImageID VARCHAR(256) NOT NULL,
ImageUUID VARCHAR(256)
);


ALTER TABLE raw_images_pkey ADD PRIMARY KEY(RawImageID);
CREATE INDEX raw_images_idx_RA ON raw_images(RA);
CREATE INDEX raw_images_idx_DEC ON raw_images(DEC);
CREATE INDEX raw_images_idx_HTM_ID ON raw_images(HTM_ID);
CREATE INDEX raw_images_idx_MIDJD ON raw_images(MIDJD);
CREATE INDEX raw_images_idx_DYEAR ON raw_images(DYEAR);
CREATE INDEX raw_images_idx_DMONTH ON raw_images(DMONTH);
CREATE INDEX raw_images_idx_DDAY ON raw_images(DDAY);
CREATE INDEX raw_images_idx_ImageUUID ON raw_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - coadded_images.csv
CREATE TABLE coadded_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
CoaddImageID VARCHAR(256),
MinJD DOUBLE PRECISION,
MaxJD DOUBLE PRECISION,
MidJD DOUBLE PRECISION,
Nimages DOUBLE PRECISION
);


ALTER TABLE coadded_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX coadded_images_idx_RA ON coadded_images(RA);
CREATE INDEX coadded_images_idx_DEC ON coadded_images(DEC);
CREATE INDEX coadded_images_idx_HTM_ID ON coadded_images(HTM_ID);
CREATE INDEX coadded_images_idx_MIDJD ON coadded_images(MIDJD);
CREATE INDEX coadded_images_idx_DYEAR ON coadded_images(DYEAR);
CREATE INDEX coadded_images_idx_DMONTH ON coadded_images(DMONTH);
CREATE INDEX coadded_images_idx_DDAY ON coadded_images(DDAY);
CREATE INDEX coadded_images_idx_ImageUUID ON coadded_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - reference_images.csv
CREATE TABLE reference_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
Nimages INTEGER,
MinJD DOUBLE PRECISION,
MaxJD DOUBLE PRECISION,
MidJD DOUBLE PRECISION
);


ALTER TABLE reference_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX reference_images_idx_RA ON reference_images(RA);
CREATE INDEX reference_images_idx_DEC ON reference_images(DEC);
CREATE INDEX reference_images_idx_HTM_ID ON reference_images(HTM_ID);
CREATE INDEX reference_images_idx_MIDJD ON reference_images(MIDJD);
CREATE INDEX reference_images_idx_DYEAR ON reference_images(DYEAR);
CREATE INDEX reference_images_idx_DMONTH ON reference_images(DMONTH);
CREATE INDEX reference_images_idx_DDAY ON reference_images(DDAY);
CREATE INDEX reference_images_idx_ImageUUID ON reference_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - stacked_cropped_sources.csv
CREATE TABLE stacked_cropped_sources (
StackSrcID BIGINT,
StackImageID INTEGER,
RA DOUBLE PRECISION,
Dec DOUBLE PRECISION,
MidJD DOUBLE PRECISION,
HTM_ID VARCHAR(256),
FluxPSF FLOAT,
FluxErrPSF FLOAT,
BackPSF FLOAT,
VarPSF FLOAT,
BackAnnulus FLOAT,
VarAnnulus FLOAT,
FluxAper1 FLOAT,
FluxErrAper1 FLOAT,
FluxAper2 FLOAT,
FluxErrAper2 FLOAT,
FluxAper3 FLOAT,
FluxErrAper3 FLOAT,
FluxAper4 FLOAT,
FluxErrAper4 FLOAT,
FluxAper5 FLOAT,
FluxErrAper5 FLOAT,
SN FLOAT,
SN_delta FLOAT,
SN_extended FLOAT,
Flag INTEGER,
InGAIA BOOLEAN,
InGALEX BOOLEAN
);

CREATE INDEX stacked_cropped_sources_idx_StackImageID ON stacked_cropped_sources(StackImageID);
CREATE INDEX stacked_cropped_sources_idx_RA ON stacked_cropped_sources(RA);
CREATE INDEX stacked_cropped_sources_idx_Dec ON stacked_cropped_sources(Dec);
CREATE INDEX stacked_cropped_sources_idx_MidJD ON stacked_cropped_sources(MidJD);
CREATE INDEX stacked_cropped_sources_idx_HTM_ID ON stacked_cropped_sources(HTM_ID);
CREATE INDEX stacked_cropped_sources_idx_FluxPSF ON stacked_cropped_sources(FluxPSF);
CREATE INDEX stacked_cropped_sources_idx_SN ON stacked_cropped_sources(SN);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - transient_sources.csv
CREATE TABLE transient_sources (
TransientSrcID VARCHAR(256),
FoundInImageProduct DOUBLE PRECISION,
OriginImageID VARCHAR(256),
Flux_PSF DOUBLE PRECISION,
FluxErr_PSF DOUBLE PRECISION,
SN DOUBLE PRECISION,
SN_delta DOUBLE PRECISION,
SN_extended DOUBLE PRECISION,
DistFromStar DOUBLE PRECISION,
HostGalaxyDist DOUBLE PRECISION,
HostGalaxyRedshift DOUBLE PRECISION,
TranslientShift DOUBLE PRECISION
);

CREATE INDEX transient_sources_idx_FoundInImageProduct ON transient_sources(FoundInImageProduct);
CREATE INDEX transient_sources_idx_SN ON transient_sources(SN);
CREATE INDEX transient_sources_idx_SN_delta ON transient_sources(SN_delta);
CREATE INDEX transient_sources_idx_SN_extended ON transient_sources(SN_extended);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - sources.csv
CREATE TABLE sources (
SourceID VARCHAR(256) NOT NULL,
A DOUBLE PRECISION,
B DOUBLE PRECISION,
C DOUBLE PRECISION,
D DOUBLE PRECISION
);


ALTER TABLE sources_pkey ADD PRIMARY KEY(SourceID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - stacked_cropped_images.csv
CREATE TABLE stacked_cropped_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
StackedImageID VARCHAR(256) NOT NULL,
NCOADD DOUBLE PRECISION,
MINJD DOUBLE PRECISION,
MAXJD DOUBLE PRECISION
);


ALTER TABLE stacked_cropped_images_pkey ADD PRIMARY KEY(StackedImageID);
CREATE INDEX stacked_cropped_images_idx_RA ON stacked_cropped_images(RA);
CREATE INDEX stacked_cropped_images_idx_DEC ON stacked_cropped_images(DEC);
CREATE INDEX stacked_cropped_images_idx_HTM_ID ON stacked_cropped_images(HTM_ID);
CREATE INDEX stacked_cropped_images_idx_MIDJD ON stacked_cropped_images(MIDJD);
CREATE INDEX stacked_cropped_images_idx_DYEAR ON stacked_cropped_images(DYEAR);
CREATE INDEX stacked_cropped_images_idx_DMONTH ON stacked_cropped_images(DMONTH);
CREATE INDEX stacked_cropped_images_idx_DDAY ON stacked_cropped_images(DDAY);
CREATE INDEX stacked_cropped_images_idx_ImageUUID ON stacked_cropped_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - processed_cropped_images.csv
CREATE TABLE processed_cropped_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ProcImageID VARCHAR(256) NOT NULL,
ImageUUID VARCHAR(256),
RawImageID VARCHAR(256),
BiasImageID VARCHAR(256),
FlatImageID VARCHAR(256),
CropInd INTEGER,
XMIN DOUBLE PRECISION,
XMAX DOUBLE PRECISION,
YMIN DOUBLE PRECISION,
YMAX DOUBLE PRECISION,
XMIN_NOOVERLAP DOUBLE PRECISION,
XMAX_NOOVERLAP DOUBLE PRECISION,
YMIN_NOOVERLAP DOUBLE PRECISION,
YMAX_NOOVERLAP DOUBLE PRECISION,
Nbit00 BIGINT,
Nbit01 BIGINT,
Nbit02 BIGINT,
Nbit03 BIGINT,
Nbit04 BIGINT,
Nbit05 BIGINT,
Nbit06 BIGINT,
Nbit07 BIGINT,
Nbit08 BIGINT,
Nbit09 BIGINT,
Nbit10 BIGINT,
Nbit11 BIGINT,
Nbit12 BIGINT,
Nbit13 BIGINT,
Nbit14 BIGINT,
Nbit15 BIGINT,
Nbit16 BIGINT,
Nbit17 BIGINT,
Nbit18 BIGINT,
Nbit19 BIGINT,
Nbit20 BIGINT,
Nbit21 BIGINT,
Nbit22 BIGINT,
Nbit23 BIGINT,
Nbit24 BIGINT,
Nbit25 BIGINT,
Nbit26 BIGINT,
Nbit27 BIGINT,
Nbit28 BIGINT,
Nbit29 BIGINT,
Nbit30 BIGINT,
Nbit31 BIGINT,
Nbit32 BIGINT,
@ History of proc_steps DOUBLE PRECISION
);


ALTER TABLE processed_cropped_images_pkey ADD PRIMARY KEY(ProcImageID);
CREATE INDEX processed_cropped_images_idx_RA ON processed_cropped_images(RA);
CREATE INDEX processed_cropped_images_idx_DEC ON processed_cropped_images(DEC);
CREATE INDEX processed_cropped_images_idx_HTM_ID ON processed_cropped_images(HTM_ID);
CREATE INDEX processed_cropped_images_idx_MIDJD ON processed_cropped_images(MIDJD);
CREATE INDEX processed_cropped_images_idx_DYEAR ON processed_cropped_images(DYEAR);
CREATE INDEX processed_cropped_images_idx_DMONTH ON processed_cropped_images(DMONTH);
CREATE INDEX processed_cropped_images_idx_DDAY ON processed_cropped_images(DDAY);
CREATE INDEX processed_cropped_images_idx_ImageUUID ON processed_cropped_images(ImageUUID);
CREATE INDEX processed_cropped_images_idx_RawImageID ON processed_cropped_images(RawImageID);
CREATE INDEX processed_cropped_images_idx_BiasImageID ON processed_cropped_images(BiasImageID);
CREATE INDEX processed_cropped_images_idx_FlatImageID ON processed_cropped_images(FlatImageID);
CREATE INDEX processed_cropped_images_idx_CropInd ON processed_cropped_images(CropInd);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - calibration_images.csv
CREATE TABLE calibration_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
NCOADD DOUBLE PRECISION,
Nbit00 BIGINT,
Nbit01 BIGINT,
Nbit02 BIGINT,
Nbit03 BIGINT,
Nbit04 BIGINT,
Nbit05 BIGINT,
Nbit06 BIGINT,
Nbit07 BIGINT,
Nbit08 BIGINT,
Nbit09 BIGINT,
Nbit10 BIGINT,
Nbit11 BIGINT,
Nbit12 BIGINT,
Nbit13 BIGINT,
Nbit14 BIGINT,
Nbit15 BIGINT,
Nbit16 BIGINT,
Nbit17 BIGINT,
Nbit18 BIGINT,
Nbit19 BIGINT,
Nbit20 BIGINT,
Nbit21 BIGINT,
Nbit22 BIGINT,
Nbit23 BIGINT,
Nbit24 BIGINT,
Nbit25 BIGINT,
Nbit26 BIGINT,
Nbit27 BIGINT,
Nbit28 BIGINT,
Nbit29 BIGINT,
Nbit30 BIGINT,
Nbit31 BIGINT,
Nbit32 BIGINT
);


ALTER TABLE calibration_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX calibration_images_idx_RA ON calibration_images(RA);
CREATE INDEX calibration_images_idx_DEC ON calibration_images(DEC);
CREATE INDEX calibration_images_idx_HTM_ID ON calibration_images(HTM_ID);
CREATE INDEX calibration_images_idx_MIDJD ON calibration_images(MIDJD);
CREATE INDEX calibration_images_idx_DYEAR ON calibration_images(DYEAR);
CREATE INDEX calibration_images_idx_DMONTH ON calibration_images(DMONTH);
CREATE INDEX calibration_images_idx_DDAY ON calibration_images(DDAY);
CREATE INDEX calibration_images_idx_ImageUUID ON calibration_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - raw_images.csv
CREATE TABLE raw_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
RawImageID VARCHAR(256) NOT NULL,
ImageUUID VARCHAR(256)
);


ALTER TABLE raw_images_pkey ADD PRIMARY KEY(RawImageID);
CREATE INDEX raw_images_idx_RA ON raw_images(RA);
CREATE INDEX raw_images_idx_DEC ON raw_images(DEC);
CREATE INDEX raw_images_idx_HTM_ID ON raw_images(HTM_ID);
CREATE INDEX raw_images_idx_MIDJD ON raw_images(MIDJD);
CREATE INDEX raw_images_idx_DYEAR ON raw_images(DYEAR);
CREATE INDEX raw_images_idx_DMONTH ON raw_images(DMONTH);
CREATE INDEX raw_images_idx_DDAY ON raw_images(DDAY);
CREATE INDEX raw_images_idx_ImageUUID ON raw_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - coadded_images.csv
CREATE TABLE coadded_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
CoaddImageID VARCHAR(256),
MinJD DOUBLE PRECISION,
MaxJD DOUBLE PRECISION,
MidJD DOUBLE PRECISION,
Nimages DOUBLE PRECISION
);


ALTER TABLE coadded_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX coadded_images_idx_RA ON coadded_images(RA);
CREATE INDEX coadded_images_idx_DEC ON coadded_images(DEC);
CREATE INDEX coadded_images_idx_HTM_ID ON coadded_images(HTM_ID);
CREATE INDEX coadded_images_idx_MIDJD ON coadded_images(MIDJD);
CREATE INDEX coadded_images_idx_DYEAR ON coadded_images(DYEAR);
CREATE INDEX coadded_images_idx_DMONTH ON coadded_images(DMONTH);
CREATE INDEX coadded_images_idx_DDAY ON coadded_images(DDAY);
CREATE INDEX coadded_images_idx_ImageUUID ON coadded_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - reference_images.csv
CREATE TABLE reference_images (
RA DOUBLE PRECISION,
DEC DOUBLE PRECISION,
HA DOUBLE PRECISION,
AZ FLOAT,
ALT FLOAT,
EQUINOX FLOAT,
IMTYPE INTEGER,
NROW INTEGER,
NCOL INTEGER,
HTM_ID VARCHAR(256),
T_RA DOUBLE PRECISION,
T_DEC DOUBLE PRECISION,
M_RA DOUBLE PRECISION,
M_DEC DOUBLE PRECISION,
C_RA DOUBLE PRECISION,
C_DEC DOUBLE PRECISION,
LST DOUBLE PRECISION,
RA_NE DOUBLE PRECISION,
RA_SE DOUBLE PRECISION,
RA_SW DOUBLE PRECISION,
RA_NW DOUBLE PRECISION,
DEC_NE DOUBLE PRECISION,
DEC_SE DOUBLE PRECISION,
DEC_SW DOUBLE PRECISION,
DEC_NW DOUBLE PRECISION,
AIRMASS FLOAT,
PARANG FLOAT,
CCDID INTEGER,
EXPTIME FLOAT,
JD DOUBLE PRECISION,
MIDJD DOUBLE PRECISION,
DYEAR INTEGER,
DMONTH INTEGER,
DDAY INTEGER,
NODE INTEGER,
TELESCOP INTEGER,
CAMNUM INTEGER,
CAMNAME VARCHAR(256),
MOUNAME VARCHAR(256),
JD_Insertion DOUBLE PRECISION,
IMMEAN FLOAT,
IMMED FLOAT,
IMBACK FLOAT,
IMVAR FLOAT,
NSAT BIGINT,
SUNALT FLOAT,
MOONALT FLOAT,
MOONDIST FLOAT,
DOMEOPEN BOOLEAN,
EASTW BOOLEAN,
NORTHW BOOLEAN,
SOUTHW BOOLEAN,
TEMPOUT FLOAT,
TEMPTEL FLOAT,
TEMPCAM FLOAT,
CAMPOW FLOAT,
HUMID FLOAT,
PRESS FLOAT,
CLOUD FLOAT,
ImageUUID VARCHAR(256),
CalibImageInd VARCHAR(256) NOT NULL,
Nimages INTEGER,
MinJD DOUBLE PRECISION,
MaxJD DOUBLE PRECISION,
MidJD DOUBLE PRECISION
);


ALTER TABLE reference_images_pkey ADD PRIMARY KEY(CalibImageInd);
CREATE INDEX reference_images_idx_RA ON reference_images(RA);
CREATE INDEX reference_images_idx_DEC ON reference_images(DEC);
CREATE INDEX reference_images_idx_HTM_ID ON reference_images(HTM_ID);
CREATE INDEX reference_images_idx_MIDJD ON reference_images(MIDJD);
CREATE INDEX reference_images_idx_DYEAR ON reference_images(DYEAR);
CREATE INDEX reference_images_idx_DMONTH ON reference_images(DMONTH);
CREATE INDEX reference_images_idx_DDAY ON reference_images(DDAY);
CREATE INDEX reference_images_idx_ImageUUID ON reference_images(ImageUUID);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - stacked_cropped_sources.csv
CREATE TABLE stacked_cropped_sources (
StackSrcID BIGINT,
StackImageID INTEGER,
RA DOUBLE PRECISION,
Dec DOUBLE PRECISION,
MidJD DOUBLE PRECISION,
HTM_ID VARCHAR(256),
FluxPSF FLOAT,
FluxErrPSF FLOAT,
BackPSF FLOAT,
VarPSF FLOAT,
BackAnnulus FLOAT,
VarAnnulus FLOAT,
FluxAper1 FLOAT,
FluxErrAper1 FLOAT,
FluxAper2 FLOAT,
FluxErrAper2 FLOAT,
FluxAper3 FLOAT,
FluxErrAper3 FLOAT,
FluxAper4 FLOAT,
FluxErrAper4 FLOAT,
FluxAper5 FLOAT,
FluxErrAper5 FLOAT,
SN FLOAT,
SN_delta FLOAT,
SN_extended FLOAT,
Flag INTEGER,
InGAIA BOOLEAN,
InGALEX BOOLEAN
);

CREATE INDEX stacked_cropped_sources_idx_StackImageID ON stacked_cropped_sources(StackImageID);
CREATE INDEX stacked_cropped_sources_idx_RA ON stacked_cropped_sources(RA);
CREATE INDEX stacked_cropped_sources_idx_Dec ON stacked_cropped_sources(Dec);
CREATE INDEX stacked_cropped_sources_idx_MidJD ON stacked_cropped_sources(MidJD);
CREATE INDEX stacked_cropped_sources_idx_HTM_ID ON stacked_cropped_sources(HTM_ID);
CREATE INDEX stacked_cropped_sources_idx_FluxPSF ON stacked_cropped_sources(FluxPSF);
CREATE INDEX stacked_cropped_sources_idx_SN ON stacked_cropped_sources(SN);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - transient_sources.csv
CREATE TABLE transient_sources (
TransientSrcID VARCHAR(256),
FoundInImageProduct DOUBLE PRECISION,
OriginImageID VARCHAR(256),
Flux_PSF DOUBLE PRECISION,
FluxErr_PSF DOUBLE PRECISION,
SN DOUBLE PRECISION,
SN_delta DOUBLE PRECISION,
SN_extended DOUBLE PRECISION,
DistFromStar DOUBLE PRECISION,
HostGalaxyDist DOUBLE PRECISION,
HostGalaxyRedshift DOUBLE PRECISION,
TranslientShift DOUBLE PRECISION
);

CREATE INDEX transient_sources_idx_FoundInImageProduct ON transient_sources(FoundInImageProduct);
CREATE INDEX transient_sources_idx_SN ON transient_sources(SN);
CREATE INDEX transient_sources_idx_SN_delta ON transient_sources(SN_delta);
CREATE INDEX transient_sources_idx_SN_extended ON transient_sources(SN_extended);

-- Source file: /home/eran/matlab/AstroPack/database/xlsx/lastdb/csv/lastdb - sources.csv
CREATE TABLE sources (
SourceID VARCHAR(256) NOT NULL,
A DOUBLE PRECISION,
B DOUBLE PRECISION,
C DOUBLE PRECISION,
D DOUBLE PRECISION
);


ALTER TABLE sources_pkey ADD PRIMARY KEY(SourceID);
