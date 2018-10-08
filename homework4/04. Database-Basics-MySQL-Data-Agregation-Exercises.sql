#1
SELECT COUNT(id) AS count
FROM wizzard_deposits;

#2
SELECT MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits;

#3
SELECT deposit_group, MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand;

#4
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY AVG(magic_wand_size)
LIMIT 1;

#5
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

#6
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator LIKE 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

#7
SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator LIKE 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

#8
SELECT deposit_group, magic_wand_creator, MIN(deposit_charge) AS min_deposit_charge
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

#9
SELECT 
CASE
WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
ELSE '[61+]' END
 AS age_group, 
 COUNT(id) AS wizard_count
FROM wizzard_deposits
GROUP BY age_group
ORDER BY age_group;

#10
SELECT substr(first_name, 1, 1) AS first_letter
FROM wizzard_deposits
WHERE deposit_group LIKE 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter;

#11
SELECT deposit_group, is_deposit_expired, AVG(deposit_interest) AS average_interest
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

#12
SELECT SUM(hw.deposit_amount - gw.deposit_amount) AS sum_difference
FROM wizzard_deposits AS hw,
wizzard_deposits AS gw
WHERE gw.id - hw.id = 1;

#13
SELECT department_id, MIN(salary) AS minimum_salary
FROM employees
WHERE department_id IN(2,5,7) AND
hire_date > '2000-01-01'
GROUP BY department_id
ORDER BY department_id;

#14
SELECT department_id, 
CASE
WHEN department_id = 1 THEN AVG(salary+5000)
ELSE AVG(salary) END
AS avg_salary
FROM employees
WHERE salary > 30000 AND manager_id NOT IN(42)
GROUP BY department_id
ORDER BY department_id;

#15
SELECT department_id, MAX(salary) as max_salary
FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

#16
SELECT COUNT(salary)
FROM employees
WHERE manager_id IS NULL;

#17
SELECT department_id, 
(SELECT DISTINCT salary 
FROM employees 
WHERE department_id = e.department_id 
ORDER BY salary DESC
LIMIT 2,1) AS third_highest_salary
FROM employees e
WHERE (SELECT DISTINCT salary 
FROM employees 
WHERE department_id = e.department_id 
ORDER BY salary DESC
LIMIT 2,1) IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

#18
SELECT e.first_name, e.last_name, e.department_id
FROM employees e
JOIN (SELECT department_id, AVG(salary) as avg
FROM employees
GROUP BY department_id) as avg_salaries
on e.department_id = avg_salaries.department_id
WHERE e.salary > avg_salaries.avg
ORDER BY e.department_id
LIMIT 10;

#19
SELECT department_id, SUM(salary) as total_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;