/* Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

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