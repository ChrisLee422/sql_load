/*
**Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
     helping job seekers understand which skills to develop that align with top salaries
*/

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


/* The data from this query was exported to a CSV and loaded into PowerBI for visualization,
    doing so let us identify the top skills from the highest paying data analyst jobs. This will help
    tailor an educational path for people looking to get into the field. 
    
    The top ten skills identified with the number of job postings were:
    1. SQL - 75 jobs
    2. Python - 52
    3. tableau - 41
    4. R - 33
    5. SAS - 28
    6. Excel - 24
    7. Power BI - 20
    8. Snowflake - 14
    9. Looker - 12
    10. go - 11

    These results come from a list of the top 100 highest paying remote data analyst jobs. However, only
    91 of these jobs had listed skills, so the skill counts are out of 91, not 100. This gives a percentage
    of 82.4% of the top 100 jobs listing SQL as a required skill, 57.1% listing Python, and so on.
    */