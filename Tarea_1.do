cd "d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1"
use "d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1\BaseCOVIDp.dta", clear
***Pregunta 1
* Inciso a
gen POS= Confirmed/ Tests
summarize POS, detail
ci mean POS

*Inciso b
tabulate POS if Country=="Mexico"
di (.1120252-.5045314)/sqrt(0.0163554/51)
*Inciso c
gen CFR= Deaths/ Confirmed
summarize CFR, detail
di (.0320818-.024)/sqrt(.0009645/100)
clear

***Pregunta 2
*Inciso a 
use "d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1\BaseCOVIDp.dta", clear
histogram PPI, frequency
tabstat PPI, stat(p25)
clear
use "d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1\BaseCOVIDm.dta", clear
generate PPI= Confirmed/ Population
save "d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1\BaseCOVIDm.dta", replace
file d:\Users\marisol.nava\Desktop\Maestría\Econometría_Arturo\Tarea_1\BaseCOVIDm.dta saved
histogram PPI, frequency
tabstat PPI, stat(p25)

*Inciso d

tempname memhold5
postfile memhold5 q25PPI using bs, replace
forvalues i=1/1000 {
use "BaseCOVIDm.dta",clear
bsample
quietly sum PPI, detail
post memhold5 (r(p25))
}
postclose memhold5
use bs,clear
sum q25PPI
histogram q25PPI, frequency

*Inciso e
tempname memhold7
postfile memhold7 q25PPI using bs, replace
forvalues i=1/1000 {
use "BaseCOVIDm.dta",clear
bsample 70
quietly sum PPI, detail
post memhold7 (r(p25))
}
postclose memhold7
use bs,clear
sum q25PPI
histogram q25PPI, frequency

* Inciso f
* Se genera una variable que corresponde a la media de los cuartiles obtenidos con bootstrap L=70
egen m= mean (q25PPI)
*Se calcula la suma de las desviaciones de la media al cuadrado para obtener la varianza
gen diff2= (q25PPI- m)^2
total (diff2)  


tempname memhold8
postfile memhold8 q25PPI using bs, replace
forvalues i=1/1000 {
use "BaseCOVIDm.dta",clear
bsample
quietly sum PPI, detail
post memhold8 (r(p25))
}
postclose memhold8
use bs,clear
sum q25PPI
histogram q25PPI, frequency

* Se genera una variable que corresponde a la media de los cuartiles obtenidos con bootstrap L=100
egen m= mean (q25PPI)
* Se calcula la suma de las desviaciones de la media al cuadrado para obtener la varianza
gen diff2= (q25PPI- m)^2
total (diff2)  

** Pregunta 3 
*Inciso a
use "BaseCOVIDm.dta",clear
generate P= Tests/ Population
*Inciso b
tab PT if Country=="Mexico"
di .0063457+ 0.005
di .0063457-.005
tabulate Country if PT<0.0113457 & PT>0.0013457
histogram PPI if PT<0.0113457 & PT>0.0013457, frequency xline (.001178) xline (.0032016)
*Inciso c
reg PPI PT
gen mylabel = 4 if Country =="Mexico"
generate etiqueta ="MEX" if Country=="Mexico"
graph twoway  scatter PPI PT if mylabel==4, mcolor(red) mlabel (etiqueta)|| scatter PPI PT if mylabel!=4, mcolor(blue)  ||lfit PPI PT
