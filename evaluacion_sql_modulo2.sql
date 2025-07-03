 USE sakila; 
 
-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

/* tabla film */

SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

/* tabla film */

SELECT DISTINCT title
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

/* tabla film */

SELECT DISTINCT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

/* tabla film */ 

SELECT DISTINCT title
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

/* tabla actor */

SELECT first_name
FROM actor;

#si los nombres están divididos en nombre y apellido, podemos unirlos en una variable.

SELECT CONCAT(first_name, ' ' , last_name) AS nombre_completo
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. 

/* tabla actor */

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

#Si queremos que coincida exactamente con esa palabra.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'Gibson';

#Si quieremos mostrar el nombre completo en una sola columna utilizamos concatenar.

SELECT CONCAT(first_name, ' ' , last_name) AS nombre_completo
FROM actor
WHERE last_name LIKE '%Gibson%';

--  7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

/* tabla actor */

SELECT first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

SELECT first_name
FROM actor
WHERE actor_id >= 10 AND actor_id <= 20;

SELECT CONCAT(first_name, ' ' , last_name) AS nombre_completo
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

/* tabla film */

SELECT DISTINCT title
FROM film
WHERE rating NOT IN ('PG-13','R');

SELECT DISTINCT title
FROM film
WHERE rating <> 'R' AND rating <> 'PG-13';

--  9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

/* tabla film */

SELECT rating AS clasificacion, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating;

#si quieres ordenarlos de mayor a menor la cantidad.

SELECT rating AS clasificacion, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY total_peliculas DESC;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

/* tabla customer(customer_id) --> rental(customer_id) */ 

SELECT 
	c.customer_id,
    c.first_name, 
    c.last_name,
    COUNT(r.rental_id) AS total_alquiladas
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquiladas DESC;

SELECT 
	c.customer_id,
    c.first_name, 
    c.last_name,
    COUNT(r.rental_id) AS total_alquiladas
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquiladas ASC;

SELECT 
	c.customer_id,
    CONCAT(c.first_name, ' ' , c.last_name) AS nombre_completo,
    COUNT(r.rental_id) AS total_alquiladas
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquiladas DESC;

 -- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

/* rental → inventory → film → film_category → category */

SELECT 
    cat.name AS categoria,
    COUNT(r.rental_id) AS total_alquiladas
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY total_alquiladas DESC;

#si queremos limitar las categorias a 5.

SELECT 
    cat.name AS categoria,
    COUNT(r.rental_id) AS total_alquiladas
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY total_alquiladas DESC
LIMIT 5;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

/* film */

SELECT 
    rating AS clasificacion,
    SUM(length) / COUNT(*) AS promedio_duracion
FROM film
GROUP BY rating;

SELECT 
    rating AS clasificacion, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

SELECT 
    rating AS clasificacion,
    ROUND(AVG(length), 2) AS promedio_duracion
FROM film
GROUP BY rating;

--  13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

/* actor (actor_id) <--> (actor_id) film_actor (film_id) <--> film (film_id) */

SELECT 
    a.first_name AS nombre_actor,
    a.last_name AS apellido_actor
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON f.film_id = fa.film_id
WHERE f.title LIKE 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

/* fim */

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

/* film */

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

SELECT title
FROM film
WHERE release_year >= 2005 AND release_year <= 2010;

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".

/* film → film_category → category */

SELECT f.title
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Family';

SELECT f.title, c.name AS categoria
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Family';

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

/* film */

SELECT title
FROM film
WHERE rating = 'R' AND length >= 120;

SELECT title, length, rating
FROM film
WHERE rating = 'R' AND length >= 120;

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

/* actor → film_actor */

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;
 
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY total_peliculas ASC;

 -- 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
 
 /* actor → film_actor */
 
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id FROM film_actor # Esto busca actores cuyo actor_id no está en la tabla film_actor.
    );
    
 -- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

/* customer → film → category → film_category */

SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
HAVING AVG(f.length) > 120;

SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS promedio_duracion #Calcula el promedio de duración (AVG(f.length)) de las películas por categoría.
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
HAVING AVG(f.length) > 120; #Usa HAVING para filtrar solo las categorías con duración media mayor a 120 minutos.

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT 
  a.first_name, 
  a.last_name, 
  COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5
ORDER BY cantidad_peliculas DESC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT f.title
FROM film f
WHERE f.film_id IN (
  SELECT i.film_id
  FROM rental r
  INNER JOIN inventory i ON r.inventory_id = i.inventory_id
  WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);

#Para que no haya títulos repetidos (ya que una película puede haber sido alquilada varias veces), puedes añadir DISTINCT:

SELECT DISTINCT f.title
FROM film f
WHERE f.film_id IN (
  SELECT i.film_id
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);

SELECT f.title, MAX(DATEDIFF(r.return_date, r.rental_date)) AS max_dias_alquiler
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING MAX(DATEDIFF(r.return_date, r.rental_date)) > 5
ORDER BY max_dias_alquiler DESC;

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
  SELECT DISTINCT fa.actor_id
  FROM film_actor fa
  INNER JOIN film_category fc ON fa.film_id = fc.film_id
  INNER JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Horror'
);

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
  SELECT DISTINCT fa.actor_id
  FROM film_actor fa
  INNER JOIN film_category fc ON fa.film_id = fc.film_id
  INNER JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Horror'
)
ORDER BY a.last_name, a.first_name;

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT f.title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
 
SELECT 
  a1.actor_id AS actor1_id,
  a1.first_name AS actor1_first_name,
  a1.last_name AS actor1_last_name,
  a2.actor_id AS actor2_id,
  a2.first_name AS actor2_first_name,
  a2.last_name AS actor2_last_name,
  COUNT(*) AS peliculas_juntos
FROM film_actor fa1
INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id  -- evita pares duplicados y auto-uniones
INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id
INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a1.last_name,
         a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(*) >= 1
ORDER BY peliculas_juntos DESC
LIMIT 10;
