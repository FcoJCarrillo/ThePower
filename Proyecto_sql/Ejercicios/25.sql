/*
Averigua el número de alquileres registrados por mes.
*/

select 
EXTRACT(year from r.rental_date) as anno,EXTRACT(month from r.rental_date) as MESES, COUNT(*) as TOTAL_ALQUILERES
from rental r
group by anno, meses ORDER BY anno,meses