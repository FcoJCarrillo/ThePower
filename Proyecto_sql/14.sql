/*
Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.
*/

select f.rating, f.length from film f WHERE f.length > 180;