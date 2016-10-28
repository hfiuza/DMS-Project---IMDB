/*
Find all the pairs of titles of movies m1 and m2 such that m1 directly or indirectly references m2,
ordered first by the title of m1, then by the title of m2. We say there is an indirect reference from
m1 to m2, if either (i) m1 references m2, or (ii) m1 references m3, and m3 indirectly references
m2.
*/

EXPLAIN SELECT M1.title AS title1, M2.title AS title2
FROM movie M1, movie M2, (SELECT movie_id AS m1, linked_movie_id AS m2
	FROM movie_link
	UNION
	(SELECT m1, m2
		FROM (SELECT movie_id AS m1, linked_movie_id AS m3
			FROM movie_link) AS temp1
			NATURAL JOIN /* We renamed the columns of movie_link so we can more easily perform a natural join */
			(SELECT movie_id AS m3, linked_movie_id AS m2
			FROM movie_link) AS temp2
		WHERE m1<>m2 /*Small optimization: it is useless to consider a movie that is linked to itself. This is very probable for indiret links */
	)
) AS all_links
WHERE M1.id=all_links.m1 AND M2.id=all_links.m2 AND M1.id<>M2.id
ORDER BY M1.title ASC, M2.title ASC


/*
 If you observe the output, there are some movies that reference another movie with the same name.
 In this case, we assume that these movies are distinct.
 Even when link type is equal to 'similar to', we treat the movies as distinct, for we are not told specifically the purpose of the query, so we cannot deduce what is expected by the user
*/