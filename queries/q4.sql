
/*Find the name of all the people that are both actors and directors, and order them by name.
*/

/* First solution: Horrible. Does not work, throws "out of memory" message

Total time: 436.794156130

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
Second solution: slow, but works

Total time: 48.881915621

SELECT person.name
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

*/

/*
Third Solution: Faster

Total time: 33.358004597

*/

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



/* 
Fourth Solution: Horrible. Does not work and throws a "out of memory" message

Total time: 461.904054488


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
