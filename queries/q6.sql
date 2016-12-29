/*
Find the titles of the movies that have only 1 and 10 as ratings, and order them by average rating
(decreasing).
*/


EXPLAIN SELECT movie.title, valid_movie_rating.average
FROM movie,  (SELECT movie_id, (COUNT (CASE WHEN info<>'1.0' AND info<>'10.0' THEN 1 ELSE NULL END) ) AS is_not_valid, ( ( (COUNT (CASE WHEN info='1.0' THEN 1 ELSE NULL END )) + (COUNT (CASE WHEN info='10.0' THEN 1 ELSE NULL END ))*10 )/(COUNT (*)) ) AS average /* is_not_valid contains the number of ratings that a movie receives that are different from 1.0 and 10.0.*/
	FROM (SELECT * FROM movie_rating WHERE info_type_id=101) AS movie_rating /* we only consider lines from movie_rating that contain ratings, whose info_type_id is 101*/
	GROUP BY movie_id
) AS valid_movie_rating
WHERE movie.id=valid_movie_rating.movie_id AND valid_movie_rating.is_not_valid=0 /* we only select movies that have is_not_valid equal to 0*/
ORDER BY valid_movie_rating.average DESC;

