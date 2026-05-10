/*
Ordena las películas por duración de forma ascendente.
*/

--POR DEFECTO EL ORDER BY, lo ordena de forma ASCENDENTE, si quiere puedes ponerlo como select * from film f ORDER BY f.rental_duration ASC;, pero no es necesario
select f.title,f.rental_duration  from film f ORDER BY f.rental_duration;