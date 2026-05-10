/*
Obtén las películas cuyo idioma coincide con el idioma original.
*/
select * from film f WHERE f.language_id = f.original_language_id;
