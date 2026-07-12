
*** Run the Master Dofile ****


	******************
	**# Event Study
	******************
	
foreach y in $allys {
    local ylabel : var label `y'

    areg `y' ib7.age_1974##c.tag_mun $control if in_sample==1 , vce(cluster birthmun) abs(birthmun )
	
	    test 7.age_1974#c.tag_mun 8.age_1974#c.tag_mun ///
		9.age_1974#c.tag_mun  10.age_1974#c.tag_mun ///
		11.age_1974#c.tag_mun 12.age_1974#c.tag_mun ///	
		13.age_1974#c.tag_mun 14.age_1974#c.tag_mun 
		local pretrend_p = r(p)
		
    coefplot, ///
        keep(*.age_1974#c.tag_mun) ci(95) vertical ///
        coeflabels( ///
            1.age_1974#c.tag_mun="1" 2.age_1974#c.tag_mun="2" ///
            3.age_1974#c.tag_mun="3" 4.age_1974#c.tag_mun="4" ///
            5.age_1974#c.tag_mun="5" 6.age_1974#c.tag_mun="6" ///
            7.age_1974#c.tag_mun="7" ///
            8.age_1974#c.tag_mun="8" 9.age_1974#c.tag_mun="9" ///
            10.age_1974#c.tag_mun="10" 11.age_1974#c.tag_mun="11" ///
            12.age_1974#c.tag_mun="12" 13.age_1974#c.tag_mun="13" ///
            14.age_1974#c.tag_mun="14" 15.age_1974#c.tag_mun="15" ///
            16.age_1974#c.tag_mun="16" 17.age_1974#c.tag_mun="17" ///
            18.age_1974#c.tag_mun="18" 19.age_1974#c.tag_mun="19" ///
            20.age_1974#c.tag_mun="20" 21.age_1974#c.tag_mun="21" ///
			22.age_1974#c.tag_mun="22" ///
        ) ///
        xlabel(,angle(0)) ///
        ylabel(,angle(0)) ///
        xtitle("Age in 1974") ///
        ytitle("Estimate and 95% CI") ///
		yline(0, lcolor(black) lwidth(vthin)) ///
		xline(4.5, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
        ciopts(recast(rcap) lwidth(vthin)) ///
        xsc(reverse) ///
		msymbol(O) ///
		msize(small) ///
		note("Pre-trend F-test p-value = `: display %5.3f `pretrend_p''")

    graph export "$Fig/PH_coefplot_`y'_mun.png", replace
}

	*****************
	**# Estimand 1
	*****************	
	* OLS DiD
	
	* Fully treated or control

	estimates clear
	
	foreach y in $allys {	
	eststo `y': areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}

	* Education (unchanged)
	esttab yrSch compHS entCol compCol ///
    using "$Tbl/BEP_ATT_Full_edu_mun.tex", replace label ///
    $coeflabs1 $cellfmt $tblfmt $tblstat1

	* Labor market (updated)
	esttab  high_english_occ ofw interethnic_any  cross_boundary_cond ///
    using "$Tbl/BEP_ATT_Full_laborsocial_mun.tex", replace label ///
    $coeflabs1 $cellfmt $tblfmt $tblstat1

	* Including potentially affected ones

	foreach y in $allys {	
	eststo `y'2: areg `y' ib0.treat##c.tag_mun $control if in_sample, vce(cluster birthmun)  abs(birthyr birthmun)
	sum `y' if treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	
	lincom 1.treat#c.tag_mun - 2.treat#c.tag_mun
	estadd scalar pval_1v2 = r(p)
}

	esttab yrSch2 compHS2 entCol2 compCol2  ///
	using "$Tbl/BEP_ATT_FullPart_edu_mun.tex", replace label ///
	$coeflabs2 $cellfmt $tblfmt $tblstat2
	
	esttab  high_english_occ2 ofw2 interethnic_any2  cross_boundary_cond2  ///
	using "$Tbl/BEP_ATT_FullPart_laborsocial_mun.tex", replace label ///
	$coeflabs2 $cellfmt $tblfmt $tblstat2  
 

    ********************
  	* HETEROGENEITY
	*******************
	
	* Urban Rural
	preserve
	keep if city==1
	foreach y in $allys {	
	eststo `y'_u: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	preserve
	keep if city==0
	foreach y in $allys {	
	eststo `y'_r: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore

	esttab yrSch_u yrSch_r compHS_u compHS_r ///
	entCol_u entCol_r compCol_u compCol_r  ///
	using "$Tbl/BEP_Hetero_edu_U_R_mun.tex", ///
	replace label $coeflabs1 $cellfmt $tblfmt $tblstat1 
	
	esttab high_english_occ_u high_english_occ_r ofw_u ofw_r ///
	interethnic_any_u interethnic_any_r cross_boundary_cond_u cross_boundary_cond_r   ///
	using "$Tbl/BEP_Hetero_laborsocial_U_R_mun.tex", replace label ///
	$coeflabs1 $cellfmt $tblfmt $tblstat1  

	* Female and Male
	
	preserve
	keep if female==1
	foreach y in $allys {	
	eststo `y'_f: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	preserve
	keep if female==0
	foreach y in $allys {	
	eststo `y'_m: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	esttab yrSch_f yrSch_m compHS_f compHS_m ///
	entCol_f entCol_m compCol_f compCol_m  ///
	using "$Tbl/BEP_Hetero_edu_F_M_mun.tex", ///
	replace label $coeflabs1 $cellfmt $tblfmt $tblstat1 
	
	esttab high_english_occ_f high_english_occ_m ofw_f ofw_m ///
	interethnic_any_f interethnic_any_m  cross_boundary_cond_f cross_boundary_cond_m   ///
	using "$Tbl/BEP_Hetero_laborsocial_F_M_mun.tex", replace label ///
	$coeflabs1 $cellfmt $tblfmt $tblstat1  

	* Linguistic Fraction

	preserve
	keep if langfrac_high_mun==1
	foreach y in $allys {	
	eststo `y'_h: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	preserve
	keep if langfrac_high_mun==0
	foreach y in $allys {	
	eststo `y'_l: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	esttab yrSch_h yrSch_l compHS_h compHS_l ///
	entCol_h entCol_l compCol_h compCol_l  ///
	using "$Tbl/BEP_Hetero_edu_H_L_mun.tex", ///
	replace label $coeflabs1 $cellfmt $tblfmt $tblstat1 
	
	esttab high_english_occ_h high_english_occ_l ofw_h ofw_l ///
	interethnic_any_h interethnic_any_l cross_boundary_cond_h cross_boundary_cond_l   ///
	using "$Tbl/BEP_Hetero_laborsocial_H_L_mun.tex", replace label ///
	$coeflabs1 $cellfmt $tblfmt $tblstat1  
/*
	* Pre-policy education condition

	preserve
	keep if HSsharemun_abovemed==1
	foreach y in $allys {	
	eststo `y'_eh: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	preserve
	keep if HSsharemun_abovemed==0
	foreach y in $allys {	
	eststo `y'_el: areg `y' ib0.fl_treat##c.tag_mun $control if in_sample, vce(cluster birthmun) abs(birthyr birthmun) 
	sum `y' if fl_treat==0 & in_sample
	estadd scalar controlmean=r(mean)
	estadd scalar controlsdscore = r(sd)
	estadd local convars "Yes"
	}
	restore
	
	esttab yrSch_eh yrSch_el compHS_eh compHS_el ///
	entCol_eh entCol_el compCol_eh compCol_el  ///
	using "$Tbl/BEP_Hetero_edu_EDU_mun.tex", ///
	replace label $coeflabs1 $cellfmt $tblfmt $tblstat1 
	
	esttab high_english_occ_eh high_english_occ_el ofw_eh ofw_el ///
	interethnic_any_eh interethnic_any_el cross_boundary_cond_eh cross_boundary_cond_el   ///
	using "$Tbl/BEP_Hetero_laborsocial_EDU_mun.tex", replace label ///
	$coeflabs1 $cellfmt $tblfmt $tblstat1  
 
*/
