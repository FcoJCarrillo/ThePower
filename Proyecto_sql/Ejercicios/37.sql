/*
Encuentra el ID del actor más bajo y más alto en la tabla actor
 */

select MIN(actor_id) AS id_minimo, MAX(actor_id) AS id_maximo from actor