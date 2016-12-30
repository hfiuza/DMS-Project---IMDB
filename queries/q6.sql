/*
Find the titles of the movies that have only 1 and 10 as ratings, and order them by average rating
(decreasing).
*/

/*
	Actual time: 1609.60 ms
*/

/*
SELECT movie.title, valid_movie_rating.average
FROM movie,  (SELECT only_movie_rating.movie_id, (COUNT (CASE WHEN only_movie_rating.info<>'1.0' AND only_movie_rating.info<>'10.0' THEN 1 ELSE NULL END) ) AS is_not_valid, ( ( (COUNT (CASE WHEN only_movie_rating.info='1.0' THEN 1 ELSE NULL END )) + (COUNT (CASE WHEN only_movie_rating.info='10.0' THEN 1 ELSE NULL END ))*10 )/(COUNT (*)) ) AS average
	FROM (SELECT movie_rating.movie_id AS movie_id, movie_rating.info AS info FROM movie_rating, info_type WHERE info_type.info='rating' AND movie_rating.info_type_id=info_type.id) AS only_movie_rating 
	GROUP BY movie_id
) AS valid_movie_rating
WHERE movie.id=valid_movie_rating.movie_id AND valid_movie_rating.is_not_valid=0
ORDER BY valid_movie_rating.average DESC;
*/


SELECT movie.title
FROM (SELECT DISTINCT movie_rating.movie_id AS id
			FROM movie_rating, info_type
			WHERE info_type.info='votes distribution' AND info_type.id=movie_rating.info_type_id AND movie_rating.info LIKE '_........_'
			) AS good_movies,
			( SELECT movie_rating.movie_id, movie_rating.info_type_id, CAST(movie_rating.info AS FLOAT) _info
				FROM movie_rating			
			) AS decimal_movie_rating, movie, info_type
WHERE good_movies.id=decimal_movie_rating.movie_id AND decimal_movie_rating.movie_id=movie.id AND info_type.info='rating' AND info_type.id=decimal_movie_rating.info_type_id
ORDER BY decimal_movie_rating._info DESC

/*
SELECT M.title
FROM movie M, movie_rating MR, info_type IT
WHERE MR.info LIKE '_........_' AND IT.info = 'votes distribution' AND IT.id = MR.info_type_id AND M.id = MR.movie_id
ORDER BY LEFT(MR.info, 1) DESC, RIGHT(MR.info, 1) DESC;
*/
/*
SELECT *
FROM movie_rating mr1, movie_rating mr2, info_type
WHERE info_type.info='votes distribution' AND info_type.id=mr1.info_type_id AND info_type.id=mr2.info_type_id AND mr1.movie_id=mr2.movie_id AND mr1.id<>mr2.id
*/