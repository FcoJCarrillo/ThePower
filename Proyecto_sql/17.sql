/*
Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igbyʼ.
*/

select a.first_name AS nombre,a.last_name AS apellido from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';