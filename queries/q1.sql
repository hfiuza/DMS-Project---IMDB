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

SELECT movie.title, movie.production_year
FROM movie, (SELECT DISTINCT cast_info.movie_id
                     FROM cast_info
                     WHERE cast_info.person_id IN (SELECT aka_name.person_id FROM aka_name
                                                   WHERE (aka_name.name = 'Cage, Nicholas' OR aka_name.name='Cage, Nicolas'))
                     ) AS ids
WHERE movie.id = ids.movie_id
ORDER BY movie.production_year DESC, movie.title ASC;

