/*
Find the name of each actor who played the character Morpheus in a video game, together with
the name of the game. Order the results by year in descending order, then by title in ascending
order.
*/

/*
This query is simple and can be opitmized

Actual time: 12313.37 

EXPLAIN ANALYZE SELECT person.name, movie.title
FROM movie, movie_type, person, cast_info, char_name
WHERE movie_type.kind='video game' AND movie_type.id=movie.kind_id AND movie.id=cast_info.movie_id AND person.id=cast_info.person_id AND cast_info.person_role_id=char_name.id AND char_name.name='Morpheus'
ORDER BY movie.production_year DESC, movie.title ASC;
*/

/*
This query is more complicated and results in a better performance

Actual time: 8925.43 ms
*/

EXPLAIN SELECT person.name, movie.title
FROM movie, person, (SELECT cast_info.person_id, cast_info.movie_id FROM cast_info
	WHERE cast_info.movie_id IN (SELECT movie.id
		FROM movie
		WHERE EXISTS (SELECT 1 FROM movie_type WHERE movie_type.kind='video game' AND movie_type.id=movie.kind_id)
	) AND cast_info.person_role_id IN (SELECT char_name.id AS role_id
		FROM char_name
		WHERE char_name.name='Morpheus')
	) AS ids
WHERE person.id=ids.person_id AND movie.id=ids.movie_id
ORDER BY movie.production_year DESC, movie.title ASC;
