*============================================================
* Dose-Aware Event Study: BEP × Linguistic Distance
* de Chaisemartin (2024) continuous treatment approach
* Each dose group compared against near-zero LDT baseline
*
* v6: June 2026
*   - Quartile grouping: LDT distribution divided into 4 equal groups
*   - Q1 (dose0): near-zero LDT, overwhelmingly Tagalog dominant
*     (mean tag_share = 0.963, mean LDT = 0.011)
*     Natural break: Q1 max LDT = 0.024 vs Q2 min = 0.025
*   - Q2 (dose1): low-medium LDT (mean LDT = 0.159, tag_share = 0.307)
*   - Q3 (dose2): medium-high LDT (mean LDT = 0.218, tag_share = 0.049)
*   - Q4 (dose3): high LDT (mean LDT = 0.289, tag_share = 0.112)
*   - Simple to explain: "municipalities divided into LDT quartiles"
*   - Q1 captures natural Tagalog-dominant cluster in LDT distribution
*
* Outcomes: yrSch, compHS, entCol, compCol,
*           high_english_occ, ofw, interethnic_any,
*           diffPdiffM_birth, cross_boundary
*
* NOTE on event_time anchoring:
*   event_time = birthyr - 1968 (anchored at 1974 BEP rollout)
*   Tagalog areas (dose0): first Grade 1 BEP cohort = event_time 6 (1974)
*   Non-Tagalog areas (dose1-3): first Grade 1 BEP cohort = event_time 10 (1978)
*   Two xlines mark both treatment years:
*     xline(7.5)  = 1974 BEP rollout in Tagalog areas
*     xline(11.5) = 1978 BEP nationwide expansion
*
* PREREQUISITES (defined in master do-file before running this):
*   global control   "..."        // covariate list
*   global cellfmt   "..."        // esttab cell format
*   global tblfmt    "..."        // esttab table format
*   global Fig       "path/to/figures"
*   global Tbl       "path/to/tables"
*============================================================

preserve

*------------------------------------------------------------
* STEP 0a: Event time (anchored at 1974)
*------------------------------------------------------------
cap drop event_time
gen event_time = birthyr - 1968
label var event_time "Event time (birth cohort relative to 1974 BEP)"

*------------------------------------------------------------
* STEP 0b: Sample window
*   event_time -8 to +9 → birthyr 1960-1977
*   Consistent with main sample cutoff; pre-MTB-MLE pilots ~2000
*------------------------------------------------------------
cap drop insample4
gen insample4 = inrange(birthyr, 1960, 1977)
*keep if inrange(event_time, -8, 9)

*------------------------------------------------------------
* STEP 1: Linguistic distance measure
*------------------------------------------------------------
* global LDIvar "LDItag_prv"   // province level (robustness)
global LDIvar "LDItag_mun"     // municipality level (main)

*------------------------------------------------------------
* STEP 2: LDT quartile dose groups
*
*   Municipalities divided into quartiles of the LDT distribution.
*   Q1 (dose0) serves as the baseline — overwhelmingly Tagalog-
*   dominant municipalities (mean Tagalog speaker share = 96.3%,
*   mean LDT = 0.011) where BEP imposed no meaningful linguistic
*   transition cost. A natural break exists between Q1 (max LDT =
*   0.024) and Q2 (min LDT = 0.025), corresponding to a sharp
*   drop in Tagalog speaker share from 96% to 31%.
*   Q2–Q4 represent municipalities with increasing linguistic
*   distance from Tagalog.
*
*   Summary statistics by group:
*   dose0 (Q1): mean LDT = 0.011, mean tag_share = 0.963
*   dose1 (Q2): mean LDT = 0.159, mean tag_share = 0.307
*   dose2 (Q3): mean LDT = 0.218, mean tag_share = 0.049
*   dose3 (Q4): mean LDT = 0.289, mean tag_share = 0.112
*------------------------------------------------------------
cap drop LDI_q4
xtile LDI_q4 = ${LDIvar}, nq(4)

* Baseline: Q1 — near-zero LDT, Tagalog-dominant municipalities
cap drop dose0
gen dose0 = (LDI_q4 == 1)
label var dose0 "Near-zero LDT — Q1 (Tagalog dominant, mean tag_share=0.96)"

* Low-medium LDT: Q2
cap drop dose1
gen dose1 = (LDI_q4 == 2)
label var dose1 "Low-medium LDT — Q2 (mean LDT=0.159)"

* Medium-high LDT: Q3
cap drop dose2
gen dose2 = (LDI_q4 == 3)
label var dose2 "Medium-high LDT — Q3 (mean LDT=0.218)"

* High LDT: Q4
cap drop dose3
gen dose3 = (LDI_q4 == 4)
label var dose3 "High LDT — Q4 (mean LDT=0.289)"

*------------------------------------------------------------
* STEP 3: Dose group labels for coefplot titles
*------------------------------------------------------------
local title1 "Low-medium LDT (Q2) vs Near-zero LDT (Q1)"
local title2 "Medium-high LDT (Q3) vs Near-zero LDT (Q1)"
local title3 "High LDT (Q4) vs Near-zero LDT (Q1)"

*------------------------------------------------------------
* STEP 4: Event-time × dose interaction terms
*   Reference period: event_time = -1 (omitted)
*   Pre-period:  event_time -8 to -2  (suffix: m8...m2)
*   Post-period: event_time  0 to +9  (suffix: p0...p9)
*------------------------------------------------------------
foreach d in 1 2 3 {
    forvalues e = -8/9 {
        if `e' != -1 {
            local suf = cond(`e' < 0, "m" + string(abs(`e')), "p" + string(`e'))
            cap drop es_d`d'_`suf'
            gen es_d`d'_`suf' = (event_time == `e') * dose`d'
        }
    }
}

*********************
**# Dose group characteristics table
*********************

* Need to be run on full dataset (not insample4 restricted)
* LDI_q4 must already be defined

local charvars LDItag_mun tag_share_mun langfrac_mun

eststo clear

estpost summarize `charvars' if LDI_q4 == 1 & in_sample==1
eststo q1

estpost summarize `charvars' if LDI_q4 == 2 & in_sample==1
eststo q2

estpost summarize `charvars' if LDI_q4 == 3 & in_sample==1
eststo q3

estpost summarize `charvars' if LDI_q4 == 4 & in_sample==1
eststo q4

esttab q1 q2 q3 q4 ///
    using "$Tbl/DoseAware_characteristics.tex", replace ///
    cells(mean(fmt(3)) sd(par fmt(3))) label fragment booktabs ///
    mlabels(, none) collabels(, none) nomtitle nonumbers noline noobs nonotes ///
    substitute(_ \_) style(tex)
*============================================================
* STEP 5: Event-study regressions + coefplots
*
* Structure per outcome × dose:
*   (i)  reghdfe on (dose0 | dose_d) subsample
*   (ii) Pre-trends F-test: event_time -8 to -2 jointly = 0
*        → r(p) saved as local AND estadd'd for table use
*   (iii) estimates store for optional post-hoc inspection
*   (iv) coefplot with dual xlines (1974, 1978)
*   (v)  graph export (.png) + save (.gph) for graph combine
*============================================================
foreach y in yrSch {

    * Pass 1: run all regressions and collect y-axis range
    local ymin = 0
    local ymax = 0

    foreach d in 1 2 3 {
        reghdfe `y' es_d`d'_* $control ///
            if (dose0 | dose`d') & insample4 == 1, ///
            absorb(birthmun birthyr) vce(cluster birthmun)

        * Pre-trends F-test
        test es_d`d'_m8 = es_d`d'_m7 = es_d`d'_m6 = ///
             es_d`d'_m5 = es_d`d'_m4 = es_d`d'_m3 = es_d`d'_m2
        local pval_d`d' = r(p)
        local pval_fmt_d`d' : display %4.3f `pval_d`d''
        estadd scalar ftest_p = `pval_d`d''
        estimates store `y'_d`d'

        * Collect min/max of b-1.96*se and b+1.96*se across all coefs
        matrix b = e(b)
        matrix V = e(V)
        local k = colsof(b)
        forvalues i = 1/`k' {
            local coefname : word `i' of `: colnames b'
            if regexm("`coefname'", "es_d`d'_") {
                local bi = b[1,`i']
                local sei = sqrt(V[`i',`i'])
                local lo = `bi' - 1.96*`sei'
                local hi = `bi' + 1.96*`sei'
                if `lo' < `ymin' local ymin = `lo'
                if `hi' > `ymax' local ymax = `hi'
            }
        }
    }

    * Round to nearest 0.1 with small padding
    local ymin = floor(`ymin' * 10 - 1) / 10
    local ymax = ceil(`ymax' * 10 + 1) / 10

    * Pass 2: plot with common y-axis
    foreach d in 1 2 3 {

        coefplot `y'_d`d', keep(es_d`d'_*) vertical ///
            coeflabels( ///
                es_d`d'_m8="-8" es_d`d'_m7="-7" es_d`d'_m6="-6" ///
                es_d`d'_m5="-5" es_d`d'_m4="-4" es_d`d'_m3="-3" ///
                es_d`d'_m2="-2" es_d`d'_p0="0"                   ///
                es_d`d'_p1="1"  es_d`d'_p2="2"  es_d`d'_p3="3"  ///
                es_d`d'_p4="4"  es_d`d'_p5="5"  es_d`d'_p6="6"  ///
                es_d`d'_p7="7"  es_d`d'_p8="8"  es_d`d'_p9="9", ///
                notick labsize(small))                             ///
            yline(0,    lpattern(dash)      lcolor(cranberry) lwidth(vthin)) ///
            xline(7.5,  lpattern(solid)     lcolor(gs8)       lwidth(vthin)) ///
            xline(11.5, lpattern(shortdash) lcolor(black)     lwidth(vthin)) ///
            ciopts(recast(rcap) lwidth(vthin))                    ///
            xlabel(, labsize(small))                              ///
            ylabel(`ymin'(0.1)`ymax', labsize(small))            ///
            yscale(range(`ymin' `ymax'))                         ///
			mcolor(black) mfcolor(white) msymbol(O) msize(small) ///
            xtitle("Event time (years relative to 1974 BEP)")     ///
            ytitle("Estimate and 95% CI")                         ///
            title("`title`d''", size(medium))                     ///
            note("Pre-trends F-test: p = `pval_fmt_d`d''.",      ///
                 size(medium) position(7))
        graph export "$Fig/ES_qtile_dose`d'_vs_dose0_`y'.png", ///
            replace width(2400) height(1400)
        graph save "$Fig/ES_qtile_dose`d'_vs_dose0_`y'.gph", replace

    }

    * Combine all three dose groups into one stacked figure per outcome
    graph combine ///
        "$Fig/ES_qtile_dose1_vs_dose0_`y'.gph" ///
        "$Fig/ES_qtile_dose2_vs_dose0_`y'.gph" ///
        "$Fig/ES_qtile_dose3_vs_dose0_`y'.gph", ///
        cols(1) ///
        graphregion(color(white)) ///
        xsize(6) ysize(10)
    graph export "$Fig/ES_dose123_combined_`y'.png", ///
        replace width(2400) height(3600)

}

/*
foreach y in yrSch {

    foreach d in 1 2 3 {

        reghdfe `y' es_d`d'_* $control ///
            if (dose0 | dose`d') & insample4 == 1, ///
            absorb(birthmun birthyr) vce(cluster birthmun)

        * Pre-trends F-test: joint significance of pre-period leads
        test es_d`d'_m8 = es_d`d'_m7 = es_d`d'_m6 = ///
             es_d`d'_m5 = es_d`d'_m4 = es_d`d'_m3 = es_d`d'_m2
        local pval     = r(p)
        local pval_fmt : display %4.3f `pval'

        * Attach ftest_p to stored estimates
        estadd scalar ftest_p = `pval'
        estimates store `y'_d`d'

        coefplot, keep(es_d`d'_*) vertical ///
            coeflabels( ///
                es_d`d'_m8="-8" es_d`d'_m7="-7" es_d`d'_m6="-6" ///
                es_d`d'_m5="-5" es_d`d'_m4="-4" es_d`d'_m3="-3" ///
                es_d`d'_m2="-2" es_d`d'_p0="0"                   ///
                es_d`d'_p1="1"  es_d`d'_p2="2"  es_d`d'_p3="3"  ///
                es_d`d'_p4="4"  es_d`d'_p5="5"  es_d`d'_p6="6"  ///
                es_d`d'_p7="7"  es_d`d'_p8="8"  es_d`d'_p9="9", ///
                notick labsize(small))                             ///
            yline(0,    lpattern(dash)      lcolor(cranberry) lwidth(vthin)) ///
            xline(7.5,  lpattern(solid)     lcolor(gs8)       lwidth(vthin)) ///
            xline(11.5, lpattern(shortdash) lcolor(black)     lwidth(vthin)) ///
            ciopts(recast(rcap) lwidth(vthin))                    ///
            xlabel(, labsize(small)) ylabel(, labsize(small))     ///
            mcolor(black) mfcolor(black) msymbol(O)               ///
            xtitle("Event time (years relative to 1974 BEP)")     ///
            ytitle("Estimate and 95% CI")                         ///
            title("`title`d''", size(medium))                     ///
            note("Pre-trends F-test: p = `pval_fmt'.",            ///
                 size(medium) position(7))
        graph export "$Fig/ES_qtile_dose`d'_vs_dose0_`y'.png", ///
            replace width(2400) height(1400)
        graph save "$Fig/ES_qtile_dose`d'_vs_dose0_`y'.gph", replace

    }

    * Combine all three dose groups into one stacked figure per outcome
    graph combine ///
        "$Fig/ES_qtile_dose1_vs_dose0_`y'.gph" ///
        "$Fig/ES_qtile_dose2_vs_dose0_`y'.gph" ///
        "$Fig/ES_qtile_dose3_vs_dose0_`y'.gph", ///
        cols(1) ///
        graphregion(color(white)) ///
        xsize(6) ysize(10)
    graph export "$Fig/ES_dose123_combined_`y'.png", ///
        replace width(2400) height(3600)

}
/*
*============================================================
* STEP 6: Summary table
*
* Design:
*   - One .tex fragment per outcome (9 fragments total)
*   - Each fragment: single row (post-treatment avg. effect)
*                    + pre-trend F-test p + N
*   - Three columns: Q2 (low-med) | Q3 (med-high) | Q4 (high)
*   - Assembled in LaTeX master via \input (one \input per panel)
*
* Panel labels (for reference — applied in LaTeX, not here)
*   Panel A: Years of schooling         → DoseAware_yrSch.tex
*   Panel B: Basic education completion → DoseAware_compHS.tex
*   Panel C: College enrollment         → DoseAware_entCol.tex
*   Panel D: College completion         → DoseAware_compCol.tex
*   Panel E: English-intensive occ.     → DoseAware_high_english_occ.tex
*   Panel F: Overseas work              → DoseAware_ofw.tex
*   Panel G: Interethnic marriage       → DoseAware_interethnic_any.tex
*   Panel H: Moved out of birth prov.   → DoseAware_diffPdiffM_birth.tex
*   Panel I: Cross-boundary migration   → DoseAware_cross_boundary.tex
*============================================================

global coeflabs_dose ///
    "coeflabels(post "Post-treatment avg. effect") keep(post) nobaselevels"

global tblstat_dose ///
    "stats(ftest_p N, labels("\midrule Pre-trend F-test \textit{p}" "Observations") fmt(%5.3f %9.0fc))"

estimates clear

foreach y in yrSch compHS entCol compCol ///
             high_english_occ ofw interethnic_any ///
             diffPdiffM_birth cross_boundary {

    foreach d in 1 2 3 {

        * Event study — for pre-trend F-test p-value only
        reghdfe `y' es_d`d'_* $control ///
            if (dose0 | dose`d') & insample4 == 1, ///
            absorb(birthmun birthyr) vce(cluster birthmun)
        test es_d`d'_m8 = es_d`d'_m7 = es_d`d'_m6 = ///
             es_d`d'_m5 = es_d`d'_m4 = es_d`d'_m3 = es_d`d'_m2
        local ftp = r(p)

        * DiD regression: single post indicator × dose
        gen post = (event_time >= 0) * dose`d'
        reghdfe `y' post $control ///
            if (dose0 | dose`d') & insample4 == 1, ///
            absorb(birthmun birthyr) vce(cluster birthmun)
        eststo `y'_d`d'
        estadd scalar ftest_p = `ftp'
        drop post

    }
}

foreach y in yrSch compHS entCol compCol ///
             high_english_occ ofw interethnic_any ///
             diffPdiffM_birth cross_boundary {

    esttab `y'_d1 `y'_d2 `y'_d3 ///
        using "$Tbl/DoseAware_`y'.tex", replace label ///
        $coeflabs_dose $cellfmt $tblfmt $tblstat_dose

}

restore
*============================================================
* END OF DO-FILE
*============================================================
