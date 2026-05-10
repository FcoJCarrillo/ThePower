/*
Encuentra el promedio, la desviación estándar y varianza del total
pagado.
*/

select AVG("amount") as "promedio_alquiler",stddev("amount") as "desviacion_alquiler", variance("amount") as "varianza" from payment p