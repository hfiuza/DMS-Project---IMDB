/*
Find the titles of the movies that have only 1 and 10 as ratings, and order them by average rating
(decreasing).
*/

/*
	Actual time: 7701.58 ms

	We analyze the votes distribution to determine which movies only received 1.0 and 10.0 ratings
	Then we look for the rating value, which is in the table movie_rating

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