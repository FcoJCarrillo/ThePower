/*
¿Qué películas se alquilan por encima del precio medio?
*/

select title,rental_rate from film
WHERE rental_rate > (
    select AVG(rental_rate) from film
) ORDER BY rental_rate DESC;