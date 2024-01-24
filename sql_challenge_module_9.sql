--Data Engineering--

--1. Use the provided information to create a table schema for each of the six CSV files.

CREATE TABLE departments (
    dept_no VARCHAR(4)   NOT NULL  PRIMARY KEY
    ,dept_name VARCHAR(40)   NOT NULL
);

CREATE TABLE titles (
    title_id VARCHAR(5)   NOT NULL PRIMARY KEY
    ,title VARCHAR(40)   NOT NULL
);

CREATE TABLE employees (
    emp_no INT   NOT NULL PRIMARY KEY
    ,emp_title_id VARCHAR(5)   NOT NULL
    ,birth_date DATE   NOT NULL
    ,first_name VARCHAR(40)   NOT NULL
    ,last_name VARCHAR(40)   NOT NULL
    ,sex VARCHAR(1)   NOT NULL
    ,hire_date DATE   NOT NULL
    ,FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL
    ,dept_no VARCHAR(4)   NOT NULL
    ,primary key (emp_no, dept_no)
    ,FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
    ,FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


CREATE TABLE dept_manager (
    dept_no VARCHAR(4)   NOT NULL
    ,emp_no INT   NOT NULL
    ,primary key (dept_no, emp_no)
    ,FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
    ,FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


CREATE TABLE salaries (
    emp_no INT   NOT NULL
    ,salary INT   NOT NULL
    ,primary key (emp_no, salary)
    ,FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--2. Import each CSV file into its corresponding SQL table.
	--I used the import/export wizard pgAdmin4 to import the csv files. They imported correctly and with no errors.

--Data Analysis--

--1. List the employee number, last name, first name, sex, and salary of each employee.

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
