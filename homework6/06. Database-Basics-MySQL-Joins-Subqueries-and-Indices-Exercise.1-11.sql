USE soft_uni;

#1---
SELECT 
    employee_id, job_title, e.address_id, address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

#2---
SELECT 
    first_name, last_name, t.name, a.address_text
FROM
    employees AS e
       JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns AS t ON a.town_id = t.town_id
ORDER BY first_name , last_name
LIMIT 5;

#3---
SELECT 
    employee_id,
    first_name,
    last_name,
    d.name AS department_name
FROM
    employees AS e
        JOIN
    (SELECT 
        department_id, name
    FROM
        departments
    WHERE
        name LIKE 'SALES') AS d ON e.department_id = d.department_id
ORDER BY e.employee_id DESC;

#4---
SELECT 
    employee_id, first_name, salary, d.name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.salary > 15000
ORDER BY e.department_id DESC
LIMIT 5;

#5---
SELECT 
    employee_id, first_name
FROM
    (SELECT 
        e.employee_id, first_name, ep.project_id
    FROM
        employees AS e
    LEFT JOIN employees_projects AS ep ON e.employee_id = ep.employee_id) AS ne
WHERE
    ne.project_id IS NULL
ORDER BY ne.employee_id DESC
LIMIT 3;

#6---
SELECT 
    first_name, last_name, hire_date, d.name AS dept_name
FROM
    employees AS e
       LEFT JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    DATE(hire_date) > '1999-01-01'
        AND d.name IN ('Finance', 'Sales')
ORDER BY hire_date;

#7---
SELECT 
    e.employee_id, first_name, p.name AS project_name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    DATE(p.start_date) > '2002-08-13'
        AND p.end_date IS NULL
ORDER BY first_name , project_name
LIMIT 5;

#8---
SELECT 
    e.employee_id, first_name, p.project_name AS project_name
FROM
    employees AS e
        JOIN
    employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    (SELECT 
        project_id,
            CASE
                WHEN YEAR(start_date) >= '2005' THEN NULL
                ELSE name
            END AS project_name
    FROM
        projects) AS p ON ep.project_id = p.project_id
WHERE
    ep.employee_id = 24
ORDER BY project_name;

#9---
SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name AS manager_name
FROM
    employees AS e
        JOIN
    employees AS m ON e.manager_id = m.employee_id
WHERE
    m.employee_id IN (3 , 7)
ORDER BY e.first_name;

#10---

SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    d.name AS department_name
FROM
    employees AS e
        JOIN
    employees AS m ON e.manager_id = m.employee_id
        JOIN
    departments AS d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

#11---

SELECT 
    MIN(salary) AS min_average_salary
FROM
    (SELECT 
        AVG(salary) AS salary
    FROM
        employees
    GROUP BY department_id) AS avgs;



