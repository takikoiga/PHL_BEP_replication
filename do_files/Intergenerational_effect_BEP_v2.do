*** Run the Master Dofile ****

	*****************
	**# Intergenerational Effects
	*****************
	
	preserve	
	keep if intrgene_sample == 1

	estimates clear
	
	* Panel A: Main result (all parents, Option 1 rule)
	foreach y in $yvar1 {	
		eststo `y': areg `y' ib0.pa_fl_treat##c.pa_tag_mun ///
			$control2_intgen if age >= 25, ///
			vce(cluster pa_birthmun) abs(pa_birthyr pa_birthmun)
		sum `y' if pa_fl_treat == 0
		estadd scalar controlmean = r(mean)
		estadd scalar controlsdscore = r(sd)
		estadd local convars "Yes"
	}

	* Panel B: Father subsample (pa_female == 0)
	foreach y in $yvar1 {	
		eststo `y'_f: areg `y' ib0.pa_fl_treat##c.pa_tag_mun ///
			$control2_intgen if age >= 25 & pa_female == 0, ///
			vce(cluster pa_birthmun) abs(pa_birthyr pa_birthmun)
		sum `y' if pa_fl_treat == 0 & pa_female == 0
		estadd scalar controlmean = r(mean)
		estadd scalar controlsdscore = r(sd)
		estadd local convars "Yes"
	}

	* Panel C: Mother subsample (pa_female == 1)
	foreach y in $yvar1 {	
		eststo `y'_m: areg `y' ib0.pa_fl_treat##c.pa_tag_mun ///
			$control2_intgen if age >= 25 & pa_female == 1, ///
			vce(cluster pa_birthmun) abs(pa_birthmun pa_birthyr)
		sum `y' if pa_fl_treat == 0 & pa_female == 1
		estadd scalar controlmean = r(mean)
		estadd scalar controlsdscore = r(sd)
		estadd local convars "Yes"
	}

	* Output Panel A
	esttab yrSch compHS entCol compCol ///
		using "$Tbl/BEP_ATT_Full_edu_mun_Child.tex", replace label ///
		$coeflabs3 $cellfmt $tblfmt $tblstat1

	* Output Panel B: Father
	esttab yrSch_f compHS_f entCol_f compCol_f ///
		using "$Tbl/BEP_ATT_Father_edu_mun_Child.tex", replace label ///
		$coeflabs3 $cellfmt $tblfmt $tblstat1

	* Output Panel C: Mother
	esttab yrSch_m compHS_m entCol_m compCol_m ///
		using "$Tbl/BEP_ATT_Mother_edu_mun_Child.tex", replace label ///
		$coeflabs3 $cellfmt $tblfmt $tblstat1

	* Event study by parental age in 1974
	foreach y in $yvar1 {
		local ylabel : var label `y'
		areg `y' ib7.pa_age1974##c.pa_tag_mun ///
			$control2_intgen ///
			if age >= 25, ///
			vce(cluster pa_birthmun) abs(pa_birthmun)

		* Pre-trend F-test (parent ages 7-14 jointly)
		test 7.pa_age1974#c.pa_tag_mun  8.pa_age1974#c.pa_tag_mun ///
			 9.pa_age1974#c.pa_tag_mun  10.pa_age1974#c.pa_tag_mun ///
			 11.pa_age1974#c.pa_tag_mun 12.pa_age1974#c.pa_tag_mun ///
			 13.pa_age1974#c.pa_tag_mun 14.pa_age1974#c.pa_tag_mun
		local pretrend_p = r(p)

		coefplot, ///
			keep(*.pa_age1974#c.pa_tag_mun) ci(95) vertical ///
			coeflabels( ///
				1.pa_age1974#c.pa_tag_mun="1"   2.pa_age1974#c.pa_tag_mun="2"  ///
				3.pa_age1974#c.pa_tag_mun="3"   4.pa_age1974#c.pa_tag_mun="4"  ///
				5.pa_age1974#c.pa_tag_mun="5"   6.pa_age1974#c.pa_tag_mun="6"  ///
				7.pa_age1974#c.pa_tag_mun="7"                                   ///
				8.pa_age1974#c.pa_tag_mun="8"   9.pa_age1974#c.pa_tag_mun="9"  ///
				10.pa_age1974#c.pa_tag_mun="10" 11.pa_age1974#c.pa_tag_mun="11" ///
				12.pa_age1974#c.pa_tag_mun="12" 13.pa_age1974#c.pa_tag_mun="13" ///
				14.pa_age1974#c.pa_tag_mun="14" 15.pa_age1974#c.pa_tag_mun="15" ///
				16.pa_age1974#c.pa_tag_mun="16" 17.pa_age1974#c.pa_tag_mun="17" ///
				18.pa_age1974#c.pa_tag_mun="18") ///
			xlabel(, angle(0)) ///
			ylabel(, angle(0)) ///
			xtitle("Parent's Age in 1974") ///
			ytitle("Estimate and 95% CI") ///
			yline(0, lcolor(black) lwidth(vthin)) ///
			xline(4.5, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
			ciopts(recast(rcap) lwidth(vthin)) ///
			xsc(reverse) ///
			msymbol(O) msize(small) ///
			note("Pre-trend F-test p-value = `: display %5.3f `pretrend_p''")
		graph export "$Fig/PH_coefplot_`y'_mun_Child.png", replace
	}
		
	restore
