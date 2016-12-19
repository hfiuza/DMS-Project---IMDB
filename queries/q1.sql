/*
Find the title and the year of production of each movie in which Nicholas Cage played. 
Order the results by year in descending order, then by title in ascending order.
*/

/*
This query is simple and can be opitmized

Actual time: 13526.49 ms
*/

/*SELECT DISTINCT movie.title, movie.production_year
FROM movie, person, cast_info
WHERE person.name = 'Cage, Nicolas' AND
      person.id = cast_info.person_id AND
      movie.id = cast_info.movie_id
ORDER BY movie.production_year DESC, movie.title ASC;
*/


/*
This query is more complicated and results in a better performance

Total time:  12394.05 ms
*/

EXPLAIN ANALYZE SELECT DISTINCT movie.title, movie.production_year
FROM movie, person, (SELECT cast_info.person_id, cast_info.movie_id
                     FROM cast_info
                     WHERE cast_info.person_id IN (SELECT person.id FROM person
                                                   WHERE person.name = 'Cage, Nicolas')
                     ) AS ids
WHERE person.id = ids.person_id AND movie.id = ids.movie_id
ORDER BY movie.production_year DESC, movie.title ASC;

