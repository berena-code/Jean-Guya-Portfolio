-- Create database
CREATE DATABASE IF NOT EXISTS sf_data;

-- 1	Show all columns and rows in the table.
SELECT * 
FROM salaries;


-- 2	Show only the EmployeeName and JobTitle columns.
SELECT EmployeeName, JobTitle 
FROM salaries;


-- 3	Show the number of employees in the table.
SELECT COUNT(Id) AS number_of_employees 
FROM salaries;


-- 4	Show the unique job titles in the table.
SELECT DISTINCT JobTitle 
FROM salaries;


-- 5	Show the job title and overtime pay for all employees with 
-- overtime pay greater than 50000.
SELECT JobTitle, OvertimePay 
FROM salaries
WHERE OvertimePay > 50000;


-- 6	Show the average base pay for all employees.
SELECT AVG(BasePay) AS avg_base_pay
FROM salaries;


-- 7	Show the top 10 highest paid employees.
SELECT EmployeeName, TotalPay 
FROM salaries
ORDER BY TotalPay DESC
LIMIT 10;


-- 8	Show the average of BasePay, OvertimePay, and OtherPay for each employee:
SELECT EmployeeName, (BasePay+ OvertimePaY+ OtherPay)/3 AS avg_bp_op_otp
FROM salaries;


-- 9	Show all employees who have the word "Manager" in their job title.
SELECT EmployeeName, JobTitle 
FROM salaries
WHERE JobTitle LIKE '%Manager%';


-- 10	Show all employees with a job title not equal to "Manager".
SELECT EmployeeName, JobTitle 
FROM salaries
WHERE JobTitle NOT LIKE '%Manager%';


-- 11	Show all employees with a total pay between 50,000 and 75,000.
SELECT EmployeeName, TotalPay 
FROM salaries
WHERE TotalPay BETWEEN 50000 AND 75000;


-- 12	Show all employees with a base pay less than 50,000 
-- or a total pay greater than 100,000.
SELECT EmployeeName, BasePay,TotalPay
FROM salaries
WHERE BasePay < 50000 OR TotalPay > 100000;


-- 13	Show all employees with a total pay benefits value 
-- between 125,000 and 150,000 and a job title containing the word "Director".
SELECT EmployeeName, TotalPayBenefits, JobTitle
FROM salaries
WHERE TotalPayBenefits BETWEEN 125000 AND 150000 AND JobTitle LIKE '%Director%';


-- 14	Show all employees ordered by their total pay benefits in descending order.
SELECT EmployeeName ,TotalPay
FROM salaries
ORDER BY TotalPayBenefits DESC;


-- 15	Show all job titles with an average base pay of 
-- at least 100,000 and order them by the average base pay in descending order.
SELECT JobTitle, AVG(BasePay) AS avg_base_pay
FROM salaries
GROUP BY JobTitle
HAVING AVG(BasePay) >= 100000
ORDER BY avg_base_pay DESC;


-- 16	Delete notes column.
ALTER TABLE salaries
DROP COLUMN notes;


-- 17	Update the base pay of all employees with 
-- the job title containing "Manager" by increasing it by 10%.
UPDATE salaries 
SET BasePay = BasePay * 1.10 
WHERE JobTitle LIKE '%Manager%';


-- 18	Delete all employees who have no OvertimePay.
DELETE FROM salaries 
WHERE OvertimePay = 0;
 