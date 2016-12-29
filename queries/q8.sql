/*
Find all the pairs of titles of movies m1 and m2 such that m1 directly or indirectly references m2,
ordered first by the title of m1, then by the title of m2. We say there is an indirect reference from
m1 to m2, if either (i) m1 references m2, or (ii) m1 references m3, and m3 indirectly references
m2.
*/
/*
CREATE OR REPLACE FUNCTION totalRecords ()
RETURNS integer AS $total$
declare
	total integer;
BEGIN
   SELECT count(*) into total FROM COMPANY;
   RETURN total;
END;
$total$ LANGUAGE plpgsql;

select totalRecords();


WITH RECURSIVE search_graph(id, link, data, depth, path, cycle) AS (
        SELECT g.id, g.link, g.data, 1,
          ARRAY[g.id],
          false
        FROM graph g
      UNION ALL
        SELECT g.id, g.link, g.data, sg.depth + 1,
          path || g.id,
          g.id = ANY(path)
        FROM graph g, search_graph sg
        WHERE g.id = sg.link AND NOT cycle
)
SELECT * FROM search_graph;*/


WITH RECURSIVE search_graph(first_id, last_id, path, cycle) AS (
				SELECT movie_link.movie_id AS first_id, movie_link.linked_movie_id AS last_id,
					ARRAY[movie_link.movie_id] AS path,
					false AS cycle
				FROM movie_link
			UNION
				SELECT movie_link.movie_id AS first_id, sg.last_id AS last_id,
					path || movie_link.movie_id AS path,
					movie_link.movie_id = ANY(path) AS cycle
				FROM movie_link, search_graph sg
				WHERE movie_link.linked_movie_id = sg.first_id AND NOT cycle
)
SELECT * FROM search_graph


/*
SELECT COUNT(*)
FROM (
	SELECT DISTINCT M1.id AS title1, M2.id AS title2
FROM movie M1, movie M2, (SELECT movie_id AS m1, linked_movie_id AS m2
	FROM movie_link
	UNION
	(SELECT m1, m2
		FROM (SELECT movie_id AS m1, linked_movie_id AS m3
			FROM movie_link) AS temp1
			NATURAL JOIN
			(SELECT movie_id AS m3, linked_movie_id AS m2
			FROM movie_link) AS temp2
		WHERE m1<>m2 
	)
	UNION
	(SELECT temp1.m1 AS m1, temp3.m2 AS m2
		FROM (SELECT movie_id AS m1, linked_movie_id AS m2
			FROM movie_link) AS temp1,
			(SELECT movie_id AS m1, linked_movie_id AS m2
			FROM movie_link) AS temp2,
			(SELECT movie_id AS m1, linked_movie_id AS m2
			FROM movie_link) AS temp3
		WHERE temp1.m2=temp2.m1 AND temp2.m2=temp3.m1 AND temp1.m1<>temp2.m2 AND temp1.m1<>temp3.m2 AND temp2.m2<>temp3.m2
	)
) AS all_links
WHERE M1.id=all_links.m1 AND M2.id=all_links.m2 AND M1.id<>M2.id
) AS foo
ORDER BY M1.title ASC, M2.title ASC
*/

/*
 If you observe the output, there are some movies that reference another movie with the same name.
 In this case, we assume that these movies are distinct.
 Even when link type is equal to 'similar to', we treat the movies as distinct, for we are not told specifically the purpose of the query, so we cannot deduce what is expected by the user
*/


/*
Find all the pairs of titles of movies m1 and m2 such that m1 directly or indirectly references m2,
ordered first by the title of m1, then by the title of m2. We say there is an indirect reference from
m1 to m2, if either (i) m1 references m2, or (ii) m1 references m3, and m3 indirectly references
m2.
*/

/*SELECT M1.title AS title1, M2.title AS title2
FROM movie M1, movie M2, (SELECT movie_id AS m1, linked_movie_id AS m2
	FROM movie_link
	UNION
	(SELECT m1, m2
		FROM (SELECT movie_id AS m1, linked_movie_id AS m3
			FROM movie_link) AS temp1
			NATURAL JOIN*/ /* We renamed the columns of movie_link so we can more easily perform a natural join */
/*			(SELECT movie_id AS m3, linked_movie_id AS m2
			FROM movie_link) AS temp2
		WHERE m1<>m2 *//*Small optimization: it is useless to consider a movie that is linked to itself. This is very probable for indiret links */
/*	)
) AS all_links
WHERE M1.id=all_links.m1 AND M2.id=all_links.m2 AND M1.id<>M2.id
ORDER BY M1.title ASC, M2.title ASC
*/

/*
 If you observe the output, there are some movies that reference another movie with the same name.
 In this case, we assume that these movies are distinct.
 Even when link type is equal to 'similar to', we treat the movies as distinct, for we are not told specifically the purpose of the query, so we cannot deduce what is expected by the user
*/
