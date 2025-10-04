# Introduction
This project was made in conjunction with [Luke Barousse's SQL for Data Analytics](https://www.lukebarousse.com) course.

In this course we were taught the basics of SQL and how to apply them in this project.

This project is a exploration of the data analyst jobs market looking at the top-paying jobs, skills in-demand, and average salary per skill.

My desire with this project was to learn SQL techniques to increase my understanding of  data analytical skills to further help me in my career.

See the SQL Queries used here: [SQL Queries](/project_sql/)

# Background


For this project I was tasked with finding the answers to the following questions:
1) What are the top-paying data-analyst jobs?
2) What skills are required for these top-paying jobs?
3) What skills are most in-demand for these top-paying jobs?
4) What skills are associated with higher salaries?
5) What are the most optimal skills to learn for a data analyst looking to maximize job market value?


# Tools Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
- **PowerBI:** Microsoft's cloud-based business intelligence (BI) platform that enables users to transform raw data into interactive visualizations, reports, and dashboards

# Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here is how we approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying jobs, I filtered the data analyst positions by average yearly salary and location to remote jobes. This query highlights the high paying positions in the field.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
```

### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 100
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_work_from_home = 'True'
GROUP BY skills
ORDER BY skill_count DESC
LIMIT 10;
```

### 4. Top Paying Data Analyst Jobs
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```SQL
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = 'True'
GROUP BY skills_dim.skills
ORDER BY avg_salary DESC
LIMIT 25;
```
### 5. Top Paying Data Analyst Jobs
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```SQL
WITH skill_demand AS (
    SELECT 
        skills,
        skills_dim.skill_id,
        COUNT(skills_job_dim.job_id) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND
        job_work_from_home = 'True' AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), skill_salary AS (
    SELECT 
        skills_dim.skills,
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = 'True'
    GROUP BY skills_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    skill_count,
    avg_salary
FROM skill_demand
INNER JOIN skill_salary ON skill_demand.skill_id = skill_salary.skill_id
WHERE
    skill_count > 10
ORDER BY
    avg_salary DESC,
    skill_count DESC
LIMIT 25;
```
# Summary
# Conclusions