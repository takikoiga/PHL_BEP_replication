********************************************************************************
* PROJECT: Philippines BEP - Municipality-Level Data Construction
* PURPOSE: Construct municipality-level Tagalog share and LDT from individual data
* AUTHOR:  Takiko Igarashi
* DATE:    February 6, 2026
********************************************************************************

********************************************************************************
* PART 1: CONSTRUCT MUNICIPALITY-LEVEL VARIABLES FROM INDIVIDUAL DATA
********************************************************************************

clear all
set more off

* ===== SET THIS TO YOUR LOCAL REPOSITORY PATH =====
* Set this to the folder where you have cloned/downloaded this repository.
gl parent "."
* ====================================================
	gl onedr "$parent/PH_BEP"
		gl data 	"$onedr/data"
		gl ldi 		"$onedr/LDI"
		gl dofile	"$onedr/do_files"
			gl ready "$data/ReadyData"

		gl Fig 		"$onedr/output/figures"
		gl Tbl 		"$onedr/output/tables"
		

set scheme plotplainblind

 use "$data/ReadyData/Popcen2020_readydata.dta", clear

keep if inrange(birthyr, 1955, 1962)

* Calculate municipality-level statistics
collapse (mean) tag_share_mun LDItag_mun tag_mun, by(mun_birth prv_birth)

* Check results
summarize tag_share_mun LDItag_mun tag_mun 
count
* Should have ~1,732 municipalities

********************************************************************************
* STEP 5: IDENTIFY MISSING/PROBLEMATIC MUNICIPALITIES
********************************************************************************

* List municipalities with missing Tagalog share
list prv_birth mun_birth tag_share_mun LDItag_mun ///
    if missing(tag_share_mun), clean

* Count by missingness pattern
count if missing(tag_share_mun) // 3 municipalities under province 38 missing tag_share
count if missing(LDItag_mun)
count if missing(tag_share_mun) & missing(LDItag_mun)

********************************************************************************
* STEP 6: IMPUTATION STRATEGY (OPTIONAL)
********************************************************************************
	*** imputing the mean to the missing mun
	
	* Calculate provincial mean for province 38 (excluding missing values)
	summarize tag_share_mun if prv_birth == 38 & !missing(tag_share_mun)
	* Calculate and store the mean
	egen prv38_mean = mean(tag_share_mun) if prv_birth == 38
	* Impute missing values with provincial mean
	replace tag_share_mun = prv38_mean if prv_birth == 38 & missing(tag_share_mun)
	* Check the imputation worked
	list prv_birth mun_birth tag_share_mun LDItag_mun ///
		if prv_birth == 38 & inlist(mun_birth, 22, 27, 30), clean
	* Clean up temporary variable
	drop prv38_mean
	* Verify no more missing values
	count if missing(tag_share_mun)

********************************************************************************
* STEP 7: SAVE MUNICIPALITY-LEVEL DATA
********************************************************************************

* Keep necessary variables
keep prv_birth mun_birth tag_share_mun LDItag_mun tag_mun 

* Sort for consistency
sort prv_birth mun_birth

* Save
save "$data/municipality_census_mapgraph.dta", replace

* Summary report
summarize tag_share_mun LDItag_mun tag_mun, detail

* Distribution of Tagalog share
histogram tag_share_mun, width(0.01) frequency ///
    title("Distribution of Tagalog Share across Municipalities") ///
    xtitle("Share of Tagalog Speakers") ytitle("Number of Municipalities")
graph export "$Fig/tagalog_share_histogram.png", replace

* Distribution of LDT
histogram LDItag_mun, width(0.005) frequency ///
    title("Distribution of Linguistic Distance from Tagalog") ///
    xtitle("LDT (0=identical, 1=maximum distance)") ytitle("Number of Municipalities")
graph export "$Fig/ldt_histogram.png", replace

********************************************************************************
* PART 2: MERGE WITH SHAPEFILE FOR MAPPING
********************************************************************************

********************************************************************************
* STEP 8: LOAD AND PREPARE SHAPEFILE
********************************************************************************

* Set shapefile directory
global shp_dir "$ldi/PH_Adm3_MuniCities"
cd "$shp_dir"

* If not already converted, convert shapefile to Stata format
capture confirm file "ph_municipalities.dta"
if _rc {
    shp2dta using "Municities.shp", ///
        database(ph_municipalities) ///
        coordinates(ph_municipalities_coord) ///
        genid(id) replace
}

* Load shapefile attribute data
use ph_municipalities.dta, clear

* Extract PSGC province and municipality codes
gen psgc_clean = floor(corr_code/1000)
gen psgc_str = string(psgc_clean, "%06.0f")
gen mun_birth = real(substr(psgc_str, -2, 2))
gen prv_birth = real(substr(psgc_str, -4, 2))

* Drop special government units (no PSGC codes)
drop if geo_level == "SGU"

* Check for duplicates
duplicates report prv_birth mun_birth
* Should be 0 duplicates after dropping SGUs

* Keep key variables from shapefile
keep id prv_birth mun_birth psgc_code corr_code name geo_level ///
     adm3_pcode adm3_en adm2_pcode adm1_pcode ///
     shape_len shape_area shape_sqkm
	 
	 ** correcting province code for NCR 
		*------------------------------------------------------------------
		* NCR legacy province codes (pre-harmonization)
		*
		* 74 = Marikina, Pasig, Quezon City, San Juan
		* 75 = Caloocan, Navotas, Valenzuela
		* 76 = Las Piñas, Makati, Taguig, Muntinlupa, Pateros
		* Official PSGC province code for NCR = 39
		*------------------------------------------------------------------

		*replace prv_birth = 39 if inlist(prv_birth, 74, 75, 76)

* Save cleaned shapefile
save $shp_dir/ph_municipalities_clean.dta, replace

********************************************************************************
* STEP 9: MERGE MUNICIPALITY DATA WITH SHAPEFILE
********************************************************************************

* Load your municipality-level data
use "$data/municipality_census_mapgraph.dta", clear

	drop if mun_birth==99

	replace mun_birth=0 if mun_birth==1 & prv_birth==39
	*replace prv_birth=74 if prv_birth==39 & inlist(mun_birth, 1,2,3,4,5)

* Merge with shapefile
merge 1:1 prv_birth mun_birth using "$shp_dir/ph_municipalities_clean.dta"

* Examine merge results
tab _merge

* List unmatched from master (in census but not in shapefile)
list prv_birth mun_birth tag_share_mun LDItag_mun  ///
    if _merge == 1, clean sepby(prv_birth)
* These may be:
* - New municipalities created after shapefile date
* - Municipality code changes
* - Data entry errors in census codes

* List unmatched from using (in shapefile but not in census)
list prv_birth mun_birth name geo_level if _merge == 2, clean
* These may be:
* - Municipalities with no individuals in pre-policy cohorts in census sample
* - Newly created municipalities with no older population


********************************************************************************
* STEP 10: HANDLE UNMATCHED MUNICIPALITIES
********************************************************************************

* STRATEGY A: Use original values, set missing for unmatched from shapefile
gen tag_share_final = tag_share_mun
gen ldt_final = LDItag_mun

* STRATEGY B: Use imputed values to fill in shapefile-only municipalities
* gen tag_share_final = tag_share_mun_imp
* gen ldt_final = LDItag_mun_imp

* For shapefile municipalities with no census data, could impute from:
* 1. Provincial average
* 2. Regional average  
* 3. Nearest neighbor (if coordinates available)

* Example: Fill with provincial average for _merge==2
bysort prv_birth: egen prv_tag = mean(tag_share_mun)
bysort prv_birth: egen prv_ldt = mean(LDItag_mun)

replace tag_share_final = prv_tag if _merge == 2 & missing(tag_share_final)
replace ldt_final = prv_ldt if _merge == 2 & missing(ldt_final)

* Create indicator for imputation source
gen data_source = ""
replace data_source = "Census" if _merge == 3 & !missing(tag_share_mun)
replace data_source = "Provincial avg (no census)" if _merge == 2
replace data_source = "Census only (no map)" if _merge == 1

label variable tag_share_final "Tagalog share (final for mapping)"
label variable ldt_final "LDT (final for mapping)"
label variable data_source "Source of municipality data"

* Check final coverage
tab data_source
summarize tag_share_final ldt_final

********************************************************************************
* STEP 11: SAVE FINAL MERGED DATA FOR MAPPING
********************************************************************************

* Keep only matched or filled observations for mapping
keep if _merge == 3 | (_merge == 2 & !missing(tag_share_final))

* Keep necessary variables
keep id prv_birth mun_birth name geo_level ///
     tag_share_final ldt_final tag_mun ///
       data_source ///
     psgc_code corr_code adm3_pcode adm3_en

* Rename for consistency
rename tag_share_final tag_share_mun
rename ldt_final lditag_mun

* Sort and save
sort id
save "$data/municipality_ShapefileCensus_final.dta", replace

* Summary statistics for final data
summarize tag_share_mun lditag_mun
count if missing(tag_share_mun)
count if missing(lditag_mun)
tab data_source

********************************************************************************
* STEP 12: CREATE MAPS WITH FINAL DATA
********************************************************************************

* Load final merged data
use "$data/municipality_ShapefileCensus_final.dta", clear

* Map 1: Tagalog Share
* Improved Tagalog Share Map
spmap tag_share_mun using ph_municipalities_coord, ///
    id(id) ///
    clmethod(custom) clbreaks(0 0.1 0.3 0.5 0.7 0.9 1) ///
    fcolor(Greys) ///
    ocolor(gs14 ..) osize(vthin ..) ///
    legend(position(9) size(vsmall) ring(0) ///
           title("Tagalog speaker share", size(vsmall))) ///
    ndfcolor(3) ///
    plotregion(margin(zero))
    
graph export "map_tagalog_final.png", replace width(3000)

* Map 2: LDT

* Step 1: Get the cutpoints
_pctile lditag_mun, nq(10)
local p10 = r(r1)
local p20 = r(r2)
local p30 = r(r3)
local p50 = r(r5)
local p70 = r(r7)
local p90 = r(r9)
local max = r(r9)
summarize lditag_mun
local max = r(max)

* Step 2: Create groups (if not already done)
capture drop ldt_group
gen ldt_group = .
replace ldt_group = 1 if lditag_mun <= `p10'
replace ldt_group = 2 if lditag_mun > `p10' & lditag_mun <= `p30'
replace ldt_group = 3 if lditag_mun > `p30' & lditag_mun <= `p50'
replace ldt_group = 4 if lditag_mun > `p50' & lditag_mun <= `p70'
replace ldt_group = 5 if lditag_mun > `p70' & lditag_mun <= `p90'
replace ldt_group = 6 if lditag_mun > `p90' & !missing(lditag_mun)

* Step 3: Create labels with actual values
label define ldt_lbl ///
    1 "Lowest" ///
    2 "P20 -- P30" ///
    3 "P40 -- P50" ///
    4 "P60 -- P70" ///
    5 "P80 -- P90" ///
    6 "Highest", replace
label values ldt_group ldt_lbl

* Step 4: Create map
spmap ldt_group using ph_municipalities_coord, ///
    id(id) ///
    clmethod(unique) ///
    fcolor(gs2 gs5 gs8 gs11 gs13 gs15) ///
    ocolor(gs14 ..) osize(vthin ..) ///
    legend(position(9) size(vsmall) ring(0) ///
           title("Linguistic Distance Index (from Tagalog)", size(vsmall))) ///
    plotregion(margin(zero))
    
graph export "map_ldt_final.png", replace width(3000)

* Map 3: Tagalog-dominant binary 
spmap tag_mun using ph_municipalities_coord, ///
    id(id) ///
    clmethod(unique) ///
    fcolor(Greys) ///
    ocolor(gs14 ..) osize(vthin ..) ///
    legend(position(9) size(vsmall) ring(0) ///
           title("Tagalog-dominant municipalities", size(vsmall))) ///
    ndfcolor(3) ///
    plotregion(margin(zero))
    
graph export "map_tagalog_dominant_final.png", replace width(3000)

********************************************************************************
* END OF DO-FILE
********************************************************************************
