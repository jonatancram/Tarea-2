/*

El Colegio de México, Centro de Estudios Económicos
Macroeconomía II: Consumo (Ejercicio 3)
Cristian Gudiño

*/

cd "/Users/cristiangudino/Desktop/MacroeconomicsII/Tarea2/Data"
global graphs = "/Users/cristiangudino/Desktop/MacroeconomicsII/Tarea2/Graphs"


clear all
set more off, permanently

log using Consumo

/*
A) Obtener datos del PIB, Consumo, Gasto de Gobierno, Inversión y Exportaciones Netas de manera trimestral de 1980 a 2019.

La base contiene los datos trimestrales para el consumo privado, gasto gubernamental, inversión, exportaciones e importaciones, así como el producto interno bruto de los años 1993 a 2019, puesto que la página del INEGI no cuenta, en todos los componentes, los datos de 1980.

*/

import delimited "cuentas_nacionales.csv"

/*
B) Gráficar cada uno de los componentes que son siempre positivas - cifras reales vs ln - y comparar.
*/

gen periodo2 = _n // Creamos una variable numérica para ordernar las fechas
generate time = tq(1993q1) + periodo2 - 1 // Creamos nuestra nueva variable de tiempo, la cual empieza desde el primer trimestre de 1993
drop periodo2
format time %tq // Establecemos el nuevo formato de nuestra variable temporal AAAA/trimestre
order time, after(periodo) // Cambiamos la posición de la nueva variable time

tsset time, quarterly // Declaramos la variable temporal como una serie de tiempo

graph twoway (line y time, legend(label(1 "PIB"))) (line c time, legend(label(2 "Consumo"))) (line g time, legend(label(3 "Gasto de Gobierno"))) (line i time, legend(label(4 "Inversión"))), ///
xtitle("Año/Trimestre", size(small)) ytitle("Cifras Reales (Millones mxn)", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(0(2000000)2.00e+07 , valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(2)) ///
caption("Fuente: Elaboración propia con datos del INEGI", size(vsmall) span)

graph export "$graphs/CifrasReales_Trimestral.pdf", as(pdf) replace

*Generamos de manera individual la variable ln_var = ln(var), la cual nos da la tasa de crecimiento para cada variable en cada trimestre

gen lny = ln(y)
gen lnc = ln(c)
gen lng = ln(g)
gen lni = ln(i) 

graph twoway (line lny time, legend(label(1 "PIB"))) (line lnc time, legend(label(2 "Consumo"))) (line lng time, legend(label(3 "Gasto de Gobierno"))) (line lni time, legend(label(4 "Inversión"))), ///
xtitle("Año/Trimestre", size(small)) ytitle("(ln)", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(14(1)17 , valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(2)) ///
caption("Fuente: Elaboración propia con datos del INEGI", size(vsmall) span)

graph export "$graphs/Cifrasln_Trimestral.pdf", as(pdf) replace

/*
C)Graficar las tasas de crecimientos de las cuatro variables anteriores. 
Tasa de crecimiento = (var_t - var_t-1)/var_t-1
*/

*Para crear una variable con lag utilizamos el comando lag. De manera análoga, creamos de manera individual cada variable lag de y, c, i, g.

gen lagy = y[_n - 1]
replace lagy = 0 if lagy == . // Reemplazamos missing value de la primera observación para evitar errores de cálculo.
gen lagc = c[_n - 1]
replace lagc = 0 if lagc == .
gen lagg = g[_n - 1]
replace lagg = 0 if lagg == .
gen lagi = i[_n - 1]
replace lagi = 0 if lagi == .

*Para crear las variables de tasas de crecimiento de cada una de las variables:

gen ty = (y/lagy) - 1
replace ty = 0 if ty == . // Reemplazamos missing values por un cero para tener consistencia en las gráficas
gen tc = (c/lagc) - 1
replace tc = 0 if tc == .
gen tg = (g/lagg) - 1
replace tg = 0 if tg == .
gen ti = (i/lagi) - 1
replace ti = 0 if ti == .

*Gráfica para el PIB

graph twoway (line ty time, legend(label(1 "PIB"))), ///
title("Tasa de Crecimiento PIB", size(small) justification(center)) ///
xtitle("Año/Trimestre", size(small)) ytitle("Tasa de Crecimiento", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(-0.06(0.02)0.05 , valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(1)) ///
name(g1, replace) nodraw

*Gráfica para el Consumo

graph twoway (line tc time, legend(label(2 "Consumo"))), ///
title("Tasa de Crecimiento Consumo", size(small) justification(center)) ///
xtitle("Año/Trimestre", size(small)) ytitle("Tasa de Crecimiento", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(-0.07(0.02)0.04 , valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(1)) ///
name(g2, replace) nodraw


graph combine g1 g2, name(combine1, replace) cols(1) ///
graphregion(fcolor(white)) ///
note("Fuente: Elaboración propia con datos del INEGI", size(tiny) span)

graph export "$graphs/TasasCrecimiento1_Trimestral.pdf", as(pdf) replace

*Gráfica para el Gasto de Gobierno

graph twoway (line tg time, legend(label(3 "Gasto de Gobierno"))), ///
title("Tasa de Crecimiento Gasto de Gobierno", size(small) justification(center)) ///
xtitle("Año/Trimestre", size(small)) ytitle("Tasa de Crecimiento", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(-0.03(0.01)0.03 , valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(1)) ///
name(g3, replace) nodraw

*Gráfica para la Inversión

graph twoway (line ti time, legend(label(4 "Inversión"))), ///
title("Tasa de Crecimiento Inversión", size(small) justification(center)) ///
xtitle("Año/Trimestre", size(small)) ytitle("Tasa de Crecimiento", size(small)) ///
xlabel(132(8)238 , valuelabel angle(vertical) labsize(small)) ///
ylabel(-0.3(0.05)0.1, valuelabel angle(horizontal) labsize(small))  ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(size(small) col(1)) ///
name(g4, replace) nodraw


graph combine g3 g4, name(combine2, replace) cols(1) ///
graphregion(fcolor(white)) ///
note("Fuente: Elaboración propia con datos del INEGI", size(tiny) span)

graph export "$graphs/TasasCrecimiento2_Trimestral.pdf", as(pdf) replace

/*
D) Considerando sólo Consumo y PIB, gráficar los puntos (\deltaC, \deltaY)
*/

graph twoway scatter tc ty, msymbol(Dh) ///
title("Gráfica de dispersión PIB vs Consumo", size(small) justification(center)) ///
xtitle("Tasa de crecimiento PIB", size(small)) ytitle("Tasa de crecimiento Consumo", size(small)) ///
graphregion(fcolor(white)) bgcolor(white) ///
caption("Fuente: Elaboración propia con datos del INEGI", size(small) span)

graph export "$graphs/Dispersión_PIBvsConsumo.pdf", as(pdf) replace

/*
E) Calcular la volatilidad de las dos series de tasas de crecimiento. 

Sabemos que cuando hablamos de volatilidad solemos referirnos a la desviación estándar, tomada con signo positivo. Por definición, la desviación estándar de una variable no es mas que la raíz cuadrada de su varianza.
*/

sum ty lny tc lnc, det // Nos permite conocer las estadísticas descriptivas de las series de tasas de crecimiento para el PIB y Consumo. 

outreg2 using summary, tex replace sum(detail) keep(ty lny tc lnc) eqkeep(N mean sd Var min max)

*Dados los resultados anteriores, podemos ver que el consumo tiene una mayor varianza, por lo que su sd será mayor respecto el PIB, de este modo podemos concluir que el componente del consumo tiene mayor volatilidad.

/*
F) Estimar los siguientes cuatro modelos lineales reportando los resultados de la regresión:

1.- C_t = a_1 + b_1 * Y_t + e_1

2.- \delta C_t = a_2 + b_2 * \delta Y_t + e_2

3.- \delta C_t = a_3 + b_3 * \delta Y_t-1 + e_3

4.- ln(C_t) = a_4 + b_4 * ln(Y_t) + e_3 

*/

*Dado que para el modelo 3 tenemos un lag Y_t-1 como var independiente, entonces debemos crear una nueva variable de crecimiento en el producto.

gen lagy2 = y[_n - 2]
replace lagy2 = 0 if lagy2 == .
order lagy2, after(lagy)

gen ty2 = (lagy/lagy2) - 1
replace ty2 = 0 if ty2 == .

label variable c "Consumo"
label variable y "PIB"
label variable ty "\Delta PIB_t"
label variable ty2 "\Delta PIB_t-1"
label variable lnc "ln(C)"
label variable lny "ln(PIB)"

*Modelo 1

reg c y, robust // Regresión líneal simple: consumo como variable dependiente y PIB como variable independiente

*Modelo 2

reg tc ty, robust // Regresión líneal simple: tasa de crecimiento del consumo como variable dependiente y tasa de crecimiento del PIB como variable independiente


*Modelo 3

reg tc ty2, robust // Regresión líneal simple: tasa de crecimiento del consumo como variable dependiente y tasa de crecimiento del PIB con un lag como variable independiente

*Modelo 4

reg lnc lny, robust // Regresión líneal simple: ln deel consumo como variable dependiente y ln del PIB como variable independiente


reg c y, robust
outreg2 using models, tex replace ctitle(Modelo 1) label
reg tc ty, robust 
outreg2 using models, tex append ctitle(Modelo 2) label
reg tc ty2, robust 
outreg2 using models, tex append ctitle(Modelo 3) label
reg lnc lny, robust
outreg2 using models, tex append ctitle(Modelo 4) label

/*
E) Explique qué se podría concluir, si fuera el caso, acerca de la HIP para méxico a partir de los coeficientes encontrados.

Sabemos que la HIP postula que el consumo de los agentes será suavizado en función de las expectativas en el ingreso. Dadas las limitaciones en los modelos antes estimados, entonces no podemos conocer el efecto de las expectativas en el ingreso sobre el nivel de consumo, por lo tanto la HIP no puede ser aceptada bajo estos modelos.

*/


log close

translate Consumo.smcl Consumo.pdf








