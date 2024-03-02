/*

PostgreSQL functions exercise for Coffee Shop Data

*/

-- SELECT statement

SELECT * FROM employees
SELECT * FROM locations
SELECT * FROM shops
SELECT * FROM suppliers

SELECT employee_id, first_name, last_name
FROM employees;

SELECT employee_id, hire_date, salary
FROM employees;


--===================================================


-- WHERE clause + AND & OR

-- Selecting only employees who make more then 50k
SELECT *
FROM employees
WHERE salary > 50000;

-- Selecting only employees who work in Commong Grounds AND make more then 50k
SELECT *
FROM employees
WHERE salary > 50000 
	AND coffeeshop_id = 1;

-- Selecting only employees who work in Commong Grounds OR make more then 50k
SELECT *
FROM employees
WHERE salary > 50000
	OR coffeeshop_id = 1;

-- Selecting only employees who work in Commong Grounds, make more then 50k and are male
SELECT *
FROM employees
WHERE salary > 50000 
	AND coffeeshop_id = 1 
	AND gender = 'M';


--===================================================


-- IN, NOT IN, IS NULL, BETWEEN

-- Select all rows from the suppliers table where the supplier is Beans and Barley
SELECT *
FROM suppliers
WHERE supplier_name = 'Beans and Barley';

-- Select all rows from the suppliers table where the supplier is NOT Beans and Barley
SELECT *
FROM suppliers
WHERE NOT supplier_name = 'Beans and Barley';

SELECT *
FROM suppliers
WHERE supplier_name <> 'Beans and Barley';

-- Select all Robusta and Arabica coffee types
SELECT *
FROM suppliers
WHERE coffee_type IN ('Robusta','Arabica');

-- Select all coffee types that are not Robusta or Arabica
SELECT *
FROM suppliers
WHERE coffee_type NOT IN ('Robusta','Arabica');

-- Select all employees with missing email addresses
SELECT *
FROM employees
WHERE email IS NULL;

-- Select all employees whos emails are not missing
SELECT *
FROM employees
WHERE NOT email IS NULL;

-- Select all employees who make between 35k and 50k
SELECT *
FROM employees
WHERE salary BETWEEN 35000 AND 50000;

SELECT *
FROM employees
WHERE salary >= 35000
	AND salary <= 50000;


--===================================================


-- ORDER BY, LIMIT, DISTINCT, Rename columns

-- Order by salary ascending
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary ASC;

-- Order by salary descending
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

-- Top 10 highest payed employees
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Return all unique coffee shop IDs
SELECT DISTINCT coffeeshop_id
FROM suppliers

-- Return all unique countries
SELECT DISTINCT country
FROM locations;

-- Renaming columns
SELECT email,
	email AS email_address,
	hire_date,
	hire_date AS date_joined,
	salary,
	salary AS pay
FROM employees;


--===================================================


-- EXTRACT

SELECT hire_date,
	EXTRACT(YEAR FROM hire_date) AS year,
	EXTRACT(MONTH FROM hire_date) AS month,
	EXTRACT(DAY FROM hire_date) AS day
FROM employees;


--===================================================


-- UPPER, LOWER, LENGHT, TRIM

-- Uppercase first and last names
SELECT first_name,
	UPPER(first_name) AS first_name_upper,
	last_name,
	UPPER(last_name) AS last_name_upper
FROM employees;

-- Lower first and last names
SELECT first_name,
	LOWER(first_name) AS first_name_upper,
	last_name,
	LOWER(last_name) AS last_name_upper
FROM employees;

-- LENGTH
SELECT email, LENGTH(email) AS email_lenght
FROM employees;

-- TRIM
SELECT 
	LENGTH('     HELLO     '    ) AS hello_with_spaces,
	LENGTH('HELLO') AS hello_with_nospaces,
	LENGTH(TRIM('     HELLO     ')) AS hello_trimmed
	
	
--===================================================	


-- CONCATENATION, BOOLEAN EXPRESSIONS, WILDCARDS

-- Concatenate first and last names to create full names
SELECT first_name, last_name, first_name || ' ' || last_name AS full_name
FROM employees;

-- Boolean expressions
-- if the person makes less than 50k, then true, otherwise false
SELECT first_name || ' ' || last_name AS full_name,
	salary,
	salary < 50000 AS less_than_50k
FROM employees;

-- if the person is a female and makes less than 50k, then true, otherwise false
SELECT first_name || ' ' || last_name AS full_name,
	gender,
	salary,
	salary < 50000 AND gender = 'F' AS less_than_50k_female
FROM employees;

-- Boolean expressions with wildcards
-- if email as '.com', return true, otherwise false
SELECT email,
	email LIKE '%.com%' AS dotcom_flag
FROM employees;

SELECT email,
	email LIKE '%.gov%' AS dotcom_flag
FROM employees;


--===================================================


-- SUBSTRING, POSITION and COALESCE

-- SUBSTRING
-- Get the email from the 5th character
SELECT email,
	SUBSTRING(email FROM 5)
FROM employees;

-- POSITION
-- Find the position of @ in the email
SELECT email,
	POSITION('@' IN email)
FROM employees;

-- SUBSTRING & POSITION to find the email client
SELECT email,
	SUBSTRING(email FROM POSITION('@' IN email)+1)
FROM employees;

-- COALESCE to fill missing emails with custom values
SELECT email,
	COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees;


--===================================================


-- MIN, MAX, AVG, SUM, COUNT

-- Select the minimum salary
SELECT MIN(salary) as min_sal
FROM employees;


-- Select the maximum salary
SELECT MAX(salary) as max_sal
FROM employees;


-- Select difference between maximum and minimum salary
SELECT MAX(salary) - MIN(salary)
FROM employees;


-- Select the average salary
SELECT AVG(salary) as avg_sal
FROM employees;

-- Round average alary to nearest integer
SELECT ROUND(AVG(salary),0) as avg_sal
FROM employees;

-- Sum up the salaries
SELECT SUM(salary)
FROM employees;

-- Count the number of entries
SELECT COUNT(*)
FROM employees;

SELECT COUNT(salary)
FROM employees;

SELECT COUNT(email)
FROM employees;


--===================================================


-- GROUP BY and HAVING

-- Return the number of employees for each coffeeshop
SELECT coffeeshop_id, COUNT(employee_id)
FROM employees
GROUP BY coffeeshop_id;

-- Return the total salaries for each coffeeshop
SELECT coffeeshop_id, SUM(salary)
FROM employees
GROUP BY coffeeshop_id;

-- Returnj the number of employees, the avg, min, max, total salaries for each coffeeshop
SELECT coffeeshop_id,
	COUNT(*) AS num_of_emp,
	MIN(salary) AS min_sal,
	MAX(salary) AS max_sal,
	ROUND(AVG(salary),0) AS avg_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
ORDER BY num_of_emp;

-- HAVING
-- After GROUP BY, return only the coffeeshops with more than 200 employees
SELECT coffeeshop_id,
	COUNT(*) AS num_of_emp,
	MIN(salary) AS min_sal,
	MAX(salary) AS max_sal,
	ROUND(AVG(salary),0) AS avg_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200
ORDER BY num_of_emp;

-- After GROUP BY, return only the coffeeshops with a minimum salary of less than 10k
SELECT coffeeshop_id,
	COUNT(*) AS num_of_emp,
	MIN(salary) AS min_sal,
	MAX(salary) AS max_sal,
	ROUND(AVG(salary),0) AS avg_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING MIN(salary) < 10000
ORDER BY num_of_emp;


--===================================================


-- CASE, CASE with GROUP BY, and CASE for transposing data

-- CASE
-- If pay is less than 50k, then low pay, otherwise high pay
SELECT employee_id,
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 50000 THEN 'low pay'
		WHEN salary >= 50000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary DESC;

-- If pay is less than 20k, then low pay, if between 20k-50k inclusive, then medium pay
-- if over 50k, then high pay
SELECT employee_id,
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
		WHEN SALARY > 5000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary DESC;

-- CASE & GROUP BY
-- Return the count of employees in each pay category
SELECT a.pay_category, COUNT(*)
FROM (
	SELECT employee_id,
		first_name,
		last_name,
		salary,
		CASE
			WHEN salary < 20000 THEN 'low pay'
			WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
			WHEN SALARY > 5000 THEN 'high pay'
			ELSE 'no pay'
		END AS pay_category
	FROM employees
	ORDER BY salary DESC
	) a
GROUP BY a.pay_category;

-- Transpose above
SELECT SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS low_pay,
	SUM(CASE WHEN salary BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS medium_pay,
	SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) AS high_pay
FROM employees;


--===================================================


-- JOINs

-- Inserting values just for the JOINs
INSERT INTO locations VALUES (4, 'Paris', 'France');
INSERT INTO shops VALUES (6, 'Happy Brew', NULL);

-- Checking the values inserted
SELECT * FROM shops;
SELECT * FROM locations;

-- INNER JOIN
SELECT s.coffeeshop_name,
	l.city,
	l.country
FROM shops AS s
  JOIN locations AS l
  ON s.city_id = l.city_id;

-- LEFT JOIN
SELECT  s.coffeeshop_name,
	l.city,
	l.country
FROM shops AS s
	LEFT JOIN locations AS l
	ON s.city_id = l.city_id;

-- RIGHT JOIN
SELECT  s.coffeeshop_name,
	l.city,
	l.country
FROM shops AS s
	RIGHT JOIN locations AS l
	ON s.city_id = l.city_id;

-- FULL OUTER JOIN
SELECT s.coffeeshop_name,
	l.city,
	l.country
FROM shops AS s
	FULL OUTER JOIN locations AS l
	ON s.city_id = l.city_id;

-- Deliting values created just for the JOIN
DELETE FROM locations WHERE city_id = 4;
DELETE FROM shops WHERE coffeeshop_id = 6;


--========================================================


-- UNIONs

-- Return all cities and countries
SELECT city FROM locations
UNION
SELECT country FROM locations;

-- UNION removes duplicates
SELECT country FROM locations
UNION
SELECT country FROM locations;

-- UNION ALL keeps duplicates
SELECT country FROM locations
UNION ALL
SELECT country FROM locations;

-- Return all coffeeshop names, cities and countries
SELECT coffeeshop_name FROM shops
UNION
SELECT city FROM locations
UNION
SELECT country FROM locations;


--=================================================


-- Subqueries

-- Basic subqueries with subqueries in the FROM clause
SELECT *
FROM (
	SELECT *
	FROM employees
	WHERE coffeeshop_id IN (3,4)
) AS a;

SELECT a.employee_id,
	a.first_name,
	a.last_name
FROM (
	SELECT *
	FROM employees
	WHERE coffeeshop_id IN (3,4)
) AS a;

-- Basic subqueries with subqueries in the SELECT clause
SELECT first_name, 
	last_name, 
	salary,
	(
	SELECT MAX(salary)
	FROM employees
	LIMIT 1
	) AS max_sal
FROM employees;

SELECT first_name, 
	last_name, 
	salary,
	(
	SELECT ROUND(AVG(salary), 0)
	FROM employees
	LIMIT 1
	) AS avg_sal
FROM employees;

SELECT first_name, 
	last_name, 
	salary, 
	salary - ( 
			SELECT ROUND(AVG(salary), 0)
			FROM employees
			LIMIT 1
			) AS avg_sal_diff
FROM employees;

-- Subqueries in the WHERE clause
-- Return all US coffee shops
SELECT * 
FROM shops
WHERE city_id IN (
	SELECT city_id
	FROM locations
	WHERE country = 'United States'
);

-- Return all employees who work in US coffee shops
SELECT *
FROM employees
WHERE coffeeshop_id IN (
	SELECT coffeeshop_id 
	FROM shops
	WHERE city_id IN (
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
);

-- Return all employees who make over 35k and work in US coffee shops
SELECT *
FROM employees
WHERE salary > 35000 AND coffeeshop_id IN (
	SELECT coffeeshop_id
	FROM shops
	WHERE city_id IN (
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
);


--===================================================


-- 30 day moving total pay
-- The inner query calculates the total_salary of employees who were hired "within" the 30-day period before the hire_date of the current employee
SELECT hire_date, salary,
	(	
		SELECT SUM(salary)
		FROM employees e2
		WHERE e2.hire_date BETWEEN e1.hire_date - 30 AND e1.hire_date
	) AS pay_pattern
FROM employees e1
ORDER BY hire_date;
