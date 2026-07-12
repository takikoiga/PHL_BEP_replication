**************
* MASTER DATA CONSTRUCTION DO-FILE (REPLICATION VERSION)
* Adopting the Language of the Ethnic Majority:
* Evaluation of the Philippines' Bilingual Education Policy
* Igarashi & Takahashi
*
* Runs the full data construction pipeline, in order, from raw PSA
* microdata extracts through to the final analysis-ready dataset used by
* ../master.do. See README.md for setup instructions and data access
* details.
*
* NOTE: Before running this, execute r_scripts/R_construct_elevation_geodata_PHIL.R
* to generate PH_BEP/LDI/terrain_ruggedness.csv (required by step 4 below).
**************

clear all
macro drop _all

* ===== SET THIS TO YOUR LOCAL REPOSITORY PATH =====
gl parent "."
* ====================================================

	gl onedr "$parent/PH_BEP"
	gl dofile "$parent/do_files/data_construction"

* Step 1: Raw PSA CSV extracts -> merged household/member-level .dta
* Output: POPCEN2020_f3_mmhh_merged.dta
do "$dofile/Process_2020popcenRaw.do"

* Step 2a: Municipality-level Linguistic Distance from Tagalog (LDT)
* Output: PH_BEP/LDI/LDI_Tagalog_municipality.dta
do "$dofile/LDI_popcen2020_languagematch_muicipality.do"

* Step 2b: Province-level Linguistic Distance from Tagalog (LDT)
* Output: PH_BEP/LDI/LDI_Tagalog_birthprov.dta
do "$dofile/LDI_popcen2020_languagematch_province.do"

* Step 3: Build final analysis-ready dataset
* Merges municipality/province LDT, elevation controls (requires
* terrain_ruggedness.csv from the R script), and other municipality-level
* variables into the individual-level census extract.
* Output: PH_BEP/data/ReadyData/Popcen2020_readydata.dta
do "$dofile/Popcen2020_readyData_v3.do"

* Step 4 (optional): Produce map figures (Tagalog share, LDT quartile maps)
* Requires Popcen2020_readydata.dta from Step 3.
do "$dofile/Mapgraph_shapefiles.do"

di "Data construction pipeline complete. Run ../master.do for the main analysis."
