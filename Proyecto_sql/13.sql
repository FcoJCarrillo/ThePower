/*
Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.
*/

select f.rating,AVG(length) as "LOGINTUD_TOTAL" from film f group by f.rating