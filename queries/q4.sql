
/*Find the name of all the people that are both actors and directors, and order them by name.
*/

/* First solution: Horrible. Does not work, throws an "out of memory" message
Actual time: 293321.49 to 381891.45


SELECT person.name
FROM person, (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.role_id = role_type.id
             ) AS ids1,
            
             (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE (role_type.role = 'actor' OR role_type.role = 'actress')
                    AND cast_info.role_id = role_type.id
             ) AS ids2
WHERE ids2.person_id=person.id AND ids1.person_id=person.id
ORDER BY person.name;
*/

/*
Second solution: fastest solution

Actual time: 50445.39 to 50520.36  ms

After optimizing: 47178.64 to 47267.14 ms

*/

EXPLAIN SELECT person.name
FROM person, (SELECT DISTINCT cast_info.person_id
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.role_id = role_type.id
             ) AS ids1,
            
             (SELECT DISTINCT cast_info.person_id
              FROM cast_info, role_type
              WHERE (role_type.role = 'actor' OR role_type.role = 'actress')
                    AND cast_info.role_id = role_type.id
             ) AS ids2
WHERE ids2.person_id=person.id AND ids1.person_id=person.id
ORDER BY person.name;


/*
Third Solution: Slightly slower

Actual time: from 51985.471 to 52067.976 ms

After improving: from 47448.09 to 47519.60 ms 

SELECT person.name
FROM person, (SELECT *
  FROM (SELECT DISTINCT cast_info.person_id
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.role_id = role_type.id
             ) AS ids1
       NATURAL JOIN
      (SELECT DISTINCT cast_info.person_id
              FROM cast_info, role_type
              WHERE (role_type.role = 'actor' OR role_type.role = 'actress')
                    AND cast_info.role_id = role_type.id
             ) AS ids2
      )AS ids3
WHERE ids3.person_id=person.id
ORDER BY person.name;
*/

/* 
Fourth Solution: Horrible. Does not work and throws an "out of memory" message

Actual time: 304226.13 to 429150.49 ms

SELECT person.name
FROM person, (SELECT *
  FROM (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.role_id = role_type.id
             ) AS ids1
       NATURAL JOIN
      (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE (role_type.role = 'actor' OR role_type.role = 'actress')
                    AND cast_info.role_id = role_type.id
             ) AS ids2
      )AS ids3
WHERE ids3.person_id=person.id
ORDER BY person.name;
*/