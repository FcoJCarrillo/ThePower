/*
Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30
y 40.
*/

--DIFERENTES SOLUCIONES--
--select a.first_name from actor a WHERE a.actor_id >=30 and a.actor_id <=40;
--select a.first_name from actor a WHERE a.actor_id between 30 and 40;
--Si quereis que salga el nombre y apellidos:
--select a.first_name, a.last_name  from actor a WHERE a.actor_id between 30 and 40;
select concat(a.first_name, ' ', a.last_name )  from actor a WHERE a.actor_id between 30 and 40;
