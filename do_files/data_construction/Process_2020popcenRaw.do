clear all

* ===== SET THIS TO THE FOLDER WHERE YOU HAVE PLACED THE RAW PSA EXTRACT =====
* This script expects the raw 2020 CPH PUF files (obtained from PSA via
* https://psada.psa.gov.ph/home) to be organized under this folder in PSA's
* original region/province subfolder structure, as distributed by PSA.
gl parent "."
* ==============================================================================
gl fm2 "/Popcen2020/PUF for CPH Form 2 (Common Household Questionnaire)"
gl fm3 "/Popcen2020/PUF for CPH Form 3 (Sample Household Questionnaire)"
gl data "CPH PUF 2020"
gl hh "- HOUSEHOLD.CSV"
gl mm "- MEMBERS.CSV"

**# BARMM

	import delimited "$parent$fm2/ARMM/Basilan/$data Basilan $hh", clear
	save "$parent/data/from2_hh_basilan.dta", replace
	import delimited "$parent$fm2/ARMM/Basilan/$data Basilan $mm", clear
	save "$parent/data/from2_mm_basilan.dta", replace
	import delimited "$parent$fm3/BARMM/Basilan/$data Basilan $hh", clear
	save "$parent/data/from3_hh_basilan.dta", replace
	import delimited "$parent$fm3/BARMM/Basilan/$data Basilan $mm", clear
	save "$parent/data/from3_mm_basilan.dta", replace

	import delimited "$parent$fm2/ARMM/Interim Province/$data Interim Province $hh", clear
	save "$parent/data/from2_hh_intrprov.dta", replace
	import delimited "$parent$fm2/ARMM/Interim Province/$data Interim Province $mm", clear
	save "$parent/data/from2_mm_intrprov.dta", replace
	import delimited "$parent$fm3/BARMM/Interim Province/$data Interim Province $hh", clear
	save "$parent/data/from3_hh_intrprov.dta", replace
	import delimited "$parent$fm3/BARMM/Interim Province/$data Interim Province $mm", clear
	save "$parent/data/from3_mm_intrprov.dta", replace

	import delimited "$parent$fm2/ARMM/Lanao Del Sur/$data Lanao Del Sur $hh", clear
	save "$parent/data/from2_hh_lanaodelsur.dta", replace
	import delimited "$parent$fm2/ARMM/Lanao Del Sur/$data Lanao Del Sur $mm", clear
	save "$parent/data/from2_mm_lanaodelsur.dta", replace
	import delimited "$parent$fm3/BARMM/Lanao Del Sur/$data Lanao Del Sur $hh", clear
	save "$parent/data/from3_hh_lanaodelsur.dta", replace
	import delimited "$parent$fm3/BARMM/Lanao Del Sur/$data Lanao Del Sur $mm", clear
	save "$parent/data/from3_mm_lanaodelsur.dta", replace

	import delimited "$parent$fm2/ARMM/Maguindanao/$data Maguindanao $hh", clear
	save "$parent/data/from2_hh_maguindanao.dta", replace
	import delimited "$parent$fm2/ARMM/Maguindanao/$data Maguindanao $mm", clear
	save "$parent/data/from2_mm_maguindanao.dta", replace
	import delimited "$parent$fm3/BARMM/Maguindanao/$data Maguindanao $hh", clear
	save "$parent/data/from3_hh_maguindanao.dta", replace
	import delimited "$parent$fm3/BARMM/Maguindanao/$data Maguindanao $mm", clear
	save "$parent/data/from3_mm_maguindanao.dta", replace

	import delimited "$parent$fm2/ARMM/Sulu/$data Sulu $hh", clear
	save "$parent/data/from2_hh_sulu.dta", replace
	import delimited "$parent$fm2/ARMM/Sulu/$data Sulu $mm", clear
	save "$parent/data/from2_mm_sulu.dta", replace
	import delimited "$parent$fm3/BARMM/Sulu/$data Sulu $hh", clear
	save "$parent/data/from3_hh_sulu.dta", replace
	import delimited "$parent$fm3/BARMM/Sulu/$data Sulu $mm", clear
	save "$parent/data/from3_mm_sulu.dta", replace

	import delimited "$parent$fm2/ARMM/Tawi Tawi/$data Tawi Tawi $hh", clear
	save "$parent/data/from2_hh_tawitawi.dta", replace
	import delimited "$parent$fm2/ARMM/Tawi Tawi/$data Tawi Tawi $mm", clear
	save "$parent/data/from2_mm_tawitawi.dta", replace
	import delimited "$parent$fm3/BARMM/Tawi Tawi/$data Tawi Tawi $hh", clear
	save "$parent/data/from3_hh_tawitawi.dta", replace
	import delimited "$parent$fm3/BARMM/Tawi Tawi/$data Tawi Tawi $mm", clear
	save "$parent/data/from3_mm_tawitawi.dta", replace

**#  CAR

	import delimited "$parent$fm2/CAR/Abra/$data Abra $hh", clear
	save "$parent/data/from2_hh_Abra.dta", replace
	import delimited "$parent$fm2/CAR/Abra/$data Abra $mm", clear
	save "$parent/data/from2_mm_Abra.dta", replace
	import delimited "$parent$fm3/CAR/Abra/$data Abra $hh", clear
	save "$parent/data/from3_hh_Abra.dta", replace
	import delimited "$parent$fm3/CAR/Abra/$data Abra $mm", clear
	save "$parent/data/from3_mm_Abra.dta", replace

		import delimited "$parent$fm2/CAR/Apayao/$data Apayao $hh", clear
	save "$parent/data/from2_hh_Apayao.dta", replace
	import delimited "$parent$fm2/CAR/Apayao/$data Apayao $mm", clear
	save "$parent/data/from2_mm_Apayao.dta", replace
	import delimited "$parent$fm3/CAR/Apayao/$data Apayao $hh", clear
	save "$parent/data/from3_hh_Apayao.dta", replace
	import delimited "$parent$fm3/CAR/Apayao/$data Apayao $mm", clear
	save "$parent/data/from3_mm_Apayao.dta", replace

		import delimited "$parent$fm2/CAR/Baguio City/$data Baguio City $hh", clear
	save "$parent/data/from2_hh_BaguioCity.dta", replace
	import delimited "$parent$fm2/CAR/Baguio City/$data Baguio City $mm", clear
	save "$parent/data/from2_mm_BaguioCity.dta", replace
	import delimited "$parent$fm3/CAR/Baguio City/CPH_PUF_2020_Baguio $hh", clear
	save "$parent/data/from3_hh_BaguioCity.dta", replace
	import delimited "$parent$fm3/CAR/Baguio City/$data Baguio $mm", clear
	save "$parent/data/from3_mm_BaguioCity.dta", replace

		import delimited "$parent$fm2/CAR/Benguet/$data Benguet $hh", clear
	save "$parent/data/from2_hh_Benguet.dta", replace
	import delimited "$parent$fm2/CAR/Benguet/$data Benguet $mm", clear
	save "$parent/data/from2_mm_Benguet.dta", replace
	import delimited "$parent$fm3/CAR/Benguet/$data Benguet $hh", clear
	save "$parent/data/from3_hh_Benguet.dta", replace
	import delimited "$parent$fm3/CAR/Benguet/$data Benguet $mm", clear
	save "$parent/data/from3_mm_Benguet.dta", replace

		import delimited "$parent$fm2/CAR/Ifugao/$data Ifugao $hh", clear
	save "$parent/data/from2_hh_Ifugao.dta", replace
	import delimited "$parent$fm2/CAR/Ifugao/$data Ifugao $mm", clear
	save "$parent/data/from2_mm_Ifugao.dta", replace
	import delimited "$parent$fm3/CAR/Ifugao/$data Ifugao $hh", clear
	save "$parent/data/from3_hh_Ifugao.dta", replace
	import delimited "$parent$fm3/CAR/Ifugao/$data Ifugao $mm", clear
	save "$parent/data/from3_mm_Ifugao.dta", replace

	import delimited "$parent$fm2/CAR/Kalinga/$data Kalinga $hh", clear
	save "$parent/data/from2_hh_Kalinga.dta", replace
	import delimited "$parent$fm2/CAR/Kalinga/$data Kalinga $mm", clear
	save "$parent/data/from2_mm_Kalinga.dta", replace
	import delimited "$parent$fm3/CAR/Kalinga/$data Kalinga $hh", clear
	save "$parent/data/from3_hh_Kalinga.dta", replace
	import delimited "$parent$fm3/CAR/Kalinga/$data Kalinga $mm", clear
	save "$parent/data/from3_mm_Kalinga.dta", replace

		import delimited "$parent$fm2/CAR/Mountain Province/$data Mountain Province $hh", clear
	save "$parent/data/from2_hh_mountain.dta", replace
	import delimited "$parent$fm2/CAR/Mountain Province/$data Mountain Province $mm", clear
	save "$parent/data/from2_mm_mountain.dta", replace
	import delimited "$parent$fm3/CAR/Mountain Province/$data Mountain Province $hh", clear
	save "$parent/data/from3_hh_mountain.dta", replace
	import delimited "$parent$fm3/CAR/Mountain Province/$data Mountain Province $mm", clear
	save "$parent/data/from3_mm_.dta", replace

**#  CARAGA
	gl rgn CARAGA
	
	import delimited "$parent$fm2/$rgn/Agusan Del Norte/$data Agusan Del Norte $hh", clear
	save "$parent/data/from2_hh_AgusanDelNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Agusan Del Norte/$data Agusan Del Norte $mm", clear
	save "$parent/data/from2_mm_AgusanDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Agusan Del Norte/$data Agusan Del Norte $hh", clear
	save "$parent/data/from3_hh_AgusanDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Agusan Del Norte/$data Agusan Del Norte $mm", clear
	save "$parent/data/from3_mm_AgusanDelNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Agusan Del Sur/$data Agusan Del Sur $hh", clear
	save "$parent/data/from2_hh_AgusanDelSur.dta", replace
	import delimited "$parent$fm2/$rgn/Agusan Del Sur/$data Agusan Del Sur $mm", clear
	save "$parent/data/from2_mm_AgusanDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Agusan Del Sur/$data Agusan Del Sur $hh", clear
	save "$parent/data/from3_hh_AgusanDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Agusan Del Sur/$data Agusan Del Sur $mm", clear
	save "$parent/data/from3_mm_AgusanDelSur.dta", replace

	import delimited "$parent$fm2/$rgn/Butuan City/$data Butuan City $hh", clear
	save "$parent/data/from2_hh_ButuanCity.dta", replace
	import delimited "$parent$fm2/$rgn/Butuan City/$data Butuan City $mm", clear
	save "$parent/data/from2_mm_ButuanCity.dta", replace
	import delimited "$parent$fm3/$rgn/Butuan City/$data Butuan City $hh", clear
	save "$parent/data/from3_hh_ButuanCity.dta", replace
	import delimited "$parent$fm3/$rgn/Butuan City/$data Butuan City $mm", clear
	save "$parent/data/from3_mm_ButuanCity.dta", replace

	import delimited "$parent$fm2/$rgn/Dinagat Islands/$data Dinagat Islands $hh", clear
	save "$parent/data/from2_hh_DinagatIslands.dta", replace
	import delimited "$parent$fm2/$rgn/Dinagat Islands/$data Dinagat Islands $mm", clear
	save "$parent/data/from2_mm_DinagatIslands.dta", replace
	import delimited "$parent$fm3/$rgn/Dinagat Islands/$data Dinagat Islands $hh", clear
	save "$parent/data/from3_hh_DinagatIslands.dta", replace
	import delimited "$parent$fm3/$rgn/Dinagat Islands/$data Dinagat Islands $mm", clear
	save "$parent/data/from3_mm_DinagatIslands.dta", replace

	import delimited "$parent$fm2/$rgn/Surigao Del Norte/$data Surigao Del Norte $hh", clear
	save "$parent/data/from2_hh_SurigaoDelNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Surigao Del Norte/$data Surigao Del Norte $mm", clear
	save "$parent/data/from2_mm_SurigaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Surigao Del Norte/$data Surigao Del Norte $hh", clear
	save "$parent/data/from3_hh_SurigaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Surigao Del Norte/$data Surigao Del Norte $mm", clear
	save "$parent/data/from3_mm_SurigaoDelNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Surigao Del Sur/$data Surigao Del Sur $hh", clear
	save "$parent/data/from2_hh_SurigaoDelSur.dta", replace
	import delimited "$parent$fm2/$rgn/Surigao Del Sur/$data Surigao Del Sur $mm", clear
	save "$parent/data/from2_mm_SurigaoDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Surigao Del Sur/$data Surigao Del Sur $hh", clear
	save "$parent/data/from3_hh_SurigaoDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Surigao Del Sur/$data Surigao Del Sur $mm", clear
	save "$parent/data/from3_mm_SurigaoDelSur.dta", replace

	**#  NCR
	gl rgn NCR
	
	import delimited "$parent$fm2/$rgn/Caloocan/$data Caloocan $hh", clear
	save "$parent/data/from2_hh_Caloocan.dta", replace
	import delimited "$parent$fm2/$rgn/Caloocan/$data Caloocan $mm", clear
	save "$parent/data/from2_mm_Caloocan.dta", replace
	import delimited "$parent$fm3/$rgn/Caloocan/$data Caloocan $hh", clear
	save "$parent/data/from3_hh_Caloocan.dta", replace
	import delimited "$parent$fm3/$rgn/Caloocan/$data Caloocan $mm", clear
	save "$parent/data/from3_mm_Caloocan.dta", replace

	import delimited "$parent$fm2/$rgn/Las Pi､as/$data Las Pi､as $hh", clear
	save "$parent/data/from2_hh_LasPinas.dta", replace
	import delimited "$parent$fm2/$rgn/Las Pi､as/$data Las Pi､as $mm", clear
	save "$parent/data/from2_mm_LasPinas.dta", replace
	import delimited "$parent$fm3/$rgn/Las Pi､as/$data Las Pi､as $hh", clear
	save "$parent/data/from3_hh_LasPinas.dta", replace
	import delimited "$parent$fm3/$rgn/Las Pi､as/$data Las Pi､as $mm", clear
	save "$parent/data/from3_mm_LasPinas.dta", replace

	import delimited "$parent$fm2/$rgn/Makati/$data Makati $hh", clear
	save "$parent/data/from2_hh_Makati.dta", replace
	import delimited "$parent$fm2/$rgn/Makati/$data Makati $mm", clear
	save "$parent/data/from2_mm_Makati.dta", replace
	import delimited "$parent$fm3/$rgn/Makati/$data Makati $hh", clear
	save "$parent/data/from3_hh_Makati.dta", replace
	import delimited "$parent$fm3/$rgn/Makati/$data Makati $mm", clear
	save "$parent/data/from3_mm_Makati.dta", replace

	import delimited "$parent$fm2/$rgn/Malabon/$data Malabon $hh", clear
	save "$parent/data/from2_hh_Malabon.dta", replace
	import delimited "$parent$fm2/$rgn/Malabon/$data Malabon $mm", clear
	save "$parent/data/from2_mm_Malabon.dta", replace
	import delimited "$parent$fm3/$rgn/Malabon/$data Malabon $hh", clear
	save "$parent/data/from3_hh_Malabon.dta", replace
	import delimited "$parent$fm3/$rgn/Malabon/$data Malabon $mm", clear
	save "$parent/data/from3_mm_.dta", replace

	import delimited "$parent$fm2/$rgn/Mandaluyong/$data Mandaluyong $hh", clear
	save "$parent/data/from2_hh_Mandaluyong.dta", replace
	import delimited "$parent$fm2/$rgn/Mandaluyong/$data Mandaluyong $mm", clear
	save "$parent/data/from2_mm_Mandaluyong.dta", replace
	import delimited "$parent$fm3/$rgn/Mandaluyong/$data Mandaluyong $hh", clear
	save "$parent/data/from3_hh_Mandaluyong.dta", replace
	import delimited "$parent$fm3/$rgn/Mandaluyong/$data Mandaluyong $mm", clear
	save "$parent/data/from3_mm_Mandaluyong.dta", replace

	import delimited "$parent$fm2/$rgn/Manila/$data Manila $hh", clear
	save "$parent/data/from2_hh_Manila.dta", replace
	import delimited "$parent$fm2/$rgn/Manila/$data Manila $mm", clear
	save "$parent/data/from2_mm_Manila.dta", replace
	import delimited "$parent$fm3/$rgn/Manila/$data Manila $hh", clear
	save "$parent/data/from3_hh_Manila.dta", replace
	import delimited "$parent$fm3/$rgn/Manila/$data Manila $mm", clear
	save "$parent/data/from3_mm_Manila.dta", replace

	import delimited "$parent$fm2/$rgn/Marikina/$data Marikina $hh", clear
	save "$parent/data/from2_hh_Marikina.dta", replace
	import delimited "$parent$fm2/$rgn/Marikina/$data Marikina $mm", clear
	save "$parent/data/from2_mm_Marikina.dta", replace
	import delimited "$parent$fm3/$rgn/Marikina/$data Marikina $hh", clear
	save "$parent/data/from3_hh_Marikina.dta", replace
	import delimited "$parent$fm3/$rgn/Marikina/$data Marikina $mm", clear
	save "$parent/data/from3_mm_Marikina.dta", replace

	import delimited "$parent$fm2/$rgn/Muntinlupa/$data Muntinlupa $hh", clear
	save "$parent/data/from2_hh_Muntinlupa.dta", replace
	import delimited "$parent$fm2/$rgn/Muntinlupa/$data Muntinlupa $mm", clear
	save "$parent/data/from2_mm_Muntinlupa.dta", replace
	import delimited "$parent$fm3/$rgn/Muntinlupa/$data Muntinlupa $hh", clear
	save "$parent/data/from3_hh_Muntinlupa.dta", replace
	import delimited "$parent$fm3/$rgn/Muntinlupa/$data Muntinlupa $mm", clear
	save "$parent/data/from3_mm_Muntinlupa.dta", replace

	import delimited "$parent$fm2/$rgn/Navotas/$data Navotas $hh", clear
	save "$parent/data/from2_hh_Navotas.dta", replace
	import delimited "$parent$fm2/$rgn/Navotas/$data Navotas $mm", clear
	save "$parent/data/from2_mm_Navotas.dta", replace
	import delimited "$parent$fm3/$rgn/Navotas/$data Navotas $hh", clear
	save "$parent/data/from3_hh_Navotas.dta", replace
	import delimited "$parent$fm3/$rgn/Navotas/$data Navotas $mm", clear
	save "$parent/data/from3_mm_Navotas.dta", replace

	import delimited "$parent$fm2/$rgn/Para､aque/$data Para､aque $hh", clear
	save "$parent/data/from2_hh_Paranaque.dta", replace
	import delimited "$parent$fm2/$rgn/Para､aque/$data Para､aque $mm", clear
	save "$parent/data/from2_mm_Paranaque.dta", replace
	import delimited "$parent$fm3/$rgn/Para､aque/$data Para､aque $hh", clear
	save "$parent/data/from3_hh_Paranaque.dta", replace
	import delimited "$parent$fm3/$rgn/Para､aque/$data Para､aque $mm", clear
	save "$parent/data/from3_mm_Paranaque.dta", replace

	import delimited "$parent$fm2/$rgn/Pasay/$data Pasay $hh", clear
	save "$parent/data/from2_hh_Pasay.dta", replace
	import delimited "$parent$fm2/$rgn/Pasay/$data Pasay $mm", clear
	save "$parent/data/from2_mm_Pasay.dta", replace
	import delimited "$parent$fm3/$rgn/Pasay/$data Pasay $hh", clear
	save "$parent/data/from3_hh_Pasay.dta", replace
	import delimited "$parent$fm3/$rgn/Pasay/$data Pasay $mm", clear
	save "$parent/data/from3_mm_Pasay.dta", replace

	import delimited "$parent$fm2/$rgn/Pasig/$data Pasig $hh", clear
	save "$parent/data/from2_hh_Pasig.dta", replace
	import delimited "$parent$fm2/$rgn/Pasig/$data Pasig $mm", clear
	save "$parent/data/from2_mm_Pasig.dta", replace
	import delimited "$parent$fm3/$rgn/Pasig/$data Pasig $hh", clear
	save "$parent/data/from3_hh_Pasig.dta", replace
	import delimited "$parent$fm3/$rgn/Pasig/$data Pasig $mm", clear
	save "$parent/data/from3_mm_Pasig.dta", replace

	import delimited "$parent$fm2/$rgn/Pateros/$data Pateros $hh", clear
	save "$parent/data/from2_hh_Pateros.dta", replace
	import delimited "$parent$fm2/$rgn/Pateros/$data Pateros $mm", clear
	save "$parent/data/from2_mm_Pateros.dta", replace
	import delimited "$parent$fm3/$rgn/Pateros/$data Pateros $hh", clear
	save "$parent/data/from3_hh_Pateros.dta", replace
	import delimited "$parent$fm3/$rgn/Pateros/$data Pateros $mm", clear
	save "$parent/data/from3_mm_Pateros.dta", replace

	import delimited "$parent$fm2/$rgn/Quezon City/$data Quezon City $hh", clear
	save "$parent/data/from2_hh_QuezonCity.dta", replace
	import delimited "$parent$fm2/$rgn/Quezon City/$data Quezon City $mm", clear
	save "$parent/data/from2_mm_QuezonCity.dta", replace
	import delimited "$parent$fm3/$rgn/Quezon City/$data Quezon City $hh", clear
	save "$parent/data/from3_hh_QuezonCity.dta", replace
	import delimited "$parent$fm3/$rgn/Quezon City/$data Quezon City $mm", clear
	save "$parent/data/from3_mm_QuezonCity.dta", replace

	import delimited "$parent$fm2/$rgn/San Juan/$data San Juan $hh", clear
	save "$parent/data/from2_hh_SanJuan.dta", replace
	import delimited "$parent$fm2/$rgn/San Juan/$data San Juan $mm", clear
	save "$parent/data/from2_mm_SanJuan.dta", replace
	import delimited "$parent$fm3/$rgn/San Juan/$data San Juan $hh", clear
	save "$parent/data/from3_hh_SanJuan.dta", replace
	import delimited "$parent$fm3/$rgn/San Juan/$data San Juan $mm", clear
	save "$parent/data/from3_mm_SanJuan.dta", replace

	import delimited "$parent$fm2/$rgn/Taguig/$data Taguig $hh", clear
	save "$parent/data/from2_hh_Taguig.dta", replace
	import delimited "$parent$fm2/$rgn/Taguig/$data Taguig $mm", clear
	save "$parent/data/from2_mm_Taguig.dta", replace
	import delimited "$parent$fm3/$rgn/Taguig/$data Taguig $hh", clear
	save "$parent/data/from3_hh_Taguig.dta", replace
	import delimited "$parent$fm3/$rgn/Taguig/$data Taguig $mm", clear
	save "$parent/data/from3_mm_Taguig.dta", replace

	import delimited "$parent$fm2/$rgn/Valenzuela/$data Valenzuela $hh", clear
	save "$parent/data/from2_hh_Valenzuela.dta", replace
	import delimited "$parent$fm2/$rgn/Valenzuela/$data Valenzuela $mm", clear
	save "$parent/data/from2_mm_Valenzuela.dta", replace
	import delimited "$parent$fm3/$rgn/Valenzuela/$data Valenzuela $hh", clear
	save "$parent/data/from3_hh_Valenzuela.dta", replace
	import delimited "$parent$fm3/$rgn/Valenzuela/$data Valenzuela $mm", clear
	save "$parent/data/from3_mm_Valenzuela.dta", replace

	**#  Region I
	gl rgn Region I - Ilocos Region

	import delimited "$parent$fm2/$rgn/Ilocos Norte/$data Ilocos Norte $hh", clear
	save "$parent/data/from2_hh_IlocosNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Ilocos Norte/$data Ilocos Norte $mm", clear
	save "$parent/data/from2_mm_locosNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Ilocos Norte/$data Ilocos Norte $hh", clear
	save "$parent/data/from3_hh_locosNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Ilocos Norte/$data Ilocos Norte $mm", clear
	save "$parent/data/from3_mm_locosNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Ilocos Sur/$data Ilocos Sur $hh", clear
	save "$parent/data/from2_hh_IlocosSur.dta", replace
	import delimited "$parent$fm2/$rgn/Ilocos Sur/$data Ilocos Sur $mm", clear
	save "$parent/data/from2_mm_IlocosSur.dta", replace
	import delimited "$parent$fm3/$rgn/Ilocos Sur/$data Ilocos Sur $hh", clear
	save "$parent/data/from3_hh_IlocosSur.dta", replace
	import delimited "$parent$fm3/$rgn/Ilocos Sur/$data Ilocos Sur $mm", clear
	save "$parent/data/from3_mm_IlocosSur.dta", replace

	import delimited "$parent$fm2/$rgn/La Union/$data La Union $hh", clear
	save "$parent/data/from2_hh_LaUnion.dta", replace
	import delimited "$parent$fm2/$rgn/La Union/$data La Union $mm", clear
	save "$parent/data/from2_mm_LaUnion.dta", replace
	import delimited "$parent$fm3/$rgn/La Union/$data La Union $hh", clear
	save "$parent/data/from3_hh_LaUnion.dta", replace
	import delimited "$parent$fm3/$rgn/La Union/$data La Union $mm", clear
	save "$parent/data/from3_mm_LaUnion.dta", replace

	import delimited "$parent$fm2/$rgn/Pangasinan/$data Pangasinan $hh", clear
	save "$parent/data/from2_hh_Pangasinan.dta", replace
	import delimited "$parent$fm2/$rgn/Pangasinan/CPH PUF 2020 Pangasinan MEMBERS.csv", clear
	save "$parent/data/from2_mm_Pangasinan.dta", replace
	import delimited "$parent$fm3/$rgn/Pangasinan/$data Pangasinan $hh", clear
	save "$parent/data/from3_hh_Pangasinan.dta", replace
	import delimited "$parent$fm3/$rgn/Pangasinan/$data Pangasinan $mm", clear
	save "$parent/data/from3_mm_Pangasinan.dta", replace
	
	**#  Region II
	gl rgn Region II - Cagayan Valley

	import delimited "$parent$fm2/$rgn/Batanes/$data Batanes $hh", clear
	save "$parent/data/from2_hh_Batanes.dta", replace
	import delimited "$parent$fm2/$rgn/Batanes/$data Batanes $mm", clear
	save "$parent/data/from2_mm_Batanes.dta", replace
	import delimited "$parent$fm3/$rgn/Batanes/$data Batanes $hh", clear
	save "$parent/data/from3_hh_Batanes.dta", replace
	import delimited "$parent$fm3/$rgn/Batanes/$data Batanes $mm", clear
	save "$parent/data/from3_mm_Batanes.dta", replace

	import delimited "$parent$fm2/$rgn/Cagayan/$data Cagayan $hh", clear
	save "$parent/data/from2_hh_Cagayan.dta", replace
	import delimited "$parent$fm2/$rgn/Cagayan/$data Cagayan $mm", clear
	save "$parent/data/from2_mm_Cagayan.dta", replace
	import delimited "$parent$fm3/$rgn/Cagayan/$data Cagayan $hh", clear
	save "$parent/data/from3_hh_Cagayan.dta", replace
	import delimited "$parent$fm3/$rgn/Cagayan/$data Cagayan $mm", clear
	save "$parent/data/from3_mm_Cagayan.dta", replace

	import delimited "$parent$fm2/$rgn/Isabela/$data Isabela $hh", clear
	save "$parent/data/from2_hh_Isabela.dta", replace
	import delimited "$parent$fm2/$rgn/Isabela/$data Isabela $mm", clear
	save "$parent/data/from2_mm_Isabela.dta", replace
	import delimited "$parent$fm3/$rgn/Isabela/$data Isabela $hh", clear
	save "$parent/data/from3_hh_Isabela.dta", replace
	import delimited "$parent$fm3/$rgn/Isabela/$data Isabela $mm", clear
	save "$parent/data/from3_mm_Isabela.dta", replace

	import delimited "$parent$fm2/$rgn/Nueva Vizcaya/$data Nueva Vizcaya $hh", clear
	save "$parent/data/from2_hh_NuevaVizcaya.dta", replace
	import delimited "$parent$fm2/$rgn/Nueva Vizcaya/$data Nueva Vizcaya $mm", clear
	save "$parent/data/from2_mm_NuevaVizcaya.dta", replace
	import delimited "$parent$fm3/$rgn/Nueva Vizcaya/$data Nueva Vizcaya $hh", clear
	save "$parent/data/from3_hh_NuevaVizcaya.dta", replace
	import delimited "$parent$fm3/$rgn/Nueva Vizcaya/$data Nueva Vizcaya $mm", clear
	save "$parent/data/from3_mm_NuevaVizcaya.dta", replace

	import delimited "$parent$fm2/$rgn/Quirino/$data Quirino $hh", clear
	save "$parent/data/from2_hh_Quirino.dta", replace
	import delimited "$parent$fm2/$rgn/Quirino/$data Quirino $mm", clear
	save "$parent/data/from2_mm_Quirino.dta", replace
	import delimited "$parent$fm3/$rgn/Quirino/$data Quirino $hh", clear
	save "$parent/data/from3_hh_Quirino.dta", replace
	import delimited "$parent$fm3/$rgn/Quirino/$data Quirino $mm", clear
	save "$parent/data/from3_mm_Quirino.dta", replace
	
	**#  Region III
	gl rgn Region III - Central Luzon

	import delimited "$parent$fm2/$rgn/Angeles City/$data Angeles City $hh", clear
	save "$parent/data/from2_hh_AngelesCity.dta", replace
	import delimited "$parent$fm2/$rgn/Angeles City/$data Angeles City $mm", clear
	save "$parent/data/from2_mm_AngelesCity.dta", replace
	import delimited "$parent$fm3/$rgn/Angeles City/$data Angeles City $hh", clear
	save "$parent/data/from3_hh_AngelesCity.dta", replace
	import delimited "$parent$fm3/$rgn/Angeles City/$data Angeles City $mm", clear
	save "$parent/data/from3_mm_AngelesCity.dta", replace

	import delimited "$parent$fm2/$rgn/Aurora/$data Aurora $hh", clear
	save "$parent/data/from2_hh_Aurora.dta", replace
	import delimited "$parent$fm2/$rgn/Aurora/$data Aurora $mm", clear
	save "$parent/data/from2_mm_Aurora.dta", replace
	import delimited "$parent$fm3/$rgn/Aurora/$data Aurora $hh", clear
	save "$parent/data/from3_hh_Aurora.dta", replace
	import delimited "$parent$fm3/$rgn/Aurora/$data Aurora $mm", clear
	save "$parent/data/from3_mm_Aurora.dta", replace

	import delimited "$parent$fm2/$rgn/Bataan/$data Bataan $hh", clear
	save "$parent/data/from2_hh_Bataan.dta", replace
	import delimited "$parent$fm2/$rgn/Bataan/$data Bataan $mm", clear
	save "$parent/data/from2_mm_Bataan.dta", replace
	import delimited "$parent$fm3/$rgn/Bataan/$data Bataan $hh", clear
	save "$parent/data/from3_hh_Bataan.dta", replace
	import delimited "$parent$fm3/$rgn/Bataan/$data Bataan $mm", clear
	save "$parent/data/from3_mm_Bataan.dta", replace

	import delimited "$parent$fm2/$rgn/Bulacan/$data Bulacan $hh", clear
	save "$parent/data/from2_hh_Bulacan.dta", replace
	import delimited "$parent$fm2/$rgn/Bulacan/$data Bulacan $mm", clear
	save "$parent/data/from2_mm_Bulacan.dta", replace
	import delimited "$parent$fm3/$rgn/Bulacan/$data Bulacan $hh", clear
	save "$parent/data/from3_hh_Bulacan.dta", replace
	import delimited "$parent$fm3/$rgn/Bulacan/$data Bulacan $mm", clear
	save "$parent/data/from3_mm_Bulacan.dta", replace

	import delimited "$parent$fm2/$rgn/Nueva Ecija/$data Nueva Ecija $hh", clear
	save "$parent/data/from2_hh_NuevaEcija.dta", replace
	import delimited "$parent$fm2/$rgn/Nueva Ecija/$data Nueva Ecija $mm", clear
	save "$parent/data/from2_mm_NuevaEcija.dta", replace
	import delimited "$parent$fm3/$rgn/Nueva Ecija/$data Nueva Ecija $hh", clear
	save "$parent/data/from3_hh_NuevaEcija.dta", replace
	import delimited "$parent$fm3/$rgn/Nueva Ecija/$data Nueva Ecija $mm", clear
	save "$parent/data/from3_mm_NuevaEcija.dta", replace

	import delimited "$parent$fm2/$rgn/Olongapo City/$data Ologapo City $hh", clear
	save "$parent/data/from2_hh_OlongapoCity.dta", replace
	import delimited "$parent$fm2/$rgn/Olongapo City/$data Ologapo City $mm", clear
	save "$parent/data/from2_mm_OlongapoCity.dta", replace
	import delimited "$parent$fm3/$rgn/Olongapo City/$data Olongapo City $hh", clear
	save "$parent/data/from3_hh_OlongapoCity.dta", replace
	import delimited "$parent$fm3/$rgn/Olongapo City/$data Olongapo City $mm", clear
	save "$parent/data/from3_mm_OlongapoCity.dta", replace

	import delimited "$parent$fm2/$rgn/Pampanga/$data Pampanga $hh", clear
	save "$parent/data/from2_hh_Pampanga.dta", replace
	import delimited "$parent$fm2/$rgn/Pampanga/$data Pampanga $mm", clear
	save "$parent/data/from2_mm_Pampanga.dta", replace
	import delimited "$parent$fm3/$rgn/Pampanga/$data Pampanga $hh", clear
	save "$parent/data/from3_hh_Pampanga.dta", replace
	import delimited "$parent$fm3/$rgn/Pampanga/$data Pampanga $mm", clear
	save "$parent/data/from3_mm_Pampanga.dta", replace

	import delimited "$parent$fm2/$rgn/Tarlac/$data Tarlac $hh", clear
	save "$parent/data/from2_hh_Tarlac.dta", replace
	import delimited "$parent$fm2/$rgn/Tarlac/$data Tarlac $mm", clear
	save "$parent/data/from2_mm_Tarlac.dta", replace
	import delimited "$parent$fm3/$rgn/Tarlac/$data Tarlac $hh", clear
	save "$parent/data/from3_hh_Tarlac.dta", replace
	import delimited "$parent$fm3/$rgn/Tarlac/$data Tarlac $mm", clear
	save "$parent/data/from3_mm_Tarlac.dta", replace

	import delimited "$parent$fm2/$rgn/Zambales/CPH PUF 2020 Zambales -  HOUSEHOLD.CSV", clear
	save "$parent/data/from2_hh_Zambales.dta", replace
	import delimited "$parent$fm2/$rgn/Zambales/$data Zambales $mm", clear
	save "$parent/data/from2_mm_Zambales.dta", replace
	import delimited "$parent$fm3/$rgn/Zambales/$data Zambales $hh", clear
	save "$parent/data/from3_hh_Zambales.dta", replace
	import delimited "$parent$fm3/$rgn/Zambales/$data Zambales $mm", clear
	save "$parent/data/from3_mm_Zambales.dta", replace
	
	**#  Region IVA
	gl rgn Region IV-A - CALABARZON

	import delimited "$parent$fm2/$rgn/Batangas/$data Batangas $hh", clear
	save "$parent/data/from2_hh_Batangas.dta", replace
	import delimited "$parent$fm2/$rgn/Batangas/$data Batangas $mm", clear
	save "$parent/data/from2_mm_Batangas.dta", replace
	import delimited "$parent$fm3/$rgn/Batangas/$data Batangas $hh", clear
	save "$parent/data/from3_hh_Batangas.dta", replace
	import delimited "$parent$fm3/$rgn/Batangas/$data Batangas $mm", clear
	save "$parent/data/from3_mm_Batangas.dta", replace

	import delimited "$parent$fm2/$rgn/Cavite/$data Cavite $hh", clear
	save "$parent/data/from2_hh_Cavite.dta", replace
	import delimited "$parent$fm2/$rgn/Cavite/$data Cavite $mm", clear
	save "$parent/data/from2_mm_Cavite.dta", replace
	import delimited "$parent$fm3/$rgn/Cavite/$data Cavite $hh", clear
	save "$parent/data/from3_hh_Cavite.dta", replace
	import delimited "$parent$fm3/$rgn/Cavite/$data Cavite $mm", clear
	save "$parent/data/from3_mm_Cavite.dta", replace

	import delimited "$parent$fm2/$rgn/Laguna/$data Laguna $hh", clear
	save "$parent/data/from2_hh_Laguna.dta", replace
	import delimited "$parent$fm2/$rgn/Laguna/$data Laguna $mm", clear
	save "$parent/data/from2_mm_Laguna.dta", replace
	import delimited "$parent$fm3/$rgn/Laguna/$data Laguna $hh", clear
	save "$parent/data/from3_hh_Laguna.dta", replace
	import delimited "$parent$fm3/$rgn/Laguna/$data Laguna $mm", clear
	save "$parent/data/from3_mm_Laguna.dta", replace

	import delimited "$parent$fm2/$rgn/Lucena City/$data Lucena City $hh", clear
	save "$parent/data/from2_hh_LucenaCity.dta", replace
	import delimited "$parent$fm2/$rgn/Lucena City/$data Lucena City $mm", clear
	save "$parent/data/from2_mm_LucenaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Lucena City/$data Lucena City $hh", clear
	save "$parent/data/from3_hh_LucenaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Lucena City/$data Lucena City $mm", clear
	save "$parent/data/from3_mm_LucenaCity.dta", replace

	import delimited "$parent$fm2/$rgn/Quezon/$data Quezon $hh", clear
	save "$parent/data/from2_hh_Quezon.dta", replace
	import delimited "$parent$fm2/$rgn/Quezon/$data Quezon $mm", clear
	save "$parent/data/from2_mm_Quezon.dta", replace
	import delimited "$parent$fm3/$rgn/Quezon/$data Quezon $hh", clear
	save "$parent/data/from3_hh_Quezon.dta", replace
	import delimited "$parent$fm3/$rgn/Quezon/$data Quezon $mm", clear
	save "$parent/data/from3_mm_Quezon.dta", replace

	import delimited "$parent$fm2/$rgn/Rizal/$data Rizal $hh", clear
	save "$parent/data/from2_hh_Rizal.dta", replace
	import delimited "$parent$fm2/$rgn/Rizal/$data Rizal $mm", clear
	save "$parent/data/from2_mm_Rizal.dta", replace
	import delimited "$parent$fm3/$rgn/Rizal/$data Rizal $hh", clear
	save "$parent/data/from3_hh_Rizal.dta", replace
	import delimited "$parent$fm3/$rgn/Rizal/$data Rizal $mm", clear
	save "$parent/data/from3_mm_Rizal.dta", replace
	
	**#  Region IVB
	gl rgn Region IV-B - MIMAROPA

	import delimited "$parent$fm2/$rgn/Marinduque/$data Marinduque $hh", clear
	save "$parent/data/from2_hh_Marinduque.dta", replace
	import delimited "$parent$fm2/$rgn/Marinduque/$data Marinduque $mm", clear
	save "$parent/data/from2_mm_Marinduque.dta", replace
	import delimited "$parent$fm3/$rgn/Marinduque/$data Marinduque $hh", clear
	save "$parent/data/from3_hh_Marinduque.dta", replace
	import delimited "$parent$fm3/$rgn/Marinduque/$data Marinduque $mm", clear
	save "$parent/data/from3_mm_Marinduque.dta", replace

	import delimited "$parent$fm2/$rgn/Occidental Mindoro/$data Occidental Mindoro $hh", clear
	save "$parent/data/from2_hh_OccidentalMindoro.dta", replace
	import delimited "$parent$fm2/$rgn/Occidental Mindoro/$data Occidental Mindoro $mm", clear
	save "$parent/data/from2_mm_OccidentalMindoro.dta", replace
	import delimited "$parent$fm3/$rgn/Occidental Mindoro/$data Occidental Mindoro $hh", clear
	save "$parent/data/from3_hh_OccidentalMindoro.dta", replace
	import delimited "$parent$fm3/$rgn/Occidental Mindoro/$data Occidental Mindoro $mm", clear
	save "$parent/data/from3_mm_OccidentalMindoro.dta", replace

	import delimited "$parent$fm2/$rgn/Oriental Mindoro/$data Oriental Mindoro $hh", clear
	save "$parent/data/from2_hh_OrientalMindoro.dta", replace
	import delimited "$parent$fm2/$rgn/Oriental Mindoro/$data Oriental Mindoro $mm", clear
	save "$parent/data/from2_mm_OrientalMindoro.dta", replace
	import delimited "$parent$fm3/$rgn/Oriental Mindoro/$data Oriental Mindoro $hh", clear
	save "$parent/data/from3_hh_OrientalMindoro.dta", replace
	import delimited "$parent$fm3/$rgn/Oriental Mindoro/$data Oriental Mindoro $mm", clear
	save "$parent/data/from3_mm_OrientalMindoro.dta", replace

	import delimited "$parent$fm2/$rgn/Palawan/$data Palawan $hh", clear
	save "$parent/data/from2_hh_Palawan.dta", replace
	import delimited "$parent$fm2/$rgn/Palawan/$data Palawan $mm", clear
	save "$parent/data/from2_mm_Palawan.dta", replace
	import delimited "$parent$fm3/$rgn/Palawan/$data Palawan $hh", clear
	save "$parent/data/from3_hh_Palawan.dta", replace
	import delimited "$parent$fm3/$rgn/Palawan/$data Palawan $mm", clear
	save "$parent/data/from3_mm_Palawan.dta", replace

	import delimited "$parent$fm2/$rgn/Puerto Princesa City/$data Puerto Princesa $hh", clear
	save "$parent/data/from2_hh_PuertoPrincesa.dta", replace
	import delimited "$parent$fm2/$rgn/Puerto Princesa City/$data Puerto Princesa $mm", clear
	save "$parent/data/from2_mm_PuertoPrincesa.dta", replace
	import delimited "$parent$fm3/$rgn/Puerto Princesa/$data Puerto Princesa $hh", clear
	save "$parent/data/from3_hh_PuertoPrincesa.dta", replace
	import delimited "$parent$fm3/$rgn/Puerto Princesa/$data Puerto Princesa $mm", clear
	save "$parent/data/from3_mm_PuertoPrincesa.dta", replace

	import delimited "$parent$fm2/$rgn/Romblon/$data Romblon $hh", clear
	save "$parent/data/from2_hh_Romblon.dta", replace
	import delimited "$parent$fm2/$rgn/Romblon/$data Romblon $mm", clear
	save "$parent/data/from2_mm_Romblon.dta", replace
	import delimited "$parent$fm3/$rgn/Romblon/$data Romblon $hh", clear
	save "$parent/data/from3_hh_Romblon.dta", replace
	import delimited "$parent$fm3/$rgn/Romblon/$data Romblon $mm", clear
	save "$parent/data/from3_mm_Romblon.dta", replace

	**#  Region IX
	gl rgn Region IX - Zamboanga Peninsula
	
	import delimited "$parent$fm2/$rgn/Isabela City/$data Isabela City $hh", clear
	save "$parent/data/from2_hh_IsabelaCity.dta", replace
	import delimited "$parent$fm2/$rgn/Isabela City/$data Isabela City $mm", clear
	save "$parent/data/from2_mm_IsabelaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Isabela City/$data Isabela City $hh", clear
	save "$parent/data/from3_hh_IsabelaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Isabela City/$data Isabela City $mm", clear
	save "$parent/data/from3_mm_IsabelaCity.dta", replace

	import delimited "$parent$fm2/$rgn/Zamboanga City/$data Zamboanga City $hh", clear
	save "$parent/data/from2_hh_ZamboangaCity.dta", replace
	import delimited "$parent$fm2/$rgn/Zamboanga City/$data Zamboanga City $mm", clear
	save "$parent/data/from2_mm_ZamboangaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga City/$data Zamboanga City $hh", clear
	save "$parent/data/from3_hh_ZamboangaCity.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga City/$data Zamboanga City $mm", clear
	save "$parent/data/from3_mm_ZamboangaCity.dta", replace

	import delimited "$parent$fm2/$rgn/Zamboanga Del Norte/$data Zamboanga Del Norte $hh", clear
	save "$parent/data/from2_hh_ZamboangaDelNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Zamboanga Del Norte/$data Zamboanga Del Norte $mm", clear
	save "$parent/data/from2_mm_ZamboangaDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Del Norte/$data Zamboanga Del Norte $hh", clear
	save "$parent/data/from3_hh_ZamboangaDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Del Norte/$data Zamboanga Del Norte $mm", clear
	save "$parent/data/from3_mm_ZamboangaDelNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Zamboanga Del Sur/$data Zamboanga Sur $hh", clear
	save "$parent/data/from2_hh_ZamboangaDelSur.dta", replace
	import delimited "$parent$fm2/$rgn/Zamboanga Del Sur/$data Zamboanga Sur $mm", clear
	save "$parent/data/from2_mm_ZamboangaDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Del Sur/$data Zamboanga Del Sur $hh", clear
	save "$parent/data/from3_hh_ZamboangaDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Del Sur/$data Zamboanga Del Sur $mm", clear
	save "$parent/data/from3_mm_ZamboangaDelSur.dta", replace

	import delimited "$parent$fm2/$rgn/Zamboanga Sibugay/$data Zamboanga Sibugay $hh", clear
	save "$parent/data/from2_hh_ZamboangaSibugay.dta", replace
	import delimited "$parent$fm2/$rgn/Zamboanga Sibugay/$data Zamboanga Sibugay $mm", clear
	save "$parent/data/from2_mm_ZamboangaSibugay.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Sibugay/$data Zamboanga Sibugay $hh", clear
	save "$parent/data/from3_hh_ZamboangaSibugay.dta", replace
	import delimited "$parent$fm3/$rgn/Zamboanga Sibugay/$data Zamboanga Sibugay $mm", clear
	save "$parent/data/from3_mm_ZamboangaSibugay.dta", replace

	**#  Region V
	gl rgn Region V - Bicol Region

	import delimited "$parent$fm2/$rgn/Albay/$data Albay $hh", clear
	save "$parent/data/from2_hh_Albay.dta", replace
	import delimited "$parent$fm2/$rgn/Albay/$data Albay $mm", clear
	save "$parent/data/from2_mm_Albay.dta", replace
	import delimited "$parent$fm3/$rgn/Albay/$data Albay $hh", clear
	save "$parent/data/from3_hh_Albay.dta", replace
	import delimited "$parent$fm3/$rgn/Albay/$data Albay $mm", clear
	save "$parent/data/from3_mm_Albay.dta", replace

	import delimited "$parent$fm2/$rgn/Camarines Norte/$data Camarines Norte $hh", clear
	save "$parent/data/from2_hh_CamarinesNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Camarines Norte/$data Camarines Norte $mm", clear
	save "$parent/data/from2_mm_CamarinesNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Camarines Norte/$data Camarines Norte $hh", clear
	save "$parent/data/from3_hh_CamarinesNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Camarines Norte/$data Camarines Norte $mm", clear
	save "$parent/data/from3_mm_CamarinesNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Camarines Sur/$data Camarines Sur $hh", clear
	save "$parent/data/from2_hh_CamarinesSur.dta", replace
	import delimited "$parent$fm2/$rgn/Camarines Sur/$data Camarines Sur $mm", clear
	save "$parent/data/from2_mm_CamarinesSur.dta", replace
	import delimited "$parent$fm3/$rgn/Camarines Sur/$data Camarines Sur $hh", clear
	save "$parent/data/from3_hh_CamarinesSur.dta", replace
	import delimited "$parent$fm3/$rgn/Camarines Sur/$data Camarines Sur $mm", clear
	save "$parent/data/from3_mm_CamarinesSur.dta", replace

	import delimited "$parent$fm2/$rgn/Catanduanes/$data Catanduanes $hh", clear
	save "$parent/data/from2_hh_Catanduanes.dta", replace
	import delimited "$parent$fm2/$rgn/Catanduanes/$data Catanduanes $mm", clear
	save "$parent/data/from2_mm_Catanduanes.dta", replace
	import delimited "$parent$fm3/$rgn/Catanduanes/$data Catanduanes $hh", clear
	save "$parent/data/from3_hh_Catanduanes.dta", replace
	import delimited "$parent$fm3/$rgn/Catanduanes/$data Catanduanes $mm", clear
	save "$parent/data/from3_mm_Catanduanes.dta", replace

	import delimited "$parent$fm2/$rgn/Masbate/$data Masbate $hh", clear
	save "$parent/data/from2_hh_Masbate.dta", replace
	import delimited "$parent$fm2/$rgn/Masbate/$data Masbate $mm", clear
	save "$parent/data/from2_mm_Masbate.dta", replace
	import delimited "$parent$fm3/$rgn/Masbate/$data Masbate $hh", clear
	save "$parent/data/from3_hh_Masbate.dta", replace
	import delimited "$parent$fm3/$rgn/Masbate/$data Masbate $mm", clear
	save "$parent/data/from3_mm_Masbate.dta", replace

	import delimited "$parent$fm2/$rgn/Sorsogon/$data Sorsogon $hh", clear
	save "$parent/data/from2_hh_Sorsogon.dta", replace
	import delimited "$parent$fm2/$rgn/Sorsogon/$data Sorsogon $mm", clear
	save "$parent/data/from2_mm_Sorsogondta", replace
	import delimited "$parent$fm3/$rgn/Sorsogon/$data Sorsogon $hh", clear
	save "$parent/data/from3_hh_Sorsogon.dta", replace
	import delimited "$parent$fm3/$rgn/Sorsogon/$data Sorsogon $mm", clear
	save "$parent/data/from3_mm_Sorsogon.dta", replace
	
	**#  Region VI
	gl rgn 	Region VI - Western Visayas

	import delimited "$parent$fm2/$rgn/Aklan/$data Aklan $hh", clear
	save "$parent/data/from2_hh_Aklan.dta", replace
	import delimited "$parent$fm2/$rgn/Aklan/$data Aklan $mm", clear
	save "$parent/data/from2_mm_Aklan.dta", replace
	import delimited "$parent$fm3/$rgn/Aklan/$data Aklan $hh", clear
	save "$parent/data/from3_hh_Aklan.dta", replace
	import delimited "$parent$fm3/$rgn/Aklan/$data Aklan $mm", clear
	save "$parent/data/from3_mm_Aklan.dta", replace

	import delimited "$parent$fm2/$rgn/Antique/$data Antique $hh", clear
	save "$parent/data/from2_hh_Antique.dta", replace
	import delimited "$parent$fm2/$rgn/Antique/$data Antique $mm", clear
	save "$parent/data/from2_mm_Antique.dta", replace
	import delimited "$parent$fm3/$rgn/Antique/$data Antique $hh", clear
	save "$parent/data/from3_hh_Antique.dta", replace
	import delimited "$parent$fm3/$rgn/Antique/$data Antique $mm", clear
	save "$parent/data/from3_mm_Antique.dta", replace

	import delimited "$parent$fm2/$rgn/Bacolod City/$data Bacolod City $hh", clear
	save "$parent/data/from2_hh_BacolodCity.dta", replace
	import delimited "$parent$fm2/$rgn/Bacolod City/$data Bacolod City $mm", clear
	save "$parent/data/from2_mm_BacolodCity.dta", replace
	import delimited "$parent$fm3/$rgn/Bacolod City/$data Bacolod City $hh", clear
	save "$parent/data/from3_hh_BacolodCity.dta", replace
	import delimited "$parent$fm3/$rgn/Bacolod City/$data Bacolod City $mm", clear
	save "$parent/data/from3_mm_BacolodCity.dta", replace

	import delimited "$parent$fm2/$rgn/Capiz/$data Capiz $hh", clear
	save "$parent/data/from2_hh_Capiz.dta", replace
	import delimited "$parent$fm2/$rgn/Capiz/$data Capiz $mm", clear
	save "$parent/data/from2_mm_Capiz.dta", replace
	import delimited "$parent$fm3/$rgn/Capiz/$data Capiz $hh", clear
	save "$parent/data/from3_hh_Capiz.dta", replace
	import delimited "$parent$fm3/$rgn/Capiz/$data Capiz $mm", clear
	save "$parent/data/from3_mm_Capiz.dta", replace

	import delimited "$parent$fm2/$rgn/Guimaras/$data Guimaras $hh", clear
	save "$parent/data/from2_hh_Guimaras.dta", replace
	import delimited "$parent$fm2/$rgn/Guimaras/$data Guimaras $mm", clear
	save "$parent/data/from2_mm_Guimaras.dta", replace
	import delimited "$parent$fm3/$rgn/Guimaras/$data Guimaras $hh", clear
	save "$parent/data/from3_hh_Guimaras.dta", replace
	import delimited "$parent$fm3/$rgn/Guimaras/$data Guimaras $mm", clear
	save "$parent/data/from3_mm_Guimaras.dta", replace

	import delimited "$parent$fm2/$rgn/Iloilo/$data Iloilo $hh", clear
	save "$parent/data/from2_hh_Iloilo.dta", replace
	import delimited "$parent$fm2/$rgn/Iloilo/$data Iloilo $mm", clear
	save "$parent/data/from2_mm_Iloilo.dta", replace
	import delimited "$parent$fm3/$rgn/Iloilo/$data Iloilo $hh", clear
	save "$parent/data/from3_hh_Iloilo.dta", replace
	import delimited "$parent$fm3/$rgn/Iloilo/$data Iloilo $mm", clear
	save "$parent/data/from3_mm_Iloilo.dta", replace

	import delimited "$parent$fm2/$rgn/Iloilo City/$data Iloilo City $hh", clear
	save "$parent/data/from2_hh_IloiloCity.dta", replace
	import delimited "$parent$fm2/$rgn/Iloilo City/$data Iloilo City $mm", clear
	save "$parent/data/from2_mm_IloiloCity.dta", replace
	import delimited "$parent$fm3/$rgn/Iloilo City/$data Iloilo City $hh", clear
	save "$parent/data/from3_hh_IloiloCity.dta", replace
	import delimited "$parent$fm3/$rgn/Iloilo City/$data Iloilo City $mm", clear
	save "$parent/data/from3_mm_IloiloCity.dta", replace

	import delimited "$parent$fm2/$rgn/Negros Occidental/$data Negros Occidental $hh", clear
	save "$parent/data/from2_hh_NegrosOccidental.dta", replace
	import delimited "$parent$fm2/$rgn/Negros Occidental/$data Negros Occidental $mm", clear
	save "$parent/data/from2_mm_NegrosOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Negros Occidental/$data Negros Occidental $hh", clear
	save "$parent/data/from3_hh_NegrosOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Negros Occidental/$data Negros Occidental $mm", clear
	save "$parent/data/from3_mm_NegrosOccidental.dta", replace

	**#  Region VII
	gl rgn 	Region VII - Central Visayas

	import delimited "$parent$fm2/$rgn/Bohol/$data Bohol $hh", clear
	save "$parent/data/from2_hh_Bohol.dta", replace
	import delimited "$parent$fm2/$rgn/Bohol/$data Bohol $mm", clear
	save "$parent/data/from2_mm_Bohol.dta", replace
	import delimited "$parent$fm3/$rgn/Bohol/$data Bohol $hh", clear
	save "$parent/data/from3_hh_Bohol.dta", replace
	import delimited "$parent$fm3/$rgn/Bohol/$data Bohol $mm", clear
	save "$parent/data/from3_mm_Bohol.dta", replace

	import delimited "$parent$fm2/$rgn/Cebu/$data Cebu $hh", clear
	save "$parent/data/from2_hh_Cebu.dta", replace
	import delimited "$parent$fm2/$rgn/Cebu/$data Cebu $mm", clear
	save "$parent/data/from2_mm_Cebu.dta", replace
	import delimited "$parent$fm3/$rgn/Cebu/$data Cebu $hh", clear
	save "$parent/data/from3_hh_Cebu.dta", replace
	import delimited "$parent$fm3/$rgn/Cebu/$data Cebu $mm", clear
	save "$parent/data/from3_mm_Cebu.dta", replace

	import delimited "$parent$fm2/$rgn/Cebu City/$data Cebu City $hh", clear
	save "$parent/data/from2_hh_CebuCity.dta", replace
	import delimited "$parent$fm2/$rgn/Cebu City/$data Cebu City $mm", clear
	save "$parent/data/from2_mm_CebuCity.dta", replace
	import delimited "$parent$fm3/$rgn/Cebu City/$data Cebu City $hh", clear
	save "$parent/data/from3_hh_CebuCity.dta", replace
	import delimited "$parent$fm3/$rgn/Cebu City/$data Cebu City $mm", clear
	save "$parent/data/from3_mm_CebuCity.dta", replace

	import delimited "$parent$fm2/$rgn/Lapu Lapu City/$data Lapu Lapu City $hh", clear
	save "$parent/data/from2_hh_LapuLapuCity.dta", replace
	import delimited "$parent$fm2/$rgn/Lapu Lapu City/$data Lapu Lapu City $mm", clear
	save "$parent/data/from2_mm_LapuLapuCity.dta", replace
	import delimited "$parent$fm3/$rgn/Lapu Lapu City/$data Lapu Lapu City $hh", clear
	save "$parent/data/from3_hh_LapuLapuCity.dta", replace
	import delimited "$parent$fm3/$rgn/Lapu Lapu City/$data Lapu Lapu City $mm", clear
	save "$parent/data/from3_mm_LapuLapuCity.dta", replace

	import delimited "$parent$fm2/$rgn/Mandaue City/$data Mandaue City $hh", clear
	save "$parent/data/from2_hh_MandaueCity.dta", replace
	import delimited "$parent$fm2/$rgn/Mandaue City/$data Mandaue City $mm", clear
	save "$parent/data/from2_mm_MandaueCity.dta", replace
	import delimited "$parent$fm3/$rgn/Mandaue City/$data Mandaue City $hh", clear
	save "$parent/data/from3_hh_MandaueCity.dta", replace
	import delimited "$parent$fm3/$rgn/Mandaue City/$data Mandaue City $mm", clear
	save "$parent/data/from3_mm_MandaueCity.dta", replace

	import delimited "$parent$fm2/$rgn/Negros Oriental/$data Negros Oriental $hh", clear
	save "$parent/data/from2_hh_NegrosOriental.dta", replace
	import delimited "$parent$fm2/$rgn/Negros Oriental/$data Negros Oriental $mm", clear
	save "$parent/data/from2_mm_NegrosOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Negros Oriental/$data Negros Oriental $hh", clear
	save "$parent/data/from3_hh_NegrosOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Negros Oriental/$data Negros Oriental $mm", clear
	save "$parent/data/from3_mm_NegrosOriental.dta", replace

	import delimited "$parent$fm2/$rgn/Siquijor/$data Siquijor $hh", clear
	save "$parent/data/from2_hh_Siquijor.dta", replace
	import delimited "$parent$fm2/$rgn/Siquijor/$data Siquijor $mm", clear
	save "$parent/data/from2_mm_Siquijor.dta", replace
	import delimited "$parent$fm3/$rgn/Siquijor/$data Siquijor $hh", clear
	save "$parent/data/from3_hh_Siquijor.dta", replace
	import delimited "$parent$fm3/$rgn/Siquijor/$data Siquijor $mm", clear
	save "$parent/data/from3_mm_Siquijor.dta", replace

	**#  Region VIII
	gl rgn 	Region VIII - Eastern Visayas

	import delimited "$parent$fm2/$rgn/Biliran/$data Biliran $hh", clear
	save "$parent/data/from2_hh_Biliran.dta", replace
	import delimited "$parent$fm2/$rgn/Biliran/$data Biliran $mm", clear
	save "$parent/data/from2_mm_Biliran.dta", replace
	import delimited "$parent$fm3/$rgn/Biliran/$data Biliran $hh", clear
	save "$parent/data/from3_hh_Biliran.dta", replace
	import delimited "$parent$fm3/$rgn/Biliran/$data Biliran $mm", clear
	save "$parent/data/from3_mm_Biliran.dta", replace

	import delimited "$parent$fm2/$rgn/Eastern Samar/$data Eastern Samar $hh", clear
	save "$parent/data/from2_hh_EasternSamar.dta", replace
	import delimited "$parent$fm2/$rgn/Eastern Samar/$data Eastern Samar $mm", clear
	save "$parent/data/from2_mm_EasternSamar.dta", replace
	import delimited "$parent$fm3/$rgn/Eastern Samar/$data Eastern Samar $hh", clear
	save "$parent/data/from3_hh_EasternSamar.dta", replace
	import delimited "$parent$fm3/$rgn/Eastern Samar/$data Eastern Samar $mm", clear
	save "$parent/data/from3_mm_EasternSamar.dta", replace

	import delimited "$parent$fm2/$rgn/Leyte/$data Leyte $hh", clear
	save "$parent/data/from2_hh_Leyte.dta", replace
	import delimited "$parent$fm2/$rgn/Leyte/$data Leyte $mm", clear
	save "$parent/data/from2_mm_Leyte.dta", replace
	import delimited "$parent$fm3/$rgn/Leyte/$data Leyte $hh", clear
	save "$parent/data/from3_hh_Leyte.dta", replace
	import delimited "$parent$fm3/$rgn/Leyte/$data Leyte $mm", clear
	save "$parent/data/from3_mm_Leyte.dta", replace

	import delimited "$parent$fm2/$rgn/Northern Samar/$data Northern Samar $hh", clear
	save "$parent/data/from2_hh_NorthernSamar.dta", replace
	import delimited "$parent$fm2/$rgn/Northern Samar/$data Northern Samar $mm", clear
	save "$parent/data/from2_mm_NorthernSamar.dta", replace
	import delimited "$parent$fm3/$rgn/Northern Samar/$data Northern Samar $hh", clear
	save "$parent/data/from3_hh_NorthernSamar.dta", replace
	import delimited "$parent$fm3/$rgn/Northern Samar/$data Northern Samar $mm", clear
	save "$parent/data/from3_mm_NorthernSamar.dta", replace

	import delimited "$parent$fm2/$rgn/Samar (Western Samar)/$data Samar $hh", clear
	save "$parent/data/from2_hh_Samer.dta", replace
	import delimited "$parent$fm2/$rgn/Samar (Western Samar)/$data Samar $mm", clear
	save "$parent/data/from2_mm_Samer.dta", replace
	import delimited "$parent$fm3/$rgn/Western Samar/$data Western Samar $hh", clear
	save "$parent/data/from3_hh_Samer.dta", replace
	import delimited "$parent$fm3/$rgn/Western Samar/$data Western Samar $mm", clear
	save "$parent/data/from3_mm_Samer.dta", replace

	import delimited "$parent$fm2/$rgn/Southern Leyte/$data Southern Leyte $hh", clear
	save "$parent/data/from2_hh_SouthernLeyte.dta", replace
	import delimited "$parent$fm2/$rgn/Southern Leyte/$data Southern Leyte $mm", clear
	save "$parent/data/from2_mm_SouthernLeyte.dta", replace
	import delimited "$parent$fm3/$rgn/Southern Leyte/$data Southern Leyte $hh", clear
	save "$parent/data/from3_hh_SouthernLeyte.dta", replace
	import delimited "$parent$fm3/$rgn/Southern Leyte/$data Southern Leyte $mm", clear
	save "$parent/data/from3_mm_SouthernLeyte.dta", replace

	import delimited "$parent$fm2/$rgn/Tacloban City/$data Tacloban City $hh", clear
	save "$parent/data/from2_hh_TaclobanCity.dta", replace
	import delimited "$parent$fm2/$rgn/Tacloban City/$data Tacloban City $mm", clear
	save "$parent/data/from2_mm_TaclobanCity.dta", replace
	import delimited "$parent$fm3/$rgn/Tacloban City/$data Tacloban City $hh", clear
	save "$parent/data/from3_hh_TaclobanCity.dta", replace
	import delimited "$parent$fm3/$rgn/Tacloban City/$data Tacloban City $mm", clear
	save "$parent/data/from3_mm_TaclobanCity.dta", replace

	**#  Region X
	gl rgn 	Region X - Northern Mindanao

	import delimited "$parent$fm2/$rgn/Bukidnon/$data Bukidnon $hh", clear
	save "$parent/data/from2_hh_Bukidnon.dta", replace
	import delimited "$parent$fm2/$rgn/Bukidnon/$data Bukidnon $mm", clear
	save "$parent/data/from2_mm_Bukidnon.dta", replace
	import delimited "$parent$fm3/$rgn/Bukidnon/$data Bukidnon $hh", clear
	save "$parent/data/from3_hh_Bukidnon.dta", replace
	import delimited "$parent$fm3/$rgn/Bukidnon/$data Bukidnon $mm", clear
	save "$parent/data/from3_mm_Bukidnon.dta", replace

	import delimited "$parent$fm2/$rgn/Cagayan De Oro City/$data Cagayan De Oro City $hh", clear
	save "$parent/data/from2_hh_CagayanDeOro.dta", replace
	import delimited "$parent$fm2/$rgn/Cagayan De Oro City/$data Cagayan De Oro City $mm", clear
	save "$parent/data/from2_mm_CagayanDeOro.dta", replace
	import delimited "$parent$fm3/$rgn/Cagayan De Oro/$data Cagayan De Oro $hh", clear
	save "$parent/data/from3_hh_CagayanDeOro.dta", replace
	import delimited "$parent$fm3/$rgn/Cagayan De Oro/$data Cagayan De Oro $mm", clear
	save "$parent/data/from3_mm_CagayanDeOro.dta", replace

	import delimited "$parent$fm2/$rgn/Camiguin/$data Camiguin $hh", clear
	save "$parent/data/from2_hh_Camiguin.dta", replace
	import delimited "$parent$fm2/$rgn/Camiguin/$data Camiguin $mm", clear
	save "$parent/data/from2_mm_Camiguin.dta", replace
	import delimited "$parent$fm3/$rgn/Camiguin/$data Camiguin $hh", clear
	save "$parent/data/from3_hh_Camiguin.dta", replace
	import delimited "$parent$fm3/$rgn/Camiguin/$data Camiguin $mm", clear
	save "$parent/data/from3_mm_Camiguin.dta", replace

	import delimited "$parent$fm2/$rgn/Iligan City/$data Iligan City $hh", clear
	save "$parent/data/from2_hh_IliganCity.dta", replace
	import delimited "$parent$fm2/$rgn/Iligan City/$data Iligan City $mm", clear
	save "$parent/data/from2_mm_IliganCity.dta", replace
	import delimited "$parent$fm3/$rgn/Iligan City/$data Iligan City $hh", clear
	save "$parent/data/from3_hh_IliganCity.dta", replace
	import delimited "$parent$fm3/$rgn/Iligan City/$data Iligan City $mm", clear
	save "$parent/data/from3_mm_IliganCity.dta", replace

	import delimited "$parent$fm2/$rgn/Lanao Del Norte/$data Lanao Del Norte $hh", clear
	save "$parent/data/from2_hh_LanaoDelNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Lanao Del Norte/$data Lanao Del Norte $mm", clear
	save "$parent/data/from2_mm_LanaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Lanao Del Norte/$data Lanao Del Norte $hh", clear
	save "$parent/data/from3_hh_LanaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Lanao Del Norte/$data Lanao Del Norte $mm", clear
	save "$parent/data/from3_mm_LanaoDelNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Misamis Occidental/$data Misamis Occidental $hh", clear
	save "$parent/data/from2_hh_MisamisOccidental.dta", replace
	import delimited "$parent$fm2/$rgn/Misamis Occidental/$data Misamis Occidental $mm", clear
	save "$parent/data/from2_mm_MisamisOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Misamis Occidental/$data Misamis Occidental $hh", clear
	save "$parent/data/from3_hh_MisamisOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Misamis Occidental/$data Misamis Occidental $mm", clear
	save "$parent/data/from3_mm_MisamisOccidental.dta", replace

	import delimited "$parent$fm2/$rgn/Misamis Oriental/$data Misamis Oriental $hh", clear
	save "$parent/data/from2_hh_MisamisOriental.dta", replace
	import delimited "$parent$fm2/$rgn/Misamis Oriental/$data Misamis Oriental $mm", clear
	save "$parent/data/from2_mm_MisamisOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Misamis Oriental/$data Misamis Oriental $hh", clear
	save "$parent/data/from3_hh_MisamisOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Misamis Oriental/$data Misamis Oriental $mm", clear
	save "$parent/data/from3_mm_MisamisOriental.dta", replace

	**#  Region XI
	gl rgn 	Region XI - Davao Region
	
	import delimited "$parent$fm2/$rgn/Compostela Valley/$data Compostela Valley $hh", clear
	save "$parent/data/from2_hh_CompostelaValley.dta", replace
	import delimited "$parent$fm2/$rgn/Compostela Valley/$data Compostela Valley $mm", clear
	save "$parent/data/from2_mm_CompostelaValley.dta", replace
	import delimited "$parent$fm3/$rgn/Compostela Valley/$data Compostela Valley $hh", clear
	save "$parent/data/from3_hh_CompostelaValley.dta", replace
	import delimited "$parent$fm3/$rgn/Compostela Valley/$data Compostela Valley $mm", clear
	save "$parent/data/from3_mm_CompostelaValley.dta", replace

	import delimited "$parent$fm2/$rgn/Davao City/$data Davao City $hh", clear
	save "$parent/data/from2_hh_DavaoCity.dta", replace
	import delimited "$parent$fm2/$rgn/Davao City/$data Davao City $mm", clear
	save "$parent/data/from2_mm_DavaoCity.dta", replace
	import delimited "$parent$fm3/$rgn/Davao City/$data Davao City $hh", clear
	save "$parent/data/from3_hh_DavaoCity.dta", replace
	import delimited "$parent$fm3/$rgn/Davao City/$data Davao City $mm", clear
	save "$parent/data/from3_mm_DavaoCity.dta", replace

	import delimited "$parent$fm2/$rgn/Davao Del Norte/$data Davao Del Norte $hh", clear
	save "$parent/data/from2_hh_DavaoDelNorte.dta", replace
	import delimited "$parent$fm2/$rgn/Davao Del Norte/$data Davao Del Norte $mm", clear
	save "$parent/data/from2_mm_DavaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Del Norte/$data Davao Del Norte $hh", clear
	save "$parent/data/from3_hh_DavaoDelNorte.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Del Norte/$data Davao Del Norte $mm", clear
	save "$parent/data/from3_mm_DavaoDelNorte.dta", replace

	import delimited "$parent$fm2/$rgn/Davao Del Sur/$data Davao Del Sur $hh", clear
	save "$parent/data/from2_hh_DavaoDelSur.dta", replace
	import delimited "$parent$fm2/$rgn/Davao Del Sur/$data Davao Del Sur $mm", clear
	save "$parent/data/from2_mm_DavaoDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Del Sur/$data Davao Del Sur $hh", clear
	save "$parent/data/from3_hh_DavaoDelSur.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Del Sur/$data Davao Del Sur $mm", clear
	save "$parent/data/from3_mm_DavaoDelSur.dta", replace

	import delimited "$parent$fm2/$rgn/Davao Occidental/$data Davao Occidental $hh", clear
	save "$parent/data/from2_hh_DavaoOccidental.dta", replace
	import delimited "$parent$fm2/$rgn/Davao Occidental/$data Davao Occidental $mm", clear
	save "$parent/data/from2_mm_DavaoOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Occidental/$data Davao Occidental $hh", clear
	save "$parent/data/from3_hh_DavaoOccidental.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Occidental/$data Davao Occidental $mm", clear
	save "$parent/data/from3_mm_DavaoOccidental.dta", replace

	import delimited "$parent$fm2/$rgn/Davao Oriental/$data Davao Oriental $hh", clear
	save "$parent/data/from2_hh_DavaoOriental.dta", replace
	import delimited "$parent$fm2/$rgn/Davao Oriental/$data Davao Oriental $mm", clear
	save "$parent/data/from2_mm_DavaoOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Oriental/$data Davao Oriental $hh", clear
	save "$parent/data/from3_hh_DavaoOriental.dta", replace
	import delimited "$parent$fm3/$rgn/Davao Oriental/$data Davao Oriental $mm", clear
	save "$parent/data/from3_mm_DavaoOriental.dta", replace
	
	**#  Region XII
	gl rgn 	Region XII - SOCCSKSARGEN

	import delimited "$parent$fm2/$rgn/General Santos City/$data General Santos City $hh", clear
	save "$parent/data/from2_hh_GeneralSantosCity.dta", replace
	import delimited "$parent$fm2/$rgn/General Santos City/$data General Santos City $mm", clear
	save "$parent/data/from2_mm_GeneralSantosCity.dta", replace
	import delimited "$parent$fm3/$rgn/General Santos City/$data General Santos City $hh", clear
	save "$parent/data/from3_hh_GeneralSantosCity.dta", replace
	import delimited "$parent$fm3/$rgn/General Santos City/$data General Santos City $mm", clear
	save "$parent/data/from3_mm_GeneralSantosCity.dta", replace

	import delimited "$parent$fm2/$rgn/North Cotabato/$data North Cotabato $hh", clear
	save "$parent/data/from2_hh_NorthCotabato.dta", replace
	import delimited "$parent$fm2/$rgn/North Cotabato/$data North Cotabato $mm", clear
	save "$parent/data/from2_mm_NorthCotabato.dta", replace
	import delimited "$parent$fm3/$rgn/North Cotabato/$data North Cotabato $hh", clear
	save "$parent/data/from3_hh_NorthCotabato.dta", replace
	import delimited "$parent$fm3/$rgn/North Cotabato/$data North Cotabato $mm", clear
	save "$parent/data/from3_mm_NorthCotabato.dta", replace

	import delimited "$parent$fm2/$rgn/Sarangani/$data Sarangani $hh", clear
	save "$parent/data/from2_hh_Sarangani.dta", replace
	import delimited "$parent$fm2/$rgn/Sarangani/$data Sarangani $mm", clear
	save "$parent/data/from2_mm_Sarangani.dta", replace
	import delimited "$parent$fm3/$rgn/Sarangani/$data Sarangani $hh", clear
	save "$parent/data/from3_hh_Sarangani.dta", replace
	import delimited "$parent$fm3/$rgn/Sarangani/$data Sarangani $mm", clear
	save "$parent/data/from3_mm_Sarangani.dta", replace

	import delimited "$parent$fm2/$rgn/South Cotabato/$data South Cotabato $hh", clear
	save "$parent/data/from2_hh_SouthCotabato.dta", replace
	import delimited "$parent$fm2/$rgn/South Cotabato/$data South Cotabato $mm", clear
	save "$parent/data/from2_mm_SouthCotabato.dta", replace
	import delimited "$parent$fm3/$rgn/South Cotabato/$data South Cotabato $hh", clear
	save "$parent/data/from3_hh_SouthCotabato.dta", replace
	import delimited "$parent$fm3/$rgn/South Cotabato/$data South Cotabato $mm", clear
	save "$parent/data/from3_mm_SouthCotabato.dta", replace

	import delimited "$parent$fm2/$rgn/Sultan Kudarat/$data Sultan Kudarat $hh", clear
	save "$parent/data/from2_hh_SultanKudarat.dta", replace
	import delimited "$parent$fm2/$rgn/Sultan Kudarat/$data Sultan Kudarat $mm", clear
	save "$parent/data/from2_mm_SultanKudarat.dta", replace
	import delimited "$parent$fm3/$rgn/Sultan Kudarat/$data Sultan Kudarat $hh", clear
	save "$parent/data/from3_hh_SultanKudarat.dta", replace
	import delimited "$parent$fm3/$rgn/Sultan Kudarat/$data Sultan Kudarat $mm", clear
	save "$parent/data/from3_mm_SultanKudarat.dta", replace

	
	cd "$parent/data"
	local file2append: dir . files "from2_hh_*.dta"	
	use from2_hh_Abra.dta, clear
	foreach f of local file2append {
    append using `"$parent/data/`f'"', force
}
	save f2_hh_appended, replace

	local file2append: dir . files "from2_mm_*.dta"
	use from2_mm_Abra.dta, clear
	foreach f of local file2append {
    append using `"$parent/data/`f'"', force
}
	save f2_mm_appended, replace
	
	local file2append: dir . files "from3_hh_*.dta"	
	use from3_hh_Abra.dta, clear
	foreach f of local file2append {
    append using `"$parent/data/`f'"', force
}
	duplicates drop
	save f3_hh_appended, replace
	

	local file2append: dir . files "from3_mm_*.dta"
	use from3_mm_Abra.dta, clear
	foreach f of local file2append {
    append using `"$parent/data/`f'"', force
}
	duplicates drop
	save f3_mm_appended, replace
	
	merge m:1 reg prv mun hsn using f3_hh_appended.dta
	keep if _merge==3
	
	renvars, upper
	*B2:H108	_IDS0	(Id Items)				
		label var 	REG	"	Region	"
		label var 	PRV	"	Province Name/Highly Urbanized City	"
		label var 	MUN	"	City/Municipality	"
		label var 	HSN	"	Household Serial Number	"
*	F3RT1	CPHF3 Household		"		"
		label var 	B1	"	Type of Building	"
		label var 	B2	"	Number of Floors of the Building	"
		label var 	B3	"	Construction materials of the roof	"
		label var 	B4	"	Construction materials of the outer walls	"
		label var 	B5	"	Finishing materials of the floor of the housing unit	"
		label var 	B6	"	Construction materials of the floor of the housing unit	"
		label var 	B7	"	State of repair of the building	"
		label var 	B8	"	Year building was built	"
		label var 	D1	"	Floor area of the housing unit	"
		label var 	H1	"	Tenure status of the housing unit/lot	"
		label var 	H2	"	Acquisition of the housing unit	"
		label var 	H3A	"	Source of financing of the housing unit (A) Own resources/interest-free loans from relatives/friends	"
		label var 	H3B	"	Source of financing of the housing unit (B) Government assistance, PAG-IBIG, GSIS, SSS, LBP, and others	"
		label var 	H3C	"	Source of financing of the housing unit (C) Private bank/foundation/cooperative	"
		label var 	H3D	"	Source of financing of the housing unit (D) Employer assistance	"
		label var 	H3E	"	Source of financing of the housing unit (E) Private persons	"
		label var 	H3F	"	Source of financing of the housing unit (F) Others	"
		label var 	H4	"	Monthly rental of the housing unit	"
		label var 	H5	"	Usual manner of kitchen garbage disposal	"
		label var 	H6	"	Kind of toilet facility	"
		label var 	H7	"	Fuel for lighting	"
		label var 	H8	"	Fuel for cooking	"
		label var 	H9	"	Source of water supply for drinking	"
		label var 	H10	"	Source of water supply for cooking	"
		label var 	H11A	"	Land ownership (A) Other residential land/s	"
		label var 	H11B	"	Land ownership (B) Agricultural land/s	"
		label var 	H11C	"	Land ownership (C) Agricultural land/s acquired through CARP	"
		label var 	H11D	"	Land ownership (D) Other land/s	"
		label var 	H13	"	Language/dialect generally spoken at home	"
		label var 	H14_PRVMUN	"	Residence Five Years from Now	"
		label var 	H14_RECODE	"	Residence Five Years from Now (Recoded)	"
		label var 	H15A	"	Presence of household conveniences (A) Refrigerator/freezer	"
		label var 	H15B	"	Presence of household conveniences (B) Stove with oven/gas range	"
		label var 	H15C	"	Presence of household conveniences (C) Microwave oven	"
		label var 	H15D	"	Presence of household conveniences (D) Washing machine	"
		label var 	H15E	"	Presence of household conveniences (E) Air conditioner	"
		label var 	H15F	"	Presence of household conveniences (F) Electric fan and other cooling equipment	"
		label var 	H15G	"	Presence of household conveniences (G) Radio/radio cassette (AM, FM, and transistor)	"
		label var 	H15H	"	Presence of household conveniences (H) Television	"
		label var 	H15I	"	Presence of household conveniences (I) CD/DVD/VCD player	"
		label var 	H15J	"	Presence of household conveniences (J) Audio component/stereo set/karaoke/videoke	"
		label var 	H15K	"	Presence of household conveniences (K) Landline/wireless telephone	"
		label var 	H15L	"	Presence of household conveniences (L) Mobile phone	"
		label var 	H15M	"	Presence of household conveniences (M) Tablet	"
		label var 	H15N	"	Presence of household conveniences (N) Personal computer (desktop, laptop, notebook, netbook, netbook, and others)	"
		label var 	H15O	"	Presence of household conveniences (O) Car/van/jeep/truck	"
		label var 	H15P	"	Presence of household conveniences (P) Motorcycle/motor scooter/tricycle	"
		label var 	H15Q	"	Presence of household conveniences (Q) Bicycle/pedicab	"
		label var 	H15R	"	Presence of household conveniences (R) Motorized boat/banca	"
		label var 	H15S	"	Presence of household conveniences (S) Non-motorized boat/banca	"
		label var 	H16A	"	Internet access (A) Fixed (wired) narrowband/broadband network	"
		label var 	H16B	"	Internet access (B) Fixed (wireless) broadband network	"
		label var 	H16C	"	Internet access (C) Satellite broadband network	"
		label var 	H16D	"	Internet access (D) Mobile broadband network	"
		label var 	H17A	"	Internet use (A) Home	"
		label var 	H17B	"	Internet use (B) Work	"
		label var 	H17C	"	Internet use (C) School	"
		label var 	H17D	"	Internet use (D) Another's person home	"
		label var 	H17E	"	Internet use (E) Public place	"
		label var 	H17F	"	Internet use (F) Private establishment	"
		label var 	H17G	"	Internet use (G) Internet café/computer shop	"
		label var 	H17H	"	Internet use (H) In mobility	"
		label var 	HHWGT	"	Household Weight	"
*	F3RT2	CPHF3 Members		"		"
		label var 	LNA	"	Line Number	"
		label var 	P2	"	Relationship to household head	"
		label var 	P3	"	Sex	"
		label var 	P5	"	Five-Year Age Group	"
		label var 	P6	"	Birth Registration	"
		label var 	P7	"	Copy of Birth Registration	"
		label var 	P8	"	Marital Status	"
		label var 	P9	"	Religious Affiliation	"
		label var 	P10	"	Dual or Non-dual Citizenship	"
		label var 	P11	"	Country of Citizenship	"
		label var 	P12	"	Ethnicity	"
		label var 	P13A	"	Functional Difficulty in Seeing	"
		label var 	P13B	"	Functional Difficulty in Hearing	"
		label var 	P13C	"	Functional Difficulty in Walking	"
		label var 	P13D	"	Functional Difficulty in Remembering or Concentrating	"
		label var 	P13E	"	Functional Difficulty in Self-Caring	"
		label var 	P13F	"	Functional Difficulty in Communicating	"
		label var 	P14_PRVMUN	"	Residence of Mother at the Time of Birth of the Household Member	"
		label var 	P14_RECODE	"	Residence of Mother at the Time of Birth (Recoded)	"
		label var 	P15_PRVMUN	"	Residence Five Years Ago	"
		label var 	P15_RECODE	"	Residence Five Years Ago (Recoded)	"
		label var 	P16	"	Literacy	"
		label var 	P17	"	Highest Grade/Year Completed	"
		label var 	P18	"	School Attendance	"
		label var 	P19_PRVMUN	"	Place of School	"
		label var 	P19_RECODE	"	Place of School (Recoded)	"
		label var 	P20	"	Overseas Worker	"
		label var 	P21	"	Usual Activity/Occupation	"
		label var 	P22	"	Kind of Business or Industry	"
		label var 	P23	"	Class of Worker	"
		label var 	P24_PRVMUN	"	Place of Work	"
		label var 	P24_RECODE	"	Place of Work (Recoded)	"
		label var 	P25	"	Children Born Alive	"
		label var 	P26	"	Children Still Living	"
		label var 	P27	"	Children Born Alive Last Year	"
		label var 	P28	"	Age at First Marriage	"
		label var 	POPWGT	"	Population Weight	"
	
	
		save POPCEN2020_f3_mmhh_merged, replace

*** END OF DOFILE ***
