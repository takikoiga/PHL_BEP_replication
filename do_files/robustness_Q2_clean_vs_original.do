*============================================================
* Robustness: "Clean" Q2 excluding Tagalog-dominant municipalities
*
* Motivation: Q2 (dose1) contains 28.13% Tagalog-dominant (tag_mun==1)
* observations, contaminating the comparison with Q1 (near-zero LDT,
* ~100% Tagalog-dominant). This do-file:
*   (1) reproduces the original Q1/Q2 (dose0/dose1) definitions used
*       in the main dose-aware analysis,
*   (2) defines a "clean" Q2 that excludes Tagalog-dominant municipalities,
*   (3) re-runs the same event-study and DiD specifications for both
*       the original and clean versions of Q2, for direct comparison.
*
* PREREQUISITES: same as Santata_Chaismartin_dose_awareES_v6_1.do
*   (global control, global cellfmt, global tblfmt, global Fig, global Tbl)
*
* Results (for reference, run June 2026):
*   Original Q2 vs Q1: DiD = 0.106 (SE = 0.031), Pre-trend F-test p = 0.571
*   Clean Q2    vs Q1: DiD = 0.177 (SE = 0.031), Pre-trend F-test p = 0.427
*============================================================

preserve

*------------------------------------------------------------
* STEP 0: Reproduce event time, sample window, and LDT quartiles
*   (identical to main do-file, STEPs 0a-0b-1-2)
*------------------------------------------------------------
cap drop event_time
gen event_time = birthyr - 1968
label var event_time "Event time (birth cohort relative to 1974 BEP)"

cap drop insample4
gen insample4 = inrange(birthyr, 1960, 1977)
label var insample4 "Birth cohorts 1960-1977 (extended analysis sample)"

global LDIvar "LDItag_mun"

cap drop LDI_q4
xtile LDI_q4 = ${LDIvar}, nq(4)

cap drop dose0
gen dose0 = (LDI_q4 == 1)
label var dose0 "Near-zero LDT -- Q1 (Tagalog dominant, mean tag_share=0.96)"

cap drop dose1
gen dose1 = (LDI_q4 == 2)
label var dose1 "Low-medium LDT -- Q2, original (includes Tagalog-dominant munis)"

cap drop dose1_clean
gen dose1_clean = (LDI_q4 == 2 & tag_mun == 0)
label var dose1_clean "Low-medium LDT -- Q2, excluding Tagalog-dominant munis"

* Sanity check: contamination share in original Q2, and confirm clean
* version has zero Tagalog-dominant observations
tab dose1 tag_mun if LDI_q4 == 2, row
tab dose1_clean tag_mun if LDI_q4 == 2, row

*------------------------------------------------------------
* STEP 1: Event-time x dose interaction terms (original and clean Q2)
*------------------------------------------------------------
foreach v in dose1 dose1_clean {
    local pfx = cond("`v'" == "dose1", "es_orig", "es_clean")
    forvalues e = -8/9 {
        if `e' != -1 {
            local suf = cond(`e' < 0, "m" + string(abs(`e')), "p" + string(`e'))
            cap drop `pfx'_`suf'
            gen `pfx'_`suf' = (event_time == `e') * `v'
        }
    }
}

*------------------------------------------------------------
* STEP 2: Event-study regressions (years of schooling)
*------------------------------------------------------------
foreach spec in orig clean {
    local dosevar = cond("`spec'" == "orig", "dose1", "dose1_clean")

    reghdfe yrSch es_`spec'_* $control ///
        if (dose0 | `dosevar') & insample4 == 1, ///
        absorb(birthmun birthyr) vce(cluster birthmun)

    * Pre-trends F-test
    test es_`spec'_m8 = es_`spec'_m7 = es_`spec'_m6 = ///
         es_`spec'_m5 = es_`spec'_m4 = es_`spec'_m3 = es_`spec'_m2
    local pval_`spec' = r(p)
    di "Pre-trends F-test p-value (`spec' Q2): `pval_`spec''"

    estimates store yrSch_`spec'
}

* Coefplot: original vs. clean Q2, side by side
foreach spec in orig clean {
    local ptitle = cond("`spec'" == "orig", ///
        "Low-medium LDT (Q2, original) vs Near-zero LDT (Q1)", ///
        "Low-medium LDT (Q2, excl. Tagalog-dominant) vs Near-zero LDT (Q1)")
    local pvalfmt : display %4.3f `pval_`spec''

    coefplot yrSch_`spec', keep(es_`spec'_*) vertical ///
        coeflabels( ///
            es_`spec'_m8="-8" es_`spec'_m7="-7" es_`spec'_m6="-6" ///
            es_`spec'_m5="-5" es_`spec'_m4="-4" es_`spec'_m3="-3" ///
            es_`spec'_m2="-2" es_`spec'_p0="0" ///
            es_`spec'_p1="1"  es_`spec'_p2="2"  es_`spec'_p3="3"  ///
            es_`spec'_p4="4"  es_`spec'_p5="5"  es_`spec'_p6="6"  ///
            es_`spec'_p7="7"  es_`spec'_p8="8"  es_`spec'_p9="9", ///
            notick labsize(small)) ///
        yline(0,    lpattern(dash)      lcolor(cranberry) lwidth(vthin)) ///
        xline(7.5,  lpattern(solid)     lcolor(gs8)       lwidth(vthin)) ///
        xline(11.5, lpattern(shortdash) lcolor(black)     lwidth(vthin)) ///
        ciopts(recast(rcap) lwidth(vthin)) ///
        xtitle("Event time (years relative to 1974 BEP)") ///
        ytitle("Estimate and 95% CI") ///
        title("`ptitle'", size(medium)) ///
        note("Pre-trends F-test: p = `pvalfmt'.", size(medium) position(7))
    graph export "$Fig/ES_qtile_dose1`=cond("`spec'"=="clean","_clean","")'_vs_dose0_yrSch.png", ///
        replace width(2400) height(1400)
}

*------------------------------------------------------------
* STEP 3: DiD point estimates (post-treatment average effect)
*   -- for direct numeric comparison, original vs. clean Q2
*------------------------------------------------------------
foreach spec in orig clean {
    local dosevar = cond("`spec'" == "orig", "dose1", "dose1_clean")

    cap drop post_`spec'
    gen post_`spec' = (event_time >= 0) * `dosevar'

    reghdfe yrSch post_`spec' $control ///
        if (dose0 | `dosevar') & insample4 == 1, ///
        absorb(birthmun birthyr) vce(cluster birthmun)

    di "DiD estimate, `spec' Q2 vs Q1: " _b[post_`spec'] " (se: " _se[post_`spec'] ")"

    drop post_`spec'
}

restore
*============================================================
* END OF ROBUSTNESS DO-FILE
*============================================================
