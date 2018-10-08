CREATE DATABASE custom_db;
USE custom_db;

#1 One-To-One Relationship


CREATE TABLE persons(
person_id INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
salary DECIMAL(10,2) NOT NULL, 
passport_id INT(11) UNSIGNED NOT NULL UNIQUE
);

INSERT INTO persons(person_id, first_name, salary, passport_id)
VALUES (1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

CREATE TABLE passports(
passport_id INT(11) UNSIGNED UNIQUE PRIMARY KEY AUTO_INCREMENT,
passport_number CHAR(8) NOT NULL UNIQUE
)AUTO_INCREMENT=101;

INSERT INTO passports(passport_number)
VALUES('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

ALTER TABLE persons
ADD PRIMARY KEY(person_id);

ALTER TABLE persons
ADD CONSTRAINT fk_passport_id
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);


#2 One-To-Many Relationship

CREATE TABLE manufacturers
(
manufacturer_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL UNIQUE,
established_on DATE NOT NULL
);

INSERT INTO  manufacturers(name, established_on)
VALUES('BMW', '1916-03-01'),
('Tesla', '2003-01-01'), 
('Lada', '1966-05-01');

CREATE TABLE models
(
model_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL,
manufacturer_id INT(11) NOT NULL,
CONSTRAINT fk_manufacturer_id
FOREIGN KEY (manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
) AUTO_INCREMENT = 101;

INSERT INTO `models` (`name`, `manufacturer_id`) 
VALUES ('X1', 1), 
('i6', 1), 
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);


#3 Many-To-Many Relationship

CREATE TABLE students 
(
student_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL
);

CREATE TABLE exams 
(
exam_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL
)AUTO_INCREMENT=101;

CREATE TABLE students_exams 
(
student_id INT(11) NOT NULL,
exam_id INT(11) NOT NULL, 
CONSTRAINT pk_students_exams_id
PRIMARY KEY (student_id, exam_id),
CONSTRAINT fk_students_exams_student_id
FOREIGN KEY (student_id)
REFERENCES students(student_id),
CONSTRAINT fk_students_exams_exam_id
FOREIGN KEY (exam_id)
REFERENCES exams(exam_id)
);

INSERT INTO students (name) 
VALUES ('Mila'), 
('Toni'), 
('Ron');
            
INSERT INTO exams (name) 
VALUES ('Spring MVC'), 
('Neo4j'), 
('Oracle 11g');
            
INSERT INTO students_exams
VALUES (1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);


#4 Self-Referencing

CREATE TABLE teachers
(
teacher_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL,
manager_id INT(11)
)AUTO_INCREMENT=101;

INSERT INTO teachers(name, manager_id)
VALUES('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE teachers
ADD CONSTRAINT fk_manager_id
FOREIGN KEY (manager_id)
REFERENCES teachers(teacher_id);
