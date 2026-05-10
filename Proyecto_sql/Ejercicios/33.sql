/*
Obtener todas las películas que tenemos y todos los registros de
alquiler.
*/

select r.rental_id, r.rental_date, f.title  from film f
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
ORDER BY f.title ,r.rental_date