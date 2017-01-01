/*
Find the name of all the people that have played in a movie they directed, and order them by their
names (increasing alphabetical order).
*/

/* 
First solution: Non optmized. Worst solution.

Actual time: 280828.25 to 281209.19 ms

CREATE INDEX person_movie_id_index on cast_info (person_id, movie_id)
cluster cast_info using person_movie_role_id_index

After optimizing: 151215.595 to 151396.019 ms

SELECT person.name
FROM person
WHERE EXISTS (SELECT 1
	FROM role_type RT1, role_type RT2, cast_info CI1, cast_info CI2 
	WHERE person.id=CI1.person_id AND person.id=CI2.person_id AND CI1.role_id=RT1.id AND CI2.role_id=RT2.id AND (RT1.role='actor' OR RT1.role='actress') AND RT2.role='director'
)
ORDER BY person.name
*/

/* 
Second solution: The fastest one when not optimized and as fast as the 4th approach when optimized.

Actual time: 68668.38 to 68745.83 ms

CREATE INDEX person_movie_id_index on cast_info (person_id, movie_id)
cluster cast_info using person_movie_role_id_index

After optimizing: 50955.145 to 51033.772 ms

*/

SELECT person.name
FROM person, (
	SELECT DISTINCT CI1.person_id
	FROM role_type RT1, role_type RT2, cast_info CI1, cast_info CI2
	WHERE (RT1.role='actor' OR RT1.role='actress') AND RT2.role='director' AND CI1.movie_id=CI2.movie_id AND CI1.person_id=CI2.person_id AND CI1.role_id=RT1.id AND CI2.role_id=RT2.id 
) AS ids
WHERE person.id=ids.person_id
ORDER BY person.name ASC;


/*
Third solution: slightly slower than the fastest solution.

Actual time: from 68819.53 to 68899.96 ms

CREATE INDEX person_movie_id_index on cast_info (person_id, movie_id)
cluster cast_info using person_movie_role_id_index

After optimizing: 51574.661 to 51655.797 ms

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
Fourth solution: Slower than the 2nd approach when not optmized and as fast as the 2nd when optmized.

Actual time: 71439.657 to 71528.970 ms

CREATE INDEX person_movie_id_index on cast_info (person_id, movie_id)
cluster cast_info using person_movie_role_id_index

After optimizing: 50428.290 to 50505.698 ms

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

