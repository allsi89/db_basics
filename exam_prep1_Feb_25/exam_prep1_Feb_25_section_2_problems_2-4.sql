USE exam_prep_1;

#2---

INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT CONCAT('Critical Problem With ', f.name,'!' ) as filename,
	'open' as issue_status,
	CEILING(f.id *2/3) as repository_id,
	c.contributor_id
FROM files AS f
	JOIN commits AS c
	ON c.id = f.commit_id
WHERE f.id BETWEEN 46 AND 50;

#3---

INSERT INTO repositories_contributors(contributor_id, repository_id)
SELECT * FROM (
SELECT contributor_id FROM
repositories_contributors
WHERE repository_id = contributor_id) AS t1
CROSS JOIN(
SELECT MIN(r.id) as repository_id
FROM repositories AS r
LEFT JOIN repositories_contributors AS rc
ON r.id = rc.repository_id
WHERE rc.repository_id IS NULL) AS t2
WHERE t2.repository_id IS NOT NULL;

#4---

DELETE
FROM repositories 
WHERE id NOT IN(SELECT repository_id
FROM issues);