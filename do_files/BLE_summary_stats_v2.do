*** Run the Master Dofile first ***

	******************
	**# Descriptive Statistics
	* Updated 2026:
	*   Panel C: yvar2 now uses high_english_occ_u, low_english_occ_u
	*            (replaces informal_job; all vars unconditional)
	*   Panel D: yvar3 unchanged
	*   Panel E: NEW — directed migration (subsamples)
	******************
*-----------------------------------------------
* Override variable labels for summary stat tables
* (shorter versions — examples in manuscript/notes)
*-----------------------------------------------
label var working              "Employed (1=yes)"
label var high_english_occ   	"High-English occupation (1=yes)"
label var low_english_occ    	"Low-English occupation (1=yes)"
label var ofw                  "Overseas worker (1=yes)"
label var wk_gov             "Government employee (1=yes)"
label var diffPdiffM_birth     "Moved into different provinces (1=yes)"
label var cross_boundary_cond  "Moved cross Tag/non-Tag areas (1=yes)" 
label var move_to_tag          "Moved into Tagalog area (1=yes)"
label var move_from_tag        "Moved into non-Tagalog area (1=yes)"
label var interethnic_any      "Interethnic marriage (1=yes)"
label var married              "Currently married (1=yes)"

	**# Panel A — Basic characteristics (UNCHANGED)
	local desvar female age_1974 langfrac_mun HSshare_mun
	eststo clear
	estpost summarize `desvar' if treat == 0 & tag_mun == 1
	eststo con_tag
	estpost summarize `desvar' if treat == 0 & tag_mun == 0
	eststo con_Ntag
	estpost summarize `desvar' if treat == 1 & tag_mun == 1
	eststo tr1_tag
	estpost summarize `desvar' if treat == 1 & tag_mun == 0
	eststo tr1_Ntag
	estpost summarize `desvar' if treat == 2 & tag_mun == 1
	eststo tr2_tag
	estpost summarize `desvar' if treat == 2 & tag_mun == 0
	eststo tr2_Ntag

esttab tr2_tag tr2_Ntag tr1_tag tr1_Ntag con_tag con_Ntag /// 
	using "$Tbl/SummaryStat_descriptive.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline noobs nonotes ///
		substitute(_ \_) style(tex) 
		

	**# Panel B — Education outcomes (UNCHANGED)
	eststo clear
	estpost summarize $yvar1 if treat == 0 & tag_mun == 1
	eststo con_tag
	estpost summarize $yvar1 if treat == 0 & tag_mun == 0
	eststo con_Ntag
	estpost summarize $yvar1 if treat == 1 & tag_mun == 1
	eststo tr1_tag
	estpost summarize $yvar1 if treat == 1 & tag_mun == 0
	eststo tr1_Ntag
	estpost summarize $yvar1 if treat == 2 & tag_mun == 1
	eststo tr2_tag
	estpost summarize $yvar1 if treat == 2 & tag_mun == 0
	eststo tr2_Ntag

esttab tr2_tag tr2_Ntag tr1_tag tr1_Ntag con_tag con_Ntag ///
	using "$Tbl/SummaryStat_education.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline noobs nonotes ///
		substitute(_ \_) style(tex) 


	**# Panel C — Labor market outcomes
	* UPDATED: yvar2 = working high_english_occ_u low_english_occ_u ofw
	* All variables unconditional (same denominator)
	eststo clear
	estpost summarize $yvar2 if treat == 0 & tag_mun == 1
	eststo con_tag
	estpost summarize $yvar2 if treat == 0 & tag_mun == 0
	eststo con_Ntag
	estpost summarize $yvar2 if treat == 1 & tag_mun == 1
	eststo tr1_tag
	estpost summarize $yvar2 if treat == 1 & tag_mun == 0
	eststo tr1_Ntag
	estpost summarize $yvar2 if treat == 2 & tag_mun == 1
	eststo tr2_tag
	estpost summarize $yvar2 if treat == 2 & tag_mun == 0
	eststo tr2_Ntag

esttab tr2_tag tr2_Ntag tr1_tag tr1_Ntag con_tag con_Ntag ///
	using "$Tbl/SummaryStat_labor.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline noobs nonotes ///
		substitute(_ \_) style(tex) 
		

	**# Panel D — Marriage outcomes (UNCHANGED)
	eststo clear
	estpost summarize $yvar4 if treat == 0 & tag_mun == 1
	eststo con_tag
	estpost summarize $yvar4 if treat == 0 & tag_mun == 0
	eststo con_Ntag
	estpost summarize $yvar4 if treat == 1 & tag_mun == 1
	eststo tr1_tag
	estpost summarize $yvar4 if treat == 1 & tag_mun == 0
	eststo tr1_Ntag
	estpost summarize $yvar4 if treat == 2 & tag_mun == 1
	eststo tr2_tag
	estpost summarize $yvar4 if treat == 2 & tag_mun == 0
	eststo tr2_Ntag

esttab tr2_tag tr2_Ntag tr1_tag tr1_Ntag con_tag con_Ntag ///
	using "$Tbl/SummaryStat_marry.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline ///
		substitute(_ \_) style(tex) stats(N, labels("\midrule Observations") fmt(%9.0fc))

/*
	**# Panel E — Directed migration (NEW, separate subsamples)
	* move_to_tag:   non-Tagalog born (tag_area_birth == 0) currently in Tagalog area
	* move_from_tag: Tagalog born (tag_area_birth == 1) currently in non-Tagalog area
	* Presented separately because denominators differ from main sample

	* Panel E1: Non-Tagalog born — migration to Tagalog areas
	eststo clear
	estpost summarize $yvar3 if treat == 0 & tag_area_birth == 1 
	eststo con_tag
	estpost summarize $yvar3 if treat == 0 & tag_area_birth == 0 
	eststo con_Ntag
	estpost summarize $yvar3 if treat == 1 & tag_area_birth == 1
	eststo tr1_tag
	estpost summarize $yvar3 if treat == 1 & tag_area_birth == 0 
	eststo tr1_Ntag
	estpost summarize $yvar3 if treat == 2 & tag_area_birth == 1 
	eststo tr2_tag
	estpost summarize $yvar3 if treat == 2 & tag_area_birth == 0 
	eststo tr2_Ntag

esttab tr2_tag tr1_tag con_tag tr2_Ntag tr1_Ntag con_Ntag ///
	using "$Tbl/SummaryStat_migration.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline noobs ///
		substitute(_ \_) style(tex) 
*/
