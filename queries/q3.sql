/*
Find the name of all the people that have played in a movie they directed, and order them by their
names (increasing alphabetical order).
*/


/* non optmized 

Actual time: 304644.215..305009.045 ms

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

Actual time: 74506.199 to 74602.415 ms

70914.138..70997.263
71054.303 to 71146.547 
71379.822 to 71466.630 
71386.171..71470.865
70315.140..70396.448
70603.474..70691.761

Obs: after creating a hash index for the columns cast_info.person_id and cast_info.movie_id the 
performance was slightly better. For 10 executions the best time was (...) ms and
the worst was (...) ms

*/

EXPLAIN ANALYZE SELECT person.name
FROM person, (
	SELECT DISTINCT CI1.person_id
	FROM role_type RT1, role_type RT2, cast_info CI1, cast_info CI2
	WHERE (RT1.role='actor' OR RT1.role='actress') AND RT2.role='director' AND CI1.movie_id=CI2.movie_id AND CI1.person_id=CI2.person_id AND CI1.role_id=RT1.id AND CI2.role_id=RT2.id 
) AS ids
WHERE person.id=ids.person_id
ORDER BY person.name ASC;


/*
We used a JOIN to get a faster algorithm

Actual time: from 78084.538 to 78182.289 ms

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
We then tried a more simple approach using JOIN. It was faster, but couldn't beat the first optmization approach

Actual time: 74811.495 to 74893.722 ms


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





