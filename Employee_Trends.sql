select * from dbo.Analyzing_Employee_Trends

/*1.Data Exploration & Validation Checks*/

--sample data

select top 10 * from dbo.Analyzing_Employee_Trends

--find total records

select count(*) as total_records from dbo.Analyzing_Employee_Trends

--check for duplicates in emp_no

select emp_no, count(*) as dup_count from dbo.Analyzing_Employee_Trends
group by emp_no
having count(*)>1

--check for nulls and missing values in important columns

select * from dbo.Analyzing_Employee_Trends
where department is null and department = ' ' or
gender is null and gender = ' ' or
age is null and age = ' ' or
education is null and education = ' ' or
job_role is null and job_role = ' ' or
attrition_label is null and attrition_label = ' ' or
job_satisfaction is null and job_satisfaction = ' ';

/*Analyze employee counts, averages, distributions across various dimensions like department, age, education etc.*/

--Total Employees

select count(*) as total_employees 
from dbo.Analyzing_Employee_Trends

--Gender Distribution

select gender, count(*) as emp_count from dbo.Analyzing_Employee_Trends
group by gender

--Age validation

select min(age) as minimum_age,
max(age) as maximum_age,
avg(age) as average_age
from dbo.Analyzing_Employee_Trends

--Education distribution

select
education,
count(*) as total_employees
from dbo.Analyzing_Employee_Trends
group by education

--Active vs Inactive employees

select active_employee,
count(*) emp_count 
from dbo.Analyzing_Employee_Trends
group by active_employee

--Validate distinct values in employee count, job_satisfaction and active_employee

select distinct employee_count,
job_satisfaction,
active_employee
from dbo.Analyzing_Employee_Trends

/*Identify top job roles and satisfaction levels by department to understand departmental trends.*/

--Top job roles

select
job_role,
count(*) as total_count
from dbo.Analyzing_Employee_Trends
group by job_role
order by total_count desc

--Department wise job satisfaction

select 
department,
sum(job_satisfaction) as total_job_satisfaction
from dbo.Analyzing_Employee_Trends
group by department


/*Calculate employee attrition rates by age band to pinpoint high risk groups.*/

--Attrition rate by age_band

select age_band, 
count(case when attrition_label = 'Ex-Employees' then 1 end) as past_employees,
count(*) as total_employees,
concat(cast(count(case when attrition_label = 'Ex-Employees' then 1 end) as float)/count(*) *100,' %') as avg_attrition_rate
from dbo.Analyzing_Employee_Trends
group by age_band
order by avg_attrition_rate desc

/*Analyze factors related to attrition like age, education, job satisfaction to uncover drivers.*/

--Attrition by age

select age,
count(case when attrition_label = 'Ex-Employees' then 1 end) as past_employees
from dbo.Analyzing_Employee_Trends
group by age
order by past_employees desc

--Attrition by education

select education,
count(case when attrition_label = 'Ex-Employees' then 1 end) as past_employees
from dbo.Analyzing_Employee_Trends
group by education
order by past_employees desc

--Attrition by job satisfaction

select marital_status,job_satisfaction,
count(case when attrition_label = 'Ex-Employees' then 1 end) as past_employees
from dbo.Analyzing_Employee_Trends
group by marital_status,job_satisfaction 
order by past_employees desc

--Attrition using where clause

select marital_status,job_satisfaction,
count(attrition_label) as past_employees
from dbo.Analyzing_Employee_Trends
where attrition_label = 'Ex-Employees'
group by marital_status,job_satisfaction
order by past_employees desc

/*Compare averages and aggregates across different employee segments and criteria.*/

drop table dbo.HR_Compensation_Employee_Trends

select * from dbo.HR_Employee_Trends

--Average salary by department

select e.department, 
avg(h.salary) as avg_sal,
avg(h.bonus) as avg_bonus,
count(*) as total_employees
from dbo.Analyzing_Employee_Trends e
join dbo.HR_Employee_Trends h on e.emp_no = h.emp_no
group by e.department
order by avg_sal desc

/*Identify top and bottom performers on key metrics like satisfaction, attrition based on criteria.*/

select e.job_satisfaction,e.gender,e.marital_status,
count(case when e.gender in ('Male','Female') and h.performance_rating = 4 then 1 end) as top_performer,
count(case when e.gender in ('Male','Female') and h.performance_rating = 2 then 1 end) as bottom_performer,
count(case when e.attrition_label = 'Ex-Employees' then 1 end) as past_employees
from dbo.Analyzing_Employee_Trends e join dbo.HR_Employee_Trends h on e.emp_no = h.emp_no
group by e.gender,e.marital_status,e.job_satisfaction
order by past_employees desc
