/* Ejercicio 2 */

/*Muestra los nombres de todas las películas
con una clasificación por edades de ‘Rʼ.
*/

select f.title from film f WHERE f.rating = 'R'

/* Ejercicio 3 */

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


/* Ejercicio 4 */

/*
Obtén las películas cuyo idioma coincide con el idioma original.
*/
select * from film f WHERE f.language_id = f.original_language_id;


/* Ejercicio 5 */

/*
Ordena las películas por duración de forma ascendente.
*/

--POR DEFECTO EL ORDER BY, lo ordena de forma ASCENDENTE, si quiere puedes ponerlo como select * from film f ORDER BY f.rental_duration ASC;, pero no es necesario
select f.title,f.rental_duration  from film f ORDER BY f.rental_duration;

/* Ejercicio 6 */

/*
Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su
apellido.
*/
select a.first_name, a.last_name  from actor a WHERE a.last_name = 'ALLEN';

/* Ejercicio 7 */

/*
Encuentra la cantidad total de películas en cada clasificación de la tabla
“filmˮ y muestra la clasificación junto con el recuento.
*/

select f.rating ,count(f.rating ) as "total_peliculas" from film f group by f.rating ORDER BY f.rating ;

/* Ejercicio 8 */

/*
Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una
duración mayor a 3 horas en la tabla film.
*/

select f.title  from film f WHERE f.rating = 'PG-13' and f.rental_duration > 3;

/* Ejercicio 9 */

/*
Encuentra la variabilidad de lo que costaría reemplazar las películas.
*/

select stddev("replacement_cost") as "varianza"  from film f;

/* Ejercicio 10 */

/*
Encuentra la mayor y menor duración de una película de nuestra BBDD.
*/

select stddev("replacement_cost") as "varianza"  from film f;

/* Ejercicio 11 */

/*
Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
*/

select p.amount, p.rental_id  from payment p join rental r on p.rental_id = r.rental_id ORDER BY r.return_date desc limit 1 offset 2;

/* Ejercicio 12 */

/*
Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC
17ʼ ni ‘Gʼ en cuanto a su clasificación.
*/

select f.title  from film f WHERE f.rating <> 'NC-17' and f.rating <> 'G'

/* Ejercicio 13 */

/*
Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.
*/

select f.rating,AVG(length) as "LOGINTUD_TOTAL" from film f group by f.rating

/* Ejercicio 14 */

/*
Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.
*/

select f.rating, f.length from film f WHERE f.length > 180;

/* Ejercicio 15 */

/*
¿Cuánto dinero ha generado en total la empresa?
*/

select SUM(p.amount ) from payment p 

/* Ejercicio 16 */

/*
Muestra los 10 clientes con mayor valor de id.
*/

select * from customer c ORDER BY c.customer_id desc limit 10

/* Ejercicio 17 */

/*
Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igbyʼ.
*/

select a.first_name AS nombre,a.last_name AS apellido from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';

/* Ejercicio 18 */

/*
Selecciona todos los nombres de las películas únicos.
*/

select distinct f.title from film f 

/* Ejercicio 19 */

/*
Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “filmˮ.
*/
--En la tabla de film no sé las he visto que en la columna rating hay algo de sea comedia...

select f.title  from film f WHERE f.length > 180 and f.rating = 'G'

/* Ejercicio 20 */

/*
Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.
*/

select f.rating, ROUND(AVG("length"), 2) AS "promedio_duracion" 
from film f group by f.rating having ROUND(AVG("length"), 2) > 110

/* Ejercicio 21 */

/*
¿Cuál es la media de duración del alquiler de las películas?
*/

alter table actor add full_name VARCHAR(255);

/* Ejercicio 22 */

/*
Crea una columna con el nombre y apellidos de todos los actores y
actrices.
*/

--PRIMERO AÑADIR LA TABLA
alter table actor add full_name VARCHAR(255);
--LUEGO UN UPDATE
UPDATE actor a 
SET full_name = CONCAT(a.first_name , ' ', a.last_name );


/* Ejercicio 23 */

/*
Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente.
*/

select r.rental_date::DATE AS alquiler_dia, COUNT(r.rental_date) AS total_alquileres from rental r 
GROUP by r.rental_date::DATE ORDER BY alquiler_dia;

/* Ejercicio 24 */

/*
Encuentra las películas con una duración superior al promedio.
*/

select f2.title, f2.length from film f2  WHERE cast(f2.length as Float) > (select AVG(f.length) from film f )

/* Ejercicio 25 */

/*
Averigua el número de alquileres registrados por mes.
*/

select 
EXTRACT(year from r.rental_date) as anno,EXTRACT(month from r.rental_date) as MESES, COUNT(*) as TOTAL_ALQUILERES
from rental r
group by anno, meses ORDER BY anno,meses

/* Ejercicio 26 */

/*
Encuentra el promedio, la desviación estándar y varianza del total
pagado.
*/

select AVG("amount") as "promedio_alquiler",stddev("amount") as "desviacion_alquiler", variance("amount") as "varianza" from payment p

/* Ejercicio 27 */

/*
¿Qué películas se alquilan por encima del precio medio?
*/

select title,rental_rate from film
WHERE rental_rate > (
    select AVG(rental_rate) from film
) ORDER BY rental_rate DESC;

/* Ejercicio 28 */

/*
Muestra el id de los actores que hayan participado en más de 40
películas.
*/

select a.actor_id, COUNT(a.actor_id) as "total_apariciones_actores" from actor a
join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id having count(fa.actor_id) > 40


/* Ejercicio 29 */

/*
Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible.
*/

select f.title,COUNT(i.inventory_id) AS "cantidad_disponible"
from film f
LEFT join inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;


/* Ejercicio 30 */

/*
Obtener los actores y el número de películas en las que ha actuado.
*/

select a.full_name , COUNT(a.actor_id) as "total_apariciones_actores" from actor a
join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id


/* Ejercicio 31 */

/*
Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.
*/

select f.title AS pelicula , a.full_name as "nombre_completo"
from film f
LEFT join film_actor fa ON f.film_id = fa.film_id
LEFT join actor a ON fa.actor_id = a.actor_id
ORDER BY f.title, a.last_name;


/* Ejercicio 32 */

/*
Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.
*/

select a.actor_id,a.first_name,a.last_name,f.title AS pelicula
from actor a
LEFT join film_actor fa 
    ON a.actor_id = fa.actor_id
LEFT join film f 
    ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;

/* Ejercicio 33 */

/*
Obtener todas las películas que tenemos y todos los registros de
alquiler.
*/

select r.rental_id, r.rental_date, f.title  from film f
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
ORDER BY f.title ,r.rental_date

/* Ejercicio 34 */

/*
 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
 */
select c.customer_id,c.first_name AS nombre,c.last_name AS apellido, SUM(p.amount) AS total_gastado
from customer c
join payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

/* Ejercicio 35 */

/*
 Selecciona todos los actores cuyo primer nombre es 'Johnny'.
 */
select * from actor WHERE first_name = 'JOHNNY';

/* Ejercicio 36 */

/*
 Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
 */

select first_name as "Nombre",last_name as "Apellido" from actor;

/* Ejercicio 37 */

/*
Encuentra el ID del actor más bajo y más alto en la tabla actor
 */

select MIN(actor_id) AS id_minimo, MAX(actor_id) AS id_maximo from actor

/* Ejercicio 38 */

/*
Cuenta cuántos actores hay en la tabla “actorˮ.
 */

select COUNT(*) AS total_actores from actor;

/* Ejercicio 39 */

/*
Selecciona todos los actores y ordénalos por apellido en orden
ascendente.
 */

select * from actor ORDER BY last_name ASC;

/* Ejercicio 40 */

/*
Selecciona las primeras 5 películas de la tabla “filmˮ.
 */

select * from film LIMIT 5;

/* Ejercicio 41 */

/*
Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?

El nombre más repetido es Kenneth, Penelope y Julia
 */

select first_name, COUNT(*) AS cantidad from actor
GROUP BY first_name ORDER BY cantidad DESC;

/* Ejercicio 42 */

/*
Encuentra todos los alquileres y los nombres de los clientes que los
realizaron.
 */

select r.rental_id,c.first_name,c.last_name from rental r
join customer c ON r.customer_id = c.customer_id;

/* Ejercicio 43 */



select * from film CROSS join category;



/* Ejercicio 44 */

/*
* Realiza un CROSS join entre las tablas film y category. ¿Aporta valor
* esta consulta? ¿Por qué? Deja después de la consulta la contestación.
*/

select * from film CROSS join category;

/*
 * Yo creo que este caso no tiene mucho valor porque se esta combinando dos tablas, una la de películas con las diferentes categorias que existe en la BBDD.
 * Una película puede tener varias categorias e incluso puede tenerla todas o ninguna, pero en este caso estas combinando todas 
 * las películas con todas las categorías para las posibles combinaciones que puede tener y no es algo que muestre realmente como sería la realidad.
 * */

/* Ejercicio 45 */

/*
Encuentra los actores que han participado en películas de la categoría
'Action'.
*/

select distinct a.first_name,a.last_name from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film_category fc ON fa.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/* Ejercicio 46 */

/*
Encuentra todos los actores que no han participado en películas.
*/

select a.full_name
from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

/* Ejercicio 47 */

/*
Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.
*/

select a.full_name, COUNT(fa.film_id) AS total_peliculas from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.full_name;

/* Ejercicio 48 */

/*
Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres
de los actores y el número de películas en las que han participado.
*/

CREATE VIEW actor_num_peliculas AS
select a.full_name, COUNT(fa.film_id) AS total_peliculas from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.full_name;

/* Ejercicio 49 */

/*
 Calcula el número total de alquileres realizados por cada cliente.
 */
select c.customer_id,c.first_name,c.last_name, COUNT(r.rental_id) AS total_alquileres from customer c
LEFT join rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/* Ejercicio 50 */

/*
Calcula la duración total de las películas en la categoría 'Action'.
 */
select SUM(f.length) AS duracion_total from film f
join film_category fc ON f.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/* Ejercicio 51 */

/*
Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las
películas que han sido alquiladas al menos 10 veces.
*/
--DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMP TABLE cliente_rentas_temporal AS
select customer_id, COUNT(*) AS total_rentas from rental
GROUP BY customer_id;

/* Ejercicio 52 */

/*
Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las
películas que han sido alquiladas al menos 10 veces.
*/

--DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMP TABLE peliculas_alquiladas AS
select f.film_id,f.title, COUNT(r.rental_id) AS veces_alquilada from film f
join inventory i ON f.film_id = i.film_id
join rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

/* Ejercicio 53 */

/*
Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.
*/
select f.title from customer c
join rental r ON c.customer_id = r.customer_id
join inventory i ON r.inventory_id = i.inventory_id
join film f ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY' AND c.last_name = 'SANDERS' AND r.return_date IS NULL
ORDER BY f.title;

/* Ejercicio 54 */

/*
Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados
alfabéticamente por apellido.
*/
select distinct a.first_name, a.last_name
from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film_category fc ON fa.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

/* Ejercicio 55 */

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

/* Ejercicio 56 */

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

/* Ejercicio 57 */

/*
Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días.
 */
select distinct f.title from rental r
join inventory i ON r.inventory_id = i.inventory_id
join film f ON i.film_id = f.film_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days';

/* Ejercicio 58 */

/*
Encuentra el título de todas las películas que son de la misma categoría
que ‘Animationʼ.
 */
select f.title from film f
join film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    select category_id from category WHERE name = 'Animation'
);

/* Ejercicio 59 */

/*
Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Feverʼ. Ordena los resultados
alfabéticamente por título de película.
 */
select title from film
WHERE length = (
    select length from film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;

/* Ejercicio 60 */

/*
Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido.
 */
select c.first_name, c.last_name from customer c
join rental r ON c.customer_id = r.customer_id
join inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name;

/* Ejercicio 61 */

/*
Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres.
 */
select c.name,COUNT(*) AS total_alquiladas from rental r
join inventory i ON r.inventory_id = i.inventory_id
join film_category fc ON i.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
GROUP BY c.name;

/* Ejercicio 62 */

/*
Encuentra el número de películas por categoría estrenadas en 2006.
 */
select c.name,COUNT(*) AS total_peliculas from film f
join film_category fc ON f.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;

/* Ejercicio 63 */

/*
Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos.
 */
select * from staff CROSS join store;

/* Ejercicio 64 */

/*
Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.
 */
select c.customer_id,c.first_name, c.last_name,COUNT(r.rental_id) AS total_peliculas from customer c
LEFT join rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

