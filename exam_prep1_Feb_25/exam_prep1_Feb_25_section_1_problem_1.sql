USE exam_prep_1;

CREATE TABLE users(
id INT(11) Primary Key AUTO_INCREMENT,
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL
);

CREATE TABLE repositories(
id	INT(11)  Primary Key AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE repositories_contributors(
repository_id INT(11),
contributor_id INT(11) 
);

ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_repository_id
FOREIGN KEY repositories_contributors(repository_id)
REFERENCES repositories(id);

ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_contributor_id
FOREIGN KEY repositories_contributors(contributor_id)
REFERENCES users(id);


CREATE TABLE issues(
id INT(11) Primary Key AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
issue_status VARCHAR(6) NOT NULL, 
repository_id INT(11) NOT NULL,
assignee_id INT(11) NOT NULL
);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_repository_id
FOREIGN KEY issues(repository_id)
REFERENCES repositories(id);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_assignee_id
FOREIGN KEY issues(assignee_id)
REFERENCES users(id);

CREATE TABLE commits(
id INT(11) Primary Key AUTO_INCREMENT,
message VARCHAR(255) NOT NULL,
issue_id INT(11),
repository_id INT(11) NOT NULL,
contributor_id INT(11) NOT NULL
);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_issue_id
FOREIGN KEY commits(issue_id)
REFERENCES issues(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_repository_id
FOREIGN KEY commits(repository_id)
REFERENCES repositories(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_contributor_id
FOREIGN KEY commits(contributor_id)
REFERENCES users(id);

CREATE TABLE files(
id INT(11) Primary Key AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
size DECIMAL(10,2) NOT NULL,
parent_id INT(11),
commit_id INT(11) NOT NULL
);

ALTER TABLE files
ADD CONSTRAINT fk_files_parent_id
FOREIGN KEY files(parent_id)
REFERENCES files(id);

ALTER TABLE files
ADD CONSTRAINT fk_files_commit_id
FOREIGN KEY files(commit_id)
REFERENCES commits(id);


