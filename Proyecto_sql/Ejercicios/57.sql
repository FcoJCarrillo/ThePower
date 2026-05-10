/*
Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días.
 */
select distinct f.title from rental r
join inventory i ON r.inventory_id = i.inventory_id
join film f ON i.film_id = f.film_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days';