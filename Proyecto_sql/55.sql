/*
Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaperʼ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.
*/
select distinct a.first_name, a.last_name
from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join inventory i ON fa.film_id = i.film_id
join rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    select MIN(r2.rental_date) from rental r2
    join inventory i2 ON r2.inventory_id = i2.inventory_id
    join film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name ASC, a.first_name ASC;