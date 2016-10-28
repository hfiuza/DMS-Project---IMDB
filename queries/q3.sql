/*
Find the name of all the people that have played in a movie they directed, and order them by their
names (increasing alphabetical order).
*/


/* non optmized 

Total time: 93.110687278 s

SELECT person.name
FROM person
WHERE EXISTS (SELECT 1
	FROM role_type RT1, role_type RT2, cast_info CI1, cast_info CI2 
	WHERE person.id=CI1.person_id AND person.id=CI2.person_id AND CI1.role_id=RT1.id AND CI2.role_id=RT2.id AND (RT1.role='actor' OR RT1.role='actress') AND RT2.role='director'
)
ORDER BY person.name
*/

/*
This is one of the most simple algorithms and has the best performance

Total time: 48.843960571 s
*/
EXPLAIN SELECT person.name
FROM person, (
	SELECT DISTINCT CI1.person_id
	FROM role_type RT1, role_type RT2, cast_info CI1, cast_info CI2
	WHERE (RT1.role='actor' OR RT1.role='actress') AND RT2.role='director' AND CI1.role_id=RT1.id AND CI2.role_id=RT2.id AND CI1.movie_id=CI2.movie_id AND CI1.person_id=CI2.person_id
) AS ids
WHERE person.id=ids.person_id
ORDER BY person.name ASC;


/*
We tried to optimize using a JOIN, but we got a slower algorithm

Total time: 57.461556533

SELECT person.name
FROM person, (SELECT DISTINCT person_id
	FROM role_type RT1, role_type RT2, (SELECT * FROM (SELECT role_id AS role_id_1, person_id, movie_id
		FROM cast_info CI1) AS compact_cast_info_1
		NATURAL JOIN
		(SELECT role_id AS role_id_2, person_id, movie_id
		FROM cast_info CI2) AS compact_cast_info_2) AS role_movie_person
	WHERE RT1.role='director' AND (RT2.role='actor' OR RT2.role='actress') AND RT1.id=role_movie_person.role_id_1 AND RT2.id=role_movie_person.role_id_2
) AS selected_person
WHERE person.id=selected_person.person_id
ORDER BY person.name ASC;

*/

/*
We then tried a more simple approach using JOIN. It was faster, but couldn't beat the first optmizing approach

Total time: 52.223502379

SELECT person.name
FROM person, (SELECT DISTINCT person_id
	FROM role_type RT1, role_type RT2, (SELECT CI1.role_id AS role_id_1, CI2.role_id AS role_id_2, CI1.movie_id, CI1.person_id
		FROM cast_info CI1
		INNER JOIN cast_info CI2
		ON CI1.movie_id=CI2.movie_id AND CI1.person_id=CI2.person_id) AS role_movie_person
	WHERE RT1.role='director' AND (RT2.role='actor' OR RT2.role='actress') AND RT1.id=role_movie_person.role_id_1 AND RT2.id=role_movie_person.role_id_2
) AS selected_person
WHERE person.id=selected_person.person_id
ORDER BY person.name ASC;

*/











