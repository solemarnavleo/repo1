* Ejemplo ilustrativo de como usar ordered logit y probit

clear all
set more off
cls

* Usamos una base de datos disponible en internet
webuse nhanes2f

* Vemos las opciones de la variable dependiente: autoreporte de nivel de salud
tab health

* Estadistica descriptiva de los controles
sum female black age houssiz

/* --------------------------------
           ORDERED PROBIT 
   -------------------------------- */
* Que sucederia si utilizamos oprobit sin controles
oprobit health
dis "La probabilidad de poor health es: " normal(_b[/cut1])
dis "La probabilidad de good health es: " (normal(_b[/cut4])-normal(_b[/cut3]))
dis "La probabilidad de excellent health es: " 1-normal(_b[/cut4])

/* Ahora agregamos controles y predecimos la probabilidad de tener fair health para 
   una mujer, blanca de 26 anhos en un hogar de 4 integrantes */
oprobit health female black age houssiz, vce(robust)
local XiB = _b[female] + _b[age]*26 + _b[houssiz]*4
dis "Prediccion: " normal(_b[/cut2]-`XiB') - normal(_b[/cut1]-`XiB')

/* Como cambiara esta probabilidad cuando cumpla 27 */   
/* Calculo exacto */   
local XiB_prime = `XiB' + _b[age]
dis "El cambio (exacto) al pasar de 26 a 27 anhos sera de: " ///
     normal(_b[/cut2]-`XiB_prime') - normal(_b[/cut1]-`XiB_prime') - ///
     (normal(_b[/cut2]-`XiB') - normal(_b[/cut1]-`XiB'))
	 
/* Calculo aproximado */
dis "El cambio (aproximado) al pasar de 26 a 27 anhos sera de: " ///
     _b[age]*(normalden(_b[/cut1]-`XiB') - normalden(_b[/cut2]-`XiB'))

/* Usando el comando margins */
margins, dydx(*) predict (outcome(#2)) at(female=1 black=0 age=26 houssiz=4) 

/* EPX usando el comando margins */
margins, dydx(*) predict (outcome(#2)) atmeans 

/* EPP usando el comando margins */
margins, dydx(*) predict (outcome(#2)) 

 /* Como generamos todas las predicciones de probabilidades */
oprobit health female black age houssiz, vce(robust)
predict pr1 pr2 pr3 pr4 pr5

ren pr* Oprobit_pr*

/* --------------------------------
           ORDERED LOGIT
   -------------------------------- */
ologit health
dis "La probabilidad de poor health es: " 1/(1+exp(-_b[/cut1]))
dis "La probabilidad de good health es: " (exp(-_b[/cut3])/(1+exp(-_b[/cut3]))) - (exp(-_b[/cut4])/(1+exp(-_b[/cut4])))
dis "La probabilidad de excellent health es: " (exp(-_b[/cut4])/(1+exp(-_b[/cut4])))

/* Nuevamente la prediccion y los cambios para la probabilidad de tener fair health para 
   una mujer, blanca de 26 anhos en un hogar de 4 integrantes */
ologit health female black age houssiz, vce(robust)
local XiB = _b[female] + _b[age]*26 + _b[houssiz]*4
local Phi_a1 = exp(`XiB' -_b[/cut1])/(1+exp(`XiB' -_b[/cut1]))
local Phi_a2 = exp(`XiB' -_b[/cut2])/(1+exp(`XiB' -_b[/cut2]))
dis "Prediccion: " `Phi_a1' - `Phi_a2'

/* Calculo exacto */   
local XiB_prime = `XiB' + _b[age]
local Phi_a1_prime = exp(`XiB_prime' -_b[/cut1])/(1+exp(`XiB_prime' -_b[/cut1]))
local Phi_a2_prime = exp(`XiB_prime' -_b[/cut2])/(1+exp(`XiB_prime' -_b[/cut2]))
dis "El cambio (exacto) al pasar de 26 a 27 anhos sera de: " ///
     (`Phi_a1_prime' - `Phi_a2_prime')  - (`Phi_a1' - `Phi_a2')

/* Calculo aproximado */
dis "El cambio (aproximado) al pasar de 26 a 27 anhos sera de: " ///
     _b[age]*(`Phi_a1'*(1-`Phi_a1') - `Phi_a2'*(1-`Phi_a2'))
	 
/* Usando el comando margins */
margins, dydx(*) predict (outcome(#2)) at(female=1 black=0 age=26 houssiz=4) 

/* EPX usando el comando margins */
margins, dydx(*) predict (outcome(#2)) atmeans 

/* EPP usando el comando margins */
margins, dydx(*) predict (outcome(#2)) 

 /* Como generamos todas las predicciones de probabilidades */
ologit health female black age houssiz, vce(robust)
predict pr1 pr2 pr3 pr4 pr5

