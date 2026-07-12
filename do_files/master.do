**************
* MASTER DO-FILE (REPLICATION VERSION)
* Adopting the Language of the Ethnic Majority:
* Evaluation of the Philippines' Bilingual Education Policy
* Igarashi & Takahashi
*
* This is the public replication version of the master do-file.
* Paths have been converted from the authors' local environment
* to a relative/placeholder structure. See README.md for setup
* instructions and data access details.
*
* v3: June 2026
*   - Drop mun_birth==99 (artificial municipality FEs)
*   - Add c.elev_mean#i.birthyr to $control
*   - Preserve $control_base for reference
**************
timer clear
timer on 1

clear all
macro drop _all

* ===== SET THIS TO YOUR LOCAL REPOSITORY PATH =====
* Set this to the folder where you have cloned/downloaded this repository.
* All other paths are defined relative to this root.
gl parent "."
* ====================================================

	gl onedr "$parent/PH_BEP"
		gl data 	"$onedr/data"
		gl ldi 		"$onedr/LDI"
		gl dofile	"$onedr/do_files"
			gl ready "$data/ReadyData"

	* Output folders (figures/tables written locally within the repo,
	* rather than to the authors' Overleaf project folder)
	gl Fig "$onedr/output/figures"
	gl Tbl "$onedr/output/tables"

set scheme plotplainblind


*-------------------*
**# Start log file
*-------------------*
capture log using "$dofile/PHL_BLE.log", text replace

	*-------------*
	**# Load Data
	*-------------*
	* NOTE: Popcen2020_readydata.dta is constructed from restricted-access
	* PSA microdata and is NOT included in this repository. Researchers
	* must obtain the 2020 Census of Population and Housing microdata
	* directly from the Philippine Statistics Authority (PSA) via
	* https://psada.psa.gov.ph/home, then run the data construction
	* do-files (see README.md) to reproduce Popcen2020_readydata.dta.
	use "$ready/Popcen2020_readydata.dta", clear

	* Drop foreign and unreported birth provinces
	drop if prv_birth==99 | prv_birth==90

	* Drop unreported birth municipality
	* mun_birth==99 creates artificial municipality FEs (birthmun==XX99)
	* that do not correspond to real geographic units, contaminating
	* municipality fixed effects and pre-trend estimates (age 14
	* pre-trend becomes spuriously significant when these are included)
	drop if mun_birth==99


		*---------------*
		**# Define Macros
		*---------------*

		* Sum Stat
		gl yvar1 yrSch compHS entCol compCol
		gl yvar2 ofw working high_english_occ low_english_occ wk_gov
		gl yvar3 diffPdiffM_birth cross_boundary_cond
		gl yvar4 diffPdiffM_birth cross_boundary_cond married interethnic_any

		* Estimate
		gl allys $yvar1 high_english_occ ofw interethnic_any cross_boundary_cond
		gl y_mig move_to_tag move_from_tag

		gl yvar5 yrSch compES compHS entCol

		* Control vars
		* Baseline (without elevation — for reference and sensitivity checks)
		gl control_base female i.eth_broad

		* Main controls — includes mean elevation × birth cohort
		* Motivation: highland areas in the Philippines are systematically
		* more linguistically distant from Tagalog (corr(elev_mean, LDItag_mun)=0.27),
		* so controlling for elevation × cohort absorbs differential cohort
		* trends driven by geographic isolation correlated with LDT.
		* Pre-trends improve systematically for moderate and high LDT groups.
		* Source: SRTM 90m via AWS; see construct_elev_control.R/.do
		gl control female i.eth_broad c.elev_mean#i.birthyr

		* Intergenerational controls
		gl control2 female i.eth_broad i.pa_edulev c.elev_mean#i.pa_birthyr
		gl control2_intgen female i.eth_broad c.elev_mean#i.pa_birthyr

		* Fixed effects vars
		gl fevars i.birthyr i.birthmun

		* esttab settings
		global cellfmt "cells(b(fmt(3) star) se(par fmt(3))) fragment booktabs star (* 0.1 ** 0.05 *** 0.01) varwidth(12)"
		global tblfmt "mlabels(, none) collabels(, none) nonumbers nolines nomtitle substitute(_ \_) style(tex)"
		global tblstat1 "stats(controlmean N convars, labels("\midrule Control group mean" "Observations" "Control variables" ) fmt(%9.3f %9.0fc))"
		global tblstat2 "stats(controlmean N convars pval_1v2, labels("\midrule Control group mean" "Observations" "Control variables" "\textit{p}-value: Poten. Exp. = Full. Expo." ) fmt(%9.3f %9.0fc 0 3))"
		global tblstat3 "stats(controlmean N convars pval_1v2, labels("\midrule Control group mean" "Observations" "Control variables" "\textit{p}-value: 1974 = 1978" ) fmt(%9.3f %9.0fc 0 3))"

		global coeflabs1 "coeflabels(1.fl_treat#c.tag_mun "Ages 3 to 6 in 1974 $\times$ Tagalog") keep(1.fl_treat#c.tag_mun) nobaselevels"

		global coeflabs2 "coeflabels(1.treat#c.tag_mun "Ages 7 to 11 in 1974 $\times$ Tagalog" 2.treat#c.tag_mun "Ages 3 to 6 in 1974 $\times$ Tagalog")keep(*treat#c.tag_mun) order (2.treat#c.tag_mun) nobaselevels"

		global coeflabs3 "coeflabels(1.pa_fl_treat#c.pa_tag_mun "Parents' Ages 3 to 6 in 1974 $\times$ Tagalog") keep(1.pa_fl_treat#c.pa_tag_mun) nobaselevels"

		global coeflabs4 "coeflabels(1.treat_ntag#c.LDItag_prv "Ages 7 to 11 in 1978 $\times$ LDI (Tagalog)" 2.treat_ntag#c.LDItag_prv "Ages 0 to 6 in 1978 $\times$ LDI (Tagalog)")keep(*treat_ntag#c.LDItag_prv) order(2.treat_ntag#c.LDItag_prv) nobaselevels"

		global coeflabs5 "coeflabels(2.pa_treat#c.pa_tag_mun "Parents' Ages 3 to 6 in 1974 $\times$ Tagalog" 1.pa_treat#c.pa_tag_mun "Parents' Ages 7 to 11 in 1974 $\times$ Tagalog")keep(*pa_treat#c.pa_tag_mun) order(2.pa_treat#c.pa_tag_mun) nobaselevels"

		global coeflabs6 "coeflabels(1.treatall#c.LDIshift_prv "Ages 3 to 6 in 1974 $\times$ Ling. Sim. Tagalog" 2.treatall#c.LDIshift_prv "Ages 1 to 6 in 1978 $\times$ Ling. Sim. Tagalog")keep(*treatall#c.LDIshift_prv) order(1.treatall#c.LDIshift_prv) nobaselevels"



		*---------------*
		**# Data analysis
		*---------------*

		**#-- Descriptive Stats ---*

		do "$dofile/BLE_summary_stats_v2.do"
		do "$dofile/BLE_summary_stats_children.do"

		**#-- Estimating ---*

		do "$dofile/Popcen_estimate_mun.do"
		do "$dofile/Santata_Chaismartin_dose_awareES_v6_1.do"

		**#-- Robustness: clean vs. original Q2 (LDT quartile) definition ---*
		* Depends on globals set within Santata_Chaismartin_dose_awareES_v6_1.do
		* (global control, cellfmt, tblfmt, Fig, Tbl) — must run immediately after it.
		do "$dofile/robustness_Q2_clean_vs_original.do"

		do "$dofile/Intergenerational_effect_BEP_v2.do"

		*-------------------*
		* End log file
		*-------------------*
		log close

timer off 1
timer list
