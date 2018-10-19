# SET GLOBAL log_bin_trust_function_creators = 1;

use soft_uni;

#SUBMIT without delimiter in judge
#1---
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN
SELECT first_name, last_name
FROM employees
WHERE salary > 35000
ORDER BY first_name, last_name, employee_id;
END $$

DELIMITER ;
CALL usp_get_employees_salary_above_35000() ;

#2---
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_value DOUBLE) 
BEGIN
SELECT first_name, last_name 
FROM employees
WHERE salary >= salary_value
ORDER BY first_name, last_name, employee_id;
END $$

CALL usp_get_employees_salary_above(48100);

#3---
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(town_string VARCHAR(20))
BEGIN
SELECT name as town_name
FROM towns
WHERE name LIKE concat(town_string, '%')
ORDER BY town_name;
END $$

DELIMITER ;

CALL usp_get_towns_starting_with('b');

#4---
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(20))
BEGIN
SELECT e.first_name AS first_name, e.last_name AS last_name
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
WHERE t.name LIKE town_name
ORDER BY first_name, last_name, employee_id;
END $$

DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

#5---


CREATE FUNCTION ufn_get_salary_level(salary_input DOUBLE)
RETURNS VARCHAR(20)
DETERMINISTIC
RETURN
(CASE
WHEN salary_input < 30000 THEN 'Low'
WHEN salary_input BETWEEN 30000 AND 50000 THEN 'Average'
ELSE 'High'
END);

SELECT UFN_GET_SALARY_LEVEL(125500.00);

#6---
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(10))
BEGIN
SELECT first_name, last_name
FROM employees
WHERE (salary < 30000 and salary_level like 'Low'
OR salary BETWEEN 30000 AND 50000 and salary_level like 'Average'
OR salary >50000 and salary_level like 'High') 
ORDER BY first_name DESC, last_name DESC;
END $$


DELIMITER ;

CALL usp_get_employees_by_salary_level('high');



#7---
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))  
RETURNS BIT
BEGIN
	DECLARE result BIT;
	DECLARE word_length INT(11);
    DECLARE current_index INT(11);
    
    SET result := 1;
    SET word_length := char_length(word);
    SET current_index := 1;
    
    WHILE(current_index <= word_length) DO
		IF(set_of_letters NOT LIKE (concat('%', substr(word, current_index, 1), '%')))
			THEN SET result := 0;
		END IF;
	SET current_index := current_index + 1;
    END WHILE;
    RETURN result;
END $$

DELIMITER ;

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
SELECT ufn_is_word_comprised('oistmiahf', 'halves');
SELECT ufn_is_word_comprised('oistmiahf', 'Rob');


#second variant
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');


USE bank_db;
#8---

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT 
		CONCAT_WS(' ', first_name, last_name) AS full_name
	FROM
		account_holders
	ORDER BY full_name , id;
END $$

DELIMITER ;

CALL usp_get_holders_full_name();

#9---

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(input_value DECIMAL(20, 4))
BEGIN
SELECT ah.first_name as first_name, ah.last_name as last_name
FROM account_holders as ah
JOIN ( SELECT *
    FROM accounts
    GROUP BY account_holder_id
    HAVING SUM(balance) > input_value) as a
ON ah.id = a.account_holder_id
ORDER BY  a.id, ah.first_name, ah.last_name;

END$$

DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

#10---
DELIMiter $$ 
Create function 
ufn_calculate_future_value(current_sum DOUBLE, 
yearly_interest_rate DOUBLE, 
number_of_years INT(11))
RETURNS DOUBLE
BEGIN
	DECLARE result DOUBLE;
    SET result:= current_sum  * POW((1+yearly_interest_rate), number_of_years);
    return result;
END$$

DELIMITER ;
SELECT ufn_calculate_future_value(1000, 0.1, 5);

#11--- #this is the same function in judge should paste that too 
DELIMITER $$
Create function 
ufn_calculate_future_value(current_sum DOUBLE, 
yearly_interest_rate DECIMAL(15,4), 
number_of_years INT(11))
RETURNS DECIMAL(15,4)
BEGIN
	DECLARE result DECIMAL(15,4);
    SET result:= current_sum  * POW((1+yearly_interest_rate), number_of_years);
    return result;
END$$

CREATE PROCEDURE usp_calculate_future_value_for_account(in_account_id INT(11), interest_rate DECIMAL(15,4))
BEGIN
DECLARE years INT;
SET years := 5;
SELECT 
    a.id AS account_id,
    ah.first_name AS first_name,
    ah.last_name AS last_name,
    a.balance AS current_balance,
    UFN_CALCULATE_FUTURE_VALUE(a.balance, interest_rate, years) AS balance_in_5_years
FROM
    account_holders AS ah
        JOIN
    accounts AS a ON ah.id = a.account_holder_id
WHERE
    a.id = in_account_id;
END$$
DELIMITER ;
CALL usp_calculate_future_value_for_account(1, 0.1); 

#12---
DELIMITER $$
CREATE PROCEDURE usp_deposit_money (account_id INT, money_amount DECIMAL)
BEGIN
    START TRANSACTION;
    UPDATE accounts AS ac
    SET ac.balance = ac.balance + money_amount
    WHERE ac.id = account_id;
    IF (
    SELECT a.balance
    FROM accounts as a
    WHERE a.id = account_id
    ) >= 0 THEN
    COMMIT;
    ELSE
    rollback;
    END IF;
END$$

DELIMITER ;

CALL usp_deposit_money(1, 10);

#13---

DELIMITER $$

CREATE PROCEDURE usp_withdraw_money(account_id INT(11), money_amount DECIMAL(19,4))
BEGIN
START TRANSACTION;
UPDATE accounts AS a
		SET a.balance = a.balance - money_amount
		WHERE a.id = account_id;
IF(money_amount > 0 AND money_amount <=
(SELECT
  a.balance
    FROM accounts as a
    WHERE a.id = account_id
)) THEN COMMIT;
    ELSE rollback;
    END IF;
END $$

DELIMITER ;


CALL usp_withdraw_money(1, 10);
SELECT id, account_holder_id, balance
FROM accounts
WHERE id = 1;


#14---

DELIMITER $$ 

CREATE PROCEDURE usp_transfer_money(from_account_id INT(11), to_account_id INT (11), amount DECIMAL(19,4)) 
BEGIN
	START TRANSACTION;
		UPDATE accounts AS a
			SET a.balance = a.balance - amount
			WHERE a.id = from_account_id;
        UPDATE accounts AS a    
            SET a.balance = a.balance + amount
			WHERE a.id = to_account_id;
		IF( 
        (SELECT a.id 
        FROM accounts AS a
        WHERE a.id = from_account_id) IS NOT NULL 
        AND
         (SELECT a.id 
        FROM accounts AS a
        WHERE a.id = to_account_id) IS NOT NULL
        AND
        amount > 0
        AND 
        amount < 
         (SELECT a.balance 
        FROM accounts AS a
        WHERE a.id = from_account_id)
        )
        THEN COMMIT;
        ELSE ROLLBACK;
        END IF;

END$$

DELIMITER ;

CALL usp_transfer_money(1, 2, 10);

SELECT*FROM
accounts 
WHERE id IN(1,2);

#15---

CREATE TABLE logs(
log_id INT(11) PRIMARY KEY AUTO_INCREMENT, 
account_id INT(11), 
old_sum DECIMAL(19,4), 
new_sum DECIMAL(19,4));

DELIMITER $$
CREATE TRIGGER tr_logs
AFTER UPDATE
ON accounts
FOR EACH ROW 
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END$$

DELIMITER ;

UPDATE accounts
SET balance = balance + 10
WHERE id = 1;

#16---
CREATE TABLE logs(
log_id INT(11) PRIMARY KEY AUTO_INCREMENT, 
account_id INT(11), 
old_sum DECIMAL(19,4), 
new_sum DECIMAL(19,4));

DELIMITER $$
CREATE TRIGGER tr_logs
AFTER UPDATE
ON accounts
FOR EACH ROW 
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END$$

DELIMITER ;
CREATE TABLE notification_emails (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    recipient INT(11),
    subject TEXT,
    body TEXT
);

DELIMITER $$
CREATE TRIGGER tr_notification_emails
AFTER INSERT
ON logs
FOR EACH ROW 
BEGIN
	INSERT INTO notification_emails(recipient, subject, body)
    VALUES (NEW.account_id, 
    CONCAT('Balance change for account:', ' ', NEW.account_id), 
    CONCAT('On ', DATE_FORMAT(now(),'%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 2), 
    ' to ', ROUND(NEW.new_sum, 2), '.')
    );
END$$














