*** Run the Master Dofile ****

	*****************
	**# Cohorts' children
	*****************
	preserve
	keep if intrgene_sample==1
	
	* By Tagalog/Non-Tagalog
	local desvar female age married pa_yrSch pa_age 
	eststo clear
	estpost summarize `desvar' if pa_fl_treat == 0 & pa_tag_mun == 1
	eststo con_tag

	estpost summarize `desvar' if pa_fl_treat == 0 & pa_tag_mun == 0
	eststo con_Ntag
	
	estpost summarize `desvar' if pa_fl_treat == 1 & pa_tag_mun == 1
	eststo tr_tag

	estpost summarize `desvar' if pa_fl_treat == 1 & pa_tag_mun == 0
	eststo tr_Ntag

esttab tr_tag tr_Ntag con_tag con_Ntag ///
	using "$Tbl/SummaryStat_descriptive_children1.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline  noobs nonotes ///
		substitute(_ \_) style(tex) stats(N, labels("\midrule Observations") fmt(%9.0fc))

	local desvar $yvar4    
	eststo clear
	estpost summarize `desvar' if pa_fl_treat == 0 & pa_tag_mun == 1
	eststo con_tag

	estpost summarize `desvar' if pa_fl_treat == 0 & pa_tag_mun == 0
	eststo con_Ntag
	
	estpost summarize `desvar' if pa_fl_treat == 1 & pa_tag_mun == 1
	eststo tr_tag

	estpost summarize `desvar' if pa_fl_treat == 1 & pa_tag_mun == 0
	eststo tr_Ntag

esttab tr_tag tr_Ntag con_tag con_Ntag ///
	using "$Tbl/SummaryStat_descriptive_children2.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
	mlabels(, none) collabels(, none) nomtitle nonumbers noline ///
		substitute(_ \_) style(tex) stats(N, labels("\midrule Observations") fmt(%9.0fc))
	
		restore
