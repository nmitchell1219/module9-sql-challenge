--Data Engineering--

--1. Use the provided information to create a table schema for each of the six CSV files.

CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL
    ,dept_name VARCHAR   NOT NULL
    ,CONSTRAINT pk_departments PRIMARY KEY (dept_no))
;

SELECT * FROM departments;

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL
    ,dept_no VARCHAR   NOT NULL)
;

SELECT * FROM dept_emp;

CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL
    ,emp_no INT   NOT NULL)
;

SELECT * FROM dept_manager;

CREATE TABLE employees (
    emp_no INT   NOT NULL
    ,emp_title_id VARCHAR   NOT NULL
    ,birth_date DATE   NOT NULL
    ,first_name VARCHAR   NOT NULL
    ,last_name VARCHAR   NOT NULL
    ,sex VARCHAR   NOT NULL
    ,hire_date DATE   NOT NULL
    ,CONSTRAINT pk_employees PRIMARY KEY (emp_no))
;

SELECT * FROM employees;

CREATE TABLE salaries (
    emp_no INT   NOT NULL
    ,salary INT   NOT NULL)
;

SELECT * FROM salaries;

CREATE TABLE titles (
    title_id VARCHAR   NOT NULL
    ,title VARCHAR   NOT NULL
    ,CONSTRAINT pk_titles PRIMARY KEY (title_id))
;

SELECT * FROM titles;

--2. Import each CSV file into its corresponding SQL table.
	--I used the import/export wizard pgAdmin4 to import the csv files. They imported correctly and with no errors.

--Data Analysis--

--1. List the employee number, last name, first name, sex, and salary of each employee.
ALTER TABLE salaries
ALTER COLUMN emp_no TYPE INT USING emp_no::IN
;

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
;

--2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986
;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
;

--4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no
;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
;

--6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
;

--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development')
;

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC
;
