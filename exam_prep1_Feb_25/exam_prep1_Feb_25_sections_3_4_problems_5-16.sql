USE exam_prep_1;

#5---

SELECT id, username
FROM users
ORDER BY id;

#6---

SELECT repository_id, contributor_id
FROM repositories_contributors
WHERE repository_id = contributor_id
ORDER BY repository_id;

#7---

SELECT id , name, size
FROM files
WHERE size > 1000 AND name  LIKE '%html%'
ORDER BY size DESC;

#8---

SELECT i.id, CONCAT_WS(' : ', u.username, i.title) AS issue_assignee
FROM issues AS i
JOIN users AS u
ON i.assignee_id = u.id
ORDER BY i.id DESC;

#9---

SELECT 
    d.id, d.name, CONCAT(d.size, 'KB') AS size
FROM
    files AS f
        RIGHT JOIN
    files AS d ON f.parent_id = d.id
WHERE
    f.id IS NULL
ORDER BY d.id;

#10---

SELECT 
    r.id, r.name, COUNT(i.id) AS issues
FROM
    repositories AS r
        JOIN
    issues AS i ON r.id = i.repository_id
GROUP BY r.id
ORDER BY issues DESC , r.id
LIMIT 5;

#11---
SELECT 
    r.id,
    r.name,
    (SELECT 
            COUNT(id)
        FROM
            commits
        WHERE
            repository_id = r.id) AS commits,
    COUNT(rc.contributor_id) AS contributors
FROM
    repositories AS r
        JOIN
    repositories_contributors AS rc ON r.id = rc.repository_id
GROUP BY r.id
ORDER BY contributors DESC , r.id
LIMIT 1;

#12---
SELECT 
    u.id AS id,
    u.username, COUNT(c.id) AS commits
 FROM issues AS i
	RIGHT JOIN users AS u
	ON i.assignee_id = u.id
    LEFT JOIN commits AS c
    ON i.id = c.issue_id AND c.contributor_id = i.assignee_id
GROUP BY u.id
ORDER BY commits DESC , u.id;

#13---
SELECT SUBSTR(f.name, 1, (INSTR(f.name, '.') - 1)) AS name, 
(
SELECT COUNT(id)
FROM commits
WHERE message LIKE CONCAT('%', f.name, '%')) AS recursive_count
FROM files as f
JOIN files as d
ON f.id = d.parent_id 
WHERE d.id = f.parent_id AND f.id NOT IN (f.parent_id) 
ORDER BY f.name;

#14---
SELECT r.id, r.name, COUNT(DISTINCT c.contributor_id)
as users
FROM repositories as r 
LEFT JOIN commits as c
ON r.id = c.repository_id
GROUP BY r.id
ORDER BY users DESC, r.id;

#15---
DELIMITER $$
CREATE PROCEDURE udp_commit(username VARCHAR(30), 
							password VARCHAR(30), 
							message VARCHAR(255), 
							issue_id INT(11))
BEGIN
	DECLARE user_id INT (11);
	DECLARE repository_id INT(11);

	IF 1 <> (SELECT COUNT(*)  FROM users AS u
    WHERE u.username = username)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No such user!';
	END IF;

	IF 1 <> (SELECT COUNT(*)  FROM users AS u
    WHERE u.username = username
    AND u.password = password)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password is incorrect!';
	END IF;
    	IF 1 <> (SELECT COUNT(*) FROM issues AS i
    WHERE i.id = issue_id)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The issue does not exist!';
	END IF;
  
	SET user_id := (SELECT u.id 
					FROM users AS u
					WHERE u.username = username);
    
    SET repository_id := (SELECT i.repository_id
						FROM issues AS i
                        WHERE i.id = issue_id);
                        
    INSERT INTO commits(repository_id, contributor_id, issue_id, message)
    VALUES (repository_id, user_id, issue_id, message);
    
    UPDATE issues
    SET issue_status = 'closed'
    WHERE issue_id = id;
END$$

DELIMITER ;
DROP PROCEDURE udp_commit;


#16---

DELIMITER $$
CREATE PROCEDURE udp_findbyextension (extension VARCHAR(30))
BEGIN
	SELECT id, name, CONCAT(SIZE, 'KB') FROM
    files 
    WHERE name LIKE CONCAT('%.', extension);
END $$


