*****************************************************************************
* Popcen2020_readyData_v2.do
* Project : BEP - Bilingual Education Policy, Philippines
* Purpose : Data preparation — construct analysis-ready dataset
* Author  : Takiko Igarashi
* Updated : 2026
*
* Structure 
*   §1  Setup and globals
*   §2  Load data and basic demographics
*   §3  Sample and treatment variables
*   §4  Geographic variables
*   §5  Tagalog-dominant area classification (pre-policy)
*   §6  Pre-policy education baseline (HS share)
*   §7  Education outcome variables
*   §8  Labor market variables — existing
*   §9  Labor market variables — NEW (English-premium mechanism)
*   §10 Industry variables
*   §11 Ethnicity classification
*   §12 Interethnic marriage
*   §13 Intergenerational sample (children of main sample)
*   §14 Fertility and other individual outcomes
*   §15 Language fractionalization
*   §16 Linguistic Distance from Tagalog (LDT)
*   §17 Directed migration (NEW)
*   §18 Save
*****************************************************************************


**# §1 Setup and globals
*****************************************************************************

clear all

* ===== SET THIS TO YOUR LOCAL REPOSITORY PATH =====
* Set this to the folder where you have cloned/downloaded this repository.
gl parent "."
* ====================================================
gl db  "$parent/PH_BEP"
gl data   "$db/data"
gl ldi    "$db/LDI"
gl ready  "$data/ReadyData"
gl Tbl    "$db/output/tables"


**# §2 Load data and basic demographics
*****************************************************************************

use "$data/POPCEN2020_f3_mmhh_merged.dta", clear

* Core demographics
gen relationHHhead = P2
gen female         = (P3 == 2)
gen age            = P5
gen ethnicity      = P12

label var female "Female (1=yes)"
label var age    "Age as of 2020 (data year)"

* Drop very young children (not relevant for any analysis)
drop if age <= 5

gen Tagalog = (H13 == 226)


**# §3 Sample and treatment variables
*****************************************************************************

* --- Age at policy rollout ---
local census_yr  2020
local policy     1974
local age_entry  6
local age_grad   15

gen age_1974 = age - (`census_yr' - `policy')
label var age_1974 "Age in 1974 (BEP start)"

gen birthyr = `census_yr' - age
label var birthyr "Year of Birth"

* --- Exposure groups (based on age in 1974) ---
gen fl_treat  = inrange(age_1974, 3, 6)   // Fully exposed: entered Grade 1 under BEP Phase I
gen pt_treat  = inrange(age_1974, 7, 11)  // Potentially exposed: enrolled when BEP was introduced
gen no_treat  = inrange(age_1974, 12, 14) // Never exposed: beyond school entry age
gen superold  = inrange(age_1974, 16, 18) // Pre-policy reference cohort (used for baseline)
gen control   = (pt_treat == 1 | no_treat == 1)

label var fl_treat "Fully exposed"
label var pt_treat "Potentially exposed"
label var no_treat "Not exposed"
label var control  "Not fully exposed or never exposed"	
label var superold "Super old (62-64 in 2020)"

* --- Sample flags ---
gen in_sample  = fl_treat | control     // Strategy 1 sample: Groups 2+3 vs control
gen in_sample2 = fl_treat | no_treat    // Strategy 1 (strict): Group 3 vs Group 1 only

* --- Categorical treatment (for cross-tabs) ---
gen treat = .
replace treat = 0 if no_treat == 1
replace treat = 1 if pt_treat == 1
replace treat = 2 if fl_treat == 1
tab treat, mi

label define treatl 0 "Not exposed" 1 "Potentially exposed" 2 "Fully exposed", replace
label values treat treatl
label var treat "BEP exposure"


**# §4 Geographic variables
*****************************************************************************

* --- Birth province and municipality ---
destring P14_PRVMUN, gen(p14)
gen prv_birth = int(p14 / 100)
gen mun_birth = substr(P14_PRVMUN, -2, 2)
destring mun_birth, replace
gen birthmun = p14

* --- Migration status relative to birthplace ---
gen samePsameM_birth = (P14_RECODE == "1")   // Same province & municipality
gen samePdiffM_birth = (P14_RECODE == "2")   // Same province, different municipality
gen diffPdiffM_birth = (P14_RECODE == "3")   // Different province & municipality
gen moveout          = (samePsameM_birth == 0)

label var samePsameM_birth "Same prov \& muni since birth (1=yes)"
label var samePdiffM_birth "Same prov, diff muni since birth (1=yes)"
label var diffPdiffM_birth "Diff prov \& muni since birth (1=yes)"
label var moveout          "Moved out from municipality of birth"

* --- 5-year-before and school province/municipality ---
destring P15_PRVMUN, gen(p15)
gen prv_5yb = int(p15 / 100)
gen mun_5yb = P15_PRVMUN

destring P19_PRVMUN, gen(p19)
gen prv_sch = int(p19 / 100)
gen mun_sch = P19_PRVMUN

label var prv_birth "Province at birth"
label var prv_5yb   "Province of residence in 2015"
label var prv_sch   "Province of school in 2020"
label var mun_birth "Municipality at birth"
label var mun_5yb   "Municipality of residence in 2015"
label var mun_sch   "Municipality of school in 2020"
label var birthmun  "Municipality (4 digits)"

* --- City/municipality classification (urban/rural) ---
merge m:1 prv_birth mun_birth using "$data/PSGC_citymunicipality.dta"
drop if _merge == 2
drop _merge


**# §5 Tagalog-dominant area classification (pre-policy)
*****************************************************************************

* Using superold cohort (ages 16-18 in 1974) as pre-policy reference
gen tag_dummy = (H13 == 226)

* --- Province-level Tagalog share and dominance ---
preserve
    keep if superold == 1
    collapse (mean) tag_share = tag_dummy [aweight = POPWGT], by(prv_birth)
    gen tag_prov = (tag_share > 0.5)
    label var tag_share "Pre-policy share of Tagalog Speakers"
    label var tag_prov  "Pre-policy Tagalog-dominance (1=yes)"
    tempfile tagshare
    save `tagshare'

    histogram tag_share, bin(50) frequency ///
        xtitle("Pre-policy Share of Tagalog Speakers") ///
        ytitle("Provinces") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/tagalog_share_histogram.png", replace
restore
merge m:1 prv_birth using `tagshare', keepusing(tag_share tag_prov)
drop _merge

* --- Municipality-level Tagalog share and dominance ---
preserve
    keep if superold == 1
    collapse (mean) tag_share_mun = tag_dummy [aweight = POPWGT], by(birthmun)
    gen tag_mun = (tag_share_mun > 0.5)
    sum tag_share_mun, detail
    label var tag_share_mun "Pre-policy share of Tagalog speakers"
    label var tag_mun       "Pre-policy Tagalog-Dominance (1=yes)"
    tempfile tagsharem
    save `tagsharem'

    histogram tag_share_mun, bin(50) frequency ///
        xtitle("Pre-policy Share of Tagalog Speakers") ///
        ytitle("Municipalities") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/tagalog_share_histogram_mun.png", replace
restore
merge m:1 birthmun using `tagsharem', keepusing(tag_share_mun tag_mun)
drop _merge

tab tag_mun if in_sample == 1


**# §5b Tagalog area classification (robustness / GS-based)
*****************************************************************************
* Main analysis uses: tag_mun (pre-policy Tagalog share > 50%, municipality)
* This section: geographic classification for robustness checks and
*               directed migration outcome variables
*
* Definition: NCR + Region III (excl. Pampanga=54, Angeles City=55)
*           + Region IV-A (CALABARZON, all 5 provinces)
*           + MIMAROPA Tagalog provinces (GS 1985 codes 02+03):
*             Marinduque(40), Occ.Mindoro(51), Or.Mindoro(52),
*             Palawan(53), Puerto Princesa City(315)
* Excluded:  Pampanga(54) — Kapampangan, not Tagalog
*            Angeles City(55) — HUC, Kapampangan
*            Romblon(59) — Romblomanon, not Tagalog
*
* Source: Gonzalez and Sibayan (1985) Table 2 + current admin boundaries
* All province codes verified from census output
*****************************************************************************

* --- Birth area (Tagalog = 1) ---
gen tag_area_birth = 0

replace tag_area_birth = 1 if inlist(prv_birth, 39, 74, 75, 76)
*                              NCR (Manila, East, North, South)

replace tag_area_birth = 1 if inlist(prv_birth, 8, 14, 49, 69, 71, 77)
*                              Region III: Bataan, Bulacan, Nueva Ecija,
*                              Tarlac, Zambales, Aurora

replace tag_area_birth = 1 if inlist(prv_birth, 10, 21, 34, 56, 58)
*                              Region IV-A: Batangas, Cavite, Laguna,
*                              Quezon, Rizal

replace tag_area_birth = 1 if inlist(prv_birth, 40, 51, 52, 53)
*                              MIMAROPA: Marinduque, Occ.Mindoro,
*                              Or.Mindoro, Palawan

label var tag_area_birth ///
    "Born in Tagalog area: NCR/RIII(excl.Pamp)/RIVA/GS-MIMAROPA (1=yes)"

* --- Current area (same classification applied to current province) ---
gen tag_area_current = inlist(REG, 4, 13)
*                      NCR (13) + CALABARZON (4) — clean at region level

replace tag_area_current = 1 if inlist(PRV, 8, 14, 49, 69, 71, 77)
*                              Region III provinces only (excl. 54, 55)

replace tag_area_current = 1 if inlist(PRV, 40, 51, 52, 53, 315)
*                              MIMAROPA: Marinduque, Mindoro x2,
*                              Palawan, Puerto Princesa City (HUC)

label var tag_area_current ///
    "Currently in Tagalog area: NCR/RIII(excl.Pamp)/RIVA/GS-MIMAROPA (1=yes)"

* --- Directed migration outcomes ---

* Variable 1: Born non-Tagalog → currently in Tagalog area
gen move_to_tag = (tag_area_current == 1) if tag_area_birth == 0
label var move_to_tag ///
    "In Tagalog area at census | born non-Tagalog (1=yes)"

* Variable 2: Born Tagalog → currently in non-Tagalog area
gen move_from_tag = (tag_area_current == 0) if tag_area_birth == 1
label var move_from_tag ///
    "In non-Tagalog area at census | born Tagalog (1=yes)"
	
gen cross_boundary = (tag_area_birth != tag_area_current) ///
    if !missing(tag_area_birth) & !missing(tag_area_current)
label var cross_boundary "Crossed Tagalog/non-Tagalog boundary (1=yes)"

gen cross_boundary_cond = (tag_area_birth != tag_area_current) ///
    if diffPdiffM_birth == 1
label var cross_boundary_cond "Crossed Tagalog boundary | migrated (1=yes)"

**# §7 Education outcome variables
*****************************************************************************

* --- Disability flags (P13 items) ---
gen probSee      = (P13A == "2" | P13A == "3" | P13A == "4")
gen probHear     = (P13B == "2" | P13B == "3" | P13B == "4")
gen probWalk     = (P13C == "2" | P13C == "3" | P13C == "4")
gen probRemember = (P13D == "2" | P13D == "3" | P13D == "4")
gen probDress    = (P13E == "2" | P13E == "3" | P13E == "4")
gen probComm     = (P13F == "2" | P13F == "3" | P13F == "4")

* --- Literacy ---
gen literacy = (P16 == "1")
label var literacy "Simple literacy (1=yes)"

* --- Education level coding ---
destring P17, gen(p17)
drop x
gen x = p17 / 10

gen eduLevel = .
replace eduLevel = 0  if x == 0 | x == 1 | x == 2
replace eduLevel = 1  if (x >= 10 & x < 16) | x == 16
replace eduLevel = 2  if x >= 16.1 & x <= 18
replace eduLevel = 3  if (x >= 20 & x <= 24) | (x >= 24.1 & x <= 24.3)
replace eduLevel = 4  if x > 24.3 & x <= 25
replace eduLevel = 5  if (x == 34 | x == 35) | (x >= 40 & x < 50)
replace eduLevel = 6  if x >= 50 & x < 60
replace eduLevel = 7  if x > 68 & x < 69
replace eduLevel = 8  if (x >= 60 & x <= 61) | (x > 68.6 & x < 70)
replace eduLevel = 9  if x == 78
replace eduLevel = 10 if (x >= 70 & x < 78) | (x > 78 & x < 80)
replace eduLevel = 11 if x == 88
replace eduLevel = 12 if (x >= 80 & x < 88) | (x > 88 & x < 90)
replace eduLevel = .  if x == 99.9

label define edulevels                             ///
    0 "No level completed"                         ///
    1 "Some elementary"    2 "Elementary graduate" ///
    3 "Some junior high"   4 "Junior high graduate" ///
    5 "Post-secondary & non-tertiary"              ///
    6 "Short tertiary"     7 "Some college"        ///
    8 "College graduate"   9 "Some master"         ///
    10 "Master graduate"  11 "Some PhD"  12 "PhD"
label values eduLevel edulevels

* --- Binary education outcomes ---
gen compHS  = (eduLevel >= 4 & eduLevel != .)   // HS completion or above
gen compES  = (eduLevel >= 2 & eduLevel != .)   // Elementary completion or above
gen entCol  = (eduLevel >= 7 & eduLevel != .)   // College entry
gen compCol = (eduLevel >= 8 & eduLevel != .)   // College completion

* --- Years of schooling ---
gen yrSch = .
replace yrSch = 0  if eduLevel == 0
replace yrSch = 1  if x >= 10 & x < 12
replace yrSch = 2  if x >= 12 & x < 13
replace yrSch = 3  if x >= 13 & x < 14
replace yrSch = 4  if x >= 14 & x < 15
replace yrSch = 5  if x >= 15 & x < 16
replace yrSch = 6  if x >= 16 & x <= 18
replace yrSch = 7  if x >= 20 & x < 22
replace yrSch = 8  if x >= 22 & x < 23
replace yrSch = 9  if x >= 23 & x < 24
replace yrSch = 10 if x >= 24 & x < 30
replace yrSch = 11 if (x >= 34 & x < 35) | x == 48
replace yrSch = 12 if (x >= 35 & x < 40) | (x >= 40 & x < 48) | x == 49.9
replace yrSch = 12 if (x >= 50 & x < 58) | x == 59.9
replace yrSch = 11 if x == 58
replace yrSch = 11 if p17 == 681
replace yrSch = 12 if p17 == 682
replace yrSch = 13 if p17 == 683
replace yrSch = 14 if p17 == 684
replace yrSch = 15 if p17 == 685
replace yrSch = 16 if p17 == 686
replace yrSch = 14 if (x >= 60 & x <= 61) | (x == 69.9)
replace yrSch = 15 if x == 78
replace yrSch = 16 if (x >= 70 & x <= 71) | (x == 79.9)
replace yrSch = 17 if x == 88
replace yrSch = 19 if (x >= 80 & x < 88) | (x == 89.9)

label var eduLevel "Highest school level completed"
label var compHS   "HS completion or higher (yes=1)"
label var compES   "ES completion or higher (yes=1)"
label var entCol   "Entered college (yes=1)"
label var compCol  "Bachelor degree (Yes=1)"
label var yrSch    "Years of schooling"


**# §6 Pre-policy education baseline (HS share)
*****************************************************************************

* Province-level
preserve
    keep if superold == 1
    collapse (mean) HSshare = compHS [aweight = POPWGT], by(prv_birth)
    sum HSshare, detail
    gen HSshareprov_abovemed = (HSshare > r(p50))
    label var HSshare             "Pre-policy share of secondary completers"
    label var HSshareprov_abovemed "Dummy for above-median HS completers (province)"
    tempfile hsshare
    save `hsshare'

    histogram HSshare, bin(50) frequency ///
        xtitle("Pre-policy Share of High School Completers") ///
        ytitle("Provinces") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/HScompleter_share_histogram.png", replace
restore
merge m:1 prv_birth using `hsshare', keepusing(HSshare HSshareprov_abovemed)
drop _merge

* Municipality-level
preserve
    keep if superold == 1
    collapse (mean) HSshare_mun = compHS [aweight = POPWGT], by(birthmun)
    sum HSshare_mun, detail
    gen HSsharemun_abovemed = (HSshare_mun > r(p50))
    label var HSshare_mun         "Pre-policy share of secondary completers"
    label var HSsharemun_abovemed "Dummy for above-median HS completers (Municipality)"
    tempfile hssharem
    save `hssharem'

    histogram HSshare_mun, bin(50) frequency ///
        xtitle("Pre-policy Share of High School Completers") ///
        ytitle("Municipalities") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/HScompleter_share_histogram_mun.png", replace
restore
merge m:1 birthmun using `hssharem', keepusing(HSshare_mun HSsharemun_abovemed)
drop _merge


**# §8 Labor market variables — existing (UNCHANGED)
*****************************************************************************

* --- Occupation (P21) ---
destring P21, gen(p21)

label define occ                                                                ///
    1 "Managers"                                                                ///
    2 "Professionals"                                                           ///
    3 "Technicians and Associate Professionals"                                 ///
    4 "Clerical Support Workers"                                                ///
    5 "Service and Sales Workers"                                               ///
    6 "Skilled Agricultural, Forestry and Fishery Workers"                      ///
    7 "Craft and Related Trades Workers"                                        ///
    8 "Plant and Machine Operators and Assemblers"                              ///
    9 "Elementary Occupations"                                                  ///
    0 "Armed Forces Occupations"                                                ///
    90 "Non-gainful Activities and Special Occupations"                         ///
    99 "Not Reported"
label values p21 occ

replace p21 = . if age < 15

* Employment status
gen notworking = (p21 == 90 | p21 == 99)
replace notworking = . if p21 == .

gen working = (notworking == 0)
replace working = . if notworking == .   

gen professional = (p21 == 2)
replace professional = . if working == 0
replace professional = . if p21 == .

* Unskilled (elementary occupations)
gen lowskill = (p21 == 9)
replace lowskill = . if working == 0
replace lowskill = . if p21 == .

* --- Class of worker (P23) ---
destring P23, gen(workerclass)

label define class                                                      ///
    1 "Worked for Private household (domestic services) - PHH"         ///
    2 "Worked for private business/enterprises/farm - PVT"             ///
    3 "Worked for government corporation - GOV"                        ///
    4 "Self-employed without any paid employee - SELF"                 ///
    5 "Employer in own farm or business - EMP"                         ///
    6 "Worked with pay in own family-operated farm or business - PAID" ///
    7 "Worked without pay in own family-operated farm or business - UNPAID" ///
    9 "Not Reported"
label values workerclass class

gen wk_phh = (workerclass == 1)
replace wk_phh = . if working == 0 | working == .
label var wk_phh "Work for private household (PHH)"

gen wk_pvt = (workerclass == 2)
replace wk_pvt = . if working == 0 | working == .
label var wk_pvt "Work for private business/farm (PVT)"

gen wk_gov = (workerclass == 3)
replace wk_gov = . if working == 0 | working == .
label var wk_gov "Government Employee (1=yes)"

gen wk_self = (workerclass == 4)
replace wk_self = . if working == 0 | working == .
label var wk_self "Self-employed without employee (1=yes)"

gen wk_emp = (workerclass == 5)
replace wk_emp = . if working == 0 | working == .
label var wk_emp "Employer in own farm/business (EMP)"

gen wk_fampaid = (workerclass == 6)
replace wk_fampaid = . if working == 0 | working == .
label var wk_fampaid "Work with pay in family business (PAID)"

gen wk_famNopaid = (workerclass == 7)
replace wk_famNopaid = . if working == 0 | working == .
label var wk_famNopaid "Work without pay in family business (UNPAID)"

gen selfemp = inlist(workerclass, 4, 5)
replace selfemp = . if working == 0 | working == .
label var selfemp "Self-employed or employer (1=yes)"

gen informal = inlist(workerclass, 1, 6, 7)
replace informal = . if working == 0 | working == .
label var informal "Working for families (1=yes)"

* Combined occupation × class variables (used in paper)
gen high_skill_job = 0
replace high_skill_job = 1 if inlist(p21, 2, 3) & inlist(workerclass, 2, 3, 5)
replace high_skill_job = . if working == 0 | working == .
label var high_skill_job "High-skilled formal job (Prof/Tech, formal sector)"
* ⚠️ FLAG: `high_skill_job` excludes Managers (p21==1).
*    See `high_skill_job2` in §9 for version that includes Managers.

gen informal_job = 0
replace informal_job = 1 if inlist(p21, 9) | inlist(workerclass, 1, 6, 7)
replace informal_job = . if working == 0 | working == .
label var informal_job "Unskilled or informal job"

label var p21          "Occupation Category"
label var working      "Employed (1=yes)"
label var professional "Professional (1=yes)"
label var lowskill     "Unskilled labor (1=yes)"

**# §9 Labor market variables — NEW (English-language mechanism)
*****************************************************************************
* Tests mechanism: BEP → displaced English instruction →
* occupational sorting away from English-gated jobs
*
* Main pair (used in analysis):
*   high_english_occ : Managers (01) + Professionals (02)
*   low_english_occ  : Skilled agri (06), Craft (07),
*                      Machine operators (08), Elementary (09)
*
* Secondary:
*   wk_gov_u         : Government employment (English-based exams)
*
* Each variable has two versions:
*   _cond  : conditional on working (consistent with existing Table 3.4)
*   _u     : unconditional (preferred for DID — avoids selection on employment)
*
* ⚠️ Parallel trends must be validated via event study before
*    using any of these as outcomes. See analysis do-file.
*****************************************************************************

* --- High-English occupation ---
* Managers (01) + Professionals (02)
* English-gated: professional licensing exams, college entry,
* formal sector documentation

gen high_english_occ   = (inlist(p21, 1, 2)) if working == 1
replace high_english_occ   = . if p21 == .
label var high_english_occ   "High-English occ: Managers/Professionals (cond.)"

gen high_english_occ_u = (inlist(p21, 1, 2))
replace high_english_occ_u = 0 if working == 0
replace high_english_occ_u = . if p21 == .
label var high_english_occ_u "High-English occ: Managers/Professionals (uncond.)"

* --- Low-English occupation ---
* Skilled agri (06), Craft (07), Machine operators (08), Elementary (09)
* Primarily Filipino/local language working environments

gen low_english_occ    = (inlist(p21, 6, 7, 8, 9)) if working == 1
replace low_english_occ    = . if p21 == .
label var low_english_occ    "Low-English occ: agri/craft/operators/elementary (cond.)"

gen low_english_occ_u  = (inlist(p21, 6, 7, 8, 9))
replace low_english_occ_u = 0 if working == 0
replace low_english_occ_u = . if p21 == .
label var low_english_occ_u  "Low-English occ: agri/craft/operators/elementary (uncond.)"

* --- Government employment (secondary) ---
* All government positions and exams are English-based

gen wk_gov_u = (workerclass == 3)
replace wk_gov_u = 0 if working == 0
replace wk_gov_u = . if p21 == .
label var wk_gov_u "Government employee (uncond.)"

* --- Quick check ---
di "=== English-language occupation distribution (main sample) ==="
sum high_english_occ high_english_occ_u ///
    low_english_occ  low_english_occ_u  ///
    wk_gov_u if in_sample == 1

di "--- By Tagalog-dominant area ---"
foreach v in high_english_occ_u low_english_occ_u wk_gov_u {
    di "`v':"
    sum `v' if in_sample == 1 & tag_mun == 1
    sum `v' if in_sample == 1 & tag_mun == 0
}

**# §10 Industry variables
*****************************************************************************

replace P22 = trim(P22)
gen byte P22_code = real(P22)
gen byte industry_cat = .
replace industry_cat = 1 if inlist(P22_code, 1, 2)
replace industry_cat = 2 if inlist(P22_code, 3, 4, 5, 6)
replace industry_cat = 3 if inrange(P22_code, 7, 21)
replace industry_cat = 9 if P22_code == 99 | working == .

label define industry_cat_lbl    ///
    1 "Primary (Agri/Mining)"    ///
    2 "Secondary (Industry)"     ///
    3 "Tertiary (Services)"      ///
    9 "Not Reported"
label values industry_cat industry_cat_lbl

gen primsector = (industry_cat == 1)
replace primsector = . if working == 0 | working == .
gen secsector = (industry_cat == 2)
replace secsector = . if working == 0 | working == .
gen tersector = (industry_cat == 3)
replace tersector = . if working == 0 | working == .

label var primsector "Primary sector (1=yes)"
label var secsector  "Secondary sector (1=yes)"
label var tersector  "Tertiary sector (1=yes)"


**# §11 Ethnicity classification
*****************************************************************************

capture drop eth_broad
gen byte eth_broad = .

replace eth_broad = 1  if P12 == 266                                        // Tagalog
replace eth_broad = 2  if inlist(P12, 82, 62, 63)        & missing(eth_broad) // Cebuano/Bisaya
replace eth_broad = 3  if P12 == 109                     & missing(eth_broad) // Ilocano
replace eth_broad = 4  if P12 == 61                      & missing(eth_broad) // Bicolano
replace eth_broad = 5  if P12 == 110                     & missing(eth_broad) // Hiligaynon
replace eth_broad = 6  if P12 == 283                     & missing(eth_broad) // Waray
replace eth_broad = 7  if P12 == 197                     & missing(eth_broad) // Kapampangan
replace eth_broad = 8  if P12 == 247                     & missing(eth_broad) // Pangasinan
replace eth_broad = 9  if inlist(P12, 236,209,274,44,49,250,251,252,253,284,114,136) ///
                                                         & missing(eth_broad) // Muslim/Moro
replace eth_broad = 11 if inlist(P12, 10,22,39,66,78,83,97,99,112,113,119,137, ///
                              203,204,256,257,258,261,271,278,289,288,999)   ///
                                                         & missing(eth_broad) // Foreign/Other
replace eth_broad = 10 if missing(eth_broad) & inrange(P12, 1, 289)         // Other indigenous

label define eth_broad_lbl                      ///
    1  "Tagalog"                                ///
    2  "Cebuano/Bisaya"                         ///
    3  "Ilocano"                                ///
    4  "Bicolano"                               ///
    5  "Hiligaynon/Ilonggo"                     ///
    6  "Waray"                                  ///
    7  "Kapampangan"                            ///
    8  "Pangasinan"                             ///
    9  "Muslim/Moro groups"                     ///
    10 "Other Indigenous/Minorities"            ///
    11 "Foreign/Other/Not reported", replace
label values eth_broad eth_broad_lbl
label var eth_broad "Ethnicity"

tab eth_broad
tab P12 if missing(eth_broad)   // Should be empty


**# §12 Interethnic marriage
*****************************************************************************

gen is_head         = (P2 == 1)
gen is_spouse       = (P2 == 2)
gen is_son          = (P2 == 3 | P2 == 5)
gen is_daughter     = (P2 == 4 | P2 == 6)
gen is_son_in_law   = (P2 == 7)
gen is_daughter_in_law = (P2 == 8)
gen married         = inlist(P8, 2, 3)
label var married "Currently married (1=yes)"

* Household ID
gen str20 hsn_str = string(PRV) + "_" + string(MUN) + "_" + string(HSN)

* Head-spouse ethnicity
preserve
    keep if P2 == 1
    keep hsn_str eth_broad
    rename eth_broad eth_head
    tempfile head_eth
    save `head_eth'
restore
merge m:1 hsn_str using `head_eth', keep(master match) nogen

preserve
    keep if P2 == 2
    keep hsn_str eth_broad
    rename eth_broad eth_spouse
    duplicates drop hsn_str, force  // 11 dropped (polygamy)
    tempfile spouse_eth
    save `spouse_eth'
restore
merge m:1 hsn_str using `spouse_eth', keep(master match) nogen

gen intethmary_head = .
replace intethmary_head = 1 if (eth_head != eth_spouse) & (eth_head != . & eth_spouse != .)
replace intethmary_head = 0 if (eth_head == eth_spouse) & (eth_head != . & eth_spouse != .)
replace intethmary_head = . if is_head != 1 & is_spouse != 1
label var intethmary_head "HH Head-Spouse inter-ethnic marriage (1=yes)"

* Sons matched with daughters-in-law
gen married_son = (is_son == 1) & (married == 1)
egen n_married_sons = total(married_son),        by(hsn_str)
egen n_dils         = total(is_daughter_in_law), by(hsn_str)
gen only_married_sons = (n_married_sons == 1 & married_son == 1)
gen keep_pair         = (n_married_sons == 1 & n_dils == 1)

preserve
    keep if married_son & keep_pair
    rename eth_broad eth_son
    keep hsn_str eth_son keep_pair
    duplicates report hsn_str
    tempfile sons
    save `sons'
restore

preserve
    keep if is_daughter_in_law & keep_pair
    rename eth_broad eth_dil
    keep hsn_str eth_dil keep_pair
    duplicates report hsn_str
    tempfile dils
    save `dils'

    merge 1:1 hsn_str using `sons'
    drop _merge
    gen interethnic_son = .
    replace interethnic_son = (eth_son != eth_dil)
    tab interethnic_son, mi
    tempfile sons_dils
    save `sons_dils'
restore

* Daughters matched with sons-in-law
gen married_daughter = (is_daughter == 1) & (married == 1)
egen n_married_daughters = total(married_daughter), by(hsn_str)
egen n_sils              = total(is_son_in_law),    by(hsn_str)
gen only_married_daughters = (n_married_daughters == 1 & married_daughter == 1)
gen keep_paird             = (n_married_daughters == 1 & n_sils == 1)

preserve
    keep if married_daughter & keep_paird
    rename eth_broad eth_daughter
    keep hsn_str eth_daughter keep_paird
    tempfile daughters
    save `daughters'
restore

preserve
    keep if is_son_in_law & keep_paird
    rename eth_broad eth_sil
    keep hsn_str eth_sil keep_paird
    tempfile sils
    save `sils'

    merge 1:1 hsn_str using `daughters'
    drop _merge
    gen interethnic_daughter = .
    replace interethnic_daughter = (eth_daughter != eth_sil)
    tab interethnic_daughter, mi
    tempfile daughters_sils
    save `daughters_sils'

    merge 1:1 hsn_str using `sons_dils'
    drop _merge
    tempfile inteth_child
    save `inteth_child'
restore

merge m:1 hsn_str using `inteth_child'
drop _merge

* Restrict to relevant individuals
replace interethnic_son = .     if is_son != 1 & is_daughter_in_law != 1
replace interethnic_son = .     if is_son == 1 & married == 0
replace interethnic_son = .     if is_son == 1 & married == 1 & n_married_sons > 1
replace interethnic_son = .     if is_daughter_in_law == 1 & n_dils > 1

replace interethnic_daughter = . if is_daughter != 1 & is_son_in_law != 1
replace interethnic_daughter = . if is_daughter == 1 & married == 0
replace interethnic_daughter = . if is_daughter == 1 & married == 1 & n_married_daughters > 1
replace interethnic_daughter = . if is_son_in_law == 1 & n_sils > 1

gen interethnic_any = .
replace interethnic_any = 1 if intethmary_head == 1 | interethnic_son == 1 | interethnic_daughter == 1
replace interethnic_any = 0 if intethmary_head == 0 | interethnic_son == 0 | interethnic_daughter == 0

tab interethnic_any, mi
label var interethnic_any "Interethnically married couples (1=yes)"

**# §13 Intergenerational sample (children of main sample)
*****************************************************************************

gen parent   = inlist(P2, 1, 2)
gen child    = inlist(P2, 3, 4)
gen grdchild = inlist(P2, 9, 10)

bysort hsn_str: egen hh_parent_insample = max(in_sample * parent)
bysort hsn_str: egen hh_child_insample  = max(in_sample * child)

gen intrgene_sample = .
replace intrgene_sample = 1 if child == 1 & hh_parent_insample == 1
* Grandchildren excluded: parent identification relies on sibling relationships
* within the household, which are not cleanly identified when multiple siblings
* are in the main sample. Affects only 1.57% of original second generation sample.
* Results robust to inclusion - available upon request.
replace intrgene_sample = . if age > 46   // Omit children > 46 years old (908 obs)

bysort hsn_str: egen hh_fl_treat          = max(fl_treat == 1)
gen hh_fl_treat_child = hh_fl_treat if intrgene_sample == 1
bysort hsn_str: egen num_child_of_treated = total(hh_fl_treat_child)

label var parent                "Parent (head or spouse)"
label var child                 "Child (son or daughter)"
label var grdchild              "Grandchild"
label var hh_parent_insample    "HH head/spouse is the main sample"
label var hh_child_insample     "Household child is the main sample"
label var intrgene_sample       "Children of the main sample (regardless of treatment status)"
label var hh_fl_treat           "HH-level treatment status (1=yes)"
label var hh_fl_treat_child     "Child-level treatment status (1=yes)"
label var num_child_of_treated  "Number of children of the main sample per HH"

* --- Parents' variables for intergenerational regressions ---
* Option 1: when both head and spouse in sample, keep head (P2==1) only
* This avoids collapse(max) over two parents with potentially different
* birth municipalities and treatment status.
* Spouse retained when head is not in sample (Subgroup B).
* pa_female added for father/mother heterogeneity analysis.
preserve
    keep if (parent == 1 & hh_parent_insample == 1 & in_sample == 1)
    rename fl_treat  pa_fl_treat
    rename treat     pa_treat
    rename tag_mun   pa_tag_mun
    rename eduLevel  pa_edulev
    rename birthyr   pa_birthyr
    rename birthmun  pa_birthmun
    rename eth_broad pa_ethbroad
    rename yrSch     pa_yrSch
    rename age_1974  pa_age1974
    rename age       pa_age
    rename female    pa_female
    * Drop spouse when both head and spouse are in sample
    bysort hsn_str: gen n_parents    = _N
    bysort hsn_str: gen has_head     = (P2 == 1)
    bysort hsn_str: egen hh_has_head = max(has_head)
    drop if n_parents == 2 & P2 == 2 & hh_has_head == 1
    * Verify no duplicates after drop
    duplicates report hsn_str
    keep hsn_str P2 pa_treat pa_fl_treat pa_tag_mun pa_birthmun pa_birthyr ///
         pa_edulev pa_ethbroad pa_yrSch pa_age1974 pa_age pa_female
    collapse (max) pa_treat pa_fl_treat pa_tag_mun pa_birthmun pa_birthyr ///
                   pa_edulev pa_ethbroad pa_yrSch pa_age1974 pa_age pa_female, ///
                   by(hsn_str)
    label var pa_fl_treat  "Ages 3-6 in 1974 (parent)"
    label var pa_tag_mun   "Tagalog (parent)"
    label var pa_birthmun  "Birth municipality of parent"
    label var pa_birthyr   "Birth year of parent"
    label var pa_edulev    "Education level of parent"
    label var pa_ethbroad  "Broad ethnicity of parent"
    label var pa_yrSch     "Years of schooling of parent"
    label var pa_age       "Age of parent"
    label var pa_female    "Female parent (1=yes)"
    tempfile parentdata1
    save `parentdata1'
restore

merge m:1 hsn_str using `parentdata1'
drop _merge

**# §14 Fertility and other individual outcomes
*****************************************************************************

destring P25, gen(nChild)
destring P28, gen(agemarried)
replace nChild     = . if nChild     == 9
replace agemarried = . if agemarried == 99

gen ofw = (P20 == "1") if inlist(P20, "1", "2")
* Drops: P20 missing (age < 15, not asked) and P20 == "9" (not reported)
* Retains: all 329,655 OFWs regardless of working status
label var ofw "Overseas Worker (1=yes)"


* Internet use
gen internet_use = (H17A==1 | H17B==1 | H17C==1 | H17D==1 | ///
                    H17E==1 | H17F==1 | H17G==1 | H17H==1)
label var internet_use "Internet use at any location"

gen internet_access = (H16A==1 | H16B==1 | H16C==1 | H16D==1)
label var internet_access "Internet access via any type"

* Floor area
gen flrarea = D1
replace flrarea = . if flrarea == 99
label var flrarea "Floor area of housing"


**# §15 Language fractionalization
*****************************************************************************

* Province-level
preserve
    keep if superold == 1
    gen one = 1
    collapse (count) pop = one, by(prv_birth H13)
    bysort prv_birth: egen total_pop = total(pop)
    gen share    = pop / total_pop
    gen share_sq = share^2
    collapse (sum) share_sq, by(prv_birth)
    gen langfrac_prv = 1 - share_sq
    order prv_birth langfrac_prv
    sum langfrac_prv, detail
    gen langfrac_high_prv = langfrac_prv > r(p50)
    label define hl 0 "Low diversity" 1 "High diversity"
    label values langfrac_high_prv hl
    tempfile langprv
    save `langprv'

    histogram langfrac_prv, bin(50) frequency ///
        xtitle("Linguistic fractionalization index") ///
        ytitle("Provinces") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/Language_share_histogram_prov.png", replace
restore
merge m:1 prv_birth using `langprv', keepusing(langfrac_prv langfrac_high_prv)
drop _merge

* Municipality-level
preserve
    keep if superold == 1
    gen one = 1
    collapse (count) pop = one, by(prv_birth mun_birth H13)
    bysort prv_birth mun_birth: egen total_pop = total(pop)
    gen share    = pop / total_pop
    gen share_sq = share^2
    collapse (sum) share_sq, by(prv_birth mun_birth)
    gen langfrac_mun = 1 - share_sq
    order mun_birth langfrac_mun
    sum langfrac_mun, detail
    gen langfrac_high_mun = langfrac_mun > r(p50)
    label values langfrac_high_mun hl
    tempfile langmn
    save `langmn'

    histogram langfrac_mun, bin(50) frequency ///
        xtitle("Linguistic fractionalization index") ///
        ytitle("Municipalities") xscale(range(0 1)) xtick(0(0.1)1)
    graph export "$Tbl/Language_share_histogram_mun.png", replace
restore
merge m:1 prv_birth mun_birth using `langmn', keepusing(langfrac_mun langfrac_high_mun)
drop _merge

label var langfrac_mun      "Linguistic Fractionalization Index"
label var langfrac_prv      "Linguistic Fractionalization Index"
label var langfrac_high_mun "Above-median Ling. Fraction."


**# §16 Linguistic Distance from Tagalog (LDT)
*****************************************************************************

merge m:1 birthmun using "$ldi/LDI_Tagalog_municipality.dta"
keep if _merge == 3
drop _merge
sum LDItag_mun, detail
gen LDI_high_mun = LDItag_mun > r(p50)
label values LDI_high_mun hl
label var LDI_high_mun "Above median LDI (1=yes)"

merge m:1 prv_birth using "$ldi/LDI_Tagalog_birthprov.dta"
keep if _merge == 3
drop _merge

* Distribution plots
preserve
    collapse tag_mun LDItag_mun, by(birthmun)
	
		twoway ///
			(histogram LDItag_mun if tag_mun == 1, ///
				fraction color(gs4%60) ///
				lcolor(black) lwidth(medthick)) ///
			(histogram LDItag_mun if tag_mun == 0, ///
				fraction color(gs10%40) ///
				lcolor(black) lpattern(dash) ///
				lwidth(medthick)), ///
			xtitle("Linguistic Distance Index") ///
			ytitle("Density") ///
			legend(order(1 "Tagalog-dominant areas" ///
						 2 "Non-Tagalog areas") ///
				   pos(2) ring(0) col(1) ///
				   size(*1.2) ///
				   region(lstyle(none)))

			graph export "$Tbl/LDI_histogram_mun.png", replace
	
		histogram LDItag_mun, ///
			fraction ///
			color(gs8) ///
			fcolor(gs8%50) ///
			lcolor(black) ///
			xtitle("Linguistic Distance Index") ///
			ytitle("Density")
				
			graph export "$Tbl/LDI_histogram_mun_all.png", replace
	
restore

preserve
    collapse tag_prov LDItag_prv, by(prv_birth)
    twoway ///
        (histogram LDItag_prv if tag_prov == 1, width(0.02) density color(gs8) fcolor(gs8%50) lcolor(black)) ///
        (histogram LDItag_prv if tag_prov == 0, width(0.02) density color(none) lcolor(black) lpattern(dash)) ///
        (kdensity LDItag_prv, lcolor(gs8)), ///
        xtitle("Linguistic Distance Index") ytitle("Density") ///
        legend(order(1 "Tagalog-dominant areas" 2 "Non-Tagalog areas" 3 "All provinces") ///
               position(3) ring(0) col(1))
    graph export "$Tbl/LDI_histogram_prov.png", replace
restore

preserve
    collapse tag_prov LDIshift_prv, by(prv_birth)
    twoway ///
        (histogram LDIshift if tag_prov == 1, width(0.02) density color(gs8) fcolor(gs8%50) lcolor(black)) ///
        (histogram LDIshift if tag_prov == 0, width(0.02) density color(none) lcolor(black) lpattern(dash)) ///
        (kdensity LDIshift, lcolor(gs8)), ///
        xtitle("Tagalog Proximity Index") ytitle("Density") ///
        legend(order(1 "Tagalog-dominant areas" 2 "Non-Tagalog areas" 3 "All provinces") ///
               position(11) ring(0) col(1))
    graph export "$Tbl/TagProximity_histogram_prov.png", replace
restore

**# §17b Terrain elevation control
*****************************************************************************
* Mean elevation of birth municipality (metres) from SRTM 90m via AWS
* Interacted with birth cohort as c.elev_mean#i.birthyr in robustness specs
* See construct_elev_control.R and construct_elev_control.do for details
*
* Merge strategy:
*   Step 1: Standard merge via prv_birth x mun_birth crosswalk
*   Step 2: NCR fix — assign NCR-wide mean elevation to all prv_birth==39
*           observations that remain unmatched after step 1.
*           Rationale: NCR cities (prv_birth==39) use a legacy census coding
*           that differs from the shapefile PSGC structure (prv 74/75/76).
*           Since all NCR municipalities share the same flat, low-lying
*           coastal geography, a common NCR elevation value is geographically
*           appropriate and avoids systematic sample loss among Tagalog-
*           dominant urban observations.
*   Step 3: Remaining missing are genuine mun_birth==99 (unreported) —
*           random non-reporting, not a systematic coding error.
*****************************************************************************

tempfile terrain terrain_crosswalk

* Step 1a: Import elevation CSV
preserve
    import delimited "$ldi/terrain_ruggedness.csv", clear stringcols(_all)
    rename adm3_psgc psgc_code
    destring psgc_code elev_mean elev_sd, replace force
    save `terrain'
restore

* Step 1b: Merge elevation into crosswalk to get prv_birth x mun_birth keys
preserve
    use "$data/municipality_ShapefileCensus_final.dta", clear
    merge 1:1 psgc_code using `terrain'
    keep if _merge == 3
    keep prv_birth mun_birth elev_mean elev_sd

    * NCR recode: crosswalk has mun_birth==0 for City of Manila
    * (prv_birth==39) while census uses mun_birth==1
    replace mun_birth = 1 if mun_birth == 0 & prv_birth == 39

    save `terrain_crosswalk'
restore

* Step 1c: Merge into main dataset
capture drop _merge
merge m:1 prv_birth mun_birth using `terrain_crosswalk'
drop if _merge == 2
drop _merge

* Step 2: NCR fix
* Assign NCR-wide mean elevation to unmatched prv_birth==39 observations
* (legacy 39XX census codes not in shapefile crosswalk)
* Value derived from matched NCR municipalities (prv_birth 74, 75, 76)
quietly sum elev_mean if inlist(prv_birth, 74, 75, 76) & !missing(elev_mean)
local ncr_elev_mean = r(mean)
quietly sum elev_sd   if inlist(prv_birth, 74, 75, 76) & !missing(elev_sd)
local ncr_elev_sd   = r(mean)

replace elev_mean = `ncr_elev_mean' if prv_birth == 39 & missing(elev_mean)
replace elev_sd   = `ncr_elev_sd'   if prv_birth == 39 & missing(elev_sd)

di "NCR elevation assigned: mean = `ncr_elev_mean', sd = `ncr_elev_sd'"

* Step 3: Verification
label var elev_mean "Mean elevation of birth municipality (metres)"
label var elev_sd   "SD of elevation within municipality (metres)"

di "Remaining missing elev_mean in in_sample (mun_birth==99 only):"
count if missing(elev_mean) & in_sample == 1
count if missing(elev_mean) & in_sample == 1 & mun_birth == 99

**# §18 Save
*****************************************************************************

save "$ready/Popcen2020_readydata.dta", replace

*** END OF DOFILE ***
