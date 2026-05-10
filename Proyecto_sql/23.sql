/*
Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente.
*/

select r.rental_date::DATE AS alquiler_dia, COUNT(r.rental_date) AS total_alquileres from rental r 
GROUP by r.rental_date::DATE ORDER BY alquiler_dia;