/* ============================================================

PROJECT: Global Data Job Market Analysis

DATABASE: job_market

TABLE: job_postings

AUTHOR: Subhangi Shreya

============================================================ */

USE job_market;

/* ============================

SECTION 1: Data Validation

============================ */

-- Q1. How many total job postings are available in the dataset?

SELECT COUNT(*) AS total_jobs

FROM job_postings;

-- Q2. How many unique companies are hiring globally?

SELECT COUNT(DISTINCT company_name) AS total_companies

FROM job_postings;

-- Q3. How many countries are represented in the dataset?

SELECT COUNT(DISTINCT job_country) AS total_countries

FROM job_postings;

-- Q4. Preview the dataset structure

DESCRIBE job_postings;

-- Q5. Sample data check

SELECT * FROM job_postings

LIMIT 10;

/* ============================

SECTION 2: Work Mode Analysis

============================ */

-- Q6. How are jobs distributed across Remote vs Onsite/Hybrid roles?

SELECT work_mode, COUNT(*) AS job_count

FROM job_postings

GROUP BY work_mode

ORDER BY job_count DESC;

/* ============================

SECTION 3: Job Role Demand

============================ */

-- Q7. What are the top 10 most in-demand job roles globally?

SELECT job_title_short, COUNT(*) AS postings

FROM job_postings

GROUP BY job_title_short

ORDER BY postings DESC

LIMIT 10;

/* ============================

SECTION 4: Country-wise Hiring

============================ */

-- Q8. Which countries have the highest number of job postings?

SELECT job_country, COUNT(*) AS postings

FROM job_postings

WHERE job_country IS NOT NULL AND job_country <> ''

GROUP BY job_country

ORDER BY postings DESC

LIMIT 15;

/* ============================

SECTION 5: Remote Jobs by Role

============================ */

-- Q9. Which roles offer the highest percentage of remote jobs?

SELECT

job_title_short,

COUNT(*) AS total_postings,

SUM(CASE WHEN work_mode = 'Remote' THEN 1 ELSE 0 END) AS remote_postings,

ROUND(

    100 * SUM(CASE WHEN work_mode = 'Remote' THEN 1 ELSE 0 END) / COUNT(*),

    2

) AS remote_percentage

FROM job_postings

GROUP BY job_title_short

ORDER BY remote_percentage DESC;

/* ============================

SECTION 6: Skill Demand Analysis

============================ */

-- Q10. What is the overall demand for key technical skills?

SELECT

SUM(`sql`) AS sql_jobs,

SUM(python) AS python_jobs,

SUM(excel) AS excel_jobs,

SUM(power_bi) AS powerbi_jobs,

SUM(tableau) AS tableau_jobs,

SUM(aws) AS aws_jobs,

SUM(azure) AS azure_jobs,

SUM(gcp) AS gcp_jobs

FROM job_postings;

-- Q11. Skill demand comparison for analyst roles

SELECT

job_title_short,

SUM(`sql`) AS sql_jobs,

SUM(python) AS python_jobs,

SUM(excel) AS excel_jobs,

SUM(power_bi) AS powerbi_jobs,

SUM(tableau) AS tableau_jobs

FROM job_postings

WHERE job_title_short IN ('Data Analyst', 'Business Analyst', 'Senior Data Analyst')

GROUP BY job_title_short

ORDER BY sql_jobs DESC;

/* ============================

SECTION 7: Time Trend Analysis

============================ */

-- Q12. How has job posting volume changed month over month?

SELECT

posted_year,

posted_month,

posted_month_name,

COUNT(*) AS total_jobs

FROM job_postings

GROUP BY posted_year, posted_month, posted_month_name

ORDER BY posted_year, posted_month;

-- Q13. Monthly remote job trend analysis

SELECT

posted_year,

posted_month,

posted_month_name,

COUNT(*) AS total_jobs,

SUM(CASE WHEN work_mode = 'Remote' THEN 1 ELSE 0 END) AS remote_jobs,

ROUND(

    100 * SUM(CASE WHEN work_mode = 'Remote' THEN 1 ELSE 0 END) / COUNT(*),

    2

) AS remote_percentage

FROM job_postings

GROUP BY posted_year, posted_month, posted_month_name

ORDER BY posted_year, posted_month;

/* ============================

SECTION 8: Company Analysis

============================ */

-- Q14. Which companies are posting the most jobs?

SELECT

company_name,

COUNT(*) AS postings

FROM job_postings

WHERE company_name IS NOT NULL AND company_name <> ''

GROUP BY company_name

ORDER BY postings DESC

LIMIT 10;

/* ============================

SECTION 9: Salary Analysis

============================ */

-- Q15. What is the average salary by job role?

SELECT

job_title_short,

COUNT(*) AS salary_records,

ROUND(AVG(salary_year_avg), 0) AS avg_salary

FROM job_postings

WHERE salary_year_avg IS NOT NULL

GROUP BY job_title_short

ORDER BY avg_salary DESC;

-- Q16. Which countries offer the highest average salaries?

SELECT

job_country,

COUNT(*) AS salary_records,

ROUND(AVG(salary_year_avg), 0) AS avg_salary

FROM job_postings

WHERE salary_year_avg IS NOT NULL

GROUP BY job_country

HAVING COUNT(*) >= 50

ORDER BY avg_salary DESC

LIMIT 15;

/* ============================

SECTION 10: Skill vs Salary (CTE)

============================ */

-- Q17. Which skills are associated with the highest average salaries?

WITH skill_salary AS (

SELECT 'sql' AS skill, AVG(salary_year_avg) AS avg_salary

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND `sql` = 1



UNION ALL

SELECT 'python', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND python = 1



UNION ALL

SELECT 'power_bi', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND power_bi = 1



UNION ALL

SELECT 'excel', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND excel = 1



UNION ALL

SELECT 'tableau', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND tableau = 1



UNION ALL

SELECT 'aws', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND aws = 1



UNION ALL

SELECT 'azure', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND azure = 1



UNION ALL

SELECT 'gcp', AVG(salary_year_avg)

FROM job_postings

WHERE salary_year_avg IS NOT NULL AND gcp = 1

)

SELECT

skill,

ROUND(avg_salary, 0) AS avg_salary

FROM skill_salary

ORDER BY avg_salary DESC;

