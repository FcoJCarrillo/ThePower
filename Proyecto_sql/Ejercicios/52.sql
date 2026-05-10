/*
Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las
películas que han sido alquiladas al menos 10 veces.
*/

--DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMP TABLE peliculas_alquiladas AS
select f.film_id,f.title, COUNT(r.rental_id) AS veces_alquilada from film f
join inventory i ON f.film_id = i.film_id
join rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;