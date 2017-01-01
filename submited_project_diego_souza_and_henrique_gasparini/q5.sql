/* Find the titles of the twenty movies having the largest number of directors and their number of directors, ordered by their number of directors in decreasing order. */

/*
    Actual time: 22.228429000
*/

SELECT movie.title
FROM movie, (SELECT cast_info.movie_id,
              COUNT (cast_info.movie_id) AS number_of_directors
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.role_id = role_type.id
             GROUP BY cast_info.movie_id
             ORDER BY number_of_directors DESC
             LIMIT 20
             ) AS ids
WHERE movie.id = ids.movie_id
             
