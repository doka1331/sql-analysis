--PHYSICAL TABLE SCHEMA
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/gQlsmd
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salaries" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

--import csv files into tables
--Select Statements to print correctly copied tables
select * from departments;
select * from titles;
select * from employees;
select * from dept_emp;
select * from dept_manager;
select * from salaries;

--DATA ANALYSIS SCRIPT

--1. List the employee number, last name, first name, sex, and salary of each employee.
select 
	e.emp_no, 
	e.last_name, 
	e.first_name, 
	e.sex, 
	s.salaries
from 
	employees e
join 
	salaries s
on (e.emp_no = s.emp_no)

--2.List the first name, last name, and hire date for the employees who were hired in 1986.
select 
	e.hire_date, 
	e.last_name, 
	e.first_name
from 
	employees e
join 
	salaries s
on (e.emp_no = s.emp_no)
where extract(YEAR FROM hire_date) = 1986;

--3. List the manager of each department along with their department number, department name, 
--   employee number, last name, and first name.
select
    dm.dept_no AS department_number,
    d.dept_name AS department_name,
    dm.emp_no AS manager_employee_number,
    e.last_name,
    e.first_name
from
    dept_manager dm
join
    departments d ON dm.dept_no = d.dept_no
join
    employees e ON dm.emp_no = e.emp_no;

--4.List the department number for each employee along with that employee’s employee number, 
--  last name, first name, and department name.
select
	de.dept_no as department_number,
	d.dept_name as department_name,
	de.emp_no as employee_number,
	e.last_name,
	e.first_name
from
	dept_emp de
join
	departments d on de.dept_no = d.dept_no
join
	employees e on de.emp_no = e.emp_no;

--5.List first name, last name, and sex of each employee whose 
--  first name is Hercules and whose last name begins with the letter B.
select 
	e.first_name, 
	e.last_name, 
	e.sex
from 
	employees e
where e.first_name = 'Hercules' and last_name like 'B%';

--6.List each employee in the Sales department, including their employee number, last name, and first name.
select 
	e.emp_no,
	e.last_name,
	e.first_name
from
	employees e
join 
	dept_emp de on e.emp_no = de.emp_no
join
	departments d on de.dept_no = d.dept_no
where
	d.dept_name = 'Sales';

--7.List each employee in the Sales and Development departments, 
--  including their employee number, last name, first name, and department name.
select
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
from
    employees e
join
    dept_emp de on e.emp_no = de.emp_no
join
    departments d on de.dept_no = d.dept_no
where
    d.dept_name in ('Sales', 'Development');

--8. List the frequency counts, in descending order, of all the employee last names 
--   (that is, how many employees share each last name).
select
    last_name, count(*) as frequency
from
    employees
group by
    last_name
order by 
    frequency desc, last_name;
