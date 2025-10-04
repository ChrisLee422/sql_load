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

From this analysis of this project we can begin to answer the questions that we posed earlier. They are:
### 1) What are the top-paying data-analyst jobs?

![Top Paying Roles](assets/Average%20Salary%20By%20Role.png)

*Figure 1. Top Paying Roles*

*This graph was generated using PowerBI by exporting my first query. It shows the top 10 salaries for data analysts*

### 2) What skills are required for these top-paying jobs?
![Top Skills](assets/Top%20Skills.png)

*Figure 2. Top Skills*

*From this graph we can see the most skills that are required from the top paying jobs. Leading the way is **SQL** and **Python** as a way of analyzing data. We can also see data visualizing applications like **Tableau** and **Power Bi**.
### 3) What skills are most in-demand for these top-paying jobs?

When looking at the most in-demand skills we continue to see **SQL** at the top with 7291 job listings. **Excel** is next with 4611 followed by **Python** at 4330. Learning these skills are essential for any data analyst to know. 
| Skill | Number  |
| :---   | ---: | 
| SQL | 7291   |
| Excel | 4611   |
| Python | 4330   |
| Tableau | 3745   |
| Power BI| 2609   |
| R | 2142   |
| SAS | 1866   |
| Looker | 868   |
| Azure | 821   |
| PowerPoint | 819   | 
**Table 1. Most In Demand Skills*
### 4 & 5) What skills are associated with higher salaries and 5hat are the most optimal skills to learn for a data analyst looking to maximize job market value?

![Highest Paying Skills](assets/Highest%20Paying%20Skills.png)
*Figure 3. Highest Paying Skills*

Specialized skills, such as **SVN** and **Solidity**, are associated with the highest average salaries, indicating a premium on niche expertise. However we can see that there is little demand for them. **SQL**, while not the highest paying job still provides one of the highest salaries while also being the most in-demand skill for the highest paying remote data analyst jobs. 

# What I learned
Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

# Conclusions

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.