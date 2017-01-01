/*
Find the title and the year of production of each movie in which Nicholas Cage played. 
Order the results by year in descending order, then by title in ascending order.
*/

/*
This query assumes that movies with different ids are different even when they have the same title and were released in the same year

This assumption is rather poor: there are four deffective cases, but three of them should not even be in the table, since
they either are named as a date (this is the case of 2011-01-05 and 2007-12-14) or are labeled as episodes whereas
they are actually a cinema movie (this the case of the movie 'Knowing').

In fact, a significant part of the movies resulting from this query have wrong data.

Actual time:  18401.56 ms
*/

SELECT movie.title, movie.production_year
FROM movie, (SELECT DISTINCT cast_info.movie_id
                     FROM cast_info
                     WHERE cast_info.person_id IN ((SELECT aka_name.person_id FROM aka_name
                                                   WHERE (aka_name.name = 'Cage, Nicholas' OR aka_name.name='Cage, Nicolas')
                                                   	)
                     																UNION
                     																(SELECT person.id FROM person
                     																	WHERE (person.name = 'Cage, Nicholas' OR person.name = 'Cage, Nicolas')
                     																)
                                                   )
                     ) AS ids
WHERE movie.id = ids.movie_id
ORDER BY movie.production_year DESC, movie.title ASC;

