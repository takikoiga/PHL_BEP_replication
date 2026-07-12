clear all
* ===== SET THIS TO YOUR LOCAL REPOSITORY PATH =====
* Set this to the folder where you have cloned/downloaded this repository.
gl parent "."
* ====================================================
gl onedr "$parent/PH_BEP"
gl data "$onedr/data"
gl ldi "$onedr/LDI"
gl ready "$data/ReadyData"
gl Tbl "$onedr/output/tables"

use "$data/POPCEN2020_f3_mmhh_merged.dta", clear


****************************************
* Restrict samples to pre-policy
****************************************
	destring P14_PRVMUN, gen(p14)
	gen prv_birth=int(p14/100)
	
	gen birthmun=p14
	
	** Defining age and sample
  local census_yr	2020
  local policy		1974
  local age_entry	6
  local age_grad	15
  
	gen age_1974=P5-(`census_yr'-`policy')
	label variable age_1974 "Age in 1974 (BEP start)"
	
	gen fl_treat = inrange(age_1974, 3, 6) 	// from 1978 BEP was expanded to non-Tagalog areas
	gen pt_treat = inrange(age_1974, 7, 11) // elementary
	gen no_treat = inrange(age_1974, 12, 15)	// high school
	gen control = (pt_treat==1|no_treat==1)
	
	
	keep if control == 1
	
	
********************
********************

keep H13 prv_birth birthmun

gen matchedlang = "" // comparing the popcen2020 with ethnologue

replace matchedlang = "Agusan Manobo" if H13 == 180
replace matchedlang = "Binukid" if H13 == 71
replace matchedlang = "Cuyonon" if H13 == 82
replace matchedlang = "Dibabawon Manobo" if H13 == 181
replace matchedlang = "Higaonon" if H13 == 96
replace matchedlang = "Ibaloi" if H13 == 98
replace matchedlang = "Ibanag" if H13 == 99
replace matchedlang = "Ibatan" if H13 == 100
replace matchedlang = "Ilocano" if H13 == 104
replace matchedlang = "Ilongot" if H13 == 69
replace matchedlang = "Isinai" if H13 == 110
replace matchedlang = "Isnag" if H13 == 111
replace matchedlang = "Itawit" if H13 == 114
replace matchedlang = "Banao Itneg" if H13 == 115
replace matchedlang = "Ivatan" if H13 == 128
replace matchedlang = "Southern Kalinga" if H13 == 141
replace matchedlang = "Kamayo" if H13 == 143
replace matchedlang = "Kankanaey" if H13 == 145
replace matchedlang = "Kapampangan" if H13 == 147
replace matchedlang = "Karao" if H13 == 148
replace matchedlang = "Kinaray-a" if H13 == 149
replace matchedlang = "Kolibugan Subanon" if H13 == 153
replace matchedlang = "Maguindanao" if H13 == 158
replace matchedlang = "Malaynon" if H13 == 160
replace matchedlang = "Mamanwa" if H13 == 161
replace matchedlang = "Karaga Mandaya" if H13 == 162
replace matchedlang = "Obo Manobo" if H13 == 175
replace matchedlang = "Mansaka" if H13 == 192
replace matchedlang = "Maranao" if H13 == 194
replace matchedlang = "Masbatenyo" if H13 == 196
replace matchedlang = "Molbog" if H13 == 197
replace matchedlang = "Porohanon" if H13 == 210
replace matchedlang = "Romblomanon" if H13 == 211
replace matchedlang = "Central Sama" if H13 == 212
replace matchedlang = "Sangil" if H13 == 216
replace matchedlang = "Central Subanen" if H13 == 219
replace matchedlang = "Surigaonon" if H13 == 220
replace matchedlang = "Tboli" if H13 == 221
replace matchedlang = "Tagabawa" if H13 == 223
replace matchedlang = "Tagakaulu Kalagan" if H13 == 225
replace matchedlang = "Tagalog" if H13 == 226
replace matchedlang = "Tagbanwa" if H13 == 227
replace matchedlang = "Tausug" if H13 == 233
replace matchedlang = "Tuwali Ifugao" if H13 == 237
replace matchedlang = "Waray-Waray" if H13 == 241
replace matchedlang = "Yakan" if H13 == 242
replace matchedlang = "Yogad" if H13 == 244
replace matchedlang = "Mandarin Chinese" if H13 == 249
replace matchedlang = "Spanish" if H13 == 255
replace matchedlang = "English" if H13 == 247
replace matchedlang = "Japanese" if H13 == 253
replace matchedlang = "Cebuano" if H13 == 64
replace matchedlang = "Albay Bicolano" if H13 == 63
replace matchedlang = "Albay Bicolano" if H13 == 65
replace matchedlang = "Western Bukidnon Manobo" if H13 == 72
replace matchedlang = "Cebuano" if H13 == 79
replace matchedlang = "Hiligaynon" if H13 == 105
replace matchedlang = "Pangasinan" if H13 == 207
replace matchedlang = "Sarangani Blaan" if H13 == 49
replace matchedlang = "Tagakaulu Kalagan" if H13 == 245
replace matchedlang = "Iraya" if H13 == 108
replace matchedlang = "Central Sama" if H13 == 214
replace matchedlang = "Tiruray" if H13 == 222
replace matchedlang = "Inonhan" if H13 == 200
replace matchedlang = "Tiruray" if H13 == 45
replace matchedlang = "Central Sama" if H13 == 213
replace matchedlang = "Central Palawano" if H13 == 202
replace matchedlang = "Alangan" if H13 == 138
replace matchedlang = "Capiznon" if H13 == 76
replace matchedlang = "Pampangan" if H13 == 147

rename matchedlang lang
lab var lang "Language names in Ethnologue"
merge m:1 lang using "$ldi/LangSimilarity_Tagalog.dta"
* このTagSimという変数は実はTagalogからのDistanceです。（確認すみ）

drop if _merge==2

* Count number of speakers per language per province
gen one = 1
drop if lang==""

*********************
* PROVINCE
*********************

collapse (sum) one (first) TagSim , by(prv_birth lang)
rename one num_speakers // Total of per-province specific lang speakers

preserve
collapse (sum) num_speakers, by(prv_birth)
rename num_speakers provpop_control

tempfile province_pop
save `province_pop'
restore

merge m:1 prv_birth using `province_pop', nogenerate
gen share = num_speakers / provpop_control
encode lang, gen(lang_id)
* NOTE: A line here previously read `replace TagSim=1 if lang=="Japanese"`,
* the same erroneous copy-paste artifact found and removed in
* LDI_popcen2020_languagematch_muicipality.do. Removed in the replication
* version; Japanese speakers now retain their correct similarity score from
* the LangSimilarity_Tagalog.dta lookup table merged in above.
gen LDItag = share * TagSim


* Save lookup table
preserve
keep lang lang_id TagSim LDItag
duplicates drop
label values lang_id 
save $ldi/lang_lookup.dta, replace
restore

*** RESHAPING ***
keep prv_birth lang_id LDItag
reshape wide LDItag, i(prv_birth) j(lang_id)


egen LDItag_prv=rowtotal(LDItag1-LDItag63)

gen LDIshift_prv=1-LDItag_prv

lab var LDItag_prv "Tagalog Ling. Distance Index (Province)"
lab var LDIshift_prv "LDI Difference (pre-post)"

keep prv_birth LDItag_prv LDIshift_prv

save $ldi/LDI_Tagalog_birthprov, replace
restore
