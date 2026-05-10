/*
Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible.
*/

select f.title,COUNT(i.inventory_id) AS "cantidad_disponible"
from film f
LEFT join inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;
