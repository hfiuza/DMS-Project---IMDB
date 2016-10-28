/*
Find the name of all the people that are both actors and directors, and order them by name.
*/

/*
    Total time: 23.099786000
*/

SELECT person.name
FROM person, (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE role_type.role = 'director'
                    AND cast_info.person_role_id = role_type.id
             ) AS ids1,
            
             (SELECT cast_info.person_id
              FROM cast_info, role_type
              WHERE (role_type.role = 'actor' OR role_type.role = 'actress')
                    AND cast_info.person_role_id = role_type.id
             ) AS ids2
WHERE ids2.person_id=person.id AND ids1.person_id=person.id
ORDER BY person.name;
