/*
Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una
duración mayor a 3 horas en la tabla film.
*/

select f.title  from film f WHERE f.rating = 'PG-13' and f.rental_duration > 3;