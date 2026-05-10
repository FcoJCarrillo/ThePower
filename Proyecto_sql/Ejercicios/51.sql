/*
Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las
películas que han sido alquiladas al menos 10 veces.
*/
--DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMP TABLE cliente_rentas_temporal AS
select customer_id, COUNT(*) AS total_rentas from rental
GROUP BY customer_id;