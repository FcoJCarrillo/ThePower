/*
Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Musicʼ.
 */
select distinct a.first_name,a.last_name
from actor a
WHERE a.actor_id NOT IN (
    select fa.actor_id from film_actor fa
    join film_category fc ON fa.film_id = fc.film_id
    join category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);