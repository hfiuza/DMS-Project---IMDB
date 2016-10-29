/*
Find the average number of cinema movies Dolores Fonzi played in, in her active years. A year is active if she plays in at least one movie produced that year.
*/

/*
    Considering all kinds of movie
*/

/*
SELECT SUM(number_of_movies_by_year.amount)/COUNT(number_of_movies_by_year)
AS average_number_of_movies_by_year
FROM (SELECT COUNT(movie.production_year) AS amount
      FROM (SELECT DISTINCT cast_info.movie_id
            FROM cast_info, person
            WHERE person.name = 'Fonzi, Dolores' AND cast_info.person_id = person.id
           ) AS movies_count,
           movie
      WHERE movie.id = movies_count.movie_id AND movie.production_year IS NOT NULL
      GROUP BY movie.production_year) AS number_of_movies_by_year
*/

/*
    Considering only movies of the type "movie"
    Total time: 15.059945000
*/

SELECT SUM(number_of_movies_by_year.amount)/COUNT(number_of_movies_by_year)
AS average_number_of_movies_by_year
FROM (SELECT COUNT(movie.production_year) AS amount
      FROM (SELECT DISTINCT cast_info.movie_id
            FROM cast_info, person
            WHERE person.name = 'Fonzi, Dolores' AND cast_info.person_id = person.id
           ) AS movies_count,
           movie, movie_type
      WHERE movie_type.kind = 'movie' AND movie_type.id = movie.kind_id 
            AND movie.id = movies_count.movie_id AND movie.production_year IS NOT NULL
      GROUP BY movie.production_year
     ) AS number_of_movies_by_year

