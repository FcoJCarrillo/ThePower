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